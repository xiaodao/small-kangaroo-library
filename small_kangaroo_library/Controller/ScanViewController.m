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
#import "Masonry.h"
#import "ScanViewController.h"
#import "Book.h"

#define DOUBAN_ISBN_URL @"http://api.douban.com/v2/book/isbn/"


@interface ScanViewController () <AVCaptureMetadataOutputObjectsDelegate>
@property(nonatomic, retain) NSOperationQueue *queue;

@property(nonatomic, strong) AVCaptureSession *session;
@property(nonatomic, strong) AVCaptureDevice *device;
@property(nonatomic, strong) AVCaptureDeviceInput *input;
@property(nonatomic, strong) AVCaptureMetadataOutput *output;
@property(nonatomic, strong) AVCaptureVideoPreviewLayer *prevLayer;
@property(strong, nonatomic) UIView *borderedView;
@property(strong, nonatomic) UILabel *tipLabel;
@end

@implementation ScanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.queue=[[NSOperationQueue alloc] init];

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
      NSLog(@"ISBN: %@", detectionString);
      [_session stopRunning];
      [self getBookDetails:detectionString];
      break;
    }
  }
}

- (void)getBookDetails:(NSString *)isbn {
  NSURL *bookUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DOUBAN_ISBN_URL, isbn]];
  NSLog(@"Started to get book details: %@ ", bookUrl);

  NSURLRequest *request = [NSURLRequest requestWithURL:bookUrl cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:7.0f];

  [NSURLConnection sendAsynchronousRequest:request queue:self.queue completionHandler:^(NSURLResponse *res, NSData *data, NSError *error) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [self getBookDetailCallback:error withData:data isbn:isbn ];
    });
  }];
}

- (void)getBookDetailCallback:(NSError *)error withData:(NSData *)data isbn:(NSString *)isbn {
  if(data==nil || error!=nil){
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"连接网络失败了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
  }else{
    NSLog(@"Get data from douban");
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if([json valueForKey:@"msg"]==nil){
      Book *book = [Book newFromJson:json andIsbn:isbn];
      NSLog(@"%@", book);
    }else{
      UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"没有找到这本书" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
      [alert show];
    }
  }
}
@end
