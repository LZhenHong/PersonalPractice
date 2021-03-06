//
//  IndexRequestHandler.m
//  CoreSpotlightIndexExtensionTest
//
//  Created by LZhenHong on 2020/9/27.
//

#import "IndexRequestHandler.h"

@implementation IndexRequestHandler

// 这个 Spotlight 扩展用来在应用处于后台或者被杀掉进程时，可以不打开 App 来更新 Spotlight Index

- (void)searchableIndex:(CSSearchableIndex *)searchableIndex reindexAllSearchableItemsWithAcknowledgementHandler:(void (^)(void))acknowledgementHandler {
    // Reindex all data with the provided index
    
    acknowledgementHandler();
}

- (void)searchableIndex:(CSSearchableIndex *)searchableIndex reindexSearchableItemsWithIdentifiers:(NSArray <NSString *> *)identifiers acknowledgementHandler:(void (^)(void))acknowledgementHandler {
    // Reindex any items with the given identifiers and the provided index
    
    acknowledgementHandler();
}

- (NSData *)dataForSearchableIndex:(CSSearchableIndex *)searchableIndex itemIdentifier:(NSString*)itemIdentifier typeIdentifier:(NSString*)typeIdentifier error:(out NSError **)outError {
    // Replace with to return data representation of requested type from item identifier
    
    NSData *data = nil;
    return data;
}


- (NSURL *)fileURLForSearchableIndex:(CSSearchableIndex *)searchableIndex itemIdentifier:(NSString *)itemIdentifier typeIdentifier:(NSString *)typeIdentifier inPlace:(BOOL)inPlace error:(out NSError ** __nullable)outError {
    // Replace with to return file url based on requested type from item identifier
    
    NSURL *url = nil;
    return url;
}

@end
