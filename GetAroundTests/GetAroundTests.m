//
//  GetAroundTests.m
//  GetAroundTests
//
//  Created by Jonathan.Guan on 4/16/13.
//  Copyright (c) 2013 NoahMonster. All rights reserved.
//

#import "GetAroundTests.h"
#import "TweetManager.h"

@implementation GetAroundTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    _manager = [TweetManager sharedInstance];
    [_manager twitterLogin];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testTwitter
{
    [_manager searchTwitter:@"@getaround" sinceId:nil];
    
    
}

@end
