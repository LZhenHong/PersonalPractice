//
//  ProvinceHepler.m
//  ChinaRegionsSearch
//
//  Created by LZhenHong on 2020/9/23.
//

#import "ProvinceHepler.h"
#import "SearchToken.h"

@implementation ProvinceHepler

+ (NSArray<SearchToken *> *)searchTokensForAllProviceType {
    NSMutableArray *tokens = [NSMutableArray array];
    for (NSUInteger i = 1; i < 4; ++i) {
        SearchToken *token = [self searchTokenForProviceType:i];
        [tokens addObject:token];
    }
    return [tokens copy];
}

+ (SearchToken *)searchTokenForProviceType:(ProvinceType)type {
    NSString *name = [self nameForProviceType:type];
    UIColor *color = [self colorForProviceType:type];
    
    UIImage *icon = [UIImage systemImageNamed:@"mappin.circle.fill"];
    UISearchToken *searchToken = [UISearchToken tokenWithIcon:icon text:name];
    searchToken.representedObject = @(type);
    
    SearchToken *token = [[SearchToken alloc] init];
    token.token = searchToken;
    token.image = icon;
    token.color = color;
    token.text = [self nameForProviceType:type];
    
    return token;
}

+ (NSString *)nameForProviceType:(ProvinceType)type {
    switch (type) {
        case ProvinceTypeDefault:
            return @"";
        case ProvinceTypeNormal:
            return @"省";
        case ProvinceAutonomousRegion:
            return @"自治区";
        case ProvinceMunicipality:
            return @"直辖市";
    }
}

+ (UIColor *)colorForProviceType:(ProvinceType)type {
    switch (type) {
        case ProvinceTypeDefault:
        case ProvinceTypeNormal:
            return [UIColor blackColor];
        case ProvinceAutonomousRegion:
            return [UIColor blueColor];
        case ProvinceMunicipality:
            return [UIColor redColor];
    }
}

@end
