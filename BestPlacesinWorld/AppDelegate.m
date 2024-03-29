//
//  AppDelegate.m
//  BestPlacesinWorld
//
//  Created by Andpercent on 21/08/2019.
//  Copyright © 2019 Domojis. All rights reserved.
//

#import "AppDelegate.h"
#import <APMultiMenu/APMultiMenu.h>
@import Firebase;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        [FIRApp configure];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]) {
        
    

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *mainVC = [sb instantiateViewControllerWithIdentifier:@"HomeNav"];
    UIViewController *leftVC = [sb instantiateViewControllerWithIdentifier:@"LeftMenuViewController"];
    
    APMultiMenu *apmm = [[APMultiMenu alloc] initWithMainViewController:mainVC
                                                               leftMenu:leftVC
                                                              rightMenu:nil];
    
    apmm.mainViewShadowColor = [UIColor blackColor];
    apmm.mainViewShadowRadius = 6.0f;
    apmm.mainViewShadowEnabled = YES;
    
    apmm.menuIndentationEnabled = YES;
    apmm.panGestureEnabled = YES;
    
    self.window.rootViewController = apmm;
    [self.window makeKeyAndVisible];
    }
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


@end
