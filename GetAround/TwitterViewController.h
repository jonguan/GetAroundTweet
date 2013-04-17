//
//  TwitterViewController.h
//  GetAround
//
//  Created by Jonathan.Guan on 4/16/13.
//  Copyright (c) 2013 NoahMonster. All rights reserved.
//
/*           
 Description:
 
 This file contains the TwitterViewController class declaration.
 */


#import <UIKit/UIKit.h>
#import "TweetManager.h"

@interface TwitterViewController : UITableViewController <TweetManagerProtocol, UIScrollViewDelegate>
{
    TweetManager *_tweetManager;
}


//@property (strong, nonatomic) IBOutlet UITableView *twitterTableView;
@property (nonatomic, strong) NSMutableArray *tweetsArray;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)didClickRetweet:(UIButton *)sender;

@end
