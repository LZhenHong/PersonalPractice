//
//  ViewController.m
//  UNNotificationTest
//
//  Created by LZhenHong on 2020/9/24.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)requestAuthorization {
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
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
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionProvisional completionHandler:^(BOOL granted, NSError * _Nullable error) {
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
    notificationContent.title = @"通知来啦";
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

- (IBAction)removeTestNotification {
    [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[@"TEST_NOTE"]];
}

@end
