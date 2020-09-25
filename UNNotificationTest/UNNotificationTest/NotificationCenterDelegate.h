//
//  NotificationCenterDelegate.h
//  UNNotificationTest
//
//  Created by LZhenHong on 2020/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NotificationCenterDelegate : NSObject

+ (void)registerToCurrentNotificationCenterDelegate;
+ (instancetype)sharedDelegate;

@end

NS_ASSUME_NONNULL_END
