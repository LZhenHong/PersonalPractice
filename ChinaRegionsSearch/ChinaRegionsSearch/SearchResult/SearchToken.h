//
//  SearchToken.h
//  ChinaRegionsSearch
//
//  Created by LZhenHong on 2020/9/23.
//

#import <Foundation/Foundation.h>

@class UISearchToken, UIImage, UIColor;

NS_ASSUME_NONNULL_BEGIN

@interface SearchToken : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UISearchToken *token;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, copy) NSString *text;

@end

NS_ASSUME_NONNULL_END
