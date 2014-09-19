//
//  MonitoringSettingsViewController.m
//  LoongYee
//
//  Created by FelixMac on 13-12-25.
//  Copyright (c) 2013年 FelixMac. All rights reserved.
//

#import "MonitoringSettingsViewController.h"
#import "UIBarButtonItemAdditions.h"

@interface MonitoringSettingsViewController ()

@end

@implementation MonitoringSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.strngTiTle;
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItemAdditions *leftItemBtn = [[UIBarButtonItemAdditions alloc] initWithMyMethodTitle:@"  返回" img:@"item_btn_back_bk" target:self action:@selector(backToMonitoring) font:10];
    self.navigationItem.leftBarButtonItem = leftItemBtn;

    [leftItemBtn release];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {

    [super dealloc];
}

#pragma mark-
#pragma mark My methods

-(void)backToMonitoring
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
