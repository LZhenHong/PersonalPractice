//
//  NotificationViewController.m
//  UNNotificationContentTest
//
//  Created by LZhenHong on 2020/9/25.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController () <UNNotificationContentExtension>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activityIndicator.hidden = YES;
}

- (void)didReceiveNotification:(UNNotification *)notification {
    self.titleLabel.text = notification.request.content.title;
    self.bodyLabel.text = notification.request.content.body;
}

- (void)didReceiveNotificationResponse:(UNNotificationResponse *)response
                     completionHandler:(void (^)(UNNotificationContentExtensionResponseOption))completion {
    if ([response.notification.request.content.categoryIdentifier isEqual:@"TEST_CATEGORY"]) {
        if ([response.actionIdentifier isEqual:@"OK_ACTION"]) {
            self.view.backgroundColor = [UIColor greenColor];
            completion(UNNotificationContentExtensionResponseOptionDismissAndForwardAction);
        } else if ([response.actionIdentifier isEqual:@"WAIT_ACTION"]) {
            self.activityIndicator.hidden = NO;
            [self.activityIndicator startAnimating];
            completion(UNNotificationContentExtensionResponseOptionDoNotDismiss);
        } else {
            completion(UNNotificationContentExtensionResponseOptionDismissAndForwardAction);
        }
    } else {
        completion(UNNotificationContentExtensionResponseOptionDismissAndForwardAction);
    }
}

@end
