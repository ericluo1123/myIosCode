//
//  HomeViewController.h
//  LoongYee
//
//  Created by FelixMac on 13-12-6.
//  Copyright (c) 2013年 FelixMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCHCircleView.h"
//#import "FelixTelnet.h"
@interface HomeViewController : UIViewController<SCHCircleViewDataSource,SCHCircleViewDelegate>
{

    
    
}
@property (retain, nonatomic)  NSMutableArray *DeviceItemsarr;
@property (nonatomic,retain) IBOutlet SCHCircleView *circle_view;
@property (retain, nonatomic) IBOutlet UILabel *Option_Lable;

//@property (nonatomic,retain)  FelixTelnet *telnet;

@end
