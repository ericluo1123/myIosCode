//
//  PlugsViewController.m
//  LoongYee
//
//  Created by FelixMac on 13-12-17.
//  Copyright (c) 2013年 FelixMac. All rights reserved.
//

#import "PlugsViewController.h"
#import "UIBarButtonItemAdditions.h"
#import "PlugSettingsViewController.h"
#import "MBProgressHUD.h"

@interface PlugsViewController ()<UITableViewDataSource, UITableViewDelegate>//, FelixTelnetDelegate>
{
    
    IBOutlet UITableView *tableViewPlugs;
    IBOutlet UIView *popEditView;
    IBOutlet UITextField *textFieldName;
    
    NSMutableArray *arrayGroup;
    NSMutableArray *arrayGroupBackup;
    
    UIView *popupView;
    UIView *coverView;
    CGAffineTransform initialPopupTransform;
    
    NSInteger indexSelect;
    
    MBProgressHUD *hudMBProgress;
    //FelixTelnet *telnet;
    
    NSInteger indexEdit;
    
    NSMutableArray *arrDemo;
}

- (IBAction)cancelEdit:(id)sender;
- (IBAction)confirmEdit:(id)sender;
@end

@implementation PlugsViewController
//@synthesize telnet;

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
    self.navigationItem.title = @"Plug";
    
    UIBarButtonItemAdditions *leftItemBtn = [[UIBarButtonItemAdditions alloc] initWithMyMethodTitle:@"  返回" img:@"item_btn_back_bk" target:self action:@selector(backToHome) font:10];
    UIBarButtonItemAdditions *rightItemBtn = [[UIBarButtonItemAdditions alloc] initWithMyMethodTitle:@"編輯" img:@"item_btn_bk" target:self action:@selector(edit) font:-10];
    self.navigationItem.leftBarButtonItem = leftItemBtn;
    self.navigationItem.rightBarButtonItem = rightItemBtn;
    [leftItemBtn release];
    [rightItemBtn release];
    
    arrDemo = [[NSMutableArray alloc] initWithObjects:@"light1",@"light2",@"light3",@"light4", @"light5",@"light6",nil];
    [self addPopupView];
    arrayGroupBackup = nil;
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    //telnet.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [popEditView release];
    [tableViewPlugs release];
    [textFieldName release];
    [super dealloc];
}

#pragma mark-
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrDemo count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"MonitoringCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									   reuseIdentifier:identifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	}
    else
    {
        for(UIView *view in [cell subviews])
        {
            if ([view isKindOfClass:[UIButton class]] && view.tag > 0 && view.tag < 8)
            {
                [view removeFromSuperview];
            }
            
        }
        
	}
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *cellBk= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Monitoring_cell_bk"]];
    cellBk.frame = CGRectMake(0, 0, 320, 71);
    cell.backgroundView = cellBk;
    
    if (tableViewPlugs.editing)
    {
        UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(10,24,23,23)];
        [btn setImage:[UIImage imageNamed:@"Monitoring_cell_setting"] forState:UIControlStateNormal];
        btn.tag = indexPath.row + 1;
        [btn addTarget:self action:@selector(cellBtnEdit:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn];
    }
    
    
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    
    cell.textLabel.text = [arrDemo objectAtIndex:indexPath.row];
    
    
    return cell;
    
}


//哪几行可以移动(可移动的行数小于等于可编辑的行数)
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

//移动cell时的操作
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    
    if (sourceIndexPath != destinationIndexPath)
    {
        
        id object = [arrDemo objectAtIndex:sourceIndexPath.row];
        [object retain];
        [arrDemo removeObjectAtIndex:sourceIndexPath.row];
        if (destinationIndexPath.row > [arrDemo count])
        {
            [arrDemo addObject:object];
        }
        else
        {
            [arrDemo insertObject:object atIndex:destinationIndexPath.row];
        }
        [object release];
    }
}

#pragma mark-
#pragma mark- UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     if ([[[arrayGroup objectAtIndex:indexPath.row] objectForKey:@"remote_code" ] isEqualToString:@"FFFFFF"])
     {
         return;
     }
    
    indexSelect = indexPath.row;
    
    PlugSettingsViewController *viewController = [[PlugSettingsViewController alloc] initWithNibName:@"PlugSettingsViewController" bundle:nil];
    viewController.groupID = [[[arrayGroup objectAtIndex:indexSelect] objectForKey:@"index"] intValue];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    //[telnet telnetGetLightStatus:indexPath.row + 1];

}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

-(void)telnetReturn:(NSString *)stringRead withTag:(NSInteger)tagIndex
{
    [hudMBProgress removeFromSuperview];
    [hudMBProgress release];
    
    PlugSettingsViewController *viewController = [[PlugSettingsViewController alloc] initWithNibName:@"PlugSettingsViewController" bundle:nil];
    viewController.groupID = [[[arrayGroup objectAtIndex:indexSelect] objectForKey:@"index"] intValue];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
//    switch (tagIndex)
//    {
//        case TAG_CONNECT:
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"LoongYee"
//                                                            message: @"无法连接设备"
//                                                           delegate: nil
//                                                  cancelButtonTitle: @"OK"
//                                                  otherButtonTitles: nil];
//            [alert show];
//            [alert release];
//            return;
//            break;
//        }
//        case TAG_GET_GROUP_LIGHT_STATUS:
//        {
//            if([stringRead isEqualToString: @"fail"])
//            {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"LoongYee"
//                                                                message: @"管理者密碼不正确！"
//                                                               delegate: nil
//                                                      cancelButtonTitle: @"OK"
//                                                      otherButtonTitles: nil];
//                [alert show];
//                [alert release];
//                return;
//            }
//            else
//            {
//                NSString *strStatus = [NSString stringWithFormat:@"%@%@", [self unicharTo2:[stringRead characterAtIndex:0]], [self unicharTo2:[stringRead characterAtIndex:1]]];
//                
//                NSMutableArray *arrayStatus =[[NSMutableArray alloc] init];
//                
//                for (int i = [[[arrayGroup objectAtIndex:indexSelect] objectForKey:@"key_id"] intValue] - 1; i >= 0; i--)
//                {
//                    if ([strStatus characterAtIndex:i] == '0')
//                    {
//                        [arrayStatus addObject:@"NO"];
//                    }
//                    else
//                    {
//
//                        [arrayStatus addObject:@"YES"];
//                        
//                    }
//                }
//                
//                PlugSettingsViewController *viewController = [[PlugSettingsViewController alloc] initWithNibName:@"PlugSettingsViewController" bundle:nil];
//                viewController.groupID = [[[arrayGroup objectAtIndex:indexSelect] objectForKey:@"index"] intValue];
//                [self.navigationController pushViewController:viewController animated:YES];
//                [viewController release];
//            }
//            break;
//        }
//            
//        default:
//            break;
//    }
    
    
}


#pragma mark-
#pragma mark My methods

-(NSString *)unicharTo2:(unichar)character
{
    NSString *str = [[[NSString alloc] init] autorelease];
    switch (character)
    {
        case '0':
        {
            str = @"0000";
            break;
        }
        case '1':
        {
            str = @"0001";
            break;
        }
        case '2':
        {
            str = @"0010";
            break;
        }
        case '3':
        {
            str = @"0011";
            break;
        }
        case '4':
        {
            str = @"0100";
            break;
        }
        case '5':
        {
            str = @"0101";
            break;
        }
        case '6':
        {
            str = @"0110";
            break;
        }
        case '7':
        {
            str = @"0111";
            break;
        }
        case '8':
        {
            str = @"1000";
            break;
        }
        case '9':
        {
            str = @"1001";
            break;
        }
        case 'A':
        {
            str = @"1010";
            break;
        }
        case 'B':
        {
            str = @"1011";
            break;
        }
        case 'C':
        {
            str = @"1100";
            break;
        }
        case 'D':
        {
            str = @"1101";
            break;
        }
        case 'E':
        {
            str = @"1110";
            break;
        }
        case 'F':
        {
            str = @"1111";
            break;
        }
            
        default:
            break;
    }
    
    return str;
}

-(void)addPopupView
{
    popupView = [[UIView alloc] initWithFrame:popEditView.frame];
    popupView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    [popupView addSubview:popEditView];
    
    coverView = [[UIView alloc] initWithFrame:self.view.bounds];
    coverView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    coverView.backgroundColor = [UIColor colorWithRed:00/255.0 green:00/255.0 blue:00/255.0 alpha:0.5];
    [self.view addSubview:coverView];
    
    
    [coverView addSubview:popupView];
    popupView.center = CGPointMake(coverView.bounds.size.width/2, coverView.bounds.size.height/2 - 30);
    
    coverView.alpha = 0;
}

-(void)showPopView
{
    
    
    initialPopupTransform = popupView.transform;
    popupView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.3f
                     animations:^{
                         popupView.transform = CGAffineTransformIdentity;
                         coverView.alpha = 1;
                     }];
    
    
}

-(void)hidePopView
{
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         coverView.alpha = 0;
                         popupView.transform = initialPopupTransform;
                     }];
    
}

-(void)cellBtnEdit:(UIButton *)btn
{
    indexEdit = btn.tag - 1;
    textFieldName.text = [[arrayGroup objectAtIndex:indexEdit] objectForKey:@"name"];
    [self showPopView];
}

-(void)cellBtnAccessory:(UIButton *)btn
{
    if ([[[arrayGroup objectAtIndex:btn.tag - 1] objectForKey:@"remote_code" ] isEqualToString:@"FFFFFF"])
    {
        return;
        UIImage *imageBtnbg = [UIImage imageNamed:@"plug_btn_bk_01"];
        [btn setFrame:CGRectMake(0,0,imageBtnbg.size.width,imageBtnbg.size.height)];
        [btn setBackgroundImage: imageBtnbg forState:UIControlStateNormal];
        [btn setTitle:@"" forState:UIControlStateNormal];
        
        //[listBool replaceObjectAtIndex:btn.tag - 1 withObject:@"YES"];
        
    }
    else
    {

        
        NSIndexPath *indexPath =  [NSIndexPath indexPathForItem:btn.tag - 1 inSection:0];
        
        if (indexPath!= nil)
            
        {
            [self tableView: tableViewPlugs accessoryButtonTappedForRowWithIndexPath:indexPath];
        }
        

    }
}

-(void)backToHome
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)edit
{
    [self hidePopView];
    [tableViewPlugs setEditing:!tableViewPlugs.editing animated:YES];
    [tableViewPlugs reloadData];
    
    if (tableViewPlugs.editing)
    {
        UIBarButtonItemAdditions *rightItemBtn = [[UIBarButtonItemAdditions alloc] initWithMyMethodTitle:@"完成" img:@"item_btn_bk" target:self action:@selector(edit) font:-10];
        self.navigationItem.rightBarButtonItem = rightItemBtn;
        
        [rightItemBtn release];
    }
    else
    {
        
        UIBarButtonItemAdditions *rightItemBtn = [[UIBarButtonItemAdditions alloc] initWithMyMethodTitle:@"編輯" img:@"item_btn_bk" target:self action:@selector(edit) font:-10];
        self.navigationItem.rightBarButtonItem = rightItemBtn;
        
        [rightItemBtn release];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *strDocumentPath = [paths objectAtIndex: 0];
        NSString *strFile = [strDocumentPath stringByAppendingString: @"/light.plist"];
        
        [arrayGroup writeToFile: strFile atomically: YES];
        
    }
}

- (IBAction)cancelEdit:(id)sender
{
    
    [self hidePopView];
}

- (IBAction)confirmEdit:(id)sender
{
    [self hidePopView];
    [[arrayGroup objectAtIndex:indexEdit] setObject:textFieldName.text forKey:@"name"];
    [tableViewPlugs reloadData];
}

@end
