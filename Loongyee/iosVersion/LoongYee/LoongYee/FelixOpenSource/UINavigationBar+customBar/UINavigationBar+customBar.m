//
//  UINavigationBar+customBar.m
//  cuntomNavigationBar
//
//  Created by Edward on 13-4-22.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "UINavigationBar+customBar.h"

@implementation UINavigationBar (customBar)
- (void)customNavigationBar {
    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        if ([[[UIDevice currentDevice] systemVersion] intValue] >= 7.0)
        {
             [self setBackgroundImage:[UIImage imageNamed:@"NavigationBar_bk_ios7"] forBarMetrics:UIBarMetricsDefault];
        }
        else
        {
            [self setBackgroundImage:[UIImage imageNamed:@"NavigationBar_bk"] forBarMetrics:UIBarMetricsDefault];
        }
        
    }
    else
    {
        [self drawRect:CGRectMake(0, 0, 320, 44)];
    }
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [self drawRoundCornerAndShadow];
}


- (void)drawRect:(CGRect)rect {
    [[UIImage imageNamed:@"NavigationBar_bk"] drawInRect:rect];
}

- (void)drawRoundCornerAndShadow {

    self.layer.shadowOffset = CGSizeMake(3, 3);
    self.layer.shadowOpacity = 0.7;
    CGRect Rect = self.bounds;
    Rect.origin.x = -7;
    Rect.size.width = Rect.size.width + 10;
    
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:Rect].CGPath;
}
@end
