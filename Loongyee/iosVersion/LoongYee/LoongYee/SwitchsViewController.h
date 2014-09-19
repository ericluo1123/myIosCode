//
//  SwitchsViewController.h
//  LoongYee
//
//  Created by FelixMac on 13-12-17.
//  Copyright (c) 2013年 FelixMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
//#import "FelixTelnet.h"
@interface SwitchsViewController : UIViewController<UIPickerViewDelegate>
{
    NSArray *pickerArray;
    NSMutableArray *DeviceItemStatus;
    NSInteger ideviceTag;
    NSInteger iitemTag;
    NSMutableArray* cellTextArr ;
    MBProgressHUD *hudMBProgress;
    NSInteger IsOpen;//用来标记table是否展开
    
}

//@property (nonatomic,retain)  FelixTelnet *telnet;
@property (retain, nonatomic)  NSMutableArray *DeviceItemsarr;
@property (nonatomic,retain) NSMutableArray *arrayGroup;
@property (retain, nonatomic) IBOutlet UIPickerView *MyPicker;


-(void)SetTiming:(NSInteger)deviceTag SetRow:(NSInteger)itemTag;
-(void)OnAndOffSwitchs:(NSInteger)deviceTag setItemTag:(NSInteger)itemTag;
-(void)AllOffSwitchs:(NSInteger)deviceTag;
@end
