//
//  CityHelper.m
//  ChinaRegionsSearch
//
//  Created by LZhenHong on 2020/9/23.
//

#import "CityHelper.h"
#import "City.h"

@interface CityHelper ()
@property (nonatomic, strong) NSDictionary<NSString *, NSArray<City *> *> *cityModelMap;
@end

@implementation CityHelper

+ (instancetype)sharedHelper {
    static CityHelper *helper = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[CityHelper alloc] init];
    });
    return helper;
}

+ (void)clearCityModelCache {
    CityHelper *cityHelper = [self sharedHelper];
    cityHelper.cityModelMap = NULL;
}

- (void)asyncGetCityModelsWithProviceId:(NSString *)provinceId callback:(void (^)(BOOL, NSArray<City *> *))callback {
    if (self.cityModelMap.count > 0) {
        if (callback) {
            callback(true, [self.cityModelMap[provinceId] copy]);
        }
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSBundle *mainBundle = [NSBundle mainBundle];
            NSURL *jsonFileUrl = [mainBundle URLForResource:@"city" withExtension:@"json"];
            NSError *error = NULL;
            NSData *jsonData = [NSData dataWithContentsOfURL:jsonFileUrl options:NSDataReadingMappedIfSafe error:&error];
            if (error) {
                NSLog(@"Load JSON file data error: %@", error.localizedDescription);
                if (callback) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        callback(false, @[]);
                    });
                }
                return;
            }
            
            NSDictionary *cityJsonMap = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
            if (error) {
                NSLog(@"Serializer JSON data error: %@", error.localizedDescription);
                if (callback) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        callback(false, @[]);
                    });
                }
                return;
            }
            
            NSMutableDictionary *cityModelMap = [NSMutableDictionary dictionary];
            for (NSString *tempProvinceId in cityJsonMap) {
                NSMutableArray *citys = cityModelMap[tempProvinceId];
                if (citys == NULL) {
                    citys = [NSMutableArray array];
                }
                NSArray *cityJsons = cityJsonMap[tempProvinceId];
                for (NSDictionary *cityJson in cityJsons) {
                    City *city = [[City alloc] initWithJsonData:cityJson];
                    [citys addObject:city];
                }
                cityModelMap[tempProvinceId] = [citys copy];
            }
            self.cityModelMap = [cityModelMap copy];
            
            if (callback) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(true, [self.cityModelMap[provinceId] copy]);
                });
            }
        });
    }
}

@end
