//
//  TwitterViewController.m
//  GetAround
//
//  Created by Jonathan.Guan on 4/16/13.
//  Copyright (c) 2013 NoahMonster. All rights reserved.
//
/*           
 
 Description:
 
 This file contains the TwitterViewController class declaration.
 */


#import "TwitterViewController.h"
#import "TwitterCell.h"
#import "TweetObject.h"
#import "FooterView.h"
#import "CKRefreshControl.h"


@interface TwitterViewController ()
@property (nonatomic, strong) NSString *nextPageUrl;
@property (nonatomic, strong) NSString *currentUrl;
@property (nonatomic, strong) FooterView *footerView;
//@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation TwitterViewController



- (void)viewDidLoad
{
    [super viewDidLoad];

    _tweetManager = [TweetManager sharedInstance];
    _tweetManager.delegate = self;
    
    self.footerView = [[FooterView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 44.0f)];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshPullCompleted) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:self.activityIndicator];
    self.activityIndicator.center = self.tableView.center;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
//    [self setTwitterTableView:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweetsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GetAroundCellIdentifier";
    TwitterCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    TweetObject *object = [self.tweetsArray objectAtIndex:indexPath.row];

    [cell loadWithTweetObject:object];
    cell.contentView.backgroundColor = (indexPath.row % 2) ? [UIColor grayColor] : [UIColor whiteColor];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.tweetsArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetObject *object = nil;
    
    if (self.tweetsArray.count > indexPath.row)
    {
        object = [self.tweetsArray objectAtIndex:indexPath.row];
    }

    return [TwitterCell cellHeightForObject:object];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 44.0f;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.footerView;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return 44.0f;
//    }
//    return 0;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return self.refreshControl;
//}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= self.tableView.contentSize.height - self.tableView.bounds.size.height)
    {
        // Send only unique (also works for nil == currentUrl)
        if (![self.currentUrl isEqualToString:self.nextPageUrl])
        {
            [self.footerView.footerActView startAnimating];
            [_tweetManager searchTwitter:@"@getaround" nextResultString:self.nextPageUrl];
            self.currentUrl = self.nextPageUrl;
        }
     
    }
    else
    {
        [self.footerView.footerActView stopAnimating];
    }
}

#pragma mark - UIRefreshControl
- (void)refreshPullCompleted
{
    self.nextPageUrl = nil;
    self.currentUrl = nil;
    [_tweetManager searchTwitter:@"@getaround" nextResultString:nil];
}

#pragma mark - Twitter
- (IBAction)didClickRetweet:(UIButton *)sender {
    TwitterCell *cell = (TwitterCell *)sender.superview.superview;
    TweetObject *object = cell.tweetObject;
    NSString *tweetID = object.tweetId;
    [_tweetManager retweetWithPostId:tweetID];
}

#pragma mark - Twitter Protocol Methods
- (void)twitterLoginSucess
{
    NSLog(@"twitter login successful");
    [self refreshPullCompleted];
}

- (void)twitterNotLoggedIn
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please login to Twitter in your iPhone settings" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
}

//App not given permission to access twitter
- (void)twitterAccessDisabled
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enable access to Twitter in your iPhone settings" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
}

// Query
- (void)onTwitterError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
}

- (void)onTweetsAvailable:(NSArray *)tweets nextPageURL:(NSString *)nextPageString
{
    NSLog(@"twitter response received");
    [self.activityIndicator stopAnimating];
    [self.footerView.footerActView stopAnimating];
    [self.refreshControl endRefreshing];
    
    NSLog(@"tweetsArray insertion");
    if (self.nextPageUrl == nil)
    {
        self.tweetsArray = [tweets mutableCopy];
    }
    else
    {
        @synchronized(self.tweetsArray)
        {
            [self.tweetsArray addObjectsFromArray:[tweets mutableCopy]];
        }

    }

    NSLog(@"tableview reload");
    self.nextPageUrl = nextPageString;
    [self.tableView reloadData];
}

- (void)onTweetRepost:(NSDictionary *)originalTweet
{
    if (originalTweet != nil)
    {
        NSLog(@"retweet success");
    }
}

@end
