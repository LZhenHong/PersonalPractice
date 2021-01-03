//
//  BadgeSupplementaryView.m
//  UICollectionViewExample
//
//  Created by LZhenHong on 2021/1/3.
//

#import "BadgeSupplementaryView.h"

@interface BadgeSupplementaryView()
@property (nonatomic, strong) UILabel *label;
@end

@implementation BadgeSupplementaryView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure {
    self.backgroundColor = [UIColor systemGreenColor];
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [[UIColor blackColor] CGColor];
    self.layer.borderWidth = 1;
    
    self.label = [[UILabel alloc] init];
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.adjustsFontForContentSizeCategory = YES;
    self.label.font = [UIFont systemFontOfSize:15];
    self.label.textColor = [UIColor blackColor];
    [self addSubview:self.label];
    
    NSLayoutConstraint *xAnchorConstraint = [self.label.centerXAnchor constraintEqualToAnchor:self.centerXAnchor];
    NSLayoutConstraint *yAnchorConstraint = [self.label.centerYAnchor constraintEqualToAnchor:self.centerYAnchor];
    [NSLayoutConstraint activateConstraints:@[xAnchorConstraint, yAnchorConstraint]];
}

- (void)setBadgeString:(NSString *)badge {
    self.label.text = badge;
}

+ (NSString *)badgeElementKind {
    return [NSString stringWithFormat:@"%@%@", NSStringFromClass(self), NSStringFromSelector(@selector(badgeElementKind))];
}

@end
