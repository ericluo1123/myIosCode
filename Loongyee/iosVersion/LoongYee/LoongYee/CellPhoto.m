//
//  CellPhoto.m
//  OzakiBook
//
//  Created by Raymond  Chow on 12-6-28.
//  Copyright (c) 2012年 TS. All rights reserved.
//

#import "CellPhoto.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation CellPhoto
@synthesize thumImage;
@synthesize selectedImage;
- (id)init
{
	
    if (self = [super init])
    {
		
		
		[[NSBundle mainBundle] loadNibNamed:@"CellPhoto" owner:self options:nil];
		
        [self addSubview:self.view];
	}
	
    return self;
	
}

- (void)dealloc {
    [thumImage release];
    [selectedImage release];
    [super dealloc];
} 

- (void) setSelected{
    selectedImage.hidden = !selectedImage.hidden;
}
- (BOOL) myIsSelected{
    return !selectedImage.hidden;
}
- (void) setMySelected:(BOOL)selected{
    selectedImage.hidden = !selected;
}
@end
