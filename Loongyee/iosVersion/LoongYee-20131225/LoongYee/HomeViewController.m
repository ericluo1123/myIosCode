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
#import "SettingsViewController.h"

@interface HomeViewController ()
{
    SCHCircleView   *_circle_view;
    NSMutableArray  *_icon_array;
    
    IBOutlet UIButton *buttonTemp;
    IBOutlet UIButton *buttonHumidity;
}
- (IBAction)clickTorH:(id)sender;
@end

@implementation HomeViewController

@synthesize circle_view = _circle_view;



#pragma mark -
#pragma mark - 初始化

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self)
    {
        self.navigationItem.title = @"Loong Yee";
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
    
    self.navigationItem.hidesBackButton = YES;
    
    buttonTemp.titleLabel.numberOfLines = 2;
    buttonTemp.titleLabel.textAlignment = NSTextAlignmentCenter;
    [buttonTemp setTitle:@"Temperature\n32°C/89.95°F" forState:UIControlStateNormal];
    
    buttonHumidity.titleLabel.numberOfLines = 2;
    buttonHumidity.titleLabel.textAlignment = NSTextAlignmentCenter;
     [buttonHumidity setTitle:@"Humidity\n78%" forState:UIControlStateNormal];
    
    
    
    _circle_view.circle_view_data_source = self;
    _circle_view.circle_view_delegate    = self;
    _circle_view.show_circle_style       = SChShowCircleWinding;
    [_circle_view reloadData];
    
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
    
    return cell;
}

#pragma mark -
#pragma mark - SCHCircleViewDelegate
- (void)touchEndCircleViewCell:(SCHCircleViewCell *)cell indexOfCircleViewCell:(NSInteger)index
{
    //[((viewCell*)cell).image_view setImage:[_icon_array objectAtIndex:0]];
    NSLog(@"%d",index);
    switch (index)
    {
        case 0:
        {
            [self goPlugsView];
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
            [self goSwitchsView];
            break;
        }
        default:
        {
            [self goSettingsView];
            break;
        }
    }
}
#pragma mark -
#pragma mark - dealloc
- (void)dealloc
{
    [_icon_array  release], _icon_array  = nil;
    
    [_circle_view release], _circle_view = nil;
    
    [buttonTemp release];
    [buttonHumidity release];
    [super dealloc];
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
    PlugsViewController *viewController = [[PlugsViewController alloc] initWithNibName:@"PlugsViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

-(void)goSwitchsView
{
    SwitchsViewController *viewController = [[SwitchsViewController alloc] initWithNibName:@"SwitchsViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

-(void)goApplicancesView
{
    ApplicancesViewController *viewController = [[ApplicancesViewController alloc] initWithNibName:@"ApplicancesViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

-(void)goMonitoringView
{
    MonitoringViewController *viewController = [[MonitoringViewController alloc] initWithNibName:@"MonitoringViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

-(void)goSettingsView
{
    SettingsViewController *viewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}


@end
