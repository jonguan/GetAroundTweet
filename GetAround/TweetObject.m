//
//  TweetObject.m
//  GetAround
//
//  Created by Jonathan.Guan on 4/16/13.
//  Copyright (c) 2013 NoahMonster. All rights reserved.
//
/*            
 Description:
 
 This file contains the TweetObject class declaration.
 */

#import "TweetObject.h"

static NSDateFormatter *formatter = nil;

@implementation TweetObject

/**
 Tweet object initializer
 @param dict - nsdictionary
 @returns - parsed tweet
 */
- (id)initWithDict:(NSDictionary *)dict
{
    if (dict == nil)
    {
        return nil;
    }
    
    self = [super init];
    
    if (self)
    {
        [self parseDict:dict];
    }
    
    return self;
}

- (void)parseDict:(NSDictionary *)dict
{
    if (dict == nil)
    {
        return;
    }
    
    NSDictionary *userDict = [dict objectForKey:@"user"];
        
    _tweetText = [dict objectForKey:@"text"];
    _tweetId = [dict objectForKey:@"id_str"];
    
    _screenName = [userDict objectForKey:@"screen_name"];
    _name = [userDict objectForKey:@"name"];
    _imageUrl = [userDict objectForKey:@"profile_image_url"];
    _userId = [userDict objectForKey:@"id_str"];
    
    NSString *createDateString  = [dict objectForKey:@"created_at"];
    
    if (createDateString != nil)
    {
        if (formatter == nil)
        {
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
        }
    
        NSDate *myDate = [formatter dateFromString: createDateString];
        _timeStamp = myDate;
    }
    
}

@end
