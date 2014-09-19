//
//  SettingViewController.m
//  LoongYee
//
//  Created by user on 14-3-31.
//  Copyright (c) 2014年 FelixMac. All rights reserved.
//

#import "SettingViewController.h"
#import "StudyViewController.h"
#import "Contant.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "UIBarButtonItemAdditions.h"
@interface SettingViewController ()
{
    MBProgressHUD *hudMBProgress;
}

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.title = @"设定";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = [Contant getStringWithKey:@"SETTING_TITLE"];
    [self.passwordText setSecureTextEntry:YES];
    self.welcomLable.text = [Contant getStringWithKey:@"SETTING_OPTION1"];
    self.Managerslable.text = [Contant getStringWithKey:@"SETTING_OPTION2"];
    self.optionLable.text =[Contant getStringWithKey:@"SETTING_OPTION3"];
    [self.LoginBtn setTitle:[Contant getStringWithKey:@"SETTING_LONIN"] forState:UIControlStateNormal];
    self.Version_title_label.text = [Contant getStringWithKey:@"SETTING_LABEL_VERSION"];
    self.Version_contant_label.text = Setting_Version;
    UIBarButtonItemAdditions *leftItemBtn = [[UIBarButtonItemAdditions alloc] initWithMyMethodTitle:[NSString stringWithFormat:@"  %@",[Contant getStringWithKey:@"SWITH_BACK"]] img:@"item_btn_back_bk" target:self action:@selector(backToHome) font:10];
    self.navigationItem.leftBarButtonItem = leftItemBtn;
    [leftItemBtn release];
}
-(void)backToHome
{
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.analysishttp.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_welcomLable release];
    [_Managerslable release];
    [_passwordText release];
    [_optionLable release];
    [_LoginBtn release];
    [_Version_title_label release];
    [_Version_contant_label release];
    [super dealloc];
}

- (void)AnalysisHTTPReturn:(NSString *)stringRead withTag:(NSInteger)tagIndex
{
    if (hudMBProgress != nil) {
        [hudMBProgress removeFromSuperview];
        [hudMBProgress release];
    }
    
    
    if (tagIndex == 1) {
        
        
        
        StudyViewController *StudyView = [[StudyViewController alloc] initWithNibName:@"StudyViewController" bundle:nil];
        StudyView.analysishttp = self.analysishttp;
        [self.navigationController pushViewController:StudyView animated:YES];
        [StudyView release];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"LoongYee"
                                                        message: stringRead
                                                       delegate: nil
                                              cancelButtonTitle: [Contant getStringWithKey:@"SWITH_OK"]
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
        
        if ([stringRead isEqualToString:[Contant getStringWithKey:@"ALTER_DEVICE"]]) {
            StudyViewController *StudyView = [[StudyViewController alloc] initWithNibName:@"StudyViewController" bundle:nil];
            StudyView.analysishttp = self.analysishttp;
            [self.navigationController pushViewController:StudyView animated:YES];
            [StudyView release];
        }
    }
}

- (IBAction)TextExit:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)LoinBtn:(id)sender {
    
    
    hudMBProgress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hudMBProgress];
    hudMBProgress.labelText =[Contant getStringWithKey:@"LOADING_WAITING"];
    hudMBProgress.mode = MBProgressHUDModeIndeterminate;
    [hudMBProgress show:YES];
    
   [self performSelector:@selector(GetTableList) withObject:nil afterDelay:0.1];
    
}

-(void)GetTableList
{
    NSString *strData = @"uci_show?data";
    NSString *strDevice = @"device";
    if (TestTAG == 1) {
        strData = @"key";
        strDevice = @"data";
    }
    NSURL* GetTableListURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@=%@",URL_SERVICE,strData,strDevice]];
    [self.analysishttp GetTableList:GetTableListURL];
}


@end
