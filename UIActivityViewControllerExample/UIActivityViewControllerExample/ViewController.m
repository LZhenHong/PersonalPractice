//
//  ViewController.m
//  UIActivityViewControllerExample
//
//  Created by LZhenHong on 2020/10/16.
//

#import "ViewController.h"
#import "RoundImageActivity.h"

@interface ViewController () <UIContextMenuInteractionDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIContextMenuInteraction *ctxMenuInteraction = [[UIContextMenuInteraction alloc] initWithDelegate:self];
    [self.avatarImageView addInteraction:ctxMenuInteraction];
    self.avatarImageView.userInteractionEnabled = YES;
}

- (UIContextMenuConfiguration *)contextMenuInteraction:(UIContextMenuInteraction *)interaction configurationForMenuAtLocation:(CGPoint)location {
    UIAction *shareAction = [UIAction actionWithTitle:@"分享" image:[UIImage systemImageNamed:@"square.and.arrow.up"] identifier:@"Share" handler:^(__kindof UIAction * _Nonnull action) {
        [self shareCurrentAvatarImage];
    }];
    UIContextMenuConfiguration *configuration = [UIContextMenuConfiguration configurationWithIdentifier:@"Test_Id" previewProvider:nil actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        return [UIMenu menuWithChildren:@[shareAction]];
    }];
    return configuration;
}

- (void)shareCurrentAvatarImage {
    RoundImageActivity *rImgActivity = [[RoundImageActivity alloc] init];
    rImgActivity.vc = self;
    UIActivityViewController *actVc = [[UIActivityViewController alloc] initWithActivityItems:@[self.avatarImageView.image]
                                                                        applicationActivities:@[rImgActivity]];
    [self presentViewController:actVc animated:YES completion:nil];
}

@end
