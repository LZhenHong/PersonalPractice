//
//  RWSearchResultsViewController.m
//  TwitterInstant
//
//  Created by Colin Eberhardt on 03/12/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "RWSearchResultsViewController.h"
#import "RWTableViewCell.h"
#import "RWTweet.h"

#import <ReactiveObjC/ReactiveObjC.h>

@interface RWSearchResultsViewController ()
@property (nonatomic, strong) NSArray *tweets;
@end

@implementation RWSearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tweets = [NSArray array];
}

- (void)displayTweets:(NSArray<RWTweet *> *)tweets {
    self.tweets = tweets;
    [self.tableView reloadData];
}

- (RACSignal *)signalForLoadingImage:(NSString *)imageUrl {
    RACScheduler *scheduler = [RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground];
    return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:imageData];
        [subscriber sendNext:image];
        [subscriber sendCompleted];
        return nil;
    }] subscribeOn:scheduler];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    RWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    RWTweet *tweet = self.tweets[indexPath.row];
    cell.twitterStatusText.text = tweet.status;
    cell.twitterUsernameText.text = [NSString stringWithFormat:@"@%@",tweet.username];
    
    [[[self signalForLoadingImage:tweet.profileImageUrl] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(UIImage * _Nullable x) {
        cell.twitterAvatarView.image = x;
    }];

    return cell;
}

@end
