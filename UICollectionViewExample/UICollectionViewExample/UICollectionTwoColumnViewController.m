//
//  UICollectionTwoColumnViewController.m
//  UICollectionViewExample
//
//  Created by Eden on 2020/12/22.
//

#import "UICollectionTwoColumnViewController.h"
#import "TextCollectionViewCell.h"

@interface UICollectionTwoColumnViewController ()
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewDiffableDataSource<NSString *, NSString *> *dataSource;
@end

@implementation UICollectionTwoColumnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"UICollectionView Two Column Style";
    
    [self configureCollectionView];
    [self configureDataSource];
}

- (void)configureCollectionView {
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[self generateLayout]];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.backgroundColor = [UIColor systemGroupedBackgroundColor];
    [self.view addSubview:self.collectionView];
}

- (UICollectionViewCompositionalLayout *)generateLayout {
    NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0] heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:1.0]];
    NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];
    NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0] heightDimension:[NSCollectionLayoutDimension fractionalWidthDimension:0.2]];
    NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize subitem:item count:2];
    NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup:group];
    UICollectionViewCompositionalLayout *layout = [[UICollectionViewCompositionalLayout alloc] initWithSection:section];
    return layout;
}

- (void)configureDataSource {
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[TextCollectionViewCell class] configurationHandler:^(__kindof TextCollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, NSString * _Nonnull item) {
        cell.label.text = item;
    }];
    
    self.dataSource = [[UICollectionViewDiffableDataSource alloc] initWithCollectionView:self.collectionView cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, NSString * _Nonnull itemIdentifier) {
        return [collectionView dequeueConfiguredReusableCellWithRegistration:cellRegistration forIndexPath:indexPath item:itemIdentifier];
    }];
    
    NSDiffableDataSourceSnapshot<NSString *, NSString *> *snapshot = [[NSDiffableDataSourceSnapshot alloc] init];
    [snapshot appendSectionsWithIdentifiers:@[@"Main"]];
    NSMutableArray *strArray = [NSMutableArray arrayWithCapacity:50];
    for (int i = 0; i < 50; ++i) {
        strArray[i] = [NSString stringWithFormat:@"%d", i];
    }
    [snapshot appendItemsWithIdentifiers:[strArray copy]];
    [self.dataSource applySnapshot:snapshot animatingDifferences:NO];
}

@end
