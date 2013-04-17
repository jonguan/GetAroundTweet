//
//  TweetManager.h
//  GetAround
//
//  Created by Jonathan.Guan on 4/16/13.
//  Copyright (c) 2013 NoahMonster. All rights reserved.
//
/*
 
 Description:
 
 This file contains the TweetManager class declaration.
 */


#import <Foundation/Foundation.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@protocol TweetManagerProtocol;


@interface TweetManager : NSObject
{
    /**
     Twitter user account store.
     */
    ACAccountStore *_accountStore;
    
    /**
     Local twitter account.
     */
    ACAccount *_localTwitterAccount;
    
    /**
     Whether login succeeded
     */
    BOOL _userLoggedIn;
}

@property (nonatomic, weak) id <TweetManagerProtocol> delegate;
/**
	Singleton class.  Manages all twitter interactions
	@returns Twitter singleton
 */
+ (TweetManager*)sharedInstance;

/**
	Get tweets - default 15 at a time
	@param searchString - starter search
	@param nextResults - if this is populated, then it will be used over searchString
 */
- (void)searchTwitter:(NSString*)searchString nextResultString:(NSString *)nextResults;


- (void)twitterLogin;

/**
	Send retweets
	@param tweetId - tweet id
 */
- (void)retweetWithPostId:(NSString *)tweetId;


@end

@protocol TweetManagerProtocol <NSObject>

// Login
- (void)twitterLoginSucess;

- (void)twitterNotLoggedIn;

- (void)twitterAccessDisabled; //App not given permission to access twitter

// Query 
- (void)onTwitterError:(NSError *)error;

- (void)onTweetsAvailable:(NSArray *)tweets nextPageURL:(NSString *)nextPageString;

- (void)onTweetRepost:(NSDictionary *)originalTweet;


@end