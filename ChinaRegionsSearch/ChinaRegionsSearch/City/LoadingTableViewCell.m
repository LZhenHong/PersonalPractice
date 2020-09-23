//
//  LoadingTableViewCell.m
//  ChinaRegionsSearch
//
//  Created by LZhenHong on 2020/9/23.
//

#import "LoadingTableViewCell.h"

@interface LoadingTableViewCell ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@end

@implementation LoadingTableViewCell

+ (NSString *)reuseIdentifier {
    return NSStringFromClass(self);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.loadingIndicator stopAnimating];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self.loadingIndicator startAnimating];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.loadingIndicator stopAnimating];
}

@end
