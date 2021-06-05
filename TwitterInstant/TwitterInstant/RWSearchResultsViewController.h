//
//  RWSearchResultsViewController.h
//  TwitterInstant
//
//  Created by Colin Eberhardt on 03/12/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RWTweet;

@interface RWSearchResultsViewController : UITableViewController

- (void)displayTweets:(NSArray<RWTweet *> *)tweets;

@end
