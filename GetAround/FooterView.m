//
//  FooterView.m
//  GetAround
//
//  Created by Jonathan.Guan on 4/16/13.
//  Copyright (c) 2013 NoahMonster. All rights reserved.
//
/*         
 Description:
 
 This file contains the FooterView class declaration.
 */


#import "FooterView.h"

@implementation FooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIActivityIndicatorView *actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        actView.hidesWhenStopped = YES;
        [self addSubview:actView];
        actView.center = self.center;
        
        self.footerActView = actView;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
