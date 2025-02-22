#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "substrate.h"

// 微信类声明
@interface WCPluginsMgr : NSObject
+ (instancetype)sharedInstance;
- (void)registerControllerWithTitle:(NSString *)title version:(NSString *)version controller:(NSString *)controller; // 设置页注册声明
- (void)registerSwitchWithTitle:(NSString *)title key:(NSString *)key; // 单开关注册声明
@end

static BOOL didRegisterXUUZHelper = NO;

%hook MicroMessengerAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (NSClassFromString(@"WCPluginsMgr")) {
        if (!didRegisterXUUZHelper) {
            WCPluginsMgr *pluginsMgr = [objc_getClass("WCPluginsMgr") sharedInstance];
            
            // 单开关注册
            [pluginsMgr registerSwitchWithTitle:@"一包小薯条" key:@"false"];
            
            // 设置页注册
            [pluginsMgr registerControllerWithTitle:@"一包小薯条" version:@"5.2.0" controller:@"WCPLSettingViewController"];
            
            didRegisterXUUZHelper = YES;  // 防止重复注册
        }
    } else {
        // 如果 WCPluginsMgr 没有加载，延迟 1 秒后再次尝试注册
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (NSClassFromString(@"WCPluginsMgr") && !didRegisterXUUZHelper) {
                WCPluginsMgr *pluginsMgr = [objc_getClass("WCPluginsMgr") sharedInstance];
                
                // 单开关注册
                [pluginsMgr registerSwitchWithTitle:@"一包小薯条" key:@"false"];
                
                // 设置页注册
                [pluginsMgr registerControllerWithTitle:@"一包小薯条" version:@"5.2.0" controller:@"WCPLSettingViewController"];
                
                didRegisterXUUZHelper = YES;  // 防止重复注册
            }
        });
    }

    BOOL result = %orig(application, launchOptions);
    return result;
}

%end
