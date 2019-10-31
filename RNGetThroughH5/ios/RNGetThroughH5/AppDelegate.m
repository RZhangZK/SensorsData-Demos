/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "AppDelegate.h"

#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>

#import <SensorsAnalyticsSDK/SensorsAnalyticsSDK.h>

static NSString *const SAServerURL = @"http://sdktest.datasink.sensorsdata.cn/sa?token=21f2e56df73988c7&project=yangzhankun";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [self initSensorsAnalyticsWithLaunchOptions:launchOptions];

  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge
                                                   moduleName:@"RNGetThroughH5"
                                            initialProperties:nil];

  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)initSensorsAnalyticsWithLaunchOptions:(NSDictionary *)launchOptions {
    SAConfigOptions *options = [[SAConfigOptions alloc] initWithServerURL:SAServerURL launchOptions:launchOptions];
    options.autoTrackEventType = SensorsAnalyticsEventTypeAppStart | SensorsAnalyticsEventTypeAppEnd | SensorsAnalyticsEventTypeAppClick;
    [SensorsAnalyticsSDK startWithConfigOptions:options];
    [SensorsAnalyticsSDK.sharedInstance enableLog:YES];
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

@end
