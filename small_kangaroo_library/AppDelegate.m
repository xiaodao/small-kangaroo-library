//
//  AppDelegate.m
//  small_kangaroo_library
//
//  Created by Jacky Li on 23/4/14.
//  Copyright (c) 2014 SmallKangarooLibrary. All rights reserved.
//

#import "AppDelegate.h"
#import "ScanPreparationViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  ScanPreparationViewController *scanPreparationViewController = [[ScanPreparationViewController alloc] init];
  UINavigationController *mainController = [[UINavigationController alloc] initWithRootViewController:scanPreparationViewController];
  // Override point for customization after application launch.
  self.window.rootViewController = mainController;
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  return YES;
}

@end