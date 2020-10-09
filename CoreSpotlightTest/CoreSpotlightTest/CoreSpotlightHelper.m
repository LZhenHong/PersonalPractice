//
//  CoreSpotlightHelper.m
//  CoreSpotlightTest
//
//  Created by LZhenHong on 2020/10/9.
//

#import "CoreSpotlightHelper.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreSpotlight/CoreSpotlight.h>

#import "MovieInfo.h"

static NSString *DOMAIN_IDENTIFIER = @"com.eden.corespotlightexample";

@implementation CoreSpotlightHelper

+ (void)indexMovieInfo:(MovieInfo *)movieInfo {
    if (![CSSearchableIndex isIndexingAvailable]) {
        NSLog(@"CoreSpotlight not available");
        return;
    }
    
    CSSearchableItemAttributeSet *itemAttributeSet = [[CSSearchableItemAttributeSet alloc] initWithContentType:UTTypeText];
    itemAttributeSet.title = movieInfo.title;
    itemAttributeSet.contentDescription = movieInfo.movieDescription;
    itemAttributeSet.keywords = [movieInfo searchKeywords];
    NSArray *imageComponents = [movieInfo.image componentsSeparatedByString:@"."];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageComponents.firstObject ofType:imageComponents.lastObject];
    itemAttributeSet.thumbnailURL = [NSURL fileURLWithPath:imagePath];
    
    CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:[movieInfo searchableUniqueIndentifier]
                                                               domainIdentifier:DOMAIN_IDENTIFIER
                                                                   attributeSet:itemAttributeSet];
    item.expirationDate = [NSDate distantFuture];
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[item] completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Index movie info: <%@> to CoreSpotlight error: %@", movieInfo.title, error.localizedDescription);
        } else {
            NSLog(@"Index movie info: <%@> to CoreSpotlight success.", movieInfo.title);
        }
    }];
}

+ (void)deindexMovieInfo:(MovieInfo *)movieInfo {
    if (![CSSearchableIndex isIndexingAvailable]) {
        NSLog(@"CoreSpotlight not available");
        return;
    }
    
    [[CSSearchableIndex defaultSearchableIndex] deleteSearchableItemsWithIdentifiers:@[movieInfo.searchableUniqueIndentifier]
                                                                   completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Delete movie info: <%@> from CoreSpotlight error: %@", movieInfo.title, error.localizedDescription);
        } else {
            NSLog(@"Delete movie info: <%@> from CoreSpotlight success.", movieInfo.title);
        }
    }];
}

@end
