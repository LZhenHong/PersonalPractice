//
//  AppDelegate.m
//  CoreSpotlightTest
//
//  Created by LZhenHong on 2020/9/27.
//

#import "AppDelegate.h"

#import <CoreSpotlight/CoreSpotlight.h>

#import "MovieInfoViewModel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    if ([userActivity.activityType isEqualToString:CSSearchableItemActionType]) {
        NSString *identifier = userActivity.userInfo[CSSearchableItemActivityIdentifier];
        if (identifier && identifier.length > 0) {
            MovieInfo *movieInfo = [[MovieInfoViewModel sharedViewModel] movieInfoForSearchIdentifier:identifier];
            if (movieInfo) {
                UIWindow *keyWindow = NULL;
                NSArray<__kindof UIWindow *> *windows = [[UIApplication sharedApplication] windows];
                for (UIWindow *window in windows) {
                    if (window.isKeyWindow) {
                        keyWindow = window;
                        break;
                    }
                }
                if (keyWindow) {
                    UINavigationController *navigationVc = (UINavigationController *)keyWindow.rootViewController;
                    [navigationVc popToRootViewControllerAnimated:YES];
                    [navigationVc.topViewController performSegueWithIdentifier:@"MovieListToDetail" sender:movieInfo];
                    return YES;
                }
            }
        }
    }
    return NO;
}

@end
