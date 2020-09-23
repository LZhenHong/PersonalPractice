//
//  CityHelper.h
//  ChinaRegionsSearch
//
//  Created by LZhenHong on 2020/9/23.
//

#import <Foundation/Foundation.h>

@class City;

NS_ASSUME_NONNULL_BEGIN

@interface CityHelper : NSObject

- (void)asyncGetCityModelsWithProviceId:(NSString *)proviceId callback:(void(^)(BOOL, NSArray<City *> *))callback;

+ (void)clearCityModelCache;
+ (instancetype)sharedHelper;

@end

NS_ASSUME_NONNULL_END
