//
//  SettingsViewController.m
//  LoongYee
//
//  Created by FelixMac on 13-12-17.
//  Copyright (c) 2013年 FelixMac. All rights reserved.
//

#import "SettingsViewController.h"
#import "UIBarButtonItemAdditions.h"
#import "LoongYeePassValueDelegate.h"
#import "ChannelViewController.h"
#import "ResetPasswordViewController.h"

@interface SettingsViewController ()<UITableViewDataSource, UITableViewDelegate, LoongYeePassValueDelegate,UIAlertViewDelegate>
{
    
    IBOutlet UITableView *tableViewSettings;
    NSInteger channelIndex;
}


@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         self.navigationItem.title = @"設定";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    UIBarButtonItemAdditions *leftItemBtn = [[UIBarButtonItemAdditions alloc] initWithMyMethodTitle:@"  返回" img:@"item_btn_back_bk" target:self action:@selector(backToHome) font:10];
    self.navigationItem.leftBarButtonItem = leftItemBtn;
    [leftItemBtn release];

    
    channelIndex = 0;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [tableViewSettings release];
    [super dealloc];
}
#pragma mark-
#pragma mark UITableViewDataSource
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewHeader = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)] autorelease];
    viewHeader.backgroundColor = [UIColor clearColor];
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 260, 30)];
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.textColor = [UIColor colorWithRed:86.0f/255.0f green:162.0f/255.0f blue:210.0f/255.0f alpha:1.0f];
    switch (section)
    {
        case 0:
            labelTitle.text = @"連接名稱";
            break;
        case 1:
            labelTitle.text = @"更改密碼";
            break;
        case 2:
            labelTitle.text = @"無線網絡頻道";
             break;
        case 3:
            labelTitle.text = @"其它";
            break;
            
        default:
            break;
    }
    [viewHeader addSubview:labelTitle];
    [labelTitle release];
    return viewHeader;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 1;;
            break;
        case 1:
            return 2;
            break;
        case 2:
             return 1;
            break;
        case 3:
             return 1;
            break;
            
        default:
             return 1;
            break;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
									   reuseIdentifier:identifier] autorelease];
	}
    else
    {
		UIView *viewToCheck = nil;
		viewToCheck = [cell.contentView viewWithTag:100];
		if (viewToCheck)
        {
			[viewToCheck removeFromSuperview];
		}
	}
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
        UIImageView *cellBk= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_bk"]];
        cellBk.frame = CGRectMake(30, 0, 260, 43);
        cell.backgroundView = cellBk;
        
    switch (indexPath.section)
    {
        case 0:
        {

            UITextField *textFieldName = [[[UITextField alloc] initWithFrame:CGRectMake(10, 8, 240, 27)] autorelease];
            textFieldName.backgroundColor = [UIColor clearColor];
            textFieldName.textColor = [UIColor blackColor];
            textFieldName.font = [UIFont systemFontOfSize:20];
            textFieldName.text = @"LoongYee";
            textFieldName.autocorrectionType = UITextAutocorrectionTypeNo;
            textFieldName.keyboardType = UIKeyboardTypeDefault;
            textFieldName.tag = 100;
            [cell.contentView addSubview:textFieldName];

            break;
        }
        case 1:
        {
            if (indexPath.row == 0)
            {
                cell.textLabel.text = @"更改連接密碼";
                cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            }
            else if(indexPath.row == 1)
            {
                cell.textLabel.text = @"更改使用者密碼";
                cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            }

            break;
        }
        case 2:
        {

            cell.textLabel.text = @"Channel";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Channel%d", channelIndex + 1];
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            break;
        }
        case 3:
        {

            cell.textLabel.text = @"版本";
            cell.detailTextLabel.text = @"1.1";
            break;
        }
        default:
            break;
    }
	return cell;
    
}

#pragma mark-
#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section)
    {
        case 0:
        {
            
            break;
        }
        case 1:
        {
        
            ResetPasswordViewController *viewController = [[ResetPasswordViewController alloc] initWithNibName:@"ResetPasswordViewController" bundle:nil];
            viewController.indexType = indexPath.row;
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case 2:
        {
            ChannelViewController *viewController = [[ChannelViewController alloc] initWithNibName:@"ChannelViewController" bundle:nil];
            viewController.indexSelect = channelIndex;
            viewController.delegate = self;
            [self.navigationController pushViewController:viewController animated:YES];
            
            break;
        }
        case 3:
        {
            break;

        }
        default:
            break;
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}


#pragma mark-
#pragma mark LoongYee PassValue Delegate
-(void)passSettingsChannelIndex:(NSInteger)index;
{
    channelIndex = index;
    [tableViewSettings reloadData];
}

#pragma mark-
#pragma mark My Methords

-(void)backToHome
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
