//
//  SwitchSettingsViewController.h
//  LoongYee
//
//  Created by FelixMac on 13-12-26.
//  Copyright (c) 2013年 FelixMac. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "FelixTelnet.h"
@interface SwitchSettingsViewController : UIViewController

//@property (nonatomic,retain)  FelixTelnet *telnet;
@property (nonatomic,retain)  NSString *remoteCode;
@property (nonatomic) NSInteger keyID;
@property (nonatomic) NSInteger groupID;

@end
