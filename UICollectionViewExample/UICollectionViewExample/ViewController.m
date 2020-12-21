//
//  ViewController.m
//  UICollectionViewExample
//
//  Created by LZhenHong on 2020/11/24.
//

#import "ViewController.h"
#import "UICollectionTableViewController.h"

@interface ViewController () <UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewDiffableDataSource<NSString *, NSString *> *dataSource;

@property (nonatomic, strong) NSArray<Class> *collectionExampleControllerClasses;
@end

@implementation ViewController

- (NSArray<Class> *)collectionExampleControllerClasses {
    if (!_collectionExampleControllerClasses) {
        _collectionExampleControllerClasses = @[
            [UICollectionTableViewController class]
        ];
    }
    return _collectionExampleControllerClasses;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Main";
    [self configureCollectionView];
    [self configureCollectionViewDataSource];
}

- (void)configureCollectionView {
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                             collectionViewLayout:[self generateLayout]];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.backgroundColor = [UIColor systemGroupedBackgroundColor];
    self.collectionView.delegate = self;
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
    }];
    
    self.dataSource = [[UICollectionViewDiffableDataSource alloc] initWithCollectionView:self.collectionView cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, Class _Nonnull itemIdentifier) {
        return [collectionView dequeueConfiguredReusableCellWithRegistration:cellRegisteration
                                                                forIndexPath:indexPath
                                                                        item:NSStringFromClass(itemIdentifier)];
    }];
    
    NSDiffableDataSourceSectionSnapshot<NSString *> *snapshot = [[NSDiffableDataSourceSectionSnapshot alloc] init];
    [snapshot appendItems:self.collectionExampleControllerClasses];
    [self.dataSource applySnapshot:snapshot toSection:@"Main" animatingDifferences:NO];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    Class clazz = self.collectionExampleControllerClasses[indexPath.item];
    if (clazz) {
        [self.navigationController pushViewController:[clazz new] animated:YES];
    }
}

@end
