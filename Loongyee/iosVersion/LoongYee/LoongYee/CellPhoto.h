//
//  CellPhoto.h
//  OzakiBook
//
//  Created by Raymond  Chow on 12-6-28.
//  Copyright (c) 2012年 TS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridViewCell.h"
@interface CellPhoto : UIGridViewCell

@property (retain, nonatomic) IBOutlet UIImageView *thumImage;
@property (retain, nonatomic) IBOutlet UIImageView *selectedImage;
- (void) setMySelected:(BOOL)selected;
@end
