//
//  City.h
//  ChinaRegionsSearch
//
//  Created by LZhenHong on 2020/9/23.
//

#import <Foundation/Foundation.h>
#import "SearchResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface City : SearchResult

@property (nonatomic, copy, readonly) NSString *cityId;
@property (nonatomic, copy, readonly) NSString *name;

- (instancetype)initWithJsonData:(NSDictionary *)json;
+ (instancetype)cityWithJsonData:(NSDictionary *)json;

@end

NS_ASSUME_NONNULL_END
