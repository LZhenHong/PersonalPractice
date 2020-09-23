//
//  CityTableViewController.h
//  ChinaRegionsSearch
//
//  Created by LZhenHong on 2020/9/23.
//

#import <UIKit/UIKit.h>

@class Province;

NS_ASSUME_NONNULL_BEGIN

@interface CityTableViewController : UITableViewController

@property (nonatomic, strong) Province *province;

@end

NS_ASSUME_NONNULL_END
