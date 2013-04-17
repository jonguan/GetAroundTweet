//
//  TweetObject.h
//  GetAround
//
//  Created by Jonathan.Guan on 4/16/13.
//  Copyright (c) 2013 NoahMonster. All rights reserved.
//
/*        
 Description:
 
 This file contains the TweetObject class declaration.
 */


#import <Foundation/Foundation.h>

@interface TweetObject : NSObject

@property (nonatomic, strong) NSDate *timeStamp;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *tweetText;
@property (nonatomic, strong) NSString *tweetId;
@property (nonatomic, strong) NSString *userId;


/**
	Tweet object initializer
	@param dict - nsdictionary
	@returns - parsed tweet
 */
- (id)initWithDict:(NSDictionary *)dict;


@end
