//
//  UINavigationItem+custonItem.m
//  OzakiBook
//
//  Created by Raymond  Chow on 12-7-12.
//  Copyright (c) 2012年 TS. All rights reserved.
//

#import "UINavigationItem+custonItem.h"

@implementation UINavigationItem (custonItem)
- (void) setTitle:(NSString*)title{  
    if (!title) {
        return;
    }
    UIView * customTitleView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 150.0f, 40.0f)];
    
    UILabel * customLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 10.0f, 150.0f, 30.0f)];
    [customLabel setBackgroundColor:[UIColor clearColor]];
    [customLabel setTextColor:[UIColor whiteColor]];
    [customLabel setFont:[UIFont fontWithName:@"Helvetica-Bold"size:20]];
     customLabel.adjustsFontSizeToFitWidth = YES;
    [customLabel setTextAlignment:NSTextAlignmentCenter];
    [customLabel setText:title];
    [customTitleView addSubview:customLabel];
    [customLabel release];
    
    [self setTitleView:customTitleView];
    [customTitleView release];    
}
@end
