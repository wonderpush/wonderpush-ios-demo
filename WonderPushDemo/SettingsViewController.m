//
//  ViewController.m
//  WonderPushDemo
//
//  Created by YAKAZ on 01/10/14.
//  Copyright (c) 2014 WonderPush. All rights reserved.
//

#import "SettingsViewController.h"
#import <WonderPush/WonderPush.h>

@interface SettingsViewController ()

@property (nonatomic) IBOutlet id swtEnableNotifications;

@end

@implementation SettingsViewController

@synthesize swtEnableNotifications;

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([WonderPush isReady]) {
        [self loadSettings];
    } else {
        [swtEnableNotifications setEnabled:NO];
        [[NSNotificationCenter defaultCenter] addObserverForName:WP_NOTIFICATION_INITIALIZED object:nil queue:nil usingBlock:^(NSNotification *note) {
            [swtEnableNotifications setEnabled:YES];
            [self loadSettings];
        }];
    }
}

- (void) loadSettings
{
    [swtEnableNotifications setOn:[WonderPush getNotificationEnabled]];
}

- (IBAction) swtEnableNotifications_valueChange:(id)sender
{
    [WonderPush setNotificationEnabled:[swtEnableNotifications isOn]];
}

@end
