//
//  ApplicancesViewController.m
//  LoongYee
//
//  Created by FelixMac on 13-12-17.
//  Copyright (c) 2013年 FelixMac. All rights reserved.
//

#import "ApplicancesViewController.h"
#import "UIBarButtonItemAdditions.h"
#import "Contant.h"
@interface ApplicancesViewController ()

@end

@implementation ApplicancesViewController

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
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = _strtitle;//@"家電";
    
    UIBarButtonItemAdditions *leftItemBtn = [[UIBarButtonItemAdditions alloc] initWithMyMethodTitle: [Contant getStringWithKey:@"SWITH_BACK"] img:@"item_btn_back_bk" target:self action:@selector(backToHome) font:10];
    self.navigationItem.leftBarButtonItem = leftItemBtn;
    [leftItemBtn release];
    
    self.Option_content.text = [Contant getStringWithKey:@"OPTION_CONTENT"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark My Methords

-(void)backToHome
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [_Option_content release];
    [super dealloc];
}
@end
