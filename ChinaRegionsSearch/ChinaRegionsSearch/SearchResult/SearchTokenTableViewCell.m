//
//  SearchTokenTableViewCell.m
//  ChinaRegionsSearch
//
//  Created by LZhenHong on 2020/9/23.
//

#import "SearchTokenTableViewCell.h"
#import "SearchToken.h"

@interface SearchTokenTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *tokenImageView;
@property (weak, nonatomic) IBOutlet UILabel *tokenTextLabel;
@end

@implementation SearchTokenTableViewCell

- (void)setSearchToken:(SearchToken *)searchToken {
    _searchToken = searchToken;
    
    [self _configCell];
}

- (void)_configCell {
    self.tokenImageView.image = self.searchToken.image;
    self.tokenImageView.tintColor = self.searchToken.color;
    self.tokenTextLabel.text = self.searchToken.text;
    self.tokenTextLabel.textColor = self.searchToken.color;
}

+ (NSString *)reuseIdentifier {
    return @"SearchTokenCellId";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tokenTextLabel.text = @"";
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.tokenTextLabel.text = @"";
    self.tokenTextLabel.textColor = [UIColor blackColor];
    self.tokenImageView.image = NULL;
}

@end
