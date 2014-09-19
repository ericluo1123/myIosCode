//
//  LoginViewController.m
//  LoongYee
//
//  Created by FelixMac on 13-12-6.
//  Copyright (c) 2013年 FelixMac. All rights reserved.
//

#import "LoginViewController.h"
#import "UINavigationBar+customBar.h"
#import "MBProgressHUD.h"
#import "HomeViewController.h"

@interface LoginViewController ()
{
    IBOutlet UIView *viewMain;
    IBOutlet UILabel *labelTips;
    IBOutlet UITextField *textFiledPassword;
    IBOutlet UIButton *buttonAdminLogin;
    IBOutlet UIButton *buttonUserLogin;
    IBOutlet UILabel  *labelUnderline;
    
    MBProgressHUD *hudMBProgress;
    
}
- (IBAction)adminLogin:(id)sender;
- (IBAction)userLogin:(id)sender;

@end

@implementation LoginViewController

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
    [self.navigationController.navigationBar customNavigationBar];
    self.navigationItem.title = @"Loong Yee";
    [buttonAdminLogin setTitle:@"登     入" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [viewMain release];
    [labelTips release];
    [buttonAdminLogin release];
    [buttonUserLogin release];
    [labelUnderline release];
    [textFiledPassword release];
    [super dealloc];
}

#pragma mark-
#pragma mark my methods
- (IBAction)adminLogin:(id)sender
{
    [textFiledPassword resignFirstResponder];
    CGRect rectTemp = viewMain.frame;
    rectTemp.origin.y = 0;
    [UIView animateWithDuration:0.3f animations:^{
        [viewMain setFrame:rectTemp];
    }];
    
    if([textFiledPassword.text isEqualToString: @""])
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"LoongYee"
                                                        message: @"管理者密碼不能為空！"
                                                       delegate: nil
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
		[alert show];
		[alert release];
		return;
	}
    
     hudMBProgress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hudMBProgress];
    hudMBProgress.labelText = @"請稍後...";
    hudMBProgress.mode = MBProgressHUDModeIndeterminate;
    [hudMBProgress showAnimated:YES whileExecutingBlock:^{

        sleep(1);
    } completionBlock:^{
        [hudMBProgress removeFromSuperview];
        [hudMBProgress release];
        
        HomeViewController *viewCtrl = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
        [self.navigationController pushViewController:viewCtrl animated:NO];
        [viewCtrl release];
        
    }];

    
}
- (IBAction)userLogin:(id)sender
{
    hudMBProgress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hudMBProgress];
    hudMBProgress.labelText = @"請稍後...";
    hudMBProgress.mode = MBProgressHUDModeIndeterminate;
    [hudMBProgress showAnimated:YES whileExecutingBlock:^{
        
        sleep(1);
    } completionBlock:^{
        [hudMBProgress removeFromSuperview];
        [hudMBProgress release];
        
        HomeViewController *viewCtrl = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
        [self.navigationController pushViewController:viewCtrl animated:YES];
        [viewCtrl release];
        
    }];
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [textFiledPassword resignFirstResponder];
    CGRect rectTemp = viewMain.frame;
    rectTemp.origin.y = 0;
    [UIView animateWithDuration:0.3f animations:^{
        [viewMain setFrame:rectTemp];
    }];
}

#pragma mark-
#pragma mark UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textFiledPassword resignFirstResponder];
    CGRect rectTemp = viewMain.frame;
    rectTemp.origin.y = 0;
    [UIView animateWithDuration:0.3f animations:^{
        [viewMain setFrame:rectTemp];
    }];
    
    [self adminLogin:0];
	return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGRect rectTemp = viewMain.frame;
    rectTemp.origin.y = -125;
    [UIView animateWithDuration:0.3f animations:^{
        [viewMain setFrame:rectTemp];
    }];
    return YES;
}

@end
