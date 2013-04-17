//
//  TweetManager.m
//  GetAround
//
//  Created by Jonathan.Guan on 4/16/13.
//  Copyright (c) 2013 NoahMonster. All rights reserved.
//
/*            
 Description:
 
 This file contains the TweetManager class declaration.
 */

#import "TweetManager.h"
#import "TweetObject.h"

static TweetManager *tweetManagerInstance = nil;
static NSString *twitterBaseUrl = @"https://api.twitter.com/1.1/";

@implementation TweetManager


#pragma mark - Singleton  Constructor

+(TweetManager*)sharedInstance
{
    if (tweetManagerInstance == nil)
    {
        tweetManagerInstance = [[TweetManager alloc] init];
    }
    
    return tweetManagerInstance;
}

#pragma mark - Initilization/Constructor  Methods

-(id) init
{
    self = [super init];
    
    if (nil != self)
    {
        _accountStore = [[ACAccountStore alloc] init];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(twitterAccountChangedNotification) name:ACAccountStoreDidChangeNotification object:nil];
        [self twitterLogin];
    }
    
    return self;
}

- (void)twitterAccountChangedNotification
{
    //Forcing relogin to verify still we have to acces to the twitter.
    //Here we are handling case like when user expliciltly disable twitter access to the app.
    _localTwitterAccount = nil;
    _userLoggedIn = NO;
    [self twitterLogin];
}

#pragma mark - Twitter Methods
/**
	Login method to twitter
 */
- (void)twitterLogin
{
    
    if (_userLoggedIn && self.delegate != nil)
    {
        [self.delegate twitterLoginSucess];
        return;
    }
    
    ACAccountType *accountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    // Request access from the user to access their Twitter account
    [_accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error)
     {
         // Did user allow  us access?
         if (granted == YES)
         {
             // Populate array with all available Twitter accounts
             NSArray *arrayOfAccounts = [_accountStore accountsWithAccountType:accountType];
             
             // Sanity check
             if ([arrayOfAccounts count] > 0)
             {
                 // Keep it simple, use the first account available
                 _localTwitterAccount = [arrayOfAccounts objectAtIndex:0];
                 _userLoggedIn = YES;
                
             }
            
             if (self.delegate != nil)
             {
                 _userLoggedIn ? [self.delegate twitterLoginSucess] : [self.delegate twitterNotLoggedIn];
             }

         }
         else
         {
             
             BOOL atLeastIOS6_0 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0;
             
             //In iOS 6.0, Twitter Access alert shows only once. User has to explicitly give access in Settings
             //Access is not granted, If version 6.0 and atleast one account exists.
             
             if ([TWTweetComposeViewController canSendTweet] && self.delegate != nil)
             {
                 atLeastIOS6_0 ? [self.delegate twitterAccessDisabled] : [self.delegate twitterNotLoggedIn];
                 
             }
             else if (error.code == 6)
             {
                 // User has no twitter account
                 [self.delegate twitterNotLoggedIn];
             }
             
         }
     }];
}

- (void)searchTwitter:(NSString*)searchString nextResultString:(NSString *)nextResults
{
    
    NSMutableString *tweetSearchUrlStr = [NSMutableString stringWithFormat:@"%@search/tweets.json", twitterBaseUrl];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    if (nextResults != nil)
    {
        [tweetSearchUrlStr appendString:nextResults];
    }
    else
    {
        [params setObject:searchString forKey:@"q"];//Filter string
        [params setObject:@"en" forKey:@"lang"];//Filter english tweets only.
        

    }
    NSString *escapedString = [tweetSearchUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //  The endpoint that we wish to call
    NSURL *url = [NSURL URLWithString:escapedString];

    NSLog(@"twitter url is %@", url);
    
    //  Build the request with our parameter
    TWRequest *request = [[TWRequest alloc] initWithURL:url  parameters:params requestMethod:TWRequestMethodGET];
    
    // Attach the account object to this request
   
    [request setAccount:_localTwitterAccount];
    
    
    [request performRequestWithHandler:
     ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
     {
         if (!responseData || error != nil)
         {
             // inspect the contents of error
             NSLog(@"%@", error);
             
             if (error.code == -1012)
             {
                 // Auth failed error code
                 [self.delegate twitterNotLoggedIn];
             }
         }
         else
         {
             
             NSError *jsonError;
             NSDictionary *timeline =  [NSJSONSerialization
                                        JSONObjectWithData:responseData
                                        options:NSJSONReadingMutableLeaves
                                        error:&jsonError];
             
             //Look for errors, If any. Somehow errors are not getting notified through NSError.
             // @[ @{code:88, message: @"rate limit exceeded"}, @{code, message}]
             NSArray *errorArray = [timeline objectForKey:@"errors"];
             
             if (errorArray == nil)
             {
                 NSArray *resultsArray = [timeline objectForKey:@"statuses"];
                 
                 NSMutableArray *tweets = [NSMutableArray arrayWithCapacity:resultsArray.count];
                 for (NSDictionary *tweet in resultsArray)
                 {
                     TweetObject *object = [[TweetObject alloc] initWithDict:tweet];
                     if (object != nil)
                     {
                         [tweets addObject:object];
                     }
                 }
                 
                 NSDictionary *searchMetaData = [timeline objectForKey:@"search_metadata"];
                 NSString *next = [searchMetaData objectForKey:@"next_results"];
                 
                 if(self.delegate!=nil)
                 {
                     [self.delegate onTweetsAvailable:tweets nextPageURL:next];
                 }
             }
             else
             {
                 NSString *msg = [NSString stringWithFormat:@"Twitter Errors: %@",[errorArray componentsJoinedByString:@";"]];
                 NSLog(@"%@", msg);
                 NSError *error = [NSError errorWithDomain:@"com.twitter" code:403 userInfo:@{ NSLocalizedDescriptionKey : msg}];
                 if (self.delegate != nil && [self.delegate respondsToSelector:@selector(onTwitterError:)])
                 {
                     [self.delegate onTwitterError:error];
                 }
                 
             }
             
         }
     }];
}

/**
 Send retweets
 @param tweetId - tweet id
 */
- (void)retweetWithPostId:(NSString *)tweetId
{
    if (tweetId == nil)
    {
        return;
    }
    
    NSMutableString *tweetSearchUrlStr = [NSMutableString stringWithFormat:@"%@statuses/retweet/%@.json", twitterBaseUrl, tweetId];
    
  
    NSString *escapedString = [tweetSearchUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //  The endpoint that we wish to call
    NSURL *url = [NSURL URLWithString:escapedString];
    
    NSLog(@"twitter url is %@", url);
    
    //  Build the request with our parameter
    TWRequest *request = [[TWRequest alloc] initWithURL:url  parameters:nil requestMethod:TWRequestMethodPOST];
    
    // Attach the account object to this request
    
    [request setAccount:_localTwitterAccount];
    
    
    [request performRequestWithHandler:
     ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
     {
         if (!responseData || error != nil)
         {
             // inspect the contents of error
             NSLog(@"%@", error);
             
             if (error.code == -1012)
             {
                 // Auth failed error code
                 [self.delegate twitterNotLoggedIn];
             }
         }
         else
         {
             
             NSError *jsonError;
             NSDictionary *tweet =  [NSJSONSerialization
                                        JSONObjectWithData:responseData
                                        options:NSJSONReadingMutableLeaves
                                        error:&jsonError];
             
             //Look for errors, If any. Somehow errors are not getting notified through NSError.
             // @[ @{code:88, message: @"rate limit exceeded"}, @{code, message}]
             NSArray *errorArray = [tweet objectForKey:@"errors"];
             
             if (errorArray == nil)
             {
                 if(self.delegate!=nil)
                 {
                     [self.delegate onTweetRepost:tweet];
                 }
             }
             else
             {
                 NSString *msg = [NSString stringWithFormat:@"Twitter Errors: %@",[errorArray componentsJoinedByString:@";"]];
                 NSLog(@"%@", msg);
                 NSError *error = [NSError errorWithDomain:@"com.twitter" code:403 userInfo:@{ NSLocalizedDescriptionKey : msg}];
                 if (self.delegate != nil && [self.delegate respondsToSelector:@selector(onTwitterError:)])
                 {
                     [self.delegate onTwitterError:error];
                 }
                 
             }
             
         }
     }];
}



@end
