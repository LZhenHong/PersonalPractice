//
//  ResultsTableViewController.h
//  ChinaRegionsSearch
//
//  Created by LZhenHong on 2020/9/23.
//

#import <UIKit/UIKit.h>

@class SearchResult, SearchToken, ResultsTableViewController;

@protocol ResultsTableViewControllerDelegate <NSObject>
@optional
- (void)resultsTableViewController:(ResultsTableViewController *_Nullable)resultsTableViewController
               didClickSearchToken:(SearchToken *_Nonnull)searchToken;
- (void)resultsTableViewController:(ResultsTableViewController *_Nullable)resultsTableViewController
              didClickSearchResult:(SearchResult *_Nonnull)searchResult;
@end

NS_ASSUME_NONNULL_BEGIN

@interface ResultsTableViewController : UITableViewController

@property (nonatomic, assign, getter=isFiltering) BOOL filtering;
// 封装 SearchToken 和 SearchResult 为了扩展
// 最开始想每个界面都可以搜索，复用这个结果展示界面，但是发现后面都是重复的代码，就没有必要再去实现
@property (nonatomic, copy) NSArray<SearchToken *> *searchTokens;
@property (nonatomic, copy) NSArray<SearchResult *> *searchResults;

@property (nonatomic, weak) id<ResultsTableViewControllerDelegate> delegate;

+ (NSString *)storyboardId;

@end

NS_ASSUME_NONNULL_END
