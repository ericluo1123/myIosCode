//
//  ResetPasswordViewController.m
//  LoongYee
//
//  Created by FelixMac on 13-12-25.
//  Copyright (c) 2013年 FelixMac. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "UIBarButtonItemAdditions.h"

@interface ResetPasswordViewController ()

@end

@implementation ResetPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.indexType == RESET_CONNECT_PASSWORD)
    {
        self.navigationItem.title = @"修改連接密碼";
    }
    else if(self.indexType == RESET_USER_PASSWORD)
    {
        self.navigationItem.title = @"修改使用者密碼";
    }
    else
    {
        self.navigationItem.title = @"修改密碼";
    }
    
    UIBarButtonItemAdditions *leftItemBtn = [[UIBarButtonItemAdditions alloc] initWithMyMethodTitle:@"  返回" img:@"item_btn_back_bk" target:self action:@selector(backToSettings) font:10];
    UIBarButtonItemAdditions *rightItemBtn = [[UIBarButtonItemAdditions alloc] initWithMyMethodTitle:@"完成" img:@"item_btn_bk" target:self action:@selector(savePassword) font:-10];
    self.navigationItem.leftBarButtonItem = leftItemBtn;
    self.navigationItem.rightBarButtonItem = rightItemBtn;
    [leftItemBtn release];
    [rightItemBtn release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-
#pragma mark My methords

-(void)backToSettings
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)savePassword
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)TextFiedReturnEditing:(id)sender {
    [sender resignFirstResponder];
}
@end
