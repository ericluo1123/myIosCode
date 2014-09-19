//
//  UIBarButtonItemAdditions.m
//  OzakiBook
//
//  Created by Raymond  Chow on 12-6-27.
//  Copyright (c) 2012年 TS. All rights reserved.
//

#import "UIBarButtonItemAdditions.h"

@implementation UIBarButtonItemAdditions
- (id) initWithMyMethodTitle:(NSString *)title img:(NSString *)imgStr target:(id)target action:(SEL)action{
    return [self initWithMyMethodTitle:title img:imgStr target:target action:action font:0];
}
- (id) initWithMyMethodTitle:(NSString *)title img:(NSString *)imgStr target:(id)target action:(SEL)action font:(int)fontSize{
    UIImage *img=[UIImage imageNamed:imgStr];    
    UIButton *myButton=[UIButton buttonWithType:UIButtonTypeCustom];    
    if (title) 
    {
        [myButton setTitle:title forState:UIControlStateNormal];        
        [myButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        myButton.titleLabel.font= [UIFont fontWithName:@"Helvetica-Bold"size:20];
        
    }
    [myButton setBackgroundImage:img forState:UIControlStateNormal];
    myButton.frame = CGRectMake(fontSize, 0, img.size.width, img.size.height);
    myButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //NSLog(@"width:%f,heigth:%f",img.size.width,img.size.height);
    [myButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    //myButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, -10, 0);
    UIView *theView = [[UIView alloc] initWithFrame:CGRectMake(fontSize, -3, img.size.width, img.size.height)];
    [theView addSubview:myButton];
    if (self = [super initWithCustomView:theView]) {
        
    }
    [theView release];
    return self;
}
- (void) setTitleColor:(UIColor*)color{
    for (UIView *theView in self.customView.subviews) {
        if ([theView isMemberOfClass:[UIButton class]]) {
            [(UIButton*)theView setTitleColor:color forState:UIControlStateNormal];
            break;
        }
    }
}
@end
