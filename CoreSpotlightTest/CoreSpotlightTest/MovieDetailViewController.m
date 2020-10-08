//
//  MovieDetailViewController.m
//  CoreSpotlightTest
//
//  Created by LZhenHong on 2020/10/9.
//

#import "MovieDetailViewController.h"
#import "MovieInfo.h"

@interface MovieDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *directorLabel;
@property (weak, nonatomic) IBOutlet UILabel *starsLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = self.movieInfo.title;
    
    self.movieImageView.image = [UIImage imageNamed:self.movieInfo.image];
    self.titleLabel.text = self.movieInfo.title;
    self.directorLabel.text = self.movieInfo.director;
    self.starsLabel.text = self.movieInfo.stars;
    self.categoryLabel.text = self.movieInfo.category;
    self.descriptionLabel.text = self.movieInfo.movieDescription;
    self.ratingLabel.text = self.movieInfo.rate;
}

@end
