//
//  WonderPush.h
//  WonderPush
//
//  Created by YAKAZ on 16/09/14.
//  Copyright (c) 2014 WonderPush. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

/**
 Name of the notification that is sent using NSNotificationCenter when the sdk is initialized
 */
#define WP_NOTIFICATION_INITIALIZED @"_wonderpushInitialized"
/**
 Key of the SID parameter for WP_NOTIFICATION_USER_LOGED_IN notification
 */
#define WP_NOTIFICATION_USER_LOGED_IN_SID_KEY @"_wonderpushSID"
/**
 Key of the Access Token parameter for WP_NOTIFICATION_USER_LOGED_IN notification
 */
#define WP_NOTIFICATION_USER_LOGED_IN_ACCESS_TOKEN_KEY @"_wonderpushAccessToken"
/**
 Name of the notification that is sent using NSNotificationCenter when a user logs in
 */
#define WP_NOTIFICATION_USER_LOGED_IN @"_wonderpushUserLoggedIn"

/**
 Key of the parameter used when a button of type 'method' is called
 */
#define WP_REGISTERED_CALLBACK_PARAMETER_KEY @"_wonderpushCallbackParameter"

/**
 Button of type link (opens the browser)
 */
#define WP_ACTION_LINK @"link"
/**
 Button of type map (opens the map application)
 */
#define WP_ACTION_MAP_OPEN @"mapOpen"
/**
 Button of type method (launch a notification using NSNotification)
 */
#define WP_ACTION_METHOD_CALL @"method"
/**
 Button of type rating (opens the itunes app on the current application)
 */
#define WP_ACTION_RATING @"rating"
/**
 Button of type track event (track a event on button click)
 */
#define WP_ACTION_TRACK @"trackEvent"
/**
 Key to set in your .plist file to allow rating button action
 */
#define WP_ITUNES_APP_ID @"itunesAppID"

/**
 Key of the wonderpush content in a push notification
 */
#define WP_PUSH_NOTIFICATION_KEY @"_wp"
/**
 Notification of type map
 */
#define WP_PUSH_NOTIFICATION_SHOW_MAP @"map"
/**
 Notification of type url
 */
#define WP_PUSH_NOTIFICATION_SHOW_URL @"url"
/**
 Notification of type text
 */
#define WP_PUSH_NOTIFICATION_SHOW_TEXT @"text"
/**
 Notification of simple type
 */
#define WP_PUSH_NOTIFICATION_SIMPLE_MESSAGE @"simple"


/**
 Notification of type html
 */
#define WP_PUSH_NOTIFICATION_SHOW_HTML @"html"

/**
 `WonderPush` is your main interface to the Wonderpush SDK.
 
 ## Initialization
 Call `setClientId:secret` in your `AppDelegate` to initialize the SDK:
 
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
 {
 [Scoreflex setClientId:@"XXXXXX" secret:@"YYYYYY"];
 
 // Override point for customization after application launch.
 
 return YES;
 }
 
 ## Tracking events
 
 - `trackEvent:withData:`
 
 */

@interface WonderPush : NSObject

///---------------------
/// @name Initialization
///---------------------

/**
 Initializes the wonderpush SDK.
 
 Initialization should occur the earliest possible when your application starts.
 A good place is the `application:didFinishLaunchingWithOptions:` method of your AppDelegate.
 
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
 {
 [WonderPush setClientId:@"XXXXXX" secret:@"YYYYYY"];
 
 // Override point for customization after application launch.
 
 return YES;
 } 
 @param clientId Your Wonderpush client ID
 @param secret Your wonderpush secret
*/
+ (void) setClientId:(NSString *)clientId secret:(NSString *)secret;

/**
 Set the user Id if deferent from the current userId will get a new access token
 @param userId the new userId
 */
+ (void) setUserId:(NSString *) userId;

+ (void) initialize;


///---------------------
/// @name Push Notification
///---------------------
/**
 Activate or deactivate the push notification on the device (if the user accepts) and register the device token to Wonderpush backend
 @param enabled the new state of the push notification
 */
+ (void) setNotificationEnabled:(BOOL) enabled;

/**
 Handles a notification to present the associated dialog
 @param notificationDictionnary the notification parameters
 */
+ (BOOL) handleNotification:(NSDictionary*) notificationDictionnary;

/**
 Method to call in your `- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions` method
 @param launchOptions the launch options
 */
+ (BOOL) handleApplicationLaunchWithOption:(NSDictionary*) launchOptions;

/**
 Method call in your `-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo` method
 @param userInfo the userInfo provided by the system
 */
+ (BOOL) handleDidReceiveRemoteNotification:(NSDictionary *)userInfo;

/**
 Method call in your `-(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken` method
 @param deviceToken the device token provided by the system
 */
+ (void) didRegisterForRemoteNotificationsWithDeviceToken:(NSData*) deviceToken;

/**
 If your application uses backgroundModes/remote-notification, call this method in your
 `- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))` method
 @param userInfo the userInfo provided by the system
 */
+ (void) handleNotificationReceivedInBackground:(NSDictionary *)userInfo;


///---------------------
/// @name Installation data and events
///---------------------

/**
 Updates or add properties to the current installation
 @param properties a collection of properties to add 
 @param overwrite if true all the installation will be cleaned before update
 */
+ (void) updateInstallation:(NSDictionary *) properties shouldOverwrite:(BOOL) overwrite;


/**
 Track an event for the current installation
 @param type a string defining the event
 @param data a key value dictionary with additional data for the event
 */
+ (void) trackEvent:(NSString*) type withData:(id)data;



@end
