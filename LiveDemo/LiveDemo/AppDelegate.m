//
//  AppDelegate.m
//  LiveDemo
//
//  Created by mrgao on 2022/11/20.
//

#import <TXLiteAVSDK_Professional/TXLiteAVSDK.h>
#import "AppDelegate.h"
#import "LCGameConfigManager.h"
#import "LCLanguageManager.h"
#import "LCNavigationViewController.h"
#import "LCTabBarViewController.h"
#import <CoreTelephony/CTCellularData.h>
#import <ZFPlayer/ZFLandscapeRotationManager.h>
@interface AppDelegate ()<V2TXLivePremierObserver, TXLiveBaseDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [UILabel appearance].adjustsFontSizeToFitWidth = YES;
    LCLanguageManager *lanManager = [LCLanguageManager shareManager];
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"userLanguageKey"]){
        [lanManager setDefaultLanguage];
    }
    
//    [self networkState];
    [[LCConfigManager shareManager] updateConfigInfo];
    [[LCGameConfigManager shareManager] getGameCurrentStatus];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    LCTabBarViewController *vc = [[LCTabBarViewController alloc]init];
    [self.window setRootViewController:vc];
    [self.window makeKeyAndVisible];

    if (@available(iOS 13.4, *)) {
        [UIDatePicker appearance].preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
    [SVProgressHUD setErrorImage:nil];
    [SVProgressHUD setInfoImage:nil];
    [SVProgressHUD setSuccessImage:nil];
    [SVProgressHUD setMinimumDismissTimeInterval:1.2];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [V2TXLivePremier setLicence:TXPushLicenceURL key:TXPushLicenceKey];
    [V2TXLivePremier setObserver:self];

    [TXLiveBase setLicenceURL:TXPushLicenceURL key:TXPushLicenceKey];
    [TXLiveBase setConsoleEnabled:NO];
    
    return YES;
}
/// 在这里写支持的旋转方向，为了防止横屏方向，应用启动时候界面变为横屏模式
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    ZFInterfaceOrientationMask orientationMask = [ZFLandscapeRotationManager supportedInterfaceOrientationsForWindow:window];
    if (orientationMask != ZFInterfaceOrientationMaskUnknow) {
        return (UIInterfaceOrientationMask)orientationMask;
    }
    /// 这里是非播放器VC支持的方向
    return UIInterfaceOrientationMaskPortrait;
}
// MARK: ----- 检测app是否授权网络状态

- (void)networkState
{
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
        BOOL _isRestricted = YES;
        // 获取联网状态
        switch(state) {
            case kCTCellularDataRestricted:
                //NSLog(@"Restricted");// 拒绝
                break;
            case kCTCellularDataNotRestricted:
                //NSLog(@"Not Restricted");// 允许
                _isRestricted = NO;
                [[LCConfigManager shareManager] updateConfigInfo];
                [[LCGameConfigManager shareManager] getGameCurrentStatus];
                break;
            case kCTCellularDataRestrictedStateUnknown:
                //NSLog(@"Unknown");// 未知
                break;
            default:
                break;
        };
        if (_isRestricted)
        {
            [UIAlertController showAlertInViewController:self.window.rootViewController withTitle:KLanguage(@"提示") message:KLanguage(@"您未授权连接网络，可以在“设置->App->无线数据”中开启“无线数据”，连接网络后才能流畅使用。") cancelButtonTitle:nil destructiveButtonTitle:@"设置" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                if(buttonIndex == controller.destructiveButtonIndex){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }];
           
        }
    };

}
#pragma mark - V2TXLivePremierObserver
- (void)onLicenceLoaded:(int)result Reason:(NSString *)reason {
    NSLog(@"onLicenceLoaded: result:%d reason:%@", result, reason);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *_Nullable))restorationHandler {
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
