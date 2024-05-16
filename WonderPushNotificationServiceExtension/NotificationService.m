#import "NotificationService.h"

@implementation NotificationService

+ (NSString *)clientId {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.wonderpush.demo"];
    return [defaults valueForKey:@"wp_clientId"];
}

+ (NSString *)clientSecret {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.wonderpush.demo"];
    return [defaults valueForKey:@"wp_secret"];
}

@end
