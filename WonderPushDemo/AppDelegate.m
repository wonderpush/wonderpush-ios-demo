//
//  AppDelegate.m
//  WonderPushDemo
//
//  Created by YAKAZ on 01/10/14.
//  Copyright (c) 2014 WonderPush. All rights reserved.
//

#import "AppDelegate.h"
#import <WonderPush/WonderPush.h>
#import <WebKit/WebKit.h>


@interface AppDelegate () <WonderPushDelegate>

@end

@implementation AppDelegate

+ (void) initializeWonderPushWithClientId:(NSString *)clientId secret:(NSString *)secret {
    BOOL requiresUserConsent = [[NSUserDefaults standardUserDefaults] objectForKey:@"requiresUserConsent"] == nil ? NO : [[NSUserDefaults standardUserDefaults] boolForKey:@"requiresUserConsent"];
    [WonderPush setRequiresUserConsent:requiresUserConsent];
    [WonderPush setLogging:YES];
    [WonderPush setClientId:clientId secret:secret];
    [WonderPush setupDelegateForApplication:[UIApplication sharedApplication]];
    [WonderPush setupDelegateForUserNotificationCenter];
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.wonderpush.demo"];
    NSString *clientId = [defaults stringForKey:@"wp_clientId"];
    NSString *secret = [defaults stringForKey:@"wp_secret"];
    if (clientId && secret) {
        [AppDelegate initializeWonderPushWithClientId:clientId secret:secret];
    } else {
        NSLog(@"Could not initialize WonderPush. Client ID: %@ secret: %@", clientId, secret ? @"<redacted>" : nil);
    }
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
            WKWebView *webView = [WKWebView new];
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
