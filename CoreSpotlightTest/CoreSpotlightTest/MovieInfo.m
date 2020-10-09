//
//  MovieInfo.m
//  CoreSpotlightTest
//
//  Created by LZhenHong on 2020/10/8.
//

#import "MovieInfo.h"

@implementation MovieInfo

- (instancetype)initWithJSONData:(NSDictionary * _Nonnull)jsonData {
    self = [super init];
    if (self) {
        _title = jsonData[@"Title"];
        _category = jsonData[@"Category"];
        _rate = jsonData[@"Rating"];
        _movieDescription = jsonData[@"Description"];
        _director = jsonData[@"Director"];
        _stars = jsonData[@"Stars"];
        _image = jsonData[@"Image"];
    }
    return self;
}

+ (instancetype)movieInfoWithJSONData:(NSDictionary * _Nonnull)jsonData {
    return [[self alloc] initWithJSONData:jsonData];
}

- (NSString *)searchableUniqueIndentifier {
    NSString *idPrefix = @"com.eden.corespotlightexample.movie_";
    return [NSString stringWithFormat:@"%@%tu", idPrefix, _movieDescription.length];
}

- (NSArray<NSString *> *)searchKeywords {
    NSMutableArray *keywords = [NSMutableArray array];
    [keywords addObject:_title];
    
    NSArray<NSString *> *categories = [_category componentsSeparatedByString:@", "];
    [keywords addObjectsFromArray:categories];
    
    NSArray<NSString *> *stars = [_stars componentsSeparatedByString:@", "];
    [keywords addObjectsFromArray:stars];
    
    return [keywords copy];
}

@end
