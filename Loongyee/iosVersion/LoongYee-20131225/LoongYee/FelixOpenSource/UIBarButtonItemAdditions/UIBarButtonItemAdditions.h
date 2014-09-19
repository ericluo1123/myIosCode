//
//  UIBarButtonItemAdditions.h
//  OzakiBook
//
//  Created by Raymond  Chow on 12-6-27.
//  Copyright (c) 2012年 TS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIBarButtonItemAdditions : UIBarButtonItem
- (id) initWithMyMethodTitle:(NSString *)title img:(NSString *)imgStr target:(id)target action:(SEL)action;
- (id) initWithMyMethodTitle:(NSString *)title img:(NSString *)imgStr target:(id)target action:(SEL)action font:(int)fontSize;
- (void) setTitleColor:(UIColor*)color;
@end
