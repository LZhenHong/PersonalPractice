//
//  MovieInfoViewModel.h
//  CoreSpotlightTest
//
//  Created by LZhenHong on 2020/10/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MovieInfo;

@interface MovieInfoViewModel : NSObject

- (void)startLoadAllMovieInfos;
- (NSArray<MovieInfo *> *)grabAllMovieInfos;

- (NSUInteger)movieInfoCount;

- (MovieInfo * _Nullable)movieInfoForSearchIdentifier:(NSString *)identifier;

+ (instancetype)sharedViewModel;

@end

NS_ASSUME_NONNULL_END
