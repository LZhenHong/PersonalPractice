//
//  Province.m
//  ChinaRegionsSearch
//
//  Created by LZhenHong on 2020/9/23.
//

#import "Province.h"
#import "ProvinceHepler.h"

@implementation Province

- (instancetype)initWithJsonData:(NSDictionary *)json {
    self = [super init];
    if (self) {
        _provinceId = json[@"id"];
        _name = json[@"name"];
        if ([_name hasSuffix:@"自治区"]) {
            _provinceType = ProvinceAutonomousRegion;
        } else if ([_name hasSuffix:@"市"]) {
            _provinceType = ProvinceMunicipality;
        } else {
            _provinceType = ProvinceTypeNormal;
        }
    }
    return self;
}

+ (instancetype)provinceWithJsonData:(NSDictionary *)json {
    return [[self alloc] initWithJsonData:json];
}

- (UIColor *)identificationColor {
    return [ProvinceHepler colorForProviceType:_provinceType];
}

- (BOOL)isAutonomousRegion {
    return _provinceType == ProvinceAutonomousRegion;
}

- (BOOL)isMunicipality {
    return _provinceType == ProvinceMunicipality;
}

- (NSString *)resultText {
    return _name;
}

- (UIColor *)resultColor {
    return [self identificationColor];
}

@end
