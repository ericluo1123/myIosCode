//
//  StudyViewController.h
//  LoongYee
//
//  Created by user on 14-3-31.
//  Copyright (c) 2014年 FelixMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchsViewCell.h"
#import "SBTableAlert.h"
#import "ASIHTTPRequest.h"
#import "QQSectionHeaderView.h"
#import "QQList.h"
#import "MBProgressHUD.h"
#import "AnalysisHTTP.h"
@interface StudyViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,ASIHTTPRequestDelegate,QQSectionHeaderViewDelegate, SBTableAlertDataSource, SBTableAlertDelegate,UIAlertViewDelegate>
{
     NSMutableArray *DeviceListarr;
    NSMutableArray *lists;
    
    NSMutableArray *DeviceItemsarr;
    
    NSInteger section_selected;
    NSInteger row_selected;
   MBProgressHUD *hudMBProgress;
    UIView *Studyimage;
}
@property (retain, nonatomic)  NSMutableArray *DeviceItemsarr;
@property (retain, nonatomic) IBOutlet UITableView *Devicetable;
@property (retain, nonatomic) IBOutlet UIButton *studybtn;
@property (retain, nonatomic) IBOutlet UIButton *refrebtn;
@property (retain, nonatomic) IBOutlet UILabel *findLable;
@property (retain, nonatomic) IBOutlet UIButton *offStudybtn;
@property (retain, nonatomic) IBOutlet UIView *OptionView;

@property (retain, nonatomic) AnalysisHTTP *analysishttp;

- (IBAction)RefreshBtn:(id)sender;
- (IBAction)StudyBtn:(id)sender;
- (IBAction)OffStudyBtn:(id)sender;

- (void)SetImageBtnIcon:(NSInteger)section SetRow:(NSInteger)row;
- (void)SetBtnImageIndex:(NSInteger)index;
- (void)SetItemName:(NSString*)itemName SetSection:(NSInteger)section SetRow:(NSInteger)row;
- (void)SetCellName:(NSString*)CellName  SetSection:(NSInteger)section;


@end
