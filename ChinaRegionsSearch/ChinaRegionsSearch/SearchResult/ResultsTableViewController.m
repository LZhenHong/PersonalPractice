//
//  ResultsTableViewController.m
//  ChinaRegionsSearch
//
//  Created by LZhenHong on 2020/9/23.
//

#import "ResultsTableViewController.h"
#import "SearchTokenTableViewCell.h"
#import "SearchResult.h"
#import "SearchToken.h"

static NSString *kSearchResultCellId = @"SearchResultCellId";

@interface ResultsTableViewController ()

@end

@implementation ResultsTableViewController

+ (NSString *)storyboardId {
    return NSStringFromClass(self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setFiltering:(BOOL)filtering {
    _filtering = filtering;
    
    [self.tableView reloadData];
}

- (void)setSearchTokens:(NSArray<SearchToken *> *)searchTokens {
    _searchTokens = [searchTokens copy];
    
    [self.tableView reloadData];
}

- (void)setSearchResults:(NSArray<SearchResult *> *)searchResults {
    _searchResults = [searchResults copy];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isFiltering) {
        return self.searchResults.count;
    }
    return self.searchTokens.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isFiltering) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchResultCellId forIndexPath:indexPath];
        SearchResult *result = self.searchResults[indexPath.row];
        cell.textLabel.text = result.resultText;
        cell.textLabel.textColor = result.resultColor;
        return cell;
    } else {
        SearchTokenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SearchTokenTableViewCell reuseIdentifier] forIndexPath:indexPath];
        SearchToken *token = self.searchTokens[indexPath.row];
        cell.searchToken = token;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.isFiltering) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(resultsTableViewController:didClickSearchResult:)]) {
            SearchResult *result = self.searchResults[indexPath.row];
            [self.delegate resultsTableViewController:self didClickSearchResult:result];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(resultsTableViewController:didClickSearchToken:)]) {
            SearchToken *token = self.searchTokens[indexPath.row];
            [self.delegate resultsTableViewController:self didClickSearchToken:token];
        }
    }
}

@end
