//
//  UICollectionSupplementaryViewController.m
//  UICollectionViewExample
//
//  Created by LZhenHong on 2021/1/3.
//

#import "UICollectionSupplementaryViewController.h"
#import "TextCollectionViewCell.h"
#import "BadgeSupplementaryView.h"

@interface UICollectionSupplementaryViewController ()
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewDiffableDataSource<NSString *, NSString *> *dataSource;
@end

@implementation UICollectionSupplementaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Badge Supplementary Style";
    
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
    NSCollectionLayoutAnchor *badgeAnchor = [NSCollectionLayoutAnchor layoutAnchorWithEdges:NSDirectionalRectEdgeTop | NSDirectionalRectEdgeTrailing fractionalOffset:CGPointMake(0.25, -0.18)];
    NSCollectionLayoutSize *badgeSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension absoluteDimension:20] heightDimension:[NSCollectionLayoutDimension absoluteDimension:20]];
    NSCollectionLayoutSupplementaryItem *badge = [NSCollectionLayoutSupplementaryItem supplementaryItemWithLayoutSize:badgeSize elementKind:[BadgeSupplementaryView badgeElementKind] containerAnchor:badgeAnchor];
    
    NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0] heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:1.0]];
    NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize supplementaryItems:@[badge]];
    item.contentInsets = NSDirectionalEdgeInsetsMake(5, 5, 5, 5);
    
    NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0] heightDimension:[NSCollectionLayoutDimension fractionalWidthDimension:0.2]];
    NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize subitem:item count:5];
    
    NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup:group];
    UICollectionViewCompositionalLayout *layout = [[UICollectionViewCompositionalLayout alloc] initWithSection:section];
    return layout;
}

- (void)configureDataSource {
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[TextCollectionViewCell class] configurationHandler:^(__kindof TextCollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, NSString * _Nonnull item) {
        cell.label.text = item;
    }];
    
    UICollectionViewSupplementaryRegistration *badgeRegistration = [UICollectionViewSupplementaryRegistration registrationWithSupplementaryClass:[BadgeSupplementaryView class] elementKind:[BadgeSupplementaryView badgeElementKind] configurationHandler:^(__kindof BadgeSupplementaryView * _Nonnull supplementaryView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
        [supplementaryView setBadgeString:[NSString stringWithFormat:@"%zd", indexPath.row]];
    }];
    
    self.dataSource = [[UICollectionViewDiffableDataSource alloc] initWithCollectionView:self.collectionView cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, NSString * _Nonnull itemIdentifier) {
        return [collectionView dequeueConfiguredReusableCellWithRegistration:cellRegistration forIndexPath:indexPath item:itemIdentifier];
    }];
    
    self.dataSource.supplementaryViewProvider = ^UICollectionReusableView * _Nullable(UICollectionView * _Nonnull collectionView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
        return [collectionView dequeueConfiguredReusableSupplementaryViewWithRegistration:badgeRegistration forIndexPath:indexPath];
    };
    
    NSDiffableDataSourceSnapshot *snapshot = [[NSDiffableDataSourceSnapshot alloc] init];
    [snapshot appendSectionsWithIdentifiers:@[@"Main"]];
    NSMutableArray *strArray = [NSMutableArray arrayWithCapacity:50];
    for (int i = 0; i < 50; ++i) {
        strArray[i] = [NSString stringWithFormat:@"%d", i];
    }
    [snapshot appendItemsWithIdentifiers:[strArray copy]];
    [self.dataSource applySnapshot:snapshot animatingDifferences:NO];
}

@end
