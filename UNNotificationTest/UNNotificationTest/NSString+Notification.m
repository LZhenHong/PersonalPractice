//
//  NSString+Notification.m
//  UNNotificationTest
//
//  Created by LZhenHong on 2020/9/25.
//

#import "NSString+Notification.h"

@implementation NSString (Notification)

+ (NSString *)okActionNotificationIdentifier {
    return @"OK_ACTION";
}

+ (NSString *)waitActionNotificationIdentifier {
    return @"WAIT_ACTION";
}

+ (NSString *)testCategoryNotificationIdentifier {
    return @"TEST_CATEGORY";
}

@end
