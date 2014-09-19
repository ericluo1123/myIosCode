//
//  SettingViewController.h
//  LoongYee
//
//  Created by user on 14-3-31.
//  Copyright (c) 2014年 FelixMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnalysisHTTP.h"
@interface SettingViewController : UIViewController

@property (retain, nonatomic) IBOutlet UILabel *welcomLable;
@property (retain, nonatomic) IBOutlet UILabel *Managerslable;
@property (retain, nonatomic) IBOutlet UITextField *passwordText;
@property (retain, nonatomic) IBOutlet UILabel *optionLable;
@property (retain, nonatomic) IBOutlet UIButton *LoginBtn;
@property (retain, nonatomic) AnalysisHTTP *analysishttp;
@property (retain, nonatomic) IBOutlet UILabel *Version_title_label;
@property (retain, nonatomic) IBOutlet UILabel *Version_contant_label;

- (IBAction)TextExit:(id)sender;
- (IBAction)LoinBtn:(id)sender;


@end
