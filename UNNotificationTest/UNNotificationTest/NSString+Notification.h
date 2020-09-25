//
//  NSString+Notification.h
//  UNNotificationTest
//
//  Created by LZhenHong on 2020/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Notification)

+ (NSString *)okActionNotificationIdentifier;
+ (NSString *)waitActionNotificationIdentifier;

+ (NSString *)testCategoryNotificationIdentifier;

@end

NS_ASSUME_NONNULL_END
