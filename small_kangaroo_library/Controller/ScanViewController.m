//
//  ScanViewController.m
//  small_kangaroo_library
//
//  Created by Jacky Li on 23/4/14.
//  Copyright (c) 2014 SmallKangarooLibrary. All rights reserved.
//
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVCaptureInput.h>
#import <AVFoundation/AVCaptureOutput.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVCaptureVideoPreviewLayer.h>
#import <AVFoundation/AVMetadataObject.h>
#import <Dropbox/Dropbox.h>
#import "Masonry.h"
#import "ScanViewController.h"
#import "DoubanClient.h"
#import "Book.h"
#import "LoadingView.h"
#import "BookAddViewController.h"

@interface ScanViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property(nonatomic, strong) AVCaptureSession *session;
@property(nonatomic, strong) AVCaptureDevice *device;
@property(nonatomic, strong) AVCaptureDeviceInput *input;
@property(nonatomic, strong) AVCaptureMetadataOutput *output;
@property(nonatomic, strong) AVCaptureVideoPreviewLayer *prevLayer;
@property(strong, nonatomic) UIView *borderedView;
@property(strong, nonatomic) UILabel *tipLabel;
@property(strong, nonatomic) DoubanClient *doubanClient;
@property(strong, nonatomic) NSString *isbn;

@end

@implementation ScanViewController {
  BOOL retrievingData;
}

- (id)init {
  self = [super init];
  if (self) {
    self.doubanClient = [[DoubanClient alloc] init];
  }

  return self;
}

- (AVCaptureSession *)session {
  return _session;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _session = [[AVCaptureSession alloc] init];
  _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  NSError *error = nil;

  _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
  if (_input) {
    [_session addInput:_input];
  } else {
    NSLog(@"Error: %@", error);
  }

  _output = [[AVCaptureMetadataOutput alloc] init];
  [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
  [_session addOutput:_output];

  _output.metadataObjectTypes = [_output availableMetadataObjectTypes];

  _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
  _prevLayer.frame = self.view.bounds;
  _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
  [self.view.layer addSublayer:_prevLayer];

  self.borderedView = UIView.new;
  self.borderedView.layer.borderColor = [UIColor lightGrayColor].CGColor;
  self.borderedView.layer.borderWidth = 1.0f;
  [self.view addSubview:self.borderedView];

  self.tipLabel = [[UILabel alloc] init];
  self.tipLabel.text = @"将条形码放入框内，即可自动扫描";
  self.tipLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
  self.tipLabel.textColor = [UIColor whiteColor];
  self.tipLabel.numberOfLines = 1;
  [self.view addSubview:self.tipLabel];
  [_session startRunning];
  [self layout];
}

- (void)layout {
  [self.borderedView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.width.equalTo(@200);
    make.centerX.equalTo(self.view.mas_centerX);
    make.height.equalTo(@200);
    make.centerY.equalTo(self.view.mas_centerY);
  }];

  [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *maker) {
    maker.top.equalTo(self.borderedView.mas_bottom).with.offset(10);
    maker.centerX.equalTo(self.view.mas_centerX);
  }];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
  NSString *detectionString = nil;
  NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
          AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
          AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];

  for (AVMetadataObject *metadata in metadataObjects) {
    for (NSString *type in barCodeTypes) {
      if ([metadata.type isEqualToString:type]) {
        detectionString = [(AVMetadataMachineReadableCodeObject *) metadata stringValue];
        break;
      }
    }

    if (detectionString != nil) {
      self.isbn = detectionString;
      [_session stopRunning];
      NSLog(@"scan finished, starting to get data from douban");
      [self scanFinished];
      break;
    }
  }
}

- (void)scanFinished {
  if (retrievingData) return;
  retrievingData = YES;
  DBAccount *account = [[DBAccountManager sharedManager] linkedAccount];
  if (account) {
    [self getBookFromDouban];
  } else {
    [[DBAccountManager sharedManager] linkFromController:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dropboxAccountLinked:) name:@"dropboxAccountLinkResult" object:nil];
  }
}

- (void)dropboxAccountLinked:(NSNotification *)notification {
  DBAccount *account = notification.object;
  if (account) {
    [self getBookFromDouban];
  } else {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"无法保存数据，请重新扫描并登录dropbox" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
  }
}

- (void)getBookFromDouban {
  [self showLoadingView];
  [self.doubanClient retrieveBookBy:self.isbn
      success:^(Book *book) {
        BookAddViewController *bookAddViewController = [[BookAddViewController alloc] initWithBook:book];
        [self.navigationController pushViewController:bookAddViewController animated:YES];
        NSLog(@"%@", book);
      }
      failure:^(NSString *message) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
      }
  ];
}

- (void)showLoadingView {
  LoadingView *loadingView = [[LoadingView alloc] initWithText:@"已扫描，正在处理" backgroundColor:[UIColor darkGrayColor]];
  [self.view addSubview:loadingView];
  [loadingView mas_makeConstraints:^(MASConstraintMaker *maker) {
    maker.top.equalTo(self.borderedView.mas_top);
    maker.bottom.equalTo(self.borderedView.mas_bottom);
    maker.right.equalTo(self.borderedView.mas_right);
    maker.left.equalTo(self.borderedView.mas_left);
  }];
}

@end
