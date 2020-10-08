//
//  MovieTableViewCell.m
//  CoreSpotlightTest
//
//  Created by LZhenHong on 2020/10/8.
//

#import "MovieTableViewCell.h"
#import "MovieInfo.h"

@interface MovieTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *movieDirector;
@property (weak, nonatomic) IBOutlet UILabel *movieStars;
@property (weak, nonatomic) IBOutlet UILabel *movieDescription;
@property (weak, nonatomic) IBOutlet UILabel *movieRating;
@end

@implementation MovieTableViewCell

+ (NSString *)reuseIdentifier {
    return NSStringFromClass(self);
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.movieTitle.text = @"";
    self.movieDirector.text = @"";
    self.movieStars.text = @"";
    self.movieDescription.text = @"";
    self.movieRating.text = @"0.0";
}

- (void)updateUIWithMovieInfo:(MovieInfo *)movieInfo {
    self.movieImageView.image = [UIImage imageNamed:movieInfo.image];
    
    self.movieTitle.text = movieInfo.title;
    self.movieDirector.text = movieInfo.director;
    self.movieStars.text = movieInfo.stars;
    self.movieDescription.text = movieInfo.movieDescription;
    self.movieRating.text = movieInfo.rate;
}

@end
