//
//  RoundImageActivity.m
//  UIActivityViewControllerExample
//
//  Created by LZhenHong on 2020/10/16.
//

#import "RoundImageActivity.h"
#import "ViewController.h"

static UIActivityType ROUND_IMAGE_ACTIVITY_TYPE = @"com.eden.roundimageactivityexample.roundimageactivity";

@interface RoundImageActivity()
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) UIImage *roundedImage;
@end

@implementation RoundImageActivity

+ (UIActivityCategory)activityCategory {
    return UIActivityCategoryAction;
}

- (UIActivityType)activityType {
    return ROUND_IMAGE_ACTIVITY_TYPE;
}

- (NSString *)activityTitle {
    return @"给头像加圆角";
}

- (UIImage *)activityImage {
    return [UIImage systemImageNamed:@"doc.circle"];
}

// 这里会比 preformActivity 先调用
// 如果返回值不为 nil，则会调用 preformActivity
// 否则 preformActivity 不会触发
- (UIViewController *)activityViewController {
//    UIViewController *previewController = [[UIViewController alloc] init];
    return nil;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    UIImage *image = [self _fetchImageFromActivityItems:activityItems];
    return image != nil;
}

- (UIImage * _Nullable)_fetchImageFromActivityItems:(NSArray *)activityItems {
    for (id item in activityItems) {
        if ([item isKindOfClass:[UIImage class]]) {
            return item;
        }
    }
    return nil;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    UIImage *image = [self _fetchImageFromActivityItems:activityItems];
    self.originalImage = image;
}

- (void)performActivity {
    if (self.originalImage == nil) {
        [self activityDidFinish:NO];
        return;
    }
    
    self.roundedImage = [self _makeCurrentImageRound:self.originalImage];
    if (self.roundedImage) {
        self.vc.avatarImageView.image = self.roundedImage;
        [self activityDidFinish:YES];
    } else {
        [self activityDidFinish:NO];
    }
}

- (UIImage *)_makeCurrentImageRound:(UIImage *)image {
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(image.size, NO, scale);
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, image.size.width, image.size.height)
                                cornerRadius:image.size.width * 0.5] addClip];
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImage *tmpImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tmpImage;
}

@end
