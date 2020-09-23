//
//  SearchTokenTableViewCell.h
//  ChinaRegionsSearch
//
//  Created by LZhenHong on 2020/9/23.
//

#import <UIKit/UIKit.h>

@class SearchToken;

NS_ASSUME_NONNULL_BEGIN

@interface SearchTokenTableViewCell : UITableViewCell

@property (nonatomic, strong) SearchToken *searchToken;

+ (NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
