//
//  MovieInfo.h
//  CoreSpotlightTest
//
//  Created by LZhenHong on 2020/10/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieInfo : NSObject

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *category;
@property (nonatomic, copy, readonly) NSString *rate;
@property (nonatomic, copy, readonly) NSString *movieDescription;
@property (nonatomic, copy, readonly) NSString *director;
@property (nonatomic, copy, readonly) NSString *stars;
@property (nonatomic, copy, readonly) NSString *image;

- (instancetype)initWithJSONData:(NSDictionary * _Nonnull)jsonData;
+ (instancetype)movieInfoWithJSONData:(NSDictionary * _Nonnull)jsonData;

@end

NS_ASSUME_NONNULL_END
