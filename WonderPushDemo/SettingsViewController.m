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

@interface SettingsViewController () <UITextFieldDelegate>

@property (nonatomic) IBOutlet UISwitch *swtEnableNotifications;
@property (nonatomic) IBOutlet UISwitch *swtEnableGeolocation;
@property (nonatomic) IBOutlet UITextField *txtUserId;

@property (nonatomic) IBOutlet UISwitch *swtNotificationTypeAlert;
@property (nonatomic) IBOutlet UISwitch *swtNotificationTypeBadge;
@property (nonatomic) IBOutlet UISwitch *swtNotificationTypeSound;
@property (weak, nonatomic) IBOutlet UISwitch *swtUserConsent;

@end

@implementation SettingsViewController

@synthesize swtEnableNotifications;

- (void)viewDidLoad {
    [super viewDidLoad];

    BOOL geolocation = [[NSUserDefaults standardUserDefaults] boolForKey:@"geolocation"];
    [self.swtEnableGeolocation setOn:geolocation];
    [self.swtUserConsent setOn:[WonderPush getUserConsent]];

    if ([WonderPush isReady]) {
        [self loadSettings];
    } else {
        [self.swtEnableNotifications setEnabled:NO];
        [[NSNotificationCenter defaultCenter] addObserverForName:WP_NOTIFICATION_INITIALIZED object:nil queue:nil usingBlock:^(NSNotification *note) {
            [self.swtEnableNotifications setEnabled:YES];
            [self loadSettings];
        }];
    }

    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            self.swtNotificationTypeAlert.on = settings.alertSetting == UNAuthorizationStatusAuthorized;
            self.swtNotificationTypeBadge.on = settings.badgeSetting == UNAuthorizationStatusAuthorized;
            self.swtNotificationTypeSound.on = settings.soundSetting == UNAuthorizationStatusAuthorized;
        }];
    } else if (@available(iOS 8.0, *)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(currentUserNotificationSettings)]) {
            UIUserNotificationSettings *currentSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
            UIUserNotificationType types = currentSettings ? currentSettings.types : 0;
            self.swtNotificationTypeAlert.on = (types & UIUserNotificationTypeAlert);
            self.swtNotificationTypeBadge.on = (types & UIUserNotificationTypeBadge);
            self.swtNotificationTypeSound.on = (types & UIUserNotificationTypeSound);
        } else {
            NSLog(@"Cannot resolve currentUserNotificationSettings");
        }
#pragma clang diagnostic pop
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        self.swtNotificationTypeAlert.on = (types & UIRemoteNotificationTypeAlert);
        self.swtNotificationTypeBadge.on = (types & UIRemoteNotificationTypeBadge);
        self.swtNotificationTypeSound.on = (types & UIRemoteNotificationTypeSound);
#pragma clang diagnostic pop
    }
}

- (void) loadSettings
{
    [self.swtEnableNotifications setOn:[WonderPush getNotificationEnabled]];
    self.txtUserId.text = [WonderPush userId];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.txtUserId) {
        NSLog(@"Setting userId to \"%@\"", self.txtUserId.text);
        [WonderPush setUserId:self.txtUserId.text];
    }
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)swtUserConsent_valueChange:(id)sender
{
    [WonderPush setUserConsent:self.swtUserConsent.isOn];
}

- (IBAction) swtNotificationType_valueChange:(UISwitch *)sender
{
    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            UNAuthorizationOptions opts = UNAuthorizationOptionNone;
            if (settings.alertSetting == UNAuthorizationStatusAuthorized) opts |= UNAuthorizationOptionAlert;
            if (settings.badgeSetting == UNAuthorizationStatusAuthorized) opts |= UNAuthorizationOptionBadge;
            if (settings.soundSetting == UNAuthorizationStatusAuthorized) opts |= UNAuthorizationOptionSound;
            if (self.swtNotificationTypeAlert.isOn) opts |= UNAuthorizationOptionAlert;
            else opts &= ~(UNAuthorizationOptionAlert);
            if (self.swtNotificationTypeBadge.isOn) opts |= UNAuthorizationOptionBadge;
            else opts &= ~(UNAuthorizationOptionBadge);
            if (self.swtNotificationTypeSound.isOn) opts |= UNAuthorizationOptionSound;
            else opts &= ~(UNAuthorizationOptionSound);
            [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:opts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (error) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }];
        }];
    } else if (@available(iOS 8.0, *)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(currentUserNotificationSettings)]) {
            UIUserNotificationSettings *currentSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
            UIUserNotificationType types = currentSettings.types;
            if (self.swtNotificationTypeAlert.isOn) types |= UIUserNotificationTypeAlert;
            else types &= ~(UIUserNotificationTypeAlert);
            if (self.swtNotificationTypeBadge.isOn) types |= UIUserNotificationTypeBadge;
            else types &= ~(UIUserNotificationTypeBadge);
            if (self.swtNotificationTypeSound.isOn) types |= UIUserNotificationTypeSound;
            else types &= ~(UIUserNotificationTypeSound);
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:currentSettings.categories];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        } else {
            NSLog(@"Cannot resolve currentUserNotificationSettings");
        }
#pragma clang diagnostic pop
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (self.swtNotificationTypeAlert.isOn) types |= UIRemoteNotificationTypeAlert;
        else types &= ~(UIUserNotificationTypeAlert);
        if (self.swtNotificationTypeBadge.isOn) types |= UIRemoteNotificationTypeBadge;
        else types &= ~(UIUserNotificationTypeBadge);
        if (self.swtNotificationTypeSound.isOn) types |= UIRemoteNotificationTypeSound;
        else types &= ~(UIRemoteNotificationTypeSound);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
#pragma clang diagnostic pop
    }
}

- (IBAction) btnUnregister_touchUpInside:(UIButton *)sender
{
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}

@end
