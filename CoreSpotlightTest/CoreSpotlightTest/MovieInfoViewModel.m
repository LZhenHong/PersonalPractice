//
//  MovieInfoViewModel.m
//  CoreSpotlightTest
//
//  Created by LZhenHong on 2020/10/8.
//

#import "MovieInfoViewModel.h"
#import "MovieInfo.h"

@interface MovieInfoViewModel ()
@property (nonatomic, copy) NSArray<MovieInfo *> *movieInfos;
@end

@implementation MovieInfoViewModel

+ (instancetype)sharedViewModel {
    static MovieInfoViewModel *_viewModel = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _viewModel = [[self alloc] init];
    });
    return _viewModel;
}

- (void)startLoadAllMovieInfos {
    NSString *movieDataPath = [[NSBundle mainBundle] pathForResource:@"MoviesData" ofType:@"plist"];
    NSArray *movieJSONDatas = [NSArray arrayWithContentsOfFile:movieDataPath];
    NSMutableArray *movieInfos = [NSMutableArray array];
    for (NSDictionary *movieJSON in movieJSONDatas) {
        MovieInfo *movieInfo = [MovieInfo movieInfoWithJSONData:movieJSON];
        [movieInfos addObject:movieInfo];
    }
    self.movieInfos = [movieInfos copy];
}

- (NSArray<MovieInfo *> *)grabAllMovieInfos {
    return self.movieInfos;
}

- (NSUInteger)movieInfoCount {
    return self.movieInfos.count;
}

@end
