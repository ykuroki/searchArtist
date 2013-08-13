//
//  SearchArtistViewController.h
//  ListeningStatation
//
//  Created by kuroki on 12/11/14.
//  Copyright (c) 2012年 黒木 裕貴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiUtil.h"
#import "LibConst.h"

@protocol SearchArtistViewControllerDelegate
@optional
- (void)SearchArtistViewControllerDidFinish;
@end

@interface SearchArtistViewController : UIViewController
<UISearchBarDelegate,
UITableViewDelegate,
UITableViewDataSource
>{
    NSArray *_artistList;
}
@property(assign, nonatomic) id<SearchArtistViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UINavigationBar *searchNavigationBar;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *searchButton;
@property (retain, nonatomic) IBOutlet UITableView *mainTableView;
- (IBAction)searchButtonAction:(id)sender;

@end
