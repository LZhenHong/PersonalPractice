//
//  ViewController.m
//  UNNotificationTest
//
//  Created by LZhenHong on 2020/9/24.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "NSString+Notification.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)requestAuthorization {
    // UNAuthorizationOptionProvidesAppNotificationSettings 这个会在设置界面 App 的通知界面加上一个选项
    // https://stackoverflow.com/questions/53877727/how-to-redirect-from-ios-app-notifications-settings-to-app-notification-settings
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionAlert |
     UNAuthorizationOptionBadge |
     UNAuthorizationOptionSound |
     UNAuthorizationOptionProvidesAppNotificationSettings completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"授权成功！");
        } else {
            NSLog(@"授权失败！");
            if (error) {
                NSLog(@"Error: %@", error);
            }
        }
    }];
}

- (IBAction)requestProvisionalAuthorization {
    // Unlike explicitly requesting authorization, this code doesn’t prompt the user for permission to receive notifications. Instead, the first time you call this method, it automatically grants authorization.
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionAlert |
     UNAuthorizationOptionBadge |
     UNAuthorizationOptionSound |
     UNAuthorizationOptionProvisional |
     UNAuthorizationOptionProvidesAppNotificationSettings completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"授权成功！");
        } else {
            NSLog(@"授权失败！");
            if (error) {
                NSLog(@"Error: %@", error);
            }
        }
    }];
}

- (IBAction)printNotificationSettings {
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus == UNAuthorizationStatusAuthorized || settings.authorizationStatus == UNAuthorizationStatusProvisional) {
            if (settings.alertSetting == UNNotificationSettingEnabled) {
                NSLog(@"Notification alert setting enabled.");
            } else {
                NSLog(@"Notification alert setting disabled.");
            }
        } else {
            NSLog(@"Notification not authorize.");
        }
    }];
}

- (IBAction)scheduleNotification {
    UNMutableNotificationContent *notificationContent = [[UNMutableNotificationContent alloc] init];
    notificationContent.categoryIdentifier = [NSString testCategoryNotificationIdentifier];
    notificationContent.userInfo = @{
        @"TEXT": @"来啦，来啦",
        @"EMOJI": @"😄😄"
    };
    notificationContent.title = @"通知来啦";
    notificationContent.subtitle = @"来看看我吧";
    notificationContent.body = @"快来看看是什么吧";
    
    // UNCalendarNotificationTrigger
    // UNTimeIntervalNotificationTrigger
    // UNLocationNotificationTrigger
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
    
    UNNotificationRequest *notificationRequest = [UNNotificationRequest requestWithIdentifier:@"TEST_NOTE" content:notificationContent trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:notificationRequest withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"添加推送失败了 o_0 %@", error.localizedDescription);
        } else {
            NSLog(@"添加推送成功啦 o.o");
        }
    }];
}

- (IBAction)removePendingTestNotification {
    [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[@"TEST_NOTE"]];
}

- (IBAction)removeDeliveredNotification {
    [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[@"TEST_NOTE"]];
}

// 修改通知就是重新添加一个相同 ID 的通知
- (IBAction)updatePendingNotification {
    UNMutableNotificationContent *notificationContent = [[UNMutableNotificationContent alloc] init];
    notificationContent.categoryIdentifier = [NSString testCategoryNotificationIdentifier];
    notificationContent.userInfo = @{
        @"TEXT": @"来啦，来啦",
        @"EMOJI": @"😄😄"
    };
    notificationContent.title = @"通知来啦";
    notificationContent.subtitle = @"你不知道吧，其实我已经偷偷修改过这条通知咯";
    notificationContent.body = @"快来看看是什么吧";
    
    // UNCalendarNotificationTrigger
    // UNTimeIntervalNotificationTrigger
    // UNLocationNotificationTrigger
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
    
    UNNotificationRequest *notificationRequest = [UNNotificationRequest requestWithIdentifier:@"TEST_NOTE" content:notificationContent trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:notificationRequest withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"修改推送失败了 o_0 %@", error.localizedDescription);
        } else {
            NSLog(@"修改推送成功啦 o.o");
        }
    }];
}

- (IBAction)updateDeliveredNotification {
    UNMutableNotificationContent *notificationContent = [[UNMutableNotificationContent alloc] init];
    notificationContent.categoryIdentifier = [NSString testCategoryNotificationIdentifier];
    notificationContent.userInfo = @{
        @"TEXT": @"来啦，来啦",
        @"EMOJI": @"😄😄"
    };
    notificationContent.title = @"通知来啦";
    notificationContent.subtitle = @"你不知道吧，其实我已经偷偷修改过这条通知咯";
    notificationContent.body = @"虽然这条通知已经展示过了，但是我还是偷偷修改了，快来看看是什么吧，嘿嘿嘿";
    
    // UNCalendarNotificationTrigger
    // UNTimeIntervalNotificationTrigger
    // UNLocationNotificationTrigger
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    
    UNNotificationRequest *notificationRequest = [UNNotificationRequest requestWithIdentifier:@"TEST_NOTE" content:notificationContent trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:notificationRequest withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"修改推送失败了 o_0 %@", error.localizedDescription);
        } else {
            NSLog(@"修改推送成功啦 o.o");
        }
    }];
}

- (IBAction)registerActionNotification {
    UNNotificationAction *okAction = [UNNotificationAction actionWithIdentifier:[NSString okActionNotificationIdentifier]
                                                                          title:@"知道了，马上来"
                                                                        options:UNNotificationActionOptionNone];
    UNNotificationAction *waitAction = [UNNotificationAction actionWithIdentifier:[NSString waitActionNotificationIdentifier]
                                                                            title:@"别着急，等我一下"
                                                                          options:UNNotificationActionOptionDestructive];
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:[NSString testCategoryNotificationIdentifier]
                                                                              actions:@[okAction, waitAction]
                                                                    intentIdentifiers:@[]
                                                                              options:UNNotificationCategoryOptionCustomDismissAction];
    // Because your app must handle all actions, you must declare the actions that your app supports at launch time.
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithArray:@[category]]];
}

@end
