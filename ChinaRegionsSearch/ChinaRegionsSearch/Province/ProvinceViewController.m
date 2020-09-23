//
//  ProvinceViewController.m
//  ChinaRegionsSearch
//
//  Created by LZhenHong on 2020/9/22.
//

#import "ProvinceViewController.h"
#import "ResultsTableViewController.h"
#import "Province.h"
#import "ProvinceHepler.h"
#import "SearchToken.h"
#import "CityTableViewController.h"

static NSString *kCellIdentifier = @"CellId";
static NSString *kSegueIdentifier = @"ProvinceToCity";

@interface ProvinceViewController () <UISearchResultsUpdating, ResultsTableViewControllerDelegate>
@property (nonatomic, strong) NSMutableArray<Province *> *provinces;

@property (nonatomic, strong) UISearchController *provinceSearchController;
@property (nonatomic, strong) ResultsTableViewController *resultsViewController;
@end

@implementation ProvinceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSearchController];
}

- (void)setupSearchController {
    self.provinceSearchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsViewController];
    self.provinceSearchController.obscuresBackgroundDuringPresentation = NO;
    self.provinceSearchController.searchResultsUpdater = self;
    self.provinceSearchController.searchBar.placeholder = @"搜索省份";
    
    self.navigationItem.searchController = self.provinceSearchController;
    
    self.definesPresentationContext = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self prepareProvinceModel];
    [self.tableView reloadData];
}

- (void)prepareProvinceModel {
    self.provinces = [NSMutableArray array];
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *jsonFileUrl = [mainBundle URLForResource:@"province" withExtension:@"json"];
    NSError *error = NULL;
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonFileUrl options:NSDataReadingMappedIfSafe error:&error];
    if (error) {
        NSLog(@"Load JSON file data error: %@", error.localizedDescription);
        return;
    }
    
    NSArray *provinceJsons = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error) {
        NSLog(@"Serializer JSON data error: %@", error.localizedDescription);
        return;
    }
    
    for (NSDictionary *provinceJson in provinceJsons) {
        Province *province = [Province provinceWithJsonData:provinceJson];
        [self.provinces addObject:province];
    }
}

- (ResultsTableViewController *)resultsViewController {
    if (!_resultsViewController) {
        _resultsViewController = [self.storyboard instantiateViewControllerWithIdentifier:[ResultsTableViewController storyboardId]];
        _resultsViewController.delegate = self;
    }
    return _resultsViewController;
}

- (BOOL)isFiltering {
    NSString *searchText = self.provinceSearchController.searchBar.text;
    NSArray *searchTokens = self.provinceSearchController.searchBar.searchTextField.tokens;
    return self.provinceSearchController.isActive && (searchText.length > 0 || searchTokens.count > 0);
}

// MARK: - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (!searchController.isActive) {
        return;
    }
    
    searchController.showsSearchResultsController = YES;
    [self updateSearchResultsViewDisplay];
}

// MARK: - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.provinces.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    Province *provice = self.provinces[indexPath.row];
    cell.textLabel.text = provice.name;
    cell.textLabel.textColor = provice.identificationColor;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:kSegueIdentifier sender:self.provinces[indexPath.row]];
}

// MARK: - ResultsTableViewControllerDelegate
- (void)resultsTableViewController:(ResultsTableViewController *)resultsTableViewController didClickSearchToken:(SearchToken *)searchToken {
    UISearchToken *token = searchToken.token;
    NSInteger index = self.provinceSearchController.searchBar.searchTextField.tokens.count;
    [self.provinceSearchController.searchBar.searchTextField insertToken:token atIndex:index];
    
    [self updateSearchResultsViewDisplay];
}

- (void)resultsTableViewController:(ResultsTableViewController *)resultsTableViewController didClickSearchResult:(SearchResult *)searchResult {
    [self performSegueWithIdentifier:kSegueIdentifier sender:searchResult];
}

- (void)updateSearchResultsViewDisplay {
    self.resultsViewController.filtering = [self isFiltering];
    if ([self isFiltering]) {
        NSString *input = self.provinceSearchController.searchBar.text;
        NSArray *tokens = self.provinceSearchController.searchBar.searchTextField.tokens;
        UISearchToken *token = tokens.firstObject;
        ProvinceType tokenType = ProvinceTypeDefault;
        if (token) {
            NSNumber *typeNumber = token.representedObject;
            tokenType = typeNumber.unsignedIntegerValue;
        }
        [self updateSearchResultsWithInput:input provinceType:tokenType];
    } else {
        self.resultsViewController.searchTokens = [ProvinceHepler searchTokensForAllProviceType];
    }
}

- (void)updateSearchResultsWithInput:(NSString *)input provinceType:(ProvinceType)type {
    NSMutableArray<Province *> *searchResults = [NSMutableArray array];
    for (Province *province in self.provinces) {
        BOOL isTypeMatch = type == ProvinceTypeDefault || type == province.provinceType;
        BOOL isInputMatch = input == NULL || input.length == 0 || [province.name containsString:input];
        if (isTypeMatch && isInputMatch) {
            [searchResults addObject:province];
        }
    }
    
    [self.resultsViewController setSearchResults:searchResults];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    Province *provice = sender;
    CityTableViewController *cityVc = segue.destinationViewController;
    cityVc.province = provice;
}

@end
