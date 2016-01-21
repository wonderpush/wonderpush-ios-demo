//
//  ViewController.m
//  WonderPushDemo
//
//  Created by YAKAZ on 01/10/14.
//  Copyright (c) 2014 WonderPush. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"
#import <WonderPush/WonderPush.h>

@interface SettingsViewController ()

@property (nonatomic) IBOutlet id swtEnableNotifications;
@property (nonatomic) IBOutlet id swtEnableGeolocation;

@end

@implementation SettingsViewController

@synthesize swtEnableNotifications;

- (void)viewDidLoad {
    [super viewDidLoad];

    BOOL geolocation = [[NSUserDefaults standardUserDefaults] boolForKey:@"geolocation"];
    [self.swtEnableGeolocation setOn:geolocation];

    if ([WonderPush isReady]) {
        [self loadSettings];
    } else {
        [self.swtEnableNotifications setEnabled:NO];
        [[NSNotificationCenter defaultCenter] addObserverForName:WP_NOTIFICATION_INITIALIZED object:nil queue:nil usingBlock:^(NSNotification *note) {
            [self.swtEnableNotifications setEnabled:YES];
            [self loadSettings];
        }];
    }
}

- (void) loadSettings
{
    [self.swtEnableNotifications setOn:[WonderPush getNotificationEnabled]];
}

- (IBAction) swtEnableNotifications_valueChange:(id)sender
{
    [WonderPush setNotificationEnabled:[self.swtEnableNotifications isOn]];
}

- (IBAction) swtEnableGeolocation_valueChange:(id)sender
{
    CLLocationManager *locationManager = (CLLocationManager *)((AppDelegate *)[UIApplication sharedApplication].delegate).locationManager;
    [[NSUserDefaults standardUserDefaults] setBool:[self.swtEnableNotifications isOn] forKey:@"geolocation"];
    if ([self.swtEnableNotifications isOn]) {
        [locationManager startUpdatingLocation];
    } else {
        [locationManager stopUpdatingLocation];
    }
}

@end
