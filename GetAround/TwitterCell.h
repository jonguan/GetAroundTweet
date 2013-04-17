//
//  TwitterCell.h
//  GetAround
//
//  Created by Jonathan.Guan on 4/16/13.
//  Copyright (c) 2013 NoahMonster. All rights reserved.
//
/*            
 Description:
 
 This file contains the TwitterCell class declaration.
 */

#import <UIKit/UIKit.h>

@class TweetObject;

@interface TwitterCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) TweetObject *tweetObject;

/**
	Loads the twitter object
	@param object - tweet object
 */
- (void)loadWithTweetObject:(TweetObject *)object;

/**
	Static method to determine cell height
	@param object - tweet object
	@returns float
 */
+ (CGFloat)cellHeightForObject:(TweetObject *)object;


@end
