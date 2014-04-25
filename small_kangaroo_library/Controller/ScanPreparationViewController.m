//
//  ScanPreparationViewController.m
//  small_kangaroo_library
//
//  Created by Jacky Li on 24/4/14.
//  Copyright (c) 2014 SmallKangarooLibrary. All rights reserved.
//

#import "ScanPreparationViewController.h"
#import "ScanViewController.h"

@interface ScanPreparationViewController ()

@end

@implementation ScanPreparationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
     self.navigationItem.title = @"小袋鼠";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)scan:(id)sender {
  ScanViewController *scanViewController = [[ScanViewController alloc] init];
  [self.navigationController pushViewController:scanViewController animated:YES];
}
@end
