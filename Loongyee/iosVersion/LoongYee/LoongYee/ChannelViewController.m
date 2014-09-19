//
//  ChannelViewController.m
//  LoongYee
//
//  Created by FelixMac on 13-12-25.
//  Copyright (c) 2013年 FelixMac. All rights reserved.
//

#import "ChannelViewController.h"
#import "UIBarButtonItemAdditions.h"

@interface ChannelViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    
    IBOutlet UITableView *tableViewChannel;
}
@end

@implementation ChannelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"Channel选择";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItemAdditions *leftItemBtn = [[UIBarButtonItemAdditions alloc] initWithMyMethodTitle:@"  返回" img:@"item_btn_back_bk" target:self action:@selector(backToSettings) font:10];
    self.navigationItem.leftBarButtonItem = leftItemBtn;
    [leftItemBtn release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [tableViewChannel release];
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

    labelTitle.text = @"选择Channel";

    [viewHeader addSubview:labelTitle];
    [labelTitle release];
    return viewHeader;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
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
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									   reuseIdentifier:identifier] autorelease];
	}
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *cellBk= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_bk"]];
    cellBk.frame = CGRectMake(30, 0, 260, 43);
    cell.backgroundView = cellBk;
    
    if(indexPath.row == self.indexSelect)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Channel%d", indexPath.row + 1];


    return cell;
    
}

#pragma mark-
#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.indexSelect == indexPath.row)
    {
        return;
    }
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:self.indexSelect inSection:0];
    
    UITableViewCell * newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone)
    {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    UITableViewCell * oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
    self.indexSelect  = indexPath.row;
}



#pragma mark-
#pragma mark My methords

-(void)backToSettings
{
    [self.delegate passSettingsChannelIndex:self.indexSelect];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
