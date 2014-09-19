//
//  HomeViewController.h
//  LoongYee
//
//  Created by FelixMac on 13-12-6.
//  Copyright (c) 2013年 FelixMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCHCircleView.h"
@interface HomeViewController : UIViewController<SCHCircleViewDataSource,SCHCircleViewDelegate>
{

    
    
}

@property (nonatomic,retain) IBOutlet SCHCircleView *circle_view;


@end
