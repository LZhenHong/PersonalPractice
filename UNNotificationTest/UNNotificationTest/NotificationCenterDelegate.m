//
//  NotificationCenterDelegate.m
//  UNNotificationTest
//
//  Created by LZhenHong on 2020/9/25.
//

#import "NotificationCenterDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "NSString+Notification.h"

@interface NotificationCenterDelegate () <UNUserNotificationCenterDelegate>
@end

@implementation NotificationCenterDelegate

+ (instancetype)sharedDelegate {
    static NotificationCenterDelegate *delegate = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        delegate = [[NotificationCenterDelegate alloc] init];
    });
    return delegate;
}

+ (void)registerToCurrentNotificationCenterDelegate {
    [[UNUserNotificationCenter currentNotificationCenter] setDelegate:[self sharedDelegate]];
}

// App 在前台，通知触发会调用这个方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSLog(@"UserInfo: %@", notification.request.content.userInfo);
    
    completionHandler(UNNotificationPresentationOptionSound);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler {
    if ([response.notification.request.content.categoryIdentifier isEqual:[NSString testCategoryNotificationIdentifier]]) {
        NSDictionary *userInfo = response.notification.request.content.userInfo;
        NSLog(@"%@ %@", userInfo[@"TEXT"], userInfo[@"EMOJI"]);
        
        if ([response.actionIdentifier isEqual:[NSString okActionNotificationIdentifier]]) {
            NSLog(@"OK Action click");
        } else if ([response.actionIdentifier isEqual:[NSString waitActionNotificationIdentifier]]) {
            NSLog(@"Wait Action click");
        } else if ([response.actionIdentifier isEqual:UNNotificationDefaultActionIdentifier]) { // 用户通过通知打开了 App
            NSLog(@"User open app through notification");
        } else if ([response.actionIdentifier isEqual:UNNotificationDismissActionIdentifier]) { // 用户点击了通知的关闭按钮
            NSLog(@"User dimiss notification");
        }
    }
    
    completionHandler();
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
   openSettingsForNotification:(UNNotification *)notification {
    NSLog(@"%s", __func__);
}

@end
