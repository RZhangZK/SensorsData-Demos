//
//  AppDelegate.m
//  EmbeddedJavaScriptSDK
//
//  Created by 张占凯 on 2019/11/6.
//  Copyright © 2019 Sensors Data. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [self initSensorsAnalyticsWithLaunchOptions:launchOptions];
    return YES;
}

- (void)initSensorsAnalyticsWithLaunchOptions:(NSDictionary *)launchOptions {

    NSString *SAServerURL = @"https://sdktest.datasink.sensorsdata.cn/sa?project=zhangzhankai&token=21f2e56df73988c7";
    SAConfigOptions *options = [SAConfigOptions.alloc initWithServerURL:SAServerURL launchOptions:launchOptions];
    options.autoTrackEventType = SensorsAnalyticsEventTypeAppStart | SensorsAnalyticsEventTypeAppEnd | SensorsAnalyticsEventTypeAppViewScreen | SensorsAnalyticsEventTypeAppClick;
    options.enableTrackAppCrash = YES;
    [SensorsAnalyticsSDK startWithConfigOptions:options];
    [SensorsAnalyticsSDK.sharedInstance enableLog:YES];

    [SensorsAnalyticsSDK.sharedInstance addWebViewUserAgentSensorsDataFlag];
    [SensorsAnalyticsSDK.sharedInstance enableHeatMap];
    [SensorsAnalyticsSDK.sharedInstance enableVisualizedAutoTrack];

    [SensorsAnalyticsSDK.sharedInstance registerSuperProperties:@{}];
    NSString *launchOptionsString = launchOptions ? launchOptions.description : @"空";
    [SensorsAnalyticsSDK.sharedInstance trackInstallation:@"AppInstall" withProperties:@{@"launchOptions":launchOptionsString}];
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
