//
//  ViewController.m
//  CoreSpotlightTest
//
//  Created by LZhenHong on 2020/9/27.
//

#import "ViewController.h"
#import "MovieInfoViewModel.h"
#import "MovieTableViewCell.h"
#import "MovieDetailViewController.h"
#import "CoreSpotlightHelper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[MovieInfoViewModel sharedViewModel] startLoadAllMovieInfos];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[MovieInfoViewModel sharedViewModel] movieInfoCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MovieTableViewCell reuseIdentifier]
                                                               forIndexPath:indexPath];
    NSArray<MovieInfo *> *movieInfos = [[MovieInfoViewModel sharedViewModel] grabAllMovieInfos];
    MovieInfo *movieInfo = movieInfos[indexPath.row];
    [cell updateUIWithMovieInfo:movieInfo];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 170;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray<__kindof MovieInfo *> *movieInfos = [[MovieInfoViewModel sharedViewModel] grabAllMovieInfos];
    MovieInfo *movieInfo = movieInfos[indexPath.row];
    [self performSegueWithIdentifier:@"MovieListToDetail" sender:movieInfo];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MovieInfo *movieInfo = sender;
    MovieDetailViewController *movieDetailVc = segue.destinationViewController;
    movieDetailVc.movieInfo = movieInfo;
}

- (IBAction)indexMoviesToCoreSpotlight:(UIBarButtonItem *)sender {
    NSArray<__kindof MovieInfo *> *movieInfos = [[MovieInfoViewModel sharedViewModel] grabAllMovieInfos];
    for (MovieInfo *movieInfo in movieInfos) {
        [CoreSpotlightHelper indexMovieInfo:movieInfo];
    }
}

- (IBAction)deindexMoviesFromCoreSpotlight:(UIBarButtonItem *)sender {
    NSArray<__kindof MovieInfo *> *movieInfos = [[MovieInfoViewModel sharedViewModel] grabAllMovieInfos];
    for (MovieInfo *movieInfo in movieInfos) {
        [CoreSpotlightHelper deindexMovieInfo:movieInfo];
    }
}

@end
