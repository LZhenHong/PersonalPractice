//
//  SearchResult.h
//  ChinaRegionsSearch
//
//  Created by LZhenHong on 2020/9/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchResult : NSObject

@property (nonatomic, copy) NSString *resultText;
@property (nonatomic, strong) UIColor *resultColor;

@end

NS_ASSUME_NONNULL_END
