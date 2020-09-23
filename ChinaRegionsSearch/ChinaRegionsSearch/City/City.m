//
//  City.m
//  ChinaRegionsSearch
//
//  Created by LZhenHong on 2020/9/23.
//

#import "City.h"

@implementation City

- (instancetype)initWithJsonData:(NSDictionary *)json {
    self = [super init];
    if (self) {
        _cityId = json[@"id"];
        _name = json[@"name"];
    }
    return self;
}

+ (instancetype)cityWithJsonData:(NSDictionary *)json {
    return [[self alloc] initWithJsonData:json];
}

- (NSString *)resultText {
    return _name;
}

@end
