//
//  DetailsViewController.m
//  Flix
//
//  Created by mac2492 on 6/23/21.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"


@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // --------- Gets the URL Poster Image -------------
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.movie[@"poster_path"];
    
    NSString *fullPosterURLString = [baseURLString stringByAppendingString: posterURLString ];
    
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    [self.posterView setImageWithURL: posterURL];
    
    //--------- Gets the Background Image -------------
    NSString *backdropURLString = self.movie[@"backdrop_path"];
    
    NSString *fullBackdropURLString = [baseURLString stringByAppendingString: backdropURLString ];
    
    
    NSURL *backdropURL = [NSURL URLWithString:fullBackdropURLString];
    
    
    // ------- Setting the details based on the movie passed in -------
    [self.backdropView setImageWithURL: backdropURL];
    
    self.titleLabel.text = self.movie[@"title"];
    
    self.titleLabel.adjustsFontSizeToFitWidth = true;
    self.titleLabel.minimumScaleFactor = 0.2;
    
    self.synopsisLabel.text = self.movie[@"overview"];
    
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
    
    UIColor *borderColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1];
    [self.posterView.layer setBorderColor: borderColor.CGColor];
    [self.posterView.layer setBorderWidth: 1.0];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
