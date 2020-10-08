//
//  MovieTableViewCell.h
//  CoreSpotlightTest
//
//  Created by LZhenHong on 2020/10/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MovieInfo;

@interface MovieTableViewCell : UITableViewCell

+ (NSString *)reuseIdentifier;

- (void)updateUIWithMovieInfo:(MovieInfo *)movieInfo;

@end

NS_ASSUME_NONNULL_END
