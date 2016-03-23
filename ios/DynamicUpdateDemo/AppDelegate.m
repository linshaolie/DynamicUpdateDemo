/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "AppDelegate.h"
#import "RCTRootView.h"
#import "NSObject+UpdateSupport.h"
#import "NativeNotificationManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [NativeNotificationManager addObserver:self selector:@selector(hadNewJSBundleVersion:) name:@"HadNewJSBundleVersion" object:nil];
  
  RCTRootView *rootView = [self getRootViewModuleName:@"DynamicUpdateDemo" launchOptions:launchOptions];
  
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)hadNewJSBundleVersion:(NSNotification *)notification {
  //根据需求设置下载地址
  NSString *version = APP_VERSION;
#warning 替换为自己的URL
  NSString *base = [@"http://domain/" stringByAppendingString:version];
  NSString *uRLStr = [base stringByAppendingString:@"/main.jsbundle"];
  NSString *md5URLStr = [base stringByAppendingString:@"/mainMd5.jsbundle"];
  NSURL *dstURL = [self URLForCodeInDocumentsDirectory];
  [self downloadCodeFrom:uRLStr md5URLString:md5URLStr toURL:dstURL completeHandler:^(BOOL result) {
    NSLog(@"finish: %@", @(result));
  }];
}

@end
