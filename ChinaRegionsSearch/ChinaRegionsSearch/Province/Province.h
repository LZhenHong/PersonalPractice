//
//  Province.h
//  ChinaRegionsSearch
//
//  Created by LZhenHong on 2020/9/23.
//

#import <Foundation/Foundation.h>
#import "SearchResult.h"

typedef NS_ENUM(NSUInteger, ProvinceType) {
    ProvinceTypeDefault,
    ProvinceTypeNormal,
    ProvinceAutonomousRegion,
    ProvinceMunicipality
};

NS_ASSUME_NONNULL_BEGIN

@interface Province : SearchResult
@property (nonatomic, copy, readonly) NSString *provinceId;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, assign, readonly) ProvinceType provinceType;
@property (nonatomic, strong, readonly) UIColor *identificationColor;

- (instancetype)initWithJsonData:(NSDictionary *)json;
+ (instancetype)provinceWithJsonData:(NSDictionary *)json;

/// 自治区
- (BOOL)isAutonomousRegion;
/// 直辖市
- (BOOL)isMunicipality;
@end

NS_ASSUME_NONNULL_END
