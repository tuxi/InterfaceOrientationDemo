//
//  AppDelegate.m
//  InterfaceOrientationDemo
//
//  Created by xiaoyuan on 2018/7/17.
//  Copyright © 2018 xiaoyuan. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
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

- (UIInterfaceOrientationMask)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window {
    // iPhone doesn't support upside down by default, while the iPad does.  Override to allow all orientations always, and let the root view controller decide what's allowed (the supported orientations mask gets intersected).
    
    UIViewController * presentdeVC = [self.class topViewControllerWithPresentedViewController];
    if ([presentdeVC isKindOfClass:NSClassFromString(@"NaviController")])
        return UIInterfaceOrientationMaskAllButUpsideDown;
    
    return UIInterfaceOrientationMaskPortrait;
}

+ (UIViewController *)topViewControllerWithPresentedViewController {
    UIViewController *vc = [self topViewController];
    if (vc) vc = [self getTopPresentedViewControllerForController:vc];
    return vc;
}

+ (UIViewController *)getTopPresentedViewControllerForController:(UIViewController *)viewController {
    if (viewController.presentedViewController) {
        UIViewController *vc = viewController.presentedViewController;
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController *)vc).topViewController;
        }
        viewController = [self getTopPresentedViewControllerForController:vc];
    }
    return viewController;
}
+ (UIViewController *)topViewController {
    UINavigationController * navigationController = [self currentNaigationController];
    if ([navigationController isKindOfClass:[UINavigationController class]]) {
        UIViewController * currentViewController = [navigationController topViewController];
        return currentViewController;
    }
    return nil;
}

+ (UINavigationController *)currentNaigationController {
    UIViewController *rootVc = [UIApplication sharedApplication].delegate.window.rootViewController;
    if ([rootVc isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)rootVc;
    }
    else if ([rootVc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tbVc = (UITabBarController *)rootVc;
        UINavigationController *nac = [tbVc selectedViewController];
        if ([nac isKindOfClass:[UINavigationController class]]) {
            return nac;
        }
    }
    return nil;
}
@end
