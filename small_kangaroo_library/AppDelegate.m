//
//  AppDelegate.m
//  small_kangaroo_library
//
//  Created by Jacky Li on 23/4/14.
//  Copyright (c) 2014 SmallKangarooLibrary. All rights reserved.
//

#import <Dropbox/Dropbox.h>
#import "AppDelegate.h"
#import "ScanPreparationViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  DBAccountManager *mgr =
          [[DBAccountManager alloc] initWithAppKey:@"34imuqk9n328tee" secret:@"fzhw7s9me85uo8g"];
  [DBAccountManager setSharedManager:mgr];

  ScanPreparationViewController *scanPreparationViewController = [[ScanPreparationViewController alloc] init];
  UINavigationController *mainController = [[UINavigationController alloc] initWithRootViewController:scanPreparationViewController];
  self.window.rootViewController = mainController;
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  DBAccount *account = [[DBAccountManager sharedManager] handleOpenURL:url];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"dropboxAccountLinkResult" object:account userInfo:@{}];
  return YES;
}
@end