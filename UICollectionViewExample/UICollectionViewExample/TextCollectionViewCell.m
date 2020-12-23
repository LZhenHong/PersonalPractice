//
//  TextCollectionViewCell.m
//  UICollectionViewExample
//
//  Created by Eden on 2020/12/22.
//

#import "TextCollectionViewCell.h"

@implementation TextCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _configure];
    }
    return self;
}

- (void)_configure {
    self.contentView.backgroundColor = [UIColor systemBlueColor];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor blackColor] CGColor];
    
    _label = [[UILabel alloc] init];
    _label.adjustsFontForContentSizeCategory = YES;
    _label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    _label.frame = self.contentView.bounds;
    _label.textAlignment = NSTextAlignmentCenter;
    _label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:_label];
}

@end
