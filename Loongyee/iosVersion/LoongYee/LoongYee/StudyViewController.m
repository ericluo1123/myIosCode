//
//  StudyViewController.m
//  LoongYee
//
//  Created by user on 14-3-31.
//  Copyright (c) 2014年 FelixMac. All rights reserved.
//

#import "StudyViewController.h"
#import "AppDelegate.h"
#import "ImageListViewController.h"
#import "UIBarButtonItemAdditions.h"
#import "Contant.h"
@interface StudyViewController ()

@end

@implementation StudyViewController
@synthesize DeviceItemsarr;

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
    //[self.refrebtn setTitle:[Contant getStringWithKey:@"STUDY_REFRE_BTN"] forState:UIControlStateNormal];
    [self.refrebtn setBackgroundImage:[UIImage imageNamed:@"refresh01"] forState:UIControlStateNormal];
    [self.refrebtn setBackgroundImage:[UIImage imageNamed:@"refresh02"] forState:UIControlStateHighlighted];
    [self.studybtn setBackgroundImage:[UIImage imageNamed:@"study_1"] forState:UIControlStateNormal];
    [self.studybtn setBackgroundImage:[UIImage imageNamed:@"studying_1"] forState:UIControlStateHighlighted];
    [self.studybtn setTitle:[Contant getStringWithKey:@"STUDY_BTN"] forState:UIControlStateNormal];
    self.studybtn.titleLabel.textColor = [UIColor blackColor];
    self.studybtn.titleLabel.font = [UIFont systemFontOfSize:15];
    DeviceListarr = [[NSMutableArray alloc]init];
    DeviceItemsarr = [[NSMutableArray alloc]init];
    lists = [[NSMutableArray alloc]init];
    
    [AppDelegate SetStudyViewController:self];
    
    UIBarButtonItemAdditions *leftItemBtn = [[UIBarButtonItemAdditions alloc] initWithMyMethodTitle:[NSString stringWithFormat:@"  %@",[Contant getStringWithKey:@"SWITH_BACK"]] img:@"item_btn_back_bk" target:self action:@selector(backToHome) font:10];
    self.navigationItem.leftBarButtonItem = leftItemBtn;
    [leftItemBtn release];
//    hudMBProgress = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:hudMBProgress];
//    hudMBProgress.labelText = @"Waiting...";
//    hudMBProgress.mode = MBProgressHUDModeIndeterminate;
//    [hudMBProgress show:YES];
    //self.analysishttp.delegate = self;
    [self StringAnalyze];
    
    Studyimage = [[UIView alloc]initWithFrame:CGRectMake(185,165,60,40)];
    UILabel *studyingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,60,40)];
    studyingLabel.text = @"...";
    studyingLabel.font = [UIFont systemFontOfSize:26];
    [Studyimage addSubview:studyingLabel];
    Studyimage.alpha = 0.3;
    Studyimage.backgroundColor = [UIColor clearColor];
    [self.OptionView addSubview:Studyimage];
    [self animation];
    self.findLable.text = [Contant getStringWithKey:@"STUDY_FIND"];
    NSInteger hight_Y = 350;
    if (IPHONE5) {
        
        hight_Y = 438;
    }

    [self.offStudybtn setFrame:CGRectMake(35, hight_Y, 258, 54)];
    [self.offStudybtn setTitle:[Contant getStringWithKey:@"STUDY_OFF_FIND"] forState:UIControlStateNormal];
    self.offStudybtn.backgroundColor = [UIColor redColor];
    self.offStudybtn.titleLabel.textColor = [UIColor whiteColor];
    //Studyimage.hidden = YES;
    self.OptionView.hidden = YES;
    [self RefreshStudy];
    self.refrebtn.hidden = YES;
    
    self.Devicetable.layer.borderWidth = 1;
    self.Devicetable.layer.borderColor = [[UIColor blackColor]CGColor];
}

-(void)RefreshStudy
{
    NSURL* GetSpiStatusURL = [NSURL URLWithString:@"http://192.168.103.1/cgi-bin/spi_status"];
    ASIHTTPRequest* SpiStatusRequest = [[ASIHTTPRequest alloc]initWithURL:GetSpiStatusURL];
    [SpiStatusRequest setShouldAttemptPersistentConnection:NO];
    [SpiStatusRequest setValidatesSecureCertificate:NO];
    [SpiStatusRequest setTimeOutSeconds:20];
    [SpiStatusRequest startSynchronous];
    
    NSData* SpiStatusdata = [SpiStatusRequest responseData];
    NSString* strSpiStatus = [[NSString alloc] initWithData:SpiStatusdata encoding:NSUTF8StringEncoding];
    NSLog(@"data:%@",strSpiStatus);
    if ((strSpiStatus != nil) && (![strSpiStatus isEqualToString:@""])) {
        NSArray *tmpItemsarr = [strSpiStatus componentsSeparatedByString:@":"];
        if (strSpiStatus.length >=7) {
            if ([[strSpiStatus substringWithRange:NSMakeRange(0,7)]isEqualToString:@"Failure"]) {
                NSString *strmessge = [NSString stringWithFormat:@"%@\n%@",strSpiStatus,[Contant getStringWithKey:@"ALTER_ERROR"]];
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"LoongYee"
                                                              message:strmessge
                                                             delegate:self cancelButtonTitle:nil
                                                    otherButtonTitles:[Contant getStringWithKey:@"SWITH_OK"],nil];
                
                [alert show];
                [alert release];
                
                return;
            }
        }
        
        if([[[[tmpItemsarr objectAtIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@""]stringByReplacingOccurrencesOfString:@"\n" withString:@""] isEqualToString:@"Normal"])
        {
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"LoongYee"
//                                                            message: [Contant getStringWithKey:@"STUDY_CLEAR_DEVICE"]
//                                                           delegate: nil
//                                                  cancelButtonTitle: [Contant getStringWithKey:@"STUDY_YES"]
//                                                  otherButtonTitles: [Contant getStringWithKey:@"STUDY_NO"], nil];
//            alert.delegate = self;
//            alert.tag = 0;//正常状态
//            [alert show];
//            [alert release];
            self.OptionView.hidden = NO;
            NSString *strData = @"spi_learning?enable=1";
            
            if (TestTAG == 1) {
                strData = @"key=learning";
            }
            NSURL* GetTableListURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@" ,URL_SERVICE,strData]];
            ASIHTTPRequest* TableListRequest = [[ASIHTTPRequest alloc]initWithURL:GetTableListURL];
            [TableListRequest setShouldAttemptPersistentConnection:NO];
            [TableListRequest setValidatesSecureCertificate:NO];
            [TableListRequest setTimeOutSeconds:20];
            [TableListRequest startSynchronous];
            
            NSData* data = [TableListRequest responseData];
            NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"data:%@",str);
            
            if ((str != nil) && (![str isEqualToString:@""])) {
                if (str.length >= 7) {
                    if ([[str substringWithRange:NSMakeRange(0,7)]isEqualToString:@"Failure"]) {
                        NSString *strmessge = [NSString stringWithFormat:@"%@\n%@",str,[Contant getStringWithKey:@"ALTER_ERROR"]];
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"LoongYee"
                                                                      message:strmessge
                                                                     delegate:self cancelButtonTitle:nil
                                                            otherButtonTitles:[Contant getStringWithKey:@"SWITH_OK"],nil];
                        
                        [alert show];
                        [alert release];
                        [TableListRequest release];
                        return;
                    }
                }
                
                if ([[str stringByReplacingOccurrencesOfString:@"\n" withString:@""] isEqualToString:@"Success"]) {
                    //self.studybtn.hidden = YES;
                   // Studyimage.hidden = NO;
                    [self.studybtn setTitle:[Contant getStringWithKey:@"STUDING_BTN"] forState:UIControlStateNormal];
                }
            }
            
            [TableListRequest release];
            
        }
        else if([[[[tmpItemsarr objectAtIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@""]stringByReplacingOccurrencesOfString:@"\n" withString:@""] isEqualToString:@"Learning"])
        {
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"LoongYee"
                                                          message:[Contant getStringWithKey:@"STUDING_BTN"]
                                                         delegate:self cancelButtonTitle:[Contant getStringWithKey:@"SWITH_OK"]
                                                otherButtonTitles:nil];
            //alert.delegate = self;
            //alert.tag = 1;//表示正在学习中
            [alert show];
            [alert release];
            
            return;
        }
        
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"LoongYee"
                                                        message: [Contant getStringWithKey:@"ALTER_OPTION"]
                                                       delegate: nil
                                              cancelButtonTitle: [Contant getStringWithKey:@"SWITH_OK"]
                                              otherButtonTitles: nil];
        alert.delegate = self;
        alert.tag = 1;
        [alert show];
        [alert release];
    }
    
    
    

}

-(void)animation
{
    [UIView animateWithDuration:2.0 animations:^{
        Studyimage.alpha = 1;
        
    }completion:^(BOOL finshed){
        if (finshed) {
            Studyimage.alpha = 0.3;
            [self animation];
        }
        
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.analysishttp.delegate = self;
}


-(void)backToHome
{
    
    [self SetDataValue];
   
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)RefreshBtn:(id)sender {
   
    NSURL* GetSpiStatusURL = [NSURL URLWithString:@"http://192.168.103.1/cgi-bin/spi_status"];
    ASIHTTPRequest* SpiStatusRequest = [[ASIHTTPRequest alloc]initWithURL:GetSpiStatusURL];
    [SpiStatusRequest setShouldAttemptPersistentConnection:NO];
    [SpiStatusRequest setValidatesSecureCertificate:NO];
    [SpiStatusRequest setTimeOutSeconds:20];
    [SpiStatusRequest startSynchronous];
    
    NSData* SpiStatusdata = [SpiStatusRequest responseData];
    NSString* strSpiStatus = [[NSString alloc] initWithData:SpiStatusdata encoding:NSUTF8StringEncoding];
    NSLog(@"data:%@",strSpiStatus);
    if (strSpiStatus != nil && ![strSpiStatus isEqualToString:@""]) {
        NSArray *tmpItemsarr = [strSpiStatus componentsSeparatedByString:@":"];
        if (strSpiStatus.length >= 7) {
            if ([[strSpiStatus substringWithRange:NSMakeRange(0,7)]isEqualToString:@"Failure"]) {
                NSString *strmessge = [NSString stringWithFormat:@"%@\n%@",strSpiStatus,[Contant getStringWithKey:@"ALTER_ERROR"]];
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"LoongYee"
                                                              message:strmessge
                                                             delegate:self cancelButtonTitle:nil
                                                    otherButtonTitles:[Contant getStringWithKey:@"SWITH_OK"],nil];
                
                [alert show];
                [alert release];
                [SpiStatusRequest release];
                return;
            }

        }
        if([[[[tmpItemsarr objectAtIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@""]stringByReplacingOccurrencesOfString:@"\n" withString:@""] isEqualToString:@"Normal"])
        {
            
            self.studybtn.hidden = NO;
            Studyimage.hidden = YES;
            [self.studybtn setTitle:[Contant getStringWithKey:@"STUDY_BTN"] forState:UIControlStateNormal];
            NSString *strTableListData = @"uci_show?data";
            NSString *strTableListDevice = @"device";
            if (TestTAG == 1) {
                strTableListData = @"key";
                strTableListDevice = @"data";
            }
            NSURL* GetTableListURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@=%@",URL_SERVICE,strTableListData,strTableListDevice]];
            [self.analysishttp GetTableList:GetTableListURL];
            
        }
        else if([[[[tmpItemsarr objectAtIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@""]stringByReplacingOccurrencesOfString:@"\n" withString:@""] isEqualToString:@"Learning"])
        {
            NSString *strData = @"spi_learning?enable=0";
            
            if (TestTAG == 1) {
                strData = @"key=learning";
            }
            NSURL* GetOffStudyURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@" ,URL_SERVICE,strData]];
            ASIHTTPRequest* OffStudyRequest = [[ASIHTTPRequest alloc]initWithURL:GetOffStudyURL];
            [OffStudyRequest setShouldAttemptPersistentConnection:NO];
            [OffStudyRequest setValidatesSecureCertificate:NO];
            [OffStudyRequest setTimeOutSeconds:20];
            [OffStudyRequest startSynchronous];
            
            NSData* data = [OffStudyRequest responseData];
            NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"data:%@",str);
            if (str != nil && ![str isEqualToString:@""]) {
                if (str.length >= 7) {
                    if ([[str substringWithRange:NSMakeRange(0,7)]isEqualToString:@"Failure"]) {
                        NSString *strmessge = [NSString stringWithFormat:@"%@\n%@",str,[Contant getStringWithKey:@"ALTER_ERROR"]];
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"LoongYee"
                                                                      message:strmessge
                                                                     delegate:self cancelButtonTitle:nil
                                                            otherButtonTitles:[Contant getStringWithKey:@"SWITH_OK"],nil];
                        
                        [alert show];
                        [alert release];
                        [OffStudyRequest release];
                        return;
                    }
                }
                
                if ([[str stringByReplacingOccurrencesOfString:@"\n" withString:@""] isEqualToString:@"Success"]) {
                    self.studybtn.hidden = NO;
                    Studyimage.hidden = YES;
                    [self.studybtn setTitle:[Contant getStringWithKey:@"STUDY_BTN"] forState:UIControlStateNormal];
                    NSString *strTableListData = @"uci_show?data";
                    NSString *strTableListDevice = @"device";
                    if (TestTAG == 1) {
                        strTableListData = @"key";
                        strTableListDevice = @"data";
                    }
                    NSURL* GetTableListURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@=%@",URL_SERVICE,strTableListData,strTableListDevice]];
                    [self.analysishttp GetTableList:GetTableListURL];
                }
            }
           
            [OffStudyRequest release];
        }
        
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"LoongYee"
                                                        message: [Contant getStringWithKey:@"ALTER_OPTION"]
                                                       delegate: nil
                                              cancelButtonTitle: [Contant getStringWithKey:@"SWITH_OK"]
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
    }

    
    
    [SpiStatusRequest release];
  
    
    
}

- (IBAction)StudyBtn:(id)sender {
    NSURL* GetSpiStatusURL = [NSURL URLWithString:@"http://192.168.103.1/cgi-bin/spi_status"];
    ASIHTTPRequest* SpiStatusRequest = [[ASIHTTPRequest alloc]initWithURL:GetSpiStatusURL];
    [SpiStatusRequest setShouldAttemptPersistentConnection:NO];
    [SpiStatusRequest setValidatesSecureCertificate:NO];
    [SpiStatusRequest setTimeOutSeconds:20];
    [SpiStatusRequest startSynchronous];
    
    NSData* SpiStatusdata = [SpiStatusRequest responseData];
    NSString* strSpiStatus = [[NSString alloc] initWithData:SpiStatusdata encoding:NSUTF8StringEncoding];
    NSLog(@"data:%@",strSpiStatus);
    if ((strSpiStatus != nil) && (![strSpiStatus isEqualToString:@""])) {
        NSArray *tmpItemsarr = [strSpiStatus componentsSeparatedByString:@":"];
        if (strSpiStatus.length >= 7) {
            if ([[strSpiStatus substringWithRange:NSMakeRange(0,7)]isEqualToString:@"Failure"]) {
                NSString *strmessge = [NSString stringWithFormat:@"%@\n%@",strSpiStatus,[Contant getStringWithKey:@"ALTER_ERROR"]];
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"LoongYee"
                                                              message:strmessge
                                                             delegate:self cancelButtonTitle:nil
                                                    otherButtonTitles:[Contant getStringWithKey:@"SWITH_OK"],nil];
                
                [alert show];
                [alert release];
                
                return;
            }
        }
        
        if([[[[tmpItemsarr objectAtIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@""]stringByReplacingOccurrencesOfString:@"\n" withString:@""] isEqualToString:@"Normal"])
        {
            NSString *strData = @"spi_learning?enable=1";
            
            if (TestTAG == 1) {
                strData = @"key=learning";
            }
            self.OptionView.hidden = NO;
            NSURL* GetTableListURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@" ,URL_SERVICE,strData]];
            ASIHTTPRequest* TableListRequest = [[ASIHTTPRequest alloc]initWithURL:GetTableListURL];
            [TableListRequest setShouldAttemptPersistentConnection:NO];
            [TableListRequest setValidatesSecureCertificate:NO];
            [TableListRequest setTimeOutSeconds:20];
            [TableListRequest startSynchronous];
            
            NSData* data = [TableListRequest responseData];
            NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"data:%@",str);
            
            if ((str != nil) && (![str isEqualToString:@""])) {
                if (str.length >= 7) {
                    if ([[str substringWithRange:NSMakeRange(0,7)]isEqualToString:@"Failure"]) {
                        self.OptionView.hidden = YES;
                        NSString *strmessge = [NSString stringWithFormat:@"%@\n%@",str,[Contant getStringWithKey:@"ALTER_ERROR"]];
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"LoongYee"
                                                                      message:strmessge
                                                                     delegate:self cancelButtonTitle:nil
                                                            otherButtonTitles:[Contant getStringWithKey:@"SWITH_OK"],nil];
                        
                        [alert show];
                        [alert release];
                        [TableListRequest release];
                        
                        return;
                    }
                }
                
                if ([[str stringByReplacingOccurrencesOfString:@"\n" withString:@""] isEqualToString:@"Success"]) {
                    //self.studybtn.hidden = YES;
                    Studyimage.hidden = NO;
                    [self.studybtn setTitle:[Contant getStringWithKey:@"STUDING_BTN"] forState:UIControlStateNormal];
                }
            }
            
            [TableListRequest release];

        }
        else if([[[[tmpItemsarr objectAtIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@""]stringByReplacingOccurrencesOfString:@"\n" withString:@""] isEqualToString:@"Learning"])
        {
            self.OptionView.hidden = YES;
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"LoongYee"
                                                          message:[Contant getStringWithKey:@"STUDING_BTN"]
                                                         delegate:self cancelButtonTitle:nil
                                                otherButtonTitles:[Contant getStringWithKey:@"SWITH_OK"],nil];
            
            [alert show];
            [alert release];
            
            return;
        }
        
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"LoongYee"
                                                        message: [Contant getStringWithKey:@"ALTER_OPTION"]
                                                       delegate: nil
                                              cancelButtonTitle: [Contant getStringWithKey:@"SWITH_OK"]
                                              otherButtonTitles: nil];
        [alert show];
        [alert release];
    }

    
    
    
}

- (IBAction)OffStudyBtn:(id)sender {
    NSString *strData = @"spi_learning?enable=0";
    
    if (TestTAG == 1) {
        strData = @"key=learning";
    }
    NSURL* GetOffStudyURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@" ,URL_SERVICE,strData]];
    ASIHTTPRequest* OffStudyRequest = [[ASIHTTPRequest alloc]initWithURL:GetOffStudyURL];
    [OffStudyRequest setShouldAttemptPersistentConnection:NO];
    [OffStudyRequest setValidatesSecureCertificate:NO];
    [OffStudyRequest setTimeOutSeconds:20];
    [OffStudyRequest startSynchronous];
    
    NSData* data = [OffStudyRequest responseData];
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data:%@",str);
    if (str != nil && ![str isEqualToString:@""]) {
        if (str.length >= 7) {
            if ([[str substringWithRange:NSMakeRange(0,7)]isEqualToString:@"Failure"]) {
                NSString *strmessge = [NSString stringWithFormat:@"%@\n%@",str,[Contant getStringWithKey:@"ALTER_ERROR"]];
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"LoongYee"
                                                              message:strmessge
                                                             delegate:self cancelButtonTitle:nil
                                                    otherButtonTitles:[Contant getStringWithKey:@"SWITH_OK"],nil];
                
                [alert show];
                [alert release];
                [OffStudyRequest release];
                return;
            }
        }
        
        if ([[str stringByReplacingOccurrencesOfString:@"\n" withString:@""] isEqualToString:@"Success"]) {
            self.studybtn.hidden = NO;
            //Studyimage.hidden = YES;
            [self.studybtn setTitle:[Contant getStringWithKey:@"STUDY_BTN"] forState:UIControlStateNormal];
            NSString *strTableListData = @"uci_show?data";
            NSString *strTableListDevice = @"device";
            if (TestTAG == 1) {
                strTableListData = @"key";
                strTableListDevice = @"data";
            }
            NSURL* GetTableListURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@=%@",URL_SERVICE,strTableListData,strTableListDevice]];
            [self.analysishttp GetTableList:GetTableListURL];
        }
    }
    self.OptionView.hidden = YES;
    [OffStudyRequest release];
}

- (void)dealloc {
    [_Devicetable release];
    [DeviceListarr release];
    [DeviceItemsarr release];
    [_studybtn release];
    [_refrebtn release];
    [_findLable release];
    [_offStudybtn release];
    [_OptionView release];
    [super dealloc];
}


- (void)AnalysisHTTPReturn:(NSString *)stringRead withTag:(NSInteger)tagIndex
{
    if (hudMBProgress != nil) {
        [hudMBProgress removeFromSuperview];
        [hudMBProgress release];
    }
    
    [self GetDataValue];
    [self  RefreshTable];
    
    if (tagIndex == 1) {
        
        
    }
    else
    {
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"LoongYee"
//                                                        message: stringRead
//                                                       delegate: nil
//                                              cancelButtonTitle: [Contant getStringWithKey:@"SWITH_OK"]
//                                              otherButtonTitles: nil];
//        [alert show];
//        [alert release];
    }
}

-(void)StringAnalyze
{
    [self GetDataValue];
    [self RefreshTable];
    
//    NSString *str = @"device.0.KeyName=\n\
//    device.0.LoopCode=010000\n\
//    device.1.KeyName=\n\
//    device.1.LoopCode=86AE5C\n\
//    device.2.KeyName=\n\
//    device.2.LoopCode=010101\n\
//    device.2.KeyID=01\n\
//    device.2.RSSI=-54\n\
//    device.2.Status=01\n\
//    device.0.KeyID=08\n\
//    device.0.RSSI=56\n\
//    device.0.Status=00\n\
//    device.1.KeyID=02\n\
//    device.1.RSSI=-65\n\
//    device.1.Status=00";
    
//    NSString *strData = @"uci_show?data";
//    NSString *strDevice = @"device";
//    if (TestTAG == 1) {
//        strData = @"key";
//        strDevice = @"data";
//    }
//    NSURL* GetTableListURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@=%@",URL_SERVICE,strData,strDevice]];
//    ASIHTTPRequest* TableListRequest = [[ASIHTTPRequest alloc]initWithURL:GetTableListURL];
//    [TableListRequest setShouldAttemptPersistentConnection:NO];
//    [TableListRequest setValidatesSecureCertificate:NO];
//    [TableListRequest setTimeOutSeconds:20];
//    [TableListRequest startSynchronous];
//    
//    
//    NSData* data = [TableListRequest responseData];
//    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"data:%@",str);
//    if (DeviceListarr == nil) {
//        DeviceListarr = [[NSMutableArray alloc]init];
//    }
//    else{
//        [DeviceListarr release];
//        DeviceListarr = [[NSMutableArray alloc]init];
//    }
//    
//    NSArray *arr = [str componentsSeparatedByString:@"\n"];
//    
//    for (int j = 0;j <( [arr count] -1)/6;j++) {
//        NSMutableDictionary *Devicedic = [[NSMutableDictionary alloc]init];
//        
//        for (int i = 0; i < ([arr count]-1); i++) {
//            NSString *tmpstr = [arr objectAtIndex:i];
//            NSArray *tmpItemsarr = [tmpstr componentsSeparatedByString:@"."];
//            if ([[tmpItemsarr objectAtIndex:1] intValue] == j) {
//                [Devicedic setObject:[NSString stringWithFormat:@"%d",j] forKey:@"DeviceIndex"];
//                NSArray *itemsValuearr = [[tmpItemsarr objectAtIndex:2]  componentsSeparatedByString:@"="];
//                [Devicedic setObject:[itemsValuearr objectAtIndex:1] forKey:[itemsValuearr objectAtIndex:0]];
//            }
//        }
//        [DeviceListarr addObject:Devicedic];
//        [Devicedic release];
//    }
//    [self GetDataValue];
//    [self loadQQData];
//    if (hudMBProgress != nil)
//    {
//        [hudMBProgress removeFromSuperview];
//        [hudMBProgress release];
//        hudMBProgress = nil;
//    }
}

//第一次用时默认的排序方式是按key的大小排序
-(void)SortSwitchs
{
    
    
    for (int i = 0; i < [DeviceListarr count]; i++) {
        // NSMutableDictionary *Devicedic = [[NSMutableDictionary alloc]init];
        // Devicedic = [DeviceListarr objectAtIndex:i];
        NSInteger keyNum = [[[DeviceListarr objectAtIndex:i] objectForKey:@"KeyID"]integerValue];
        for (int j =i+1 ; j <  [DeviceListarr count]; j++) {
            if (keyNum < [[[DeviceListarr objectAtIndex:j] objectForKey:@"KeyID"]integerValue]) {
                keyNum = [[[DeviceListarr objectAtIndex:j] objectForKey:@"KeyID"]integerValue];
                id object = [DeviceListarr objectAtIndex:j];
                [object retain];
                [DeviceListarr removeObjectAtIndex:j];
                [DeviceListarr insertObject:object atIndex:i];
                [object release];
            }
        }
        
        // [Devicedic release];
    }
}

#pragma mark-
#pragma mark- UITableViewDelegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//    SwitchSettingsViewController *viewController = [[SwitchSettingsViewController alloc] initWithNibName:@"SwitchSettingsViewController" bundle:nil];
//    //viewController.telnet = self.telnet;
//    viewController.remoteCode = [[self.arrayGroup objectAtIndex:indexPath.row] objectForKey:@"remote_code"];
//    viewController.groupID = [[[self.arrayGroup objectAtIndex:indexPath.row] objectForKey:@"index"] integerValue];
//    viewController.keyID = [[[self.arrayGroup objectAtIndex:indexPath.row] objectForKey:@"key_id"] integerValue];
//    [self.navigationController pushViewController:viewController animated:YES];
//    [viewController release];
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
        return 70;
    
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 71;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [DeviceItemsarr count]; // 分组数
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	QQList *persons = [lists objectAtIndex:section];
	if ([persons opened]) {
		return ([persons.m_arrayPersons count]); // 人员数
        
	}else {
		return 0;	// 不展开
	}
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
	QQList *persons = [lists objectAtIndex:section];
    
	NSString *headString = [NSString stringWithFormat:@"%@",persons.m_strName];
    
	
	QQSectionHeaderView *sectionHeadView = [[QQSectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.Devicetable.bounds.size.width, 70) title:headString section:section opened:persons.opened delegate:self] ;
    sectionHeadView.titleLabel.tag = section;
    sectionHeadView.iPageTag =0;
	return [sectionHeadView autorelease];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SwitchsViewCell";
    SwitchsViewCell *cell = (SwitchsViewCell *)[self.Devicetable dequeueReusableCellWithIdentifier: CellIdentifier];
        // cell.selectedBackgroundView.backgroundColor = [UIColor blueColor];
    if(cell == nil)
    {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed: @"SwitchsViewCell" owner: self options: nil];
        cell = [nib objectAtIndex: 0];
    }
    cell.backgroundColor = [UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.OnandOffBtn.hidden = YES;
    cell.PowerLabel.hidden = YES;
    cell.iPageTag = 0;
    
    cell.IconBtn.tag = indexPath.section;
    cell.NameBtn.tag = indexPath.row;
    NSLog(@"section = %ld row = %ld",(long)indexPath.section,(long)indexPath.row);

    NSLog(@"顯示device: %@",[[[[DeviceItemsarr objectAtIndex:indexPath.section]objectForKey:@"P_device_items"]objectAtIndex:indexPath.row ]objectForKey:@"P_KeyName"]);
    [cell.NameBtn setTitle:[[[[DeviceItemsarr objectAtIndex:indexPath.section]objectForKey:@"P_device_items"]objectAtIndex:indexPath.row ]objectForKey:@"P_KeyName"] forState:UIControlStateNormal];
    
       if ( [[[[[DeviceItemsarr objectAtIndex:indexPath.section]objectForKey:@"P_device_items"]objectAtIndex:indexPath.row ]objectForKey:@"P_ImageName" ] length] > 15) {
        UIImage *tmpIconImage = [UIImage imageWithContentsOfFile:[[[[DeviceItemsarr objectAtIndex:indexPath.section]objectForKey:@"P_device_items"]objectAtIndex:indexPath.row ]objectForKey:@"P_ImageName" ]];
        if (tmpIconImage != nil) {
            [cell.IconBtn setBackgroundImage:tmpIconImage forState:UIControlStateNormal];
        }
        else
        {
            [cell.IconBtn setBackgroundImage:[UIImage imageNamed:@"default_pic-00"] forState:UIControlStateNormal];
        }
        
    }
    else
    {
        [cell.IconBtn setBackgroundImage:[UIImage imageNamed:[[[[DeviceItemsarr objectAtIndex:indexPath.section]objectForKey:@"P_device_items"]objectAtIndex:indexPath.row ]objectForKey:@"P_ImageName" ]] forState:UIControlStateNormal];
    }
    
        //'QQList *persons = [lists objectAtIndex:indexPath.section];
    return cell;
    
}



-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section
{
	QQList *persons = [lists objectAtIndex:section];
	persons.opened = !persons.opened;
	
	// 收缩+动画 (如果不需要动画直接reloaddata)
	NSInteger countOfRowsToDelete = [self.Devicetable numberOfRowsInSection:section];
    if (countOfRowsToDelete > 0)
    {
        persons.indexPaths = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++)
        {
            [persons.indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        }
        [self.Devicetable deleteRowsAtIndexPaths:persons.indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
}

-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section
{
	QQList *persons = [lists objectAtIndex:section];
	persons.opened = !persons.opened;
	
	// 展开+动画 (如果不需要动画直接reloaddata)
	if(persons.indexPaths)
    {
		[self.Devicetable insertRowsAtIndexPaths:persons.indexPaths withRowAnimation:UITableViewRowAnimationBottom];
	}
    else
    {
        [self.Devicetable reloadData];
    }
    
	persons.indexPaths = nil;
}

-(void) loadQQData
{
    if (DeviceItemsarr == nil || [DeviceItemsarr count] <= 0) {
        [self SortSwitchs];
    }
    if (lists != nil) {
        [lists release];
        lists = [[NSMutableArray alloc]init];
    }
    else{
        lists = [[NSMutableArray alloc]init];
    }
    
    //用来判断本地有没有删除的设备
    for (int i = 0; i < [DeviceItemsarr count]; i++) {
        NSInteger isExistItem = 0;//用来标记这个设备是否存在，如果存在为1，不存在为0；
        for (int j = 0; j < [DeviceListarr count]; j++) {
            if ([[[DeviceListarr objectAtIndex:j] objectForKey:@"LoopCode"]isEqualToString:[[DeviceItemsarr objectAtIndex:i] objectForKey:@"P_LoopCode"] ]){
                isExistItem = 1;
            }
        }
        if (isExistItem == 0) {
            [DeviceItemsarr removeObjectAtIndex:i];
            i--;
        }
    }
    
    //用来添加新的设别
    for (int i = 0; i < [DeviceListarr count]; i++) {
        NSMutableDictionary *device_lists = [[NSMutableDictionary alloc]init];
        
        NSMutableArray *device_List_item = [[[NSMutableArray alloc]init]autorelease];
        NSInteger isExistItem = 0;//用来标记这个设备是否存在，如果存在为1，不存在为0；
        for (int j = 0; j < [DeviceItemsarr count]; j++) {
            if ([[[DeviceListarr objectAtIndex:i] objectForKey:@"LoopCode"]isEqualToString:[[DeviceItemsarr objectAtIndex:j] objectForKey:@"P_LoopCode"] ]){
                [device_lists setObject:[[DeviceListarr objectAtIndex:i] objectForKey:@"Status"] forKey:@"P_Status"];
                isExistItem = 1;
            }
        }
        if (isExistItem == 0) {
            //增加一项
            [device_lists setObject:[[DeviceListarr objectAtIndex:i] objectForKey:@"LoopCode"] forKey:@"P_LoopCode"];
            [device_lists setObject:[[DeviceListarr objectAtIndex:i] objectForKey:@"Status"] forKey:@"P_Status"];
            [device_lists setObject:[[DeviceListarr objectAtIndex:i] objectForKey:@"KeyID"] forKey:@"P_KeyID"];
            [device_lists setObject:[[DeviceListarr objectAtIndex:i] objectForKey:@"DeviceIndex"] forKey:@"P_DeviceIndex"];
            if ([[DeviceListarr objectAtIndex:i]objectForKey:@"GroupName"] == nil ||[[[DeviceListarr objectAtIndex:i]objectForKey:@"GroupName"] isEqualToString:@""] ) {
                [device_lists setObject:[NSString stringWithFormat:@"%@KEY",[[DeviceListarr objectAtIndex:i] objectForKey:@"KeyID"]] forKey:@"P_KeyIDName"];
            }
            else
            {
                [device_lists setObject:[[DeviceListarr objectAtIndex:i] objectForKey:@"GroupName"] forKey:@"P_KeyIDName"];
            }
            
            NSInteger items_num = [[[DeviceListarr objectAtIndex:i] objectForKey:@"KeyID"] intValue];
            if (items_num == 8) {
                items_num = 6;
            }
            
            NSMutableArray *itemsName = [[[NSMutableArray alloc]init]autorelease];
            if ([[[DeviceListarr objectAtIndex:i] objectForKey:@"KeyName"]isEqualToString:@""]||[[DeviceListarr objectAtIndex:i] objectForKey:@"KeyName"] == nil)
            {
                for (int m = 0; m < items_num; m++) {
                    [itemsName addObject:[NSString stringWithFormat:@"%@%d",[Contant getStringWithKey:@"SETTING_SET"],m+1]];
                }
            }
            else
            {
                
                itemsName = [NSMutableArray arrayWithArray: [[[DeviceListarr objectAtIndex:i] objectForKey:@"KeyName"] componentsSeparatedByString:@","]];//;
                
            }
            

            for (int j = 0; j < items_num; j++) {
                NSMutableDictionary *device_items = [[[NSMutableDictionary alloc]init]autorelease];
                [device_items setObject:[itemsName objectAtIndex:j] forKey:@"P_KeyName"];
                [device_items setObject:@"default_pic-00" forKey:@"P_ImageName"];
                [device_items setObject:@"0" forKey:@"P_ItemStatus"];
                [device_List_item addObject:device_items];
            }
            [device_lists setObject:device_List_item forKey:@"P_device_items"];
            [self.DeviceItemsarr addObject:device_lists];
            [device_lists release];
        }
    }
    //用来显示新的设备信息
    
    for (int i = 0; i < [DeviceItemsarr count]; i++)
    {
        QQList *list = [[[QQList alloc] init] autorelease];
		list.m_nID = i; //  分组依据
		list.m_arrayPersons = [[[NSMutableArray alloc] init] autorelease];
		list.opened = NO; // 默认bu展开
        list.m_strName = [[DeviceItemsarr objectAtIndex:i] objectForKey:@"P_KeyIDName"];
       // NSString *strItemStatus = [[DeviceItemsarr objectAtIndex:i] objectForKey:@"P_Status"];
        //[self TenToTwo:[[strItemStatus substringWithRange:NSMakeRange(0, 1)] intValue] LeftAndRightTag:0];
        //[self TenToTwo:[[strItemStatus substringWithRange:NSMakeRange(1, 1)] intValue] LeftAndRightTag:1];
        
        for (int j = 0; j < [[[DeviceItemsarr objectAtIndex:i] objectForKey:@"P_device_items"] count]; j++) {
            QQPerson *person = [[[QQPerson alloc] init] autorelease];
            person.m_strKeyName =[[[[DeviceItemsarr objectAtIndex:i] objectForKey:@"P_device_items"] objectAtIndex:j]objectForKey:@"P_KeyName"];
            person.m_strImageName =[[[[DeviceItemsarr objectAtIndex:i] objectForKey:@"P_device_items"] objectAtIndex:j]objectForKey:@"P_ImageName"];
            person.m_strStatus = @"0";//[DeviceItemStatus objectAtIndex:j];
            [list.m_arrayPersons addObject:person];
        }
        [lists addObject:list];
        
    }
    
    [self SetDataValue];
    [self.Devicetable reloadData];
}

-(void)RefreshTable
{
    //用来显示新的设备信息
    if (lists != nil) {
        [lists release];
        lists = [[NSMutableArray alloc]init];
        
    }
    else{
        lists = [[NSMutableArray alloc]init];
    }
    
    for (int i = 0; i < [DeviceItemsarr count]; i++)
    {

        QQList *list = [[[QQList alloc] init] autorelease];
		list.m_nID = i; //  分组依据
		list.m_arrayPersons = [[[NSMutableArray alloc] init] autorelease];
        
        list.opened = NO; // 默认bu展开
        
		
        list.m_strName = [[DeviceItemsarr objectAtIndex:i] objectForKey:@"P_KeyIDName"];
    
        for (int j = 0; j < [[[DeviceItemsarr objectAtIndex:i] objectForKey:@"P_device_items"] count]; j++) {
            QQPerson *person = [[[QQPerson alloc] init] autorelease];
            person.m_strKeyName =[[[[DeviceItemsarr objectAtIndex:i] objectForKey:@"P_device_items"] objectAtIndex:j]objectForKey:@"P_KeyName"];
            person.m_strImageName =[[[[DeviceItemsarr objectAtIndex:i] objectForKey:@"P_device_items"] objectAtIndex:j]objectForKey:@"P_ImageName"];
            //person.m_strStatus = [DeviceItemStatus objectAtIndex:j];
            [list.m_arrayPersons addObject:person];
        }
        [lists addObject:list];
        
    }
    
    [self.Devicetable reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark set icon And Name
- (void)SetImageBtnIcon:(NSInteger)section SetRow:(NSInteger)row
{
    section_selected = section;
    row_selected = row;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"選擇一張圖片"
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:@"選擇默認圖片"
                                                   otherButtonTitles:@"從相冊選取",nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showInView:self.view];
    
//    ImageListViewController *listView = [[ImageListViewController alloc] initWithNibName:@"ImageListViewController" bundle:nil];
//    listView.arrImageList = [[NSMutableArray alloc] init];
//    for (int i = 0; i < 15; i++)
//    {
//        [listView.arrImageList addObject:[NSString stringWithFormat:@"default_pic-%02d" , i + 1]];
//    }
//    
//    [self.navigationController pushViewController:listView animated:YES];
//    [listView release];
}

- (void)SetBtnImageIndex:(NSInteger)index
{
    NSString* strImageName = [NSString stringWithFormat:@"default_pic-%02ld",(long)index];
    [[[[self.DeviceItemsarr objectAtIndex:section_selected]objectForKey:@"P_device_items"]objectAtIndex:row_selected ]setObject:strImageName forKey:@"P_ImageName"];
    //[self SetDataValue];
    [self.Devicetable reloadData];
}

- (void)SetItemName:(NSString*)itemName SetSection:(NSInteger)section SetRow:(NSInteger)row
{
    //QQList *persons = [lists objectAtIndex:section];
    //persons.m_strName = itemName;
    //[[[self.DeviceItemsarr objectAtIndex:section]objectAtIndex:row]setObject:itemName forKey:@"P_KeyName"];
    NSString *strValue = @"";
    NSString *getkeynameurlStr = [NSString stringWithFormat:@"%@uci_get?data=device.%@.KeyName",URL_SERVICE,[[self.DeviceItemsarr objectAtIndex:section] objectForKey:@"P_DeviceIndex"]];
    getkeynameurlStr = [getkeynameurlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *GetKeynameURL = [NSURL URLWithString:getkeynameurlStr];
    
    ASIHTTPRequest* GetKeynameRequest = [[ASIHTTPRequest alloc]initWithURL:GetKeynameURL];
    [GetKeynameRequest setShouldAttemptPersistentConnection:NO];
    [GetKeynameRequest setValidatesSecureCertificate:NO];
    [GetKeynameRequest setTimeOutSeconds:20];
    [GetKeynameRequest startSynchronous];
    
    
    NSData* GetKeynamedata = [GetKeynameRequest responseData];
    NSString* strGetKeyname = [[NSString alloc] initWithData:GetKeynamedata encoding:NSUTF8StringEncoding];
    NSLog(@"data:%@",strGetKeyname);
    if ((strGetKeyname != nil) && (![strGetKeyname isEqualToString:@""])) {
        if (strGetKeyname.length >= 7) {
            if ([[strGetKeyname substringWithRange:NSMakeRange(0,7)]isEqualToString:@"Failure"]) {
                NSString *strmessge = [NSString stringWithFormat:@"%@\n%@",strGetKeyname,[Contant getStringWithKey:@"ALTER_ERROR"]];
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"LoongYee"
                                                              message:strmessge
                                                             delegate:self cancelButtonTitle:nil
                                                    otherButtonTitles:[Contant getStringWithKey:@"SWITH_OK"],nil];
                
                [alert show];
                [alert release];
                
                return;
            }
        }
       
        {
            strGetKeyname = [strGetKeyname stringByReplacingOccurrencesOfString:@"\n" withString:@""];
             NSArray *tmpItemsarr = [strGetKeyname componentsSeparatedByString:@","];
            if ([tmpItemsarr count] >=1) {
                if (row == 0) {
                    strValue = [strValue stringByAppendingString:[NSString stringWithFormat:@"%@",itemName ]];
                }
                else
                {
                  strValue = [tmpItemsarr objectAtIndex:0];  
                }
                
                for (int i= 1 ; i < [tmpItemsarr count]; i++) {
                    if (i == row) {
                        strValue = [strValue stringByAppendingString:[NSString stringWithFormat:@",%@",itemName ]];
                    }
                    else
                    {
                        strValue = [strValue stringByAppendingString:[NSString stringWithFormat:@",%@",[tmpItemsarr objectAtIndex:i] ]];
                    }
                }
            }
            
        }

    }
    
    //http://192.168.103.1/cgi-bin/uci_set?data=device.0.KeyName&value=ROOM_1
    NSString *strData = @"uci_set?data";
    
    if (TestTAG == 1) {
        strData = @"key";
        
    }
    if (strValue == nil || [strValue isEqualToString:@""]) {
        if (row == 0) {
            strValue = [[[[self.DeviceItemsarr objectAtIndex:section ]objectForKey:@"P_device_items"]objectAtIndex:0]objectForKey:@"P_KeyName"] ;
        }
        for (int i =1 ; i < [[[self.DeviceItemsarr objectAtIndex:section ]objectForKey:@"P_device_items"] count]; i++) {
            if (i == row) {
                strValue = [strValue stringByAppendingString:[NSString stringWithFormat:@",%@",itemName ]];
            }
            else
            {
                strValue = [strValue stringByAppendingString:@","];
            }
            
        }
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@=device.%@.KeyName&value=%@",URL_SERVICE,strData,[[self.DeviceItemsarr objectAtIndex:section] objectForKey:@"P_DeviceIndex"],strValue];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *GetTableListURL = [NSURL URLWithString:urlStr];
   
    ASIHTTPRequest* TableListRequest = [[ASIHTTPRequest alloc]initWithURL:GetTableListURL];
    [TableListRequest setShouldAttemptPersistentConnection:NO];
    [TableListRequest setValidatesSecureCertificate:NO];
    [TableListRequest setTimeOutSeconds:20];
    [TableListRequest startSynchronous];
    
    
    NSData* data = [TableListRequest responseData];
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data:%@",str);
    if (str.length >= 7) {
        if ([[str substringWithRange:NSMakeRange(0,7)]isEqualToString:@"Failure"]) {
            NSString *strmessge = [NSString stringWithFormat:@"%@\n%@",str,[Contant getStringWithKey:@"ALTER_ERROR"]];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"LoongYee"
                                                          message:strmessge
                                                         delegate:self cancelButtonTitle:nil
                                                otherButtonTitles:[Contant getStringWithKey:@"SWITH_OK"],nil];
            
            [alert show];
            [alert release];
            
            return;
        }
    }
    
     if ([[str stringByReplacingOccurrencesOfString:@"\n" withString:@""] isEqualToString:@"Success"]) {
        [[[[self.DeviceItemsarr objectAtIndex:section]objectForKey:@"P_device_items"]objectAtIndex:row ]setObject:itemName forKey:@"P_KeyName"];
        NSLog(@"Set KeyName Success");
    }
    
    
   // [self SetDataValue];
}

- (void)SetCellName:(NSString*)CellName SetSection:(NSInteger)section
{
    QQList *persons = [lists objectAtIndex:section];
	persons.m_strName = CellName;
    [[self.DeviceItemsarr objectAtIndex:section] setObject:CellName forKey:@"P_KeyIDName"];
    //[self SetDataValue];
    [self.Devicetable reloadData];
    
    //http://192.168.103.1/cgi-bin/uci_set?data=device.0.KeyName&value=ROOM_1
    NSString *strData = @"uci_set?data";
    
    if (TestTAG == 1) {
        strData = @"key";
        
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@=device.%@.GroupName&value=%@",URL_SERVICE,strData,[[self.DeviceItemsarr objectAtIndex:section] objectForKey:@"P_DeviceIndex"],CellName];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *GetTableListURL = [NSURL URLWithString:urlStr];
    ASIHTTPRequest* TableListRequest = [[ASIHTTPRequest alloc]initWithURL:GetTableListURL];
    [TableListRequest setShouldAttemptPersistentConnection:NO];
    [TableListRequest setValidatesSecureCertificate:NO];
    [TableListRequest setTimeOutSeconds:20];
    [TableListRequest startSynchronous];
    
    
    NSData* data = [TableListRequest responseData];
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data:%@",str);
    if (str.length >= 7) {
        if ([[str substringWithRange:NSMakeRange(0,7)]isEqualToString:@"Failure"]) {
            NSString *strmessge = [NSString stringWithFormat:@"%@\n%@",str,[Contant getStringWithKey:@"ALTER_ERROR"]];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"LoongYee"
                                                          message:strmessge
                                                         delegate:self cancelButtonTitle:nil
                                                otherButtonTitles:[Contant getStringWithKey:@"SWITH_OK"],nil];
            
            [alert show];
            [alert release];
            
            return;
        }
    }
    
    if ([[str stringByReplacingOccurrencesOfString:@"\n" withString:@""] isEqualToString:@"Success"]) {
        NSLog(@"Set GroupName Success");
    }
    
}

#pragma mark Get Data
-(void)GetDataValue
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *datafullFileName;
    NSString *datafilename;
    datafilename = [NSString stringWithFormat:@"LoongYee_control.plist"];
    datafullFileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory,datafilename];
    NSLog(@"fullFileName--144--%@",datafullFileName);
   
    if (self.DeviceItemsarr != nil) {
        [self.DeviceItemsarr removeAllObjects];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:datafullFileName])
    {
        self.DeviceItemsarr =[NSMutableArray arrayWithContentsOfFile:datafullFileName];
    }
}

-(void)SetDataValue
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *datafullFileName;
    NSString *datafilename;
    datafilename = [NSString stringWithFormat:@"LoongYee_control.plist"];
    datafullFileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory,datafilename];
    NSLog(@"fullFileName--144--%@",datafullFileName);
    [DeviceItemsarr writeToFile:datafullFileName atomically:NO];
}

#pragma mark ASIHTTP
- (void)SetDataToService
{
    NSURL* GetTableListURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@data=device.0.KeyName&value=R1,R2,R3",URL_SERVICE]];
    ASIHTTPRequest* TableListRequest = [[ASIHTTPRequest alloc]initWithURL:GetTableListURL];
    [TableListRequest setShouldAttemptPersistentConnection:NO];
    [TableListRequest setValidatesSecureCertificate:NO];
    [TableListRequest setTimeOutSeconds:20];
    [TableListRequest startSynchronous];
    
    NSData* data = [TableListRequest responseData];
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data:%@",str);
}

//#pragma mark ASITHHP
//-(void)requestFailed:(ASIHTTPRequest *)request
//{
//    
//}
//
//-(void)requestFinished:(ASIHTTPRequest *)request
//{
//    NSError* error = nil;
//    SMXMLDocument* rootDoc = [SMXMLDocument documentWithData:request.responseData error:&error];
//    if (error)
//    {
//        NSLog(@"parse car info request failed:%@", error);
//        
//    }
//    else
//    {
//        [devicedic setObject:@"8key" forKey:@"KEYID"];
//        
//    }
//    
//}
#pragma mark alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0) {
        if (buttonIndex == 0) {
            NSString *strrefreshData = @"spi_learning?enable=1&refresh=1";
            
            if (TestTAG == 1) {
                strrefreshData = @"key=learning";
            }
            NSURL* GetrefreshURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@" ,URL_SERVICE,strrefreshData]];
            ASIHTTPRequest* refreshRequest = [[ASIHTTPRequest alloc]initWithURL:GetrefreshURL];
            [refreshRequest setShouldAttemptPersistentConnection:NO];
            [refreshRequest setValidatesSecureCertificate:NO];
            [refreshRequest setTimeOutSeconds:20];
            [refreshRequest startSynchronous];
            
            NSData* refreshdata = [refreshRequest responseData];
            NSString* refreshstr = [[NSString alloc] initWithData:refreshdata encoding:NSUTF8StringEncoding];
            NSLog(@"data:%@",refreshstr);
            
            if ((refreshstr != nil) && (![refreshstr isEqualToString:@""])) {
                if (refreshstr) {
                    if ([[refreshstr substringWithRange:NSMakeRange(0,7)]isEqualToString:@"Failure"]) {
                        NSString *strmessge = [NSString stringWithFormat:@"%@\n%@",refreshstr,[Contant getStringWithKey:@"ALTER_ERROR"]];
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"LoongYee"
                                                                      message:strmessge
                                                                     delegate:self cancelButtonTitle:nil
                                                            otherButtonTitles:[Contant getStringWithKey:@"SWITH_OK"],nil];
                        
                        [alert show];
                        [alert release];
                        [refreshRequest release];
                        return;
                    }
                }
                
                if ([[refreshstr stringByReplacingOccurrencesOfString:@"\n" withString:@""] isEqualToString:@"Success"]) {
                    NSString *strData = @"spi_learning?enable=1";
                    
                    if (TestTAG == 1) {
                        strData = @"key=learning";
                    }
                    NSURL* GetTableListURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@" ,URL_SERVICE,strData]];
                    ASIHTTPRequest* TableListRequest = [[ASIHTTPRequest alloc]initWithURL:GetTableListURL];
                    [TableListRequest setShouldAttemptPersistentConnection:NO];
                    [TableListRequest setValidatesSecureCertificate:NO];
                    [TableListRequest setTimeOutSeconds:20];
                    [TableListRequest startSynchronous];
                    
                    NSData* data = [TableListRequest responseData];
                    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"data:%@",str);
                    
                    if ((str != nil) && (![str isEqualToString:@""])) {
                        if (str.length >= 7) {
                            if ([[str substringWithRange:NSMakeRange(0,7)]isEqualToString:@"Failure"]) {
                                NSString *strmessge = [NSString stringWithFormat:@"%@\n%@",str,[Contant getStringWithKey:@"ALTER_ERROR"]];
                                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"LoongYee"
                                                                              message:strmessge
                                                                             delegate:self cancelButtonTitle:nil
                                                                    otherButtonTitles:[Contant getStringWithKey:@"SWITH_OK"],nil];
                                
                                [alert show];
                                [alert release];
                                [TableListRequest release];
                                return;
                            }
                        }
                        
                        if ([[str stringByReplacingOccurrencesOfString:@"\n" withString:@""] isEqualToString:@"Success"]) {
                            //self.studybtn.hidden = YES;
                            //Studyimage.hidden = NO;
                            //[self.studybtn setTitle:[Contant getStringWithKey:@"STUDING_BTN"] forState:UIControlStateNormal];
                            //跳出搜寻中字样
                            self.OptionView.hidden = NO;
                        }
                    }
                }
            }
            
        }
        else{
            NSString *strData = @"spi_learning?enable=1";
            
            if (TestTAG == 1) {
                strData = @"key=learning";
            }
            NSURL* GetTableListURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@" ,URL_SERVICE,strData]];
            ASIHTTPRequest* TableListRequest = [[ASIHTTPRequest alloc]initWithURL:GetTableListURL];
            [TableListRequest setShouldAttemptPersistentConnection:NO];
            [TableListRequest setValidatesSecureCertificate:NO];
            [TableListRequest setTimeOutSeconds:20];
            [TableListRequest startSynchronous];
            
            NSData* data = [TableListRequest responseData];
            NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"data:%@",str);
            
            if ((str != nil) && (![str isEqualToString:@""])) {
                if (str.length >= 7) {
                    if ([[str substringWithRange:NSMakeRange(0,7)]isEqualToString:@"Failure"]) {
                        NSString *strmessge = [NSString stringWithFormat:@"%@\n%@",str,[Contant getStringWithKey:@"ALTER_ERROR"]];
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"LoongYee"
                                                                      message:strmessge
                                                                     delegate:self cancelButtonTitle:nil
                                                            otherButtonTitles:[Contant getStringWithKey:@"SWITH_OK"],nil];
                        
                        [alert show];
                        [alert release];
                        [TableListRequest release];
                        return;
                    }
                }
                
                if ([[str stringByReplacingOccurrencesOfString:@"\n" withString:@""] isEqualToString:@"Success"]) {
                    //self.studybtn.hidden = YES;
                    //Studyimage.hidden = NO;
                    //[self.studybtn setTitle:[Contant getStringWithKey:@"STUDING_BTN"] forState:UIControlStateNormal];
                    //跳出搜寻中字样
                    self.OptionView.hidden = NO;
                }
            }
            
        }
        
        
        
    }
    else if (alertView.tag == 1)
    {
        if (buttonIndex == 0) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


#pragma mark -
#pragma mark UIActionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        ImageListViewController *listView = [[ImageListViewController alloc] initWithNibName:@"ImageListViewController" bundle:nil];
        listView.arrImageList = [[NSMutableArray alloc] init];
        for (int i = 0; i < 15; i++)
        {
           [listView.arrImageList addObject:[NSString stringWithFormat:@"default_pic-%02d" , i + 1]];
        }
        
        [self.navigationController pushViewController:listView animated:YES];
        [listView release];
    }
    else if (buttonIndex == 1)
    {
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        [imgPicker setAllowsEditing:YES];
        [imgPicker setDelegate:self];
        [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
    }
/*
    else if (buttonIndex == 2)
    {
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        [imgPicker setAllowsEditing:YES];
        [imgPicker setDelegate:self];
        [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
    }
*/
    return;
}


#pragma mark-
#pragma mark UIImagePickerController delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *datafullFileName;
    NSString *datafilename;
    datafilename = [NSString stringWithFormat:@"%@_%d.png",[[self.DeviceItemsarr objectAtIndex:section_selected] objectForKey:@"P_LoopCode"],row_selected];
    datafullFileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory,datafilename];
    NSLog(@"`````````%@",datafullFileName);
    NSData *data = UIImagePNGRepresentation(image);
    BOOL ret = [data writeToFile:datafullFileName atomically:YES];//UIImageJPEGRepresentation(image, 1.0f)
    NSLog(@"```%hhd",ret);
    
    [[[[self.DeviceItemsarr objectAtIndex:section_selected]objectForKey:@"P_device_items"]objectAtIndex:row_selected ]setObject:datafullFileName forKey:@"P_ImageName"];
    //[ setImage:image forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.Devicetable reloadData];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    return;
}
//add by Kobe 調整從相冊選照片時, Navigation bar 為不透明
- (void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    navigationController.navigationBar.barStyle = UIBarStyleBlack;
}
//add end
@end
