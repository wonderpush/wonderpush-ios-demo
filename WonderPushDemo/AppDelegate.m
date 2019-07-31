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


@interface AppDelegate () <WonderPushDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL requiresUserConsent = [[NSUserDefaults standardUserDefaults] objectForKey:@"requiresUserConsent"] == nil ? YES : [[NSUserDefaults standardUserDefaults] boolForKey:@"requiresUserConsent"];
    [WonderPush setRequiresUserConsent:requiresUserConsent];
    [WonderPush setLogging:YES];
    [WonderPush setClientId:@"7524c8a317c1794c0b23895dce3a3314d6a24105" secret:@"b43a2d0fbdb54d24332b4d70736954eab5d24d29012b18ef6d214ff0f51e7901"];
    [WonderPush setupDelegateForApplication:application];
    [WonderPush setupDelegateForUserNotificationCenter];
    [WonderPush setDelegate:self];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Register an example method
    [[NSNotificationCenter defaultCenter] addObserverForName:@"example" object:nil queue:nil usingBlock:^(NSNotification *note) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"The example method was called"
                                                                       message:[NSString stringWithFormat:@"argument: %@",
                                                                                [note.userInfo objectForKey:WP_REGISTERED_CALLBACK_PARAMETER_KEY]]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [application.keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        });
    }];

    // Register a catchall listener to help seeing called methods
    [[NSNotificationCenter defaultCenter] addObserverForName:nil object:[WonderPush self] queue:nil usingBlock:^(NSNotification *note) {
        if ([note.userInfo isKindOfClass:[NSDictionary class]]
            && [note.userInfo objectForKey:WP_REGISTERED_CALLBACK_PARAMETER_KEY]
            && ![note.name isEqualToString:@"example"] // avoid a second notification for the "example" method handled above
        ) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Method \"%@\" called",
                                                                                    note.name]
                                                                           message:[NSString stringWithFormat:@"argument: %@",
                                                                                    [note.userInfo objectForKey:WP_REGISTERED_CALLBACK_PARAMETER_KEY]]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [application.keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
            });
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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    NSLog(@"application: openURL:%@ options:%@", url, options);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Deep link" message:[url absoluteString] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [application.keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
    return YES;
}

#pragma mark - WonderPushDelegate

/**
 Open all URLs with a wonderpush.com hostname in a web view.
 */
- (void) wonderPushWillOpenURL:(NSURL *)URL withCompletionHandler:(void (^)(NSURL *))completionHandler
{
    if ([[URL host] hasSuffix:@".wonderpush.com"]) {
        id navigationController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        if ([navigationController isKindOfClass:[UINavigationController class]]) {
            UIViewController *controller = [UIViewController new];
            UIWebView *webView = [UIWebView new];
            webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [controller.view addSubview:webView];
            webView.frame = controller.view.bounds;
            [webView loadRequest:[NSURLRequest requestWithURL:URL]];
            [navigationController pushViewController:controller animated:true];
            completionHandler(nil);
            return;
        }
    }
    completionHandler(URL);
}
@end
