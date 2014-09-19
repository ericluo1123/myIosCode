//
//  MonitoringViewController.m
//  LoongYee
//
//  Created by FelixMac on 13-12-17.
//  Copyright (c) 2013年 FelixMac. All rights reserved.
//

#import "MonitoringViewController.h"
#import "UIBarButtonItemAdditions.h"
#import "MonitoringSettingsViewController.h"
@interface MonitoringViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    
    IBOutlet UITableView *tableViewMonitoring;
    NSMutableArray *list;
    IBOutlet UIView *popEditView;
    
    UIView *popupView;
    UIView *coverView;
    CGAffineTransform initialPopupTransform;
}
- (IBAction)cancelEdit:(id)sender;
- (IBAction)confirmEdit:(id)sender;

@end

@implementation MonitoringViewController

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
    self.navigationItem.title = @"監視器";
    
    UIBarButtonItemAdditions *leftItemBtn = [[UIBarButtonItemAdditions alloc] initWithMyMethodTitle:@"  返回" img:@"item_btn_back_bk" target:self action:@selector(backToHome) font:10];
    UIBarButtonItemAdditions *rightItemBtn = [[UIBarButtonItemAdditions alloc] initWithMyMethodTitle:@"編輯" img:@"item_btn_bk" target:self action:@selector(edit) font:-10];
    self.navigationItem.leftBarButtonItem = leftItemBtn;
    self.navigationItem.rightBarButtonItem = rightItemBtn;
    [leftItemBtn release];
    [rightItemBtn release];
    
    [self addPopupView];
    
    list = [[NSMutableArray alloc] initWithObjects:@"Monitoring1", @"Monitoring2", @"Monitoring3", @"Monitoring4", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [tableViewMonitoring release];
    [popEditView release];
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
    return [list count];
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
		UIView *viewToCheck = nil;
		viewToCheck = [cell viewWithTag:indexPath.row + 1];
		while(viewToCheck)
        {
			[viewToCheck removeFromSuperview];
            viewToCheck = [cell viewWithTag:indexPath.row + 1];
		}
	}
    [cell setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *cellBk= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Monitoring_cell_bk"]];
    cellBk.frame = CGRectMake(0, 0, 320, 71);
    cell.backgroundView = cellBk;
    
    if (tableViewMonitoring.editing)
    {
        UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(10,24,23,23)];
        [btn setImage:[UIImage imageNamed:@"Monitoring_cell_setting"] forState:UIControlStateNormal];
        btn.tag = indexPath.row + 1;
        [btn addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn];
    }
    

    cell.textLabel.text = [list objectAtIndex:indexPath.row];
    
    
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
        
        id object = [list objectAtIndex:sourceIndexPath.row];
        [object retain];
        [list removeObjectAtIndex:sourceIndexPath.row];
        if (destinationIndexPath.row > [list count])
        {
            [list addObject:object];
        }
        else
        {
            [list insertObject:object atIndex:destinationIndexPath.row];
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
    MonitoringSettingsViewController *viewController = [[MonitoringSettingsViewController alloc] initWithNibName:@"MonitoringSettingsViewController" bundle:nil];
    viewController.strngTiTle = [list objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}


#pragma mark-
#pragma mark My methods
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
    popupView.center = CGPointMake(coverView.bounds.size.width/2, coverView.bounds.size.height/2);
    
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

-(void)cellBtnClick:(UIButton *)btn
{
    [self showPopView];
}

-(void)backToHome
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)edit
{
     [self hidePopView];
    [tableViewMonitoring setEditing:!tableViewMonitoring.editing animated:YES];
    [tableViewMonitoring reloadData];
    if (tableViewMonitoring.editing)
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
    }
}

- (IBAction)cancelEdit:(id)sender
{
    [self hidePopView];
}

- (IBAction)confirmEdit:(id)sender
{
    [self hidePopView];
}

@end
