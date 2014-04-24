//
//  ScanPreparationViewController.m
//  small_kangaroo_library
//
//  Created by Jacky Li on 24/4/14.
//  Copyright (c) 2014 SmallKangarooLibrary. All rights reserved.
//

#import "ScanPreparationViewController.h"

@interface ScanPreparationViewController ()

@end

@implementation ScanPreparationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
     self.navigationItem.title = @"添加书籍";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
