//
//  SearchMovieCell.h
//  Flix
//
//  Created by mac2492 on 6/25/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchMovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *movieLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moviePosterImage;

@end

NS_ASSUME_NONNULL_END
