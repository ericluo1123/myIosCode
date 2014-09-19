//
//  SwitchsSortViewController.m
//  LoongYee
//
//  Created by user on 14-4-10.
//  Copyright (c) 2014年 FelixMac. All rights reserved.
//

#import "SwitchsSortViewController.h"
#import "UIBarButtonItemAdditions.h"
#import "Contant.h"

@interface SwitchsSortViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation SwitchsSortViewController
@synthesize DeviceListTable;

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
    
    UIBarButtonItemAdditions *leftItemBtn = [[UIBarButtonItemAdditions alloc] initWithMyMethodTitle:[NSString stringWithFormat:@"  %@",[Contant getStringWithKey:@"SWITH_BACK"]] img:@"item_btn_back_bk" target:self action:@selector(backToHome) font:10];
    self.navigationItem.leftBarButtonItem = leftItemBtn;
    [leftItemBtn release];
    UIBarButtonItemAdditions *rightItemBtn = [[UIBarButtonItemAdditions alloc] initWithMyMethodTitle:[NSString stringWithFormat:@"  %@",[Contant getStringWithKey:@"SWITH_SAVE"]] img:@"item_btn_bk" target:self action:@selector(SaveAndbackToHome) font:10];
    self.navigationItem.rightBarButtonItem = rightItemBtn;
    [rightItemBtn release];

    [self.DeviceListTable setEditing:YES animated:YES];
    [self GetDataValue];
    [DeviceListTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [DeviceListTable release];
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
    return [self.DeviceItemsarr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    cell.textLabel.text = [[self.DeviceItemsarr objectAtIndex:indexPath.row] objectForKey:@"P_KeyIDName"];
    
    return cell;
}

//哪几行可以移动(可移动的行数小于等于可编辑的行数)
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

//移动cell时的操作
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    NSLog(@"old row = %d,new row = %d",sourceIndexPath.row,destinationIndexPath.row);
    if (sourceIndexPath != destinationIndexPath)
    {
        
                id object = [self.DeviceItemsarr objectAtIndex:sourceIndexPath.row];
                [object retain];
                [self.DeviceItemsarr removeObjectAtIndex:sourceIndexPath.row];
                if (destinationIndexPath.row > [self.DeviceItemsarr count])
                {
                    [self.DeviceItemsarr addObject:object];
                }
                else
                {
                    [self.DeviceItemsarr insertObject:object atIndex:destinationIndexPath.row];
                }
                [object release];
    }
    
}




- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  UITableViewCellEditingStyleNone;
}

#pragma mark Get Data
-(void)GetDataValue
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *datafullFileName;
    NSString *datafilename;
    datafilename = [NSString stringWithFormat:@"LoongYee_control.plist"];
    datafullFileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory,datafilename];
    NSLog(@"fullFileName--144--%@",datafullFileName);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:datafullFileName])
    {
        self.DeviceItemsarr =[NSMutableArray arrayWithContentsOfFile:datafullFileName];
    }
}

-(void)SetDataValue
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *datafullFileName;
    NSString *datafilename;
    datafilename = [NSString stringWithFormat:@"LoongYee_control.plist"];
    datafullFileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory,datafilename];
    NSLog(@"fullFileName--144--%@",datafullFileName);
    [self.DeviceItemsarr writeToFile:datafullFileName atomically:NO];
    
    
}

#pragma mark-
#pragma mark My methods



-(void)backToHome
{
    //[self SetDataValue];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)SaveAndbackToHome
{
    [self SetDataValue];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
