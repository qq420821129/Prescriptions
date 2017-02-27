//
//  AppDelegate.m
//  千金方
//
//  Created by 周小伟 on 2017/1/6.
//  Copyright © 2017年 周小伟. All rights reserved.
//

#import "AppDelegate.h"
#import "XTabbarController.h"

#import "Reachability.h"

#import "JPUSHService.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import <AdSupport/AdSupport.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"

@interface AppDelegate ()<JPUSHRegisterDelegate>
@property (nonatomic,assign) NSInteger launchNum;
@end

@implementation AppDelegate
@synthesize launchNum = _launchNum;
- (NSInteger)launchNum{
    _launchNum = [[NSUserDefaults standardUserDefaults] integerForKey:@"launchNum"];
    return _launchNum;
}

- (void)setLaunchNum:(NSInteger)launchNum{
    _launchNum = launchNum;
    [[NSUserDefaults standardUserDefaults] setInteger:launchNum forKey:@"launchNum"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UIApplication sharedApplication].statusBarHidden = YES;
    XTabbarController *tabController = [[XTabbarController alloc]init];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = tabController;
    [self.window makeKeyAndVisible];
    self.launchNum++;
    if (self.launchNum % 5 == 0) {
        [self checkVersion];
    }
    
    [self registerPushNotificationWithOptions:launchOptions];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self registerShareSdkWithOptions:launchOptions];
    return YES;
}

#pragma mark - ShareSDK
- (void)registerShareSdkWithOptions:(NSDictionary *)launchOptions{
    [ShareSDK registerApp:@"" activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformTypeMail),@(SSDKPlatformTypeCopy),@(SSDKPlatformTypeWechat),@(SSDKPlatformTypeQQ)] onImport:^(SSDKPlatformType platformType) {
        switch (platformType) {
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
            case SSDKPlatformTypeSinaWeibo:
                [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                break;
            default:
                break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType) {
            case SSDKPlatformTypeSinaWeibo:
                [appInfo SSDKSetupSinaWeiboByAppKey:@"3947694522" appSecret:@"fefd8b4e35fe9523ba61f4d8f6fdf613" redirectUri:@"http://www.baidu.com" authType:SSDKAuthTypeBoth];
                break;
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:@"wxaeabaa9accc794f8" appSecret:@"9c1848407102ff768c8e8c7bad431f06"];
                break;
            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:@"1105744956" appKey:@"yAs5vcX3pb62bwsJ" authType:SSDKAuthTypeBoth];
                break;
            default:
                break;
        }
    }];
}


#pragma mark - JPush
- (void)registerPushNotificationWithOptions:(NSDictionary *)launchOptions{
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc]init];
    entity.types = JPAuthorizationOptionAlert | JPAuthorizationOptionBadge | JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager]advertisingIdentifier]UUIDString];
    if([UIDevice currentDevice].systemVersion.floatValue >= 10.0){
        if (![[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            advertisingId = nil;
        }
    }
    [JPUSHService setupWithOption:launchOptions appKey:@"f1bfd5db2794acd46f5c147b" channel:@"App Store" apsForProduction:NO advertisingIdentifier:advertisingId];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"did Fail To Register For Remote Notifications With Error:%@",error);
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler{
    NSDictionary *userInfo = notification.request.content.userInfo;
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert);
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        completionHandler();
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)checkVersion{
    NSString *oldVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",@"1168251397"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [@"id=1168251397" dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    if ([[Reachability reachabilityWithHostName:@"http://www.baidu.com"]currentReachabilityStatus] == ReachableViaWiFi) {
        NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error == nil) {
                if (data) {
                    NSError *jsonError = [NSError errorWithDomain:NSURLErrorDomain code:0 userInfo:@{}];
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonError];
                    if ([dict[@"resultCount"] intValue] == 1) {
                        NSString *newVersion = dict[@"results"][0][@"version"];
                        if (!([oldVersion isEqualToString:newVersion])) {
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"有新版本可供更新" message:nil preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dict[@"results"][0][@"trackViewUrl"]]];
                            }];
                            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
                            [alertController addAction:cancleAction];
                            [alertController addAction:okAction];
                            [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
                        }
                    }
                }
            }
        }];
        [task resume];
    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
