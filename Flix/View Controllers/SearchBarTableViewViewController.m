//
//  SearchBarTableViewViewController.m
//  Flix
//
//  Created by mac2492 on 6/25/21.
//

#import "SearchBarTableViewViewController.h"
#import "MovieCell.h"
#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "SearchMovieCell.h"
#import <objc/runtime.h>

@interface SearchBarTableViewViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *movieSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *movieTableView;

@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSMutableArray *filteredData;

@end

@implementation SearchBarTableViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.movieTableView.delegate = self;
    self.movieTableView.dataSource = self;
    self.movieSearchBar.delegate = self;

    
    
}

- (void) fetchMovies: (NSString *)searchText {
    NSString *baseSearchUrl = @"https://api.themoviedb.org/3/search/movie?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&query=";
    NSString *searchQuery = [ searchText stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *searchUrlString = [baseSearchUrl stringByAppendingString: searchQuery ];
    
    NSURL *searchUrl = [NSURL URLWithString:searchUrlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:searchUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            //If the API call returned an error, print out the error message
           if (error != nil) {
               NSLog(@"Network error");
           }
        //If API call successful, add the movie results into the array
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               self.filteredData = dataDictionary[@"results"];
               [self checkForPosterAndBackdropImage];
               [self.movieTableView reloadData];
           }
  
       }];
    [task resume];
}
-(void) checkForPosterAndBackdropImage{
    for (NSInteger i = self.filteredData.count - 1; i >= 0 ; i--) {
        NSDictionary *movie = self.filteredData[i];
        NSString *posterURLString = movie[@"poster_path"];
        NSString *backdropURLString = movie[@"backdrop_path"];
        
        if ( (posterURLString == (id)[NSNull null] || posterURLString.length == 0 )){
            [self.filteredData removeObjectAtIndex:i];
            
        }
        else if( (backdropURLString == (id)[NSNull null] || backdropURLString.length == 0)){
            [self.filteredData removeObjectAtIndex:i];
        }
        
        
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filteredData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchMovieCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchMovieCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.filteredData[indexPath.row];
    
    cell.movieLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    
    
    if (! (posterURLString == (id)[NSNull null] || posterURLString.length == 0 )){
        NSString *fullPosterURLString = [baseURLString stringByAppendingString: posterURLString ];
        NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
        cell.moviePosterImage.image = nil;
        [cell.moviePosterImage setImageWithURL:posterURL];
        
    }
       
        
        
  
    return cell;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length != 0) {
        [self fetchMovies:searchText];
        }
    else {
        self.filteredData = self.data;
    }
    
}



- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.movieSearchBar.showsCancelButton = YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.movieSearchBar.showsCancelButton = NO;
    self.movieSearchBar.text = @"";
    [self.movieSearchBar resignFirstResponder];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    MovieCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.movieTableView indexPathForCell: tappedCell];
    NSDictionary *movie = self.filteredData[indexPath.row];
    
    DetailsViewController *detailsViewController = [segue destinationViewController];
    
    detailsViewController.movie = movie;
    
}
@end
