//
//  CoreSpotlightHelper.h
//  CoreSpotlightTest
//
//  Created by LZhenHong on 2020/10/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MovieInfo;

@interface CoreSpotlightHelper : NSObject

+ (void)indexMovieInfo:(MovieInfo *)movieInfo;
+ (void)deindexMovieInfo:(MovieInfo *)movieInfo;

@end

NS_ASSUME_NONNULL_END
