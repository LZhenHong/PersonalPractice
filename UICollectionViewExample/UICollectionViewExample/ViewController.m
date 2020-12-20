//
//  ViewController.m
//  UICollectionViewExample
//
//  Created by LZhenHong on 2020/11/24.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewDiffableDataSource<NSString *, NSString *> *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureCollectionView];
    [self configureCollectionViewDataSource];
}

- (void)configureCollectionView {
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                             collectionViewLayout:[self generateLayout]];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.backgroundColor = [UIColor systemGroupedBackgroundColor];
    [self.view addSubview:self.collectionView];
}

- (UICollectionViewLayout *)generateLayout {
    UICollectionLayoutListConfiguration *configuration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceSidebar];
    UICollectionViewCompositionalLayout *layout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:configuration];
    return layout;
}

- (void)configureCollectionViewDataSource {
    UICollectionViewCellRegistration *cellRegisteration = [UICollectionViewCellRegistration registrationWithCellClass:UICollectionViewListCell.class configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, NSString * _Nonnull item) {
        UIListContentConfiguration *configuration = [cell defaultContentConfiguration];
        configuration.text = item;
        configuration.textProperties.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        cell.contentConfiguration = configuration;
        
        UICellAccessoryOutlineDisclosure *accessory = [[UICellAccessoryOutlineDisclosure alloc] init];
        accessory.style = UICellAccessoryOutlineDisclosureStyleHeader;
        cell.accessories = @[accessory];
        cell.backgroundConfiguration = [UIBackgroundConfiguration clearConfiguration];
    }];
    
    self.dataSource = [[UICollectionViewDiffableDataSource alloc] initWithCollectionView:self.collectionView cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, NSString * _Nonnull itemIdentifier) {
        return [collectionView dequeueConfiguredReusableCellWithRegistration:cellRegisteration forIndexPath:indexPath item:itemIdentifier];
    }];
    
    NSDiffableDataSourceSectionSnapshot<NSString *> *snapshot = [[NSDiffableDataSourceSectionSnapshot alloc] init];
    [snapshot appendItems:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7"]];
    [snapshot appendItems:@[@"123", @"124"] intoParentItem:@"1"];
    [self.dataSource applySnapshot:snapshot toSection:@"Main" animatingDifferences:NO];
}

@end
