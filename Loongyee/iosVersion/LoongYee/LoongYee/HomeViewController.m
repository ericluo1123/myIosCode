//
//  HomeViewController.m
//  LoongYee
//
//  Created by FelixMac on 13-12-6.
//  Copyright (c) 2013年 FelixMac. All rights reserved.
//

#import "HomeViewController.h"
#import "viewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "TandHViewController.h"
#import "PlugsViewController.h"
#import "SwitchsViewController.h"
#import "ApplicancesViewController.h"
#import "MonitoringViewController.h"
#import "SettingViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
//#import "FelixTelnet.h"
#import "AnalysisHTTP.h"
@interface HomeViewController ()<ASIHTTPRequestDelegate>//<FelixTelnetDelegate>
{
    SCHCircleView   *_circle_view;
    NSMutableArray  *_icon_array;
    
    IBOutlet UIButton *buttonTemp;
    IBOutlet UIButton *buttonHumidity;
    
    MBProgressHUD *hudMBProgress;
    
    NSMutableArray *DeviceItemsarr;
    //FelixTelnet *telnet;
    AnalysisHTTP *analysishttp;
}
- (IBAction)clickTorH:(id)sender;
@end

@implementation HomeViewController

@synthesize circle_view = _circle_view;
//@synthesize telnet;


#pragma mark -
#pragma mark - 初始化

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self)
    {
       
        _icon_array = [[NSMutableArray alloc] init];
        [_icon_array addObject:[UIImage imageNamed:@"home_btn_bulb_selected"]];
        [_icon_array addObject:[UIImage imageNamed:@"home_btn_ha_selected"]];
        [_icon_array addObject:[UIImage imageNamed:@"home_btn_settings_selected"]];
        [_icon_array addObject:[UIImage imageNamed:@"home_btn_th_selected"]];
        [_icon_array addObject:[UIImage imageNamed:@"home_btn_camera_selected"]];
        [_icon_array addObject:[UIImage imageNamed:@"home_btn_socket_selected"]];
        
        
    }
    
    return self;
}

#pragma mark -
#pragma mark - view
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"Loong Yee";
    self.navigationItem.hidesBackButton = YES;
    
    buttonTemp.titleLabel.numberOfLines = 2;
    buttonTemp.titleLabel.textAlignment = NSTextAlignmentCenter;
    [buttonTemp setTitle:@"Temperature\n25°C/77°F" forState:UIControlStateNormal];
    
    buttonHumidity.titleLabel.numberOfLines = 2;
    buttonHumidity.titleLabel.textAlignment = NSTextAlignmentCenter;
     [buttonHumidity setTitle:@"Humidity\n78%" forState:UIControlStateNormal];
    
    
    
    _circle_view.circle_view_data_source = self;
    _circle_view.circle_view_delegate    = self;
    _circle_view.show_circle_style       = SChShowCircleWinding;
    [_circle_view reloadData];
    
    analysishttp = [[AnalysisHTTP alloc] init];
    
    if (IPHONE5) {
        [self.Option_Lable setFrame:CGRectMake(0, 400, 320, 44)];
    }
    else
    {
        [self.Option_Lable setFrame:CGRectMake(0, 360, 320, 44)];
    }
    
    self.Option_Lable.text = [Contant getStringWithKey:@"HOME_SWITCH_OPTION"];
}

-(void)viewDidAppear:(BOOL)animated
{
    //telnet.delegate = self;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    analysishttp.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - SCHCircleViewDataSource


- (CGPoint)centerOfCircleView:(SCHCircleView *)circle_view
{
    return CGPointMake(160.0f, 165.0f);
}

- (NSInteger)numberOfCellInCircleView:(SCHCircleView *)circle_view
{
    return _icon_array.count;
}

- (SCHCircleViewCell *)circleView:(SCHCircleView *)circle_view cellAtIndex:(NSInteger)index_circle_cell
{
    viewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"viewCell" owner:nil options:nil] lastObject];
    
    [cell.image_view setImage:[_icon_array objectAtIndex:index_circle_cell]];
    cell.tag = index_circle_cell;
    return cell;
}

#pragma mark -
#pragma mark - SCHCircleViewDelegate
- (void)touchBeginCircleViewCell:(SCHCircleViewCell *)cell indexOfCircleViewCell:(NSInteger)index
{
    NSLog(@"-----%d",index);
    switch (index)
    {
        case 0:
        {
            self.Option_Lable.text = [Contant getStringWithKey:@"HOME_SWITCH_OPTION"];
            break;
        }
        case 1:
        {
            self.Option_Lable.text =@"";
            //[self goApplicancesView];
            break;
        }
            
        case 2:
        {
            self.Option_Lable.text = [Contant getStringWithKey:@"HOME_SETTING_OPTION"];
            break;
        }
            
        case 3:
        {
            self.Option_Lable.text =@"";
            //[self goTAndHView];
            break;
        }
            
        case 4:
        {
            self.Option_Lable.text =@"";
            //[self goMonitoringView];
            break;
        }
        case 5:
        {
            self.Option_Lable.text =@"";
            //[self goPlugsView];
            break;
        }
        default:
        {
            self.Option_Lable.text =[Contant getStringWithKey:@"HOME_SWITCH_OPTION"];
            //[self goSettingsView];
            break;
        }
    }

}

- (void)touchEndCircleViewCell:(SCHCircleViewCell *)cell indexOfCircleViewCell:(NSInteger)index
{
    //[((viewCell*)cell).image_view setImage:[_icon_array objectAtIndex:0]];
    NSLog(@"%d",index);
    switch (index)
    {
        case 0:
        {
            [self goSwitchsView];
            break;
        }
        case 1:
        {
            [self goApplicancesView];
            break;
        }
            
        case 2:
        {
            [self goSettingsView];
            break;
        }
            
        case 3:
        {
            [self goTAndHView];
            break;
        }
            
        case 4:
        {
            [self goMonitoringView];
            break;
        }
        case 5:
        {
            [self goPlugsView];
            break;
        }
        default:
        {
            [self goSettingsView];
            break;
        }
    }
}

- (void)dragEndCircleViewCell:(SCHCircleViewCell *)cell indexOfCircleViewCell:(NSInteger)index
{
    
    NSLog(@"-----%d",index);
    switch (index)
    {
        case 0:
        {
            self.Option_Lable.text = [Contant getStringWithKey:@"HOME_SWITCH_OPTION"];
            break;
        }
        case 1:
        {
            self.Option_Lable.text =@"";
            //[self goApplicancesView];
            break;
        }
            
        case 2:
        {
            self.Option_Lable.text = [Contant getStringWithKey:@"HOME_SETTING_OPTION"];
            break;
        }
            
        case 3:
        {
            self.Option_Lable.text =@"";
            //[self goTAndHView];
            break;
        }
            
        case 4:
        {
            self.Option_Lable.text =@"";
            //[self goMonitoringView];
            break;
        }
        case 5:
        {
            self.Option_Lable.text =@"";
            //[self goPlugsView];
            break;
        }
        default:
        {
            self.Option_Lable.text =[Contant getStringWithKey:@"HOME_SWITCH_OPTION"];
            //[self goSettingsView];
            break;
        }
    }
    
}



#pragma mark -
#pragma mark - dealloc
- (void)dealloc
{
    //[analysishttp release];

    [_icon_array  release], _icon_array  = nil;
    
    [_circle_view release], _circle_view = nil;
    
    [buttonTemp release];
    [buttonHumidity release];
    [_Option_Lable release];
    [super dealloc];
}

-(void)telnetReturn:(NSString *)stringRead withTag:(NSInteger)tagIndex
{
    [hudMBProgress removeFromSuperview];
    [hudMBProgress release];
    
    SwitchsViewController *viewController = [[SwitchsViewController alloc] initWithNibName:@"SwitchsViewController" bundle:nil];
  
    //viewController.telnet = telnet;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
//    switch (tagIndex)
//    {
//        case TAG_CONNECT:
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"LoongYee"
//                                                            message: @"communication error"
//                                                           delegate: nil
//                                                  cancelButtonTitle: @"OK"
//                                                  otherButtonTitles: nil];
//            [alert show];
//            [alert release];
//            return;
//            break;
//        }
//        case TAG_GET_LIGHT_ALL:
//        {
//            if([stringRead isEqualToString: @"fail"])
//            {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"LoongYee"
//                                                                message: @"communication error"
//                                                               delegate: nil
//                                                      cancelButtonTitle: @"OK"
//                                                      otherButtonTitles: nil];
//                [alert show];
//                [alert release];
//                return;
//            }
//            else
//            {
//                NSString *strTemp = stringRead;
//                
//                //NSRange r = [strTemp rangeOfString:@"result_num="];
//                //NSRange r1 = [strTemp rangeOfString:@"\r\n"];
//                
//                //NSInteger resultCount = [[strTemp substringWithRange:NSMakeRange(r.location + r.length, r1.location)] integerValue];
//                //NSArray *arrTemp = [strTemp componentsSeparatedByString:@"\r\n"];
//                
//                NSMutableArray *arrayLightGroup =  [[NSMutableArray alloc] init];
//
//                
//                NSRange rangeFind;
//                
//                for (int i = 1; i <= 8; i++)
//                {
//                    rangeFind = [strTemp rangeOfString:[NSString stringWithFormat:@"remote_code%d=", i]];
//                    
//                    if (rangeFind.length == 0)
//                    {
//                        continue;
//                    }
//                    
//                    NSString *stringRemoteCode = [strTemp substringWithRange:NSMakeRange(rangeFind.location + rangeFind.length, 6)];
//                    
//                    if (stringRemoteCode == nil || [stringRemoteCode isEqualToString:@"FFFFFF"])
//                    {
//                        continue;
//                    }
//                    
//                    NSMutableDictionary *dicTemp = [[NSMutableDictionary alloc] init];
//                    
//                    [dicTemp setObject:[strTemp substringWithRange:NSMakeRange(rangeFind.location + rangeFind.length, 6)] forKey:@"remote_code"];
//                    
//                 
//                    rangeFind = [strTemp rangeOfString:[NSString stringWithFormat:@"light_status%d=", i]];
//                    [dicTemp setObject:[strTemp substringWithRange:NSMakeRange(rangeFind.location + rangeFind.length, 2)] forKey:@"light_status"];
//                    
//                   
//                    
//                    rangeFind = [strTemp rangeOfString:[NSString stringWithFormat:@"key_id%d=", i]];
//                    [dicTemp setObject:[strTemp substringWithRange:NSMakeRange(rangeFind.location + rangeFind.length, 2)] forKey:@"key_id"];
//                    
//                    [dicTemp setObject:[NSString stringWithFormat:@"%d", i] forKey:@"index"];
//                    
//                    [arrayLightGroup addObject:dicTemp];
//                    [dicTemp release];
//                }
// 
//                SwitchsViewController *viewController = [[SwitchsViewController alloc] initWithNibName:@"SwitchsViewController" bundle:nil];
//                viewController.arrayGroup = arrayLightGroup;
//                [arrayLightGroup release];
//                viewController.telnet = telnet;
//                [self.navigationController pushViewController:viewController animated:YES];
//                [viewController release];
//                
//            }
//            break;
//        }
//    
//        default:
//            break;
//    }
    
    
}

- (void)AnalysisHTTPReturn:(NSString *)stringRead withTag:(NSInteger)tagIndex
{
    if (hudMBProgress != nil) {
        [hudMBProgress removeFromSuperview];
        [hudMBProgress release];
    }
    
    
    if (tagIndex == 1) {
        
        
        SwitchsViewController *viewController = [[SwitchsViewController alloc] initWithNibName:@"SwitchsViewController" bundle:nil];
        
        //viewController.telnet = telnet;
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
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
    }
}

#pragma mark -
#pragma mark - My Methords
- (IBAction)clickTorH:(id)sender
{
    [self goTAndHView];
}

-(void)goTAndHView
{
    TandHViewController *viewController = [[TandHViewController alloc] initWithNibName:@"TandHViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

-(void)goPlugsView
{
    ApplicancesViewController *viewController = [[ApplicancesViewController alloc] initWithNibName:@"ApplicancesViewController" bundle:nil];
    viewController.strtitle = [Contant getStringWithKey:@"PLUG_TITLE"];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
//    PlugsViewController *viewController = [[PlugsViewController alloc] initWithNibName:@"PlugsViewController" bundle:nil];
//    [self.navigationController pushViewController:viewController animated:YES];
//    [viewController release];
}

-(void)goSwitchsView
{
    hudMBProgress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hudMBProgress];
    hudMBProgress.labelText = [Contant getStringWithKey:@"LOADING_WAITING"];
    hudMBProgress.mode = MBProgressHUDModeIndeterminate;
    [hudMBProgress show:YES];
    
    
    
    [self performSelector:@selector(GetTableList) withObject:nil afterDelay:0.1];
    //[telnet telnetGetLightList];
     //viewController.telnet = telnet;
    
//    SwitchsViewController *viewController = [[SwitchsViewController alloc] initWithNibName:@"SwitchsViewController" bundle:nil];
//    
//   
//    [self.navigationController pushViewController:viewController animated:YES];
//    [viewController release];

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
    [analysishttp GetTableList:GetTableListURL];
}

-(void)goApplicancesView
{
    ApplicancesViewController *viewController = [[ApplicancesViewController alloc] initWithNibName:@"ApplicancesViewController" bundle:nil];
    viewController.strtitle = [Contant getStringWithKey:@"HOUSEHOLD_TITLE"];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

-(void)goMonitoringView
{
    ApplicancesViewController *viewController = [[ApplicancesViewController alloc] initWithNibName:@"ApplicancesViewController" bundle:nil];
    viewController.strtitle = [Contant getStringWithKey:@"MONITORING_TITLE"];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
//    MonitoringViewController *viewController = [[MonitoringViewController alloc] initWithNibName:@"MonitoringViewController" bundle:nil];
//    [self.navigationController pushViewController:viewController animated:YES];
//    [viewController release];
}

-(void)goSettingsView
{
    SettingViewController *viewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    viewController.analysishttp = analysishttp;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

@end
