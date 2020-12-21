//
//  UICollectionTableViewController.m
//  UICollectionViewExample
//
//  Created by Eden on 2020/12/20.
//

#import "UICollectionTableViewController.h"

@interface UICollectionTableViewController () <UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewDiffableDataSource<NSString *, NSString *> *dataSource;
@end

@implementation UICollectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"CollectionView List Style";
    
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

- (UICollectionViewLayout *)generateLayout {
    UICollectionLayoutListConfiguration *configuration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearancePlain];
    configuration.trailingSwipeActionsConfigurationProvider = ^UISwipeActionsConfiguration *(NSIndexPath *indexPath) {
        NSString *item = [self.dataSource itemIdentifierForIndexPath:indexPath];
        UIContextualAction *action = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Log" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            NSLog(@"Swipe item: %@", item);
            completionHandler(YES);
        }];
        action.image = [UIImage systemImageNamed:@"airpodspro"];
        action.backgroundColor = [UIColor systemGreenColor];
        return [UISwipeActionsConfiguration configurationWithActions:@[action]];
    };
    UICollectionViewCompositionalLayout *layout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:configuration];
    return layout;
}

- (void)configureDataSource {
    UICollectionViewCellRegistration *cotainerCellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewListCell class] configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, NSString * _Nonnull item) {
        UIListContentConfiguration *configuration = [cell defaultContentConfiguration];
        configuration.text = item;
        configuration.textProperties.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        cell.contentConfiguration = configuration;
        
        UICellAccessoryOutlineDisclosure *accessory = [[UICellAccessoryOutlineDisclosure alloc] init];
        accessory.style = UICellAccessoryOutlineDisclosureStyleHeader;
        cell.accessories = @[accessory];
        cell.backgroundConfiguration = [UIBackgroundConfiguration clearConfiguration];
    }];
    
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewListCell class] configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, NSString * _Nonnull item) {
        UIListContentConfiguration *configuration = [cell defaultContentConfiguration];
        configuration.text = item;
        configuration.textProperties.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        cell.contentConfiguration = configuration;
    }];
    
    self.dataSource = [[UICollectionViewDiffableDataSource alloc] initWithCollectionView:self.collectionView cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, NSString * _Nonnull item) {
        if ([item isEqualToString:@"Hello"]) {
            return [collectionView dequeueConfiguredReusableCellWithRegistration:cotainerCellRegistration forIndexPath:indexPath item:item];
        }
        return [collectionView dequeueConfiguredReusableCellWithRegistration:cellRegistration forIndexPath:indexPath item:item];
    }];
    
    NSDiffableDataSourceSectionSnapshot<NSString *> *snapshot = [[NSDiffableDataSourceSectionSnapshot alloc] init];
    [snapshot appendItems:@[@"Hello", @"World", @"My", @"Friend"]];
    [snapshot appendItems:@[@"Hello baby", @"Hello child", @"Hello city", @"Hello you"] intoParentItem:@"Hello"];
    [self.dataSource applySnapshot:snapshot toSection:@"Main" animatingDifferences:NO];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end
