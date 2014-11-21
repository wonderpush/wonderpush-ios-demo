//
//  AppDelegate.m
//  WonderPushDemo
//
//  Created by YAKAZ on 01/10/14.
//  Copyright (c) 2014 WonderPush. All rights reserved.
//

#import "AppDelegate.h"
#import <WonderPush/WonderPush.h>
#import <UIKit/UIKit.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [WonderPush setClientId:@"7524c8a317c1794c0b23895dce3a3314d6a24105" secret:@"b43a2d0fbdb54d24332b4d70736954eab5d24d29012b18ef6d214ff0f51e7901"];
    [WonderPush setNotificationEnabled:YES];
    [WonderPush handleApplicationLaunchWithOption:launchOptions];

    // Register an example method
    [[NSNotificationCenter defaultCenter] addObserverForName:@"example" object:nil queue:nil usingBlock:^(NSNotification *note) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The example method was called"
                                                        message:[NSString stringWithFormat:@"argument: %@",
                                                                 [note.userInfo objectForKey:WP_REGISTERED_CALLBACK_PARAMETER_KEY]]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];

    // Register a catchall listener to help seeing called methods
    [[NSNotificationCenter defaultCenter] addObserverForName:nil object:[WonderPush self] queue:nil usingBlock:^(NSNotification *note) {
        if ([note.userInfo isKindOfClass:[NSDictionary class]]
            && [note.userInfo objectForKey:WP_REGISTERED_CALLBACK_PARAMETER_KEY]
            && ![note.name isEqualToString:@"example"] // avoid a second notification for the "example" method handled above
        ) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Method \"%@\" called",
                                                                     note.name]
                                                            message:[NSString stringWithFormat:@"argument: %@",
                                                                     [note.userInfo objectForKey:WP_REGISTERED_CALLBACK_PARAMETER_KEY]]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];

    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [WonderPush handleNotification:notification.userInfo];
}


-(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [WonderPush didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [WonderPush handleDidReceiveRemoteNotification:userInfo];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
