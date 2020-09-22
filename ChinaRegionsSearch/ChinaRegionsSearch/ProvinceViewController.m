//
//  ProvinceViewController.m
//  ChinaRegionsSearch
//
//  Created by LZhenHong on 2020/9/22.
//

#import "ProvinceViewController.h"

@interface Province : NSObject
@property (nonatomic, copy, readonly) NSString *provinceId;
@property (nonatomic, copy, readonly) NSString *name;

- (instancetype)initWithJsonData:(NSDictionary *)json;
+ (instancetype)provinceWithJsonData:(NSDictionary *)json;
@end

@implementation Province

- (instancetype)initWithJsonData:(NSDictionary *)json {
    self = [super init];
    if (self) {
        _provinceId = json[@"id"];
        _name = json[@"name"];
    }
    return self;
}

+ (instancetype)provinceWithJsonData:(NSDictionary *)json {
    return [[self alloc] initWithJsonData:json];
}

@end

static NSString *kCellIdentifier = @"CellId";

@interface ProvinceViewController () <UISearchResultsUpdating>
@property (nonatomic, strong) NSMutableArray<Province *> *provinces;

@property (nonatomic, strong) UISearchController *provinceSearchController;
@end

@implementation ProvinceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSearchController];
}

- (void)setupSearchController {
    self.provinceSearchController = [[UISearchController alloc] init];
    self.provinceSearchController.obscuresBackgroundDuringPresentation = NO;
    self.provinceSearchController.searchResultsUpdater = self;
    self.provinceSearchController.searchBar.placeholder = @"Search Chinese Province";
    
    self.navigationItem.searchController = self.provinceSearchController;
    
    self.definesPresentationContext = YES;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self prepareProvinceModel];
    [self.tableView reloadData];
}

- (void)prepareProvinceModel {
    self.provinces = [@[] mutableCopy];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.provinces.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    Province *provice = self.provinces[indexPath.row];
    cell.textLabel.text = provice.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
