//
//  ProvinceHepler.h
//  ChinaRegionsSearch
//
//  Created by LZhenHong on 2020/9/23.
//

#import <Foundation/Foundation.h>

#import "Province.h"

@class SearchToken;

NS_ASSUME_NONNULL_BEGIN

@interface ProvinceHepler : NSObject

+ (NSString *)nameForProviceType:(ProvinceType)type;
+ (UIColor *)colorForProviceType:(ProvinceType)type;
+ (SearchToken *)searchTokenForProviceType:(ProvinceType)type;
+ (NSArray<SearchToken *> *)searchTokensForAllProviceType;

@end

NS_ASSUME_NONNULL_END
