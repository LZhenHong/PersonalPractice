//
//  CityTableViewController.m
//  ChinaRegionsSearch
//
//  Created by LZhenHong on 2020/9/23.
//

#import "CityTableViewController.h"
#import "CityHelper.h"
#import "City.h"
#import "Province.h"
#import "LoadingTableViewCell.h"

static NSString *kCellIdentifier = @"CityCellReuseId";

@interface CityTableViewController ()
@property (nonatomic, copy) NSArray<City *> *citys;
@property (nonatomic, assign, getter=isLoading) BOOL loading;
@property (nonatomic, assign, getter=isLoadCityModelSuccess) BOOL loadCityModelSuccess;
@end

@implementation CityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loading = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self startLoadCityModels];
}

- (void)startLoadCityModels {
    self.loading = YES;
    [[CityHelper sharedHelper] asyncGetCityModelsWithProviceId:self.province.provinceId callback:^(BOOL isSucc, NSArray<City *> * _Nonnull citys) {
        self.loading = NO;
        self.loadCityModelSuccess = isSucc;
        self.citys = citys;
        [self.tableView reloadData];
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [CityHelper clearCityModelCache];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isLoadCityModelSuccess) {
        return self.citys.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isLoading) {
        LoadingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LoadingTableViewCell reuseIdentifier] forIndexPath:indexPath];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
        if (self.isLoadCityModelSuccess) {
            City *city = self.citys[indexPath.row];
            cell.textLabel.text = city.name;
            cell.textLabel.textColor = self.province.identificationColor;
        } else {
            cell.textLabel.text = @"加载城市数据失败了 o_0";
            cell.textLabel.textColor = [UIColor magentaColor];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

@end
