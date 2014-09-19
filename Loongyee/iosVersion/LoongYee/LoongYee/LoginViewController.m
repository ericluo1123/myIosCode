//
//  LoginViewController.m
//  LoongYee
//
//  Created by FelixMac on 13-12-6.
//  Copyright (c) 2013年 FelixMac. All rights reserved.
//

#import "LoginViewController.h"

#import "MBProgressHUD.h"
#import "HomeViewController.h"
//#import "FelixTelnet.h"
#import "Contant.h"

@interface LoginViewController ()//<FelixTelnetDelegate>
{
    IBOutlet UIView *viewMain;
    IBOutlet UILabel *labelTips;
    IBOutlet UITextField *textFiledPassword;
    IBOutlet UIButton *buttonAdminLogin;
    IBOutlet UIButton *buttonUserLogin;
    IBOutlet UILabel  *labelUnderline;
    
    MBProgressHUD *hudMBProgress;
    
    //FelixTelnet *telnet;
    
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
    //[self.navigationController.navigationBar customNavigationBar];
    
    self.title = @"Loong Yee";
    [buttonAdminLogin setTitle:@"登     入" forState:UIControlStateNormal];
    [textFiledPassword setText:@"admin"];
    
    //telnet = [[FelixTelnet alloc] init];
    //telnet.delegate = self;
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    //[telnet uninit];
    //[telnet release];
    [viewMain release];
    [labelTips release];
    [buttonAdminLogin release];
    [buttonUserLogin release];
    [labelUnderline release];
    [textFiledPassword release];
    [super dealloc];
}
#pragma mark-
#pragma mark FelixTelnet delegate

-(void)telnetReturn:(NSString *)stringRead withTag:(NSInteger)tagIndex
{
    if (hudMBProgress != nil)
    {
        [hudMBProgress removeFromSuperview];
        [hudMBProgress release];
        hudMBProgress = nil;
    }
    HomeViewController *viewCtrl = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    //viewCtrl.telnet = telnet;
    [self.navigationController pushViewController:viewCtrl animated:YES];
    [viewCtrl release];

//    switch (tagIndex) {
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
//        case TAG_LOGIN:
//        {
//            if([stringRead isEqualToString: @"NO"])
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
//                HomeViewController *viewCtrl = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
//                viewCtrl.telnet = telnet;
//                [self.navigationController pushViewController:viewCtrl animated:YES];
//                [viewCtrl release];
//            }
//            break;
//        }
//        default:
//            break;
//    }
    

}

#pragma mark-
#pragma mark my methods
- (IBAction)adminLogin:(id)sender
{
    [textFiledPassword resignFirstResponder];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"LoongYee"
                                                    message: @"目前不支持，请使用一般使用者登入！"
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
    return;
    
   
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
    hudMBProgress.labelText = [Contant getStringWithKey:@"LOADING_WAITING"];
    hudMBProgress.mode = MBProgressHUDModeIndeterminate;
    [hudMBProgress show:YES];
    //[telnet telnetLogin:@"admin" withPassword:@"admin"];
    

    
}
- (IBAction)userLogin:(id)sender
{
    /*
   
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"LoongYee"
                                                        message: @"目前不支持，请使用管理者密码登入！"
                                                       delegate: nil
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
    [alert show];
    [alert release];
    return;
	*/
    
//    hudMBProgress = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:hudMBProgress];
//    hudMBProgress.labelText = @"Waiting...";
//    hudMBProgress.mode = MBProgressHUDModeIndeterminate;
//    [hudMBProgress show:YES];
    //[telnet telnetLogin:@"admin" withPassword:@"admin"];
    
    HomeViewController *viewCtrl = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    //viewCtrl.telnet = telnet;
    [self.navigationController pushViewController:viewCtrl animated:YES];
    [viewCtrl release];
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
