//
//  RWSearchFormViewController.m
//  TwitterInstant
//
//  Created by Colin Eberhardt on 02/12/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "RWSearchFormViewController.h"
#import "RWSearchResultsViewController.h"
#import "RWTweet.h"
#import <NSArray+LinqExtensions.h>

#import <ReactiveObjC/ReactiveObjC.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

typedef NS_ENUM(NSInteger, RWTwitterInstantError) {
    RWTwitterInstantErrorAccessDenied,
    RWTwitterInstantErrorNoTwitterAccounts,
    RWTwitterInstantErrorInvalidResponse
};

static NSString * const RWTwitterInstantDomain = @"TwitterInstant";

@interface RWSearchFormViewController ()

@property (weak, nonatomic) IBOutlet UITextField *searchText;

@property (strong, nonatomic) RWSearchResultsViewController *resultsViewController;

@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) ACAccountType *twitterAccountType;

@end

@implementation RWSearchFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Twitter Instant";
    
    [self styleTextField:self.searchText];
    
    self.resultsViewController = self.splitViewController.viewControllers[1];
    
    @weakify(self)
    [[self.searchText.rac_textSignal map:^UIColor * _Nullable(NSString * _Nullable value) {
        return [self isValidSearchText:value] ? [UIColor whiteColor] : [UIColor yellowColor];
    }] subscribeNext:^(UIColor * _Nullable x) {
        @strongify(self)
        self.searchText.backgroundColor = x;
    }];
    
    self.accountStore = [[ACAccountStore alloc] init];
    self.twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [[[[[[self requestAccessToTwitterSignal] then:^RACSignal * _Nonnull {
        @strongify(self)
        return self.searchText.rac_textSignal;
    }] filter:^BOOL(NSString * _Nullable value) {
        @strongify(self)
        return [self isValidSearchText:value];
    }] flattenMap:^__kindof RACSignal * _Nullable(NSString * _Nullable value) {
        @strongify(self)
        return [self signalForSearchWithText:value];
    }] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDictionary * _Nullable x) {
        NSArray *statuses = x[@"statuses"];
        NSArray *tweets = [statuses linq_select:^id(id item) {
            return [RWTweet tweetWithStatus:item];
        }];
        [self.resultsViewController displayTweets:tweets];
    } error:^(NSError * _Nullable error) {
        NSLog(@"An error occurred: %@", error);
    }];
}

- (BOOL)isValidSearchText:(NSString *)text {
    return text.length > 2;
}

- (RACSignal *)requestAccessToTwitterSignal {
    NSError *accessError = [NSError errorWithDomain:RWTwitterInstantDomain
                                               code:RWTwitterInstantErrorAccessDenied
                                           userInfo:nil];
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
        @strongify(self)
        [self.accountStore requestAccessToAccountsWithType:self.twitterAccountType
                                                   options:nil
                                                completion:^(BOOL granted, NSError *error) {
            if (!granted) {
                [subscriber sendError:accessError];
            } else {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }
        }];
        return nil;
    }];
}

- (SLRequest *)requestForTwitterSearchWithText:(NSString *)text {
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
    NSDictionary *params = @{
        @"q": text
    };
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:url
                                               parameters:params];
    return request;
}

- (RACSignal *)signalForSearchWithText:(NSString *)text {
    NSError *noAccountsError = [NSError errorWithDomain:RWTwitterInstantDomain
                                                   code:RWTwitterInstantErrorNoTwitterAccounts
                                               userInfo:nil];
    NSError *invalidResponseError = [NSError errorWithDomain:RWTwitterInstantDomain
                                                        code:RWTwitterInstantErrorInvalidResponse
                                                    userInfo:nil];
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber> _Nonnull subscriber) {
        @strongify(self)
        SLRequest *request = [self requestForTwitterSearchWithText:text];
        
        NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:self.twitterAccountType];
        if (twitterAccounts.count == 0) {
            [subscriber sendError:noAccountsError];
        } else {
            [request setAccount:[twitterAccounts lastObject]];
            
            [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                if (urlResponse.statusCode == 200) {
                    NSDictionary *timelineData = [NSJSONSerialization JSONObjectWithData:responseData
                                                                                 options:NSJSONReadingAllowFragments
                                                                                   error:nil];
                    [subscriber sendNext:timelineData];
                    [subscriber sendCompleted];
                } else {
                    [subscriber sendError:invalidResponseError];
                }
            }];
        }
        return nil;
    }];
}

- (void)styleTextField:(UITextField *)textField {
    CALayer *textFieldLayer = textField.layer;
    textFieldLayer.borderColor = [UIColor grayColor].CGColor;
    textFieldLayer.borderWidth = 2.0f;
    textFieldLayer.cornerRadius = 0.0f;
}

@end
