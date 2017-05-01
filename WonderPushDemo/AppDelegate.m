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


- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [WonderPush setLogging:YES];
    [WonderPush setClientId:@"7524c8a317c1794c0b23895dce3a3314d6a24105" secret:@"b43a2d0fbdb54d24332b4d70736954eab5d24d29012b18ef6d214ff0f51e7901"];
    [WonderPush setupDelegateForApplication:application];
    [WonderPush setupDelegateForUserNotificationCenter];
    //[WonderPush putInstallationCustomProperties:@{@"int_foo": [NSNumber numberWithInt:(int)arc4random()]}];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
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

    self.locationManager = [CLLocationManager new];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    BOOL geolocation = [[NSUserDefaults standardUserDefaults] boolForKey:@"geolocation"];
    if (geolocation) {
        [self.locationManager startUpdatingLocation];
    }

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"application: openURL:%@ sourceApplication:%@ annotation:%@", url, sourceApplication, annotation);
    [[[UIAlertView alloc] initWithTitle:@"Deep link" message:[url absoluteString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    NSLog(@"application: openURL:%@ options:%@", url, options);
    [[[UIAlertView alloc] initWithTitle:@"Deep link" message:[url absoluteString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    return YES;
}

@end
