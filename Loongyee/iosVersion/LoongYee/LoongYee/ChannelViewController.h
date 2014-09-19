//
//  ChannelViewController.h
//  LoongYee
//
//  Created by FelixMac on 13-12-25.
//  Copyright (c) 2013年 FelixMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoongYeePassValueDelegate.h"

@interface ChannelViewController : UIViewController
{
    
}

@property (nonatomic, assign) int indexSelect;
@property(nonatomic, retain) NSObject<LoongYeePassValueDelegate> * delegate;
@end
