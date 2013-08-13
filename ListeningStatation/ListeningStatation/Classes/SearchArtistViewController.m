//
//  SearchArtistViewController.m
//  ListeningStatation
//
//  Created by kuroki on 12/11/14.
//  Copyright (c) 2012年 黒木 裕貴. All rights reserved.
//

#import "SearchArtistViewController.h"

@interface SearchArtistViewController ()

@end

@implementation SearchArtistViewController
@synthesize delegate = _delegate;
@synthesize mainTableView = _mainTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchBar.delegate = self;
    self.searchButton.title = NSLocalizedString(@"SEARCH_BUTTON", @"search list");
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.searchBar becomeFirstResponder];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.searchBar.text = [defaults objectForKey:@"artistName"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_artistList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ArtistListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSDictionary *artist = [_artistList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [artist objectForKey:@"artistName"];
    
    return cell;
}

/*
 * リストから選択された場合の分岐
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.mainTableView reloadData];
    
    NSDictionary *artist = [_artistList objectAtIndex:indexPath.row];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[artist objectForKey:@"artistName"] forKey:@"artistName"];
    [defaults synchronize];
    NSLog(@"amgArtistId id = %@", [artist objectForKey:@"amgArtistId"]);
    NSLog(@"artist id = %@", [artist objectForKey:@"artistId"]);
    if ([artist objectForKey:@"amgArtistId"]) {
        NSString *str = [NSString stringWithFormat:@"%@", [artist objectForKey:@"amgArtistId"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"amgArtistId"
                                                        message:str
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }else{
        NSString *str = [NSString stringWithFormat:@"%@", [artist objectForKey:@"artistId"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"amg ないのでartistId"
                                                        message:str
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    
    }

    [_delegate SearchArtistViewControllerDidFinish];
    
    [super viewDidLoad];
}

/*
 * iTuneMusicを取得する
 */
-(void)getArtistList
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    AFHTTPRequestSuccessBlocks success = ^(AFHTTPRequestOperation *operation, id response) {
        NSDictionary  *res = [ApiUtil parseToJson:response];
        _artistList = (NSArray *)[res objectForKey:@"results"];
        [self.mainTableView reloadData];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    };
    
    AFHTTPRequestFailureBlocks failure = ^(AFHTTPRequestOperation *operation, NSError *error) {};
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]
                                   initWithObjectsAndKeys:
                                   self.searchBar.text, @"term",
                                   @"jp", @"country",
                                   @"music", @"media",
                                   @"musicArtist", @"entity",
                                   nil];
    [ApiUtil requestToUrl:ITUNE_API_URL params:params method:@"GET" success:success failure:failure];
}

- (IBAction)searchButtonAction:(id)sender {
    [_delegate SearchArtistViewControllerDidFinish];
    //[self getArtistList];
}

/*
 * キーボードの検索を押したとき
 */
-(void)searchBarSearchButtonClicked:(UISearchBar*)searchBar
{
    [self getArtistList];
}

/*
 * キャンセルボタン押したとき
 */
-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText
{
    [self getArtistList];
}

@end
