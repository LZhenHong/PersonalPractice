//
//  BadgeSupplementaryView.h
//  UICollectionViewExample
//
//  Created by LZhenHong on 2021/1/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BadgeSupplementaryView : UICollectionReusableView

+ (NSString *)badgeElementKind;

- (void)setBadgeString:(NSString *)badge;

@end

NS_ASSUME_NONNULL_END
