//
//  UICollectionDistinctLayoutsViewController.m
//  UICollectionViewExample
//
//  Created by Eden on 2020/12/23.
//

#import "UICollectionDistinctLayoutsViewController.h"
#import "TextCollectionViewCell.h"

@interface UICollectionDistinctLayoutsViewController () <UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewDiffableDataSource<NSString *, NSString *> *dataSource;
@property (nonatomic, strong) NSArray<NSString *> *sections;
@end

@implementation UICollectionDistinctLayoutsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Distinct Layout Style";
    
    self.sections = @[@"First", @"Second", @"Third"];
    
    [self configureCollectionView];
    [self configureDataSource];
}

- (void)configureCollectionView {
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[self generateLayout]];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.backgroundColor = [UIColor systemGroupedBackgroundColor];
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
}

- (UICollectionViewCompositionalLayout *)generateLayout {
    UICollectionViewCompositionalLayout *layout = [[UICollectionViewCompositionalLayout alloc] initWithSectionProvider:^NSCollectionLayoutSection * _Nullable(NSInteger section, id<NSCollectionLayoutEnvironment> _Nonnull layoutEnvironment) {
        if (section < self.sections.count) {
            if (section >= 3) {
                return NULL;
            }
            
            NSInteger count = 1;
            NSCollectionLayoutDimension *heightDimension = NULL;
            if (section == 0) {
                heightDimension = [NSCollectionLayoutDimension absoluteDimension:44.0];
            } else if (section == 1) {
                count = 5;
                heightDimension = [NSCollectionLayoutDimension fractionalWidthDimension:0.2];
            } else if (section == 2) {
                count = 3;
                heightDimension = [NSCollectionLayoutDimension fractionalWidthDimension:0.2];
            }
            NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0] heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:1.0]];
            NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];
            NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0] heightDimension:heightDimension];
            NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize subitem:item count:count];
            NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup:group];
            section.contentInsets = NSDirectionalEdgeInsetsMake(20, 20, 20, 20);
            return section;
        } else {
            return NULL;
        }
    }];
    return layout;
}

- (void)configureDataSource {
    UICollectionViewCellRegistration *tableLikeCellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewListCell class] configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, NSString * _Nonnull item) {
        UIListContentConfiguration *configuration = [cell defaultContentConfiguration];
        configuration.text = item;
        configuration.textProperties.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        cell.contentConfiguration = configuration;
    }];
    
    UICollectionViewCellRegistration *textCellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[TextCollectionViewCell class] configurationHandler:^(__kindof TextCollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, NSString * _Nonnull item) {
        cell.label.text = item;
    }];
    
    self.dataSource = [[UICollectionViewDiffableDataSource alloc] initWithCollectionView:self.collectionView cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, NSString * _Nonnull itemIdentifier) {
        if (indexPath.section == 0) {
            return [collectionView dequeueConfiguredReusableCellWithRegistration:tableLikeCellRegistration forIndexPath:indexPath item:itemIdentifier];
        }
        return [collectionView dequeueConfiguredReusableCellWithRegistration:textCellRegistration forIndexPath:indexPath item:itemIdentifier];
    }];
    
    NSDiffableDataSourceSnapshot *snapshot = [[NSDiffableDataSourceSnapshot alloc] init];
    [snapshot appendSectionsWithIdentifiers:self.sections];
    [self.sections enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:10];
        for (int i = 0; i < 10; ++i) {
            [tempArray addObject:[NSString stringWithFormat:@"%zd", idx * 10 + i]];
        }
        [snapshot appendItemsWithIdentifiers:[tempArray copy] intoSectionWithIdentifier:obj];
    }];
    [self.dataSource applySnapshot:snapshot animatingDifferences:NO];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end
