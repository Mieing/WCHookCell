#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "substrate.h"


// 微信相关类声明
@interface WCPluginsMgr : NSObject
+ (instancetype)sharedInstance;
- (void)registerControllerWithTitle:(NSString *)title version:(NSString *)version controller:(NSString *)controller;
@end

static BOOL didRegisterXUUZHelper = NO;

%hook MicroMessengerAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 注册插件带设置页面
    if (NSClassFromString(@"WCPluginsMgr")) {
        if (!didRegisterXUUZHelper) {
            WCPluginsMgr *pluginsMgr = [objc_getClass("WCPluginsMgr") sharedInstance];
            [pluginsMgr registerControllerWithTitle:@"一包小薯条" version:@"5.2.0" controller:@"WCPLSettingViewController"];
            didRegisterXUUZHelper = YES;
        }
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (NSClassFromString(@"WCPluginsMgr") && !didRegisterXUUZHelper) {
                WCPluginsMgr *pluginsMgr = [objc_getClass("WCPluginsMgr") sharedInstance];
                [pluginsMgr registerControllerWithTitle:@"一包小薯条" version:@"5.2.0" controller:@"WCPLSettingViewController"];
                didRegisterXUUZHelper = YES;
            }
        });
    }

    BOOL result = %orig(application, launchOptions);
    return result;
}

%end
