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

@end
