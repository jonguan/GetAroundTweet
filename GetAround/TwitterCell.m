//
//  TwitterCell.m
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
#import "TwitterCell.h"
#import "TweetObject.h"

@implementation TwitterCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 Loads the twitter object
 @param object - tweet object
 */
- (void)loadWithTweetObject:(TweetObject *)object
{
    if (object == nil)
    {
        return;
    }
    self.tweetObject = object;
    
    
    self.descLabel.text = object.tweetText;
    CGSize size = [self.descLabel sizeThatFits:CGSizeMake(228.0f, 9999.0f)];
    CGFloat height = size.height;
    
    // Resize the description label
    CGRect labelRect = self.descLabel.frame;
    labelRect.size.height = height;
    self.descLabel.frame = labelRect;
    
    self.nameLabel.text = [NSString stringWithFormat:@"-%@", object.screenName];

    // TODO: cancel previous image requests here
    
    [self performSelectorInBackground:@selector(sendRequestForImageUrl:) withObject:object.imageUrl];

}


- (void)sendRequestForImageUrl:(NSString *)url
{
    if (url != nil)
    {
        NSURLRequest *imageRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
        [NSURLConnection sendAsynchronousRequest:imageRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        
            if (error == nil)
            {
                UIImage *image = [UIImage imageWithData:data];
                self.imageView.image = image;
                self.imageView.frame = CGRectMake(20, 11, 44, 44);
            }
        }];
    }
}

/**
 Static method to determine cell height
 @param object - tweet object
 @returns float
 */
+ (CGFloat)cellHeightForObject:(TweetObject *)object
{
    if (object == nil)
    {
        return 0;
    }
    
    CGSize maximumSize = CGSizeMake(228, 9999);
    NSString *descString = object.tweetText;
    UIFont *myFont = [UIFont systemFontOfSize:17.0f];
    CGSize myStringSize = [descString sizeWithFont:myFont
                               constrainedToSize:maximumSize
                                   lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat topBuffer = 11.0f;
    CGFloat midBuffer = 8.0f;
    CGFloat nameLabelHeight = 21.0f;
    CGFloat descHeight = myStringSize.height + topBuffer + midBuffer + nameLabelHeight;
    CGFloat height = MAX(110, descHeight);
    

    return height;
}



@end
