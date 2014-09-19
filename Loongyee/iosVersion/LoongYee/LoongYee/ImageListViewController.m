//
//  ImageListViewController.m
//  LoongYee
//
//  Created by FelixMac on 13-12-23.
//  Copyright (c) 2013年 FelixMac. All rights reserved.
//

#import "ImageListViewController.h"
#import "UIBarButtonItemAdditions.h"
#import "UIGridView.h"
#import "UIGridViewDelegate.h"
#import "CellPhoto.h"
#import "AppDelegate.h"

@interface ImageListViewController ()<UIGridViewDelegate>

@end

@implementation ImageListViewController
@synthesize arrImageList;

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
    
    UIBarButtonItemAdditions *leftItemBtn = [[UIBarButtonItemAdditions alloc] initWithMyMethodTitle:[NSString stringWithFormat:@"  %@",[Contant getStringWithKey:@"SWITH_BACK"]] img:@"item_btn_back_bk" target:self action:@selector(backToTandH) font:10];
    self.navigationItem.leftBarButtonItem = leftItemBtn;

    
    UIGridView *tableView = [[UIGridView alloc] initWithFrame:
                             CGRectMake(20, 10, 320, 440)];
    //tableView.dataSource = self;
    tableView.uiGridViewDelegate=self;
    tableView.backgroundColor=[UIColor clearColor];
    tableView.tag = 0;
    tableView.scrollEnabled=YES;
    tableView.clipsToBounds = NO;
    [self.view addSubview:tableView];
    [tableView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [arrImageList release];
    [super dealloc];
}
#pragma mark-
#pragma mark - UIGridView
- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex
{
    return 100;
}

- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int)rowIndex
{
    return 80;
}

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
	return 3;
}


- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
	return [arrImageList count];
}

- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{

	CellPhoto *cell = (CellPhoto *)[grid dequeueReusableCell];
	if (cell == nil) {
		cell = [[[CellPhoto alloc] init] autorelease];
	}
    int count =  rowIndex * 3 + columnIndex;
    cell.tag = count+1;

    cell.thumImage.image = [UIImage imageNamed:[arrImageList objectAtIndex:count]];
    //cell.selectedImage.image = [UIImage imageNamed:@"icon_selected"];
    if (count == 0)
    {
        [cell setMySelected:YES];
    }
    return cell;
    
}

- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)colIndex
{
    [(CellPhoto*)[self.view viewWithTag:1] setSelected];
    //int count =  rowIndex * 3 + colIndex;
    //[AppDelegate setCoverPhotoNumStatic:[NSNumber numberWithInt:count]];
    [[AppDelegate GetStudyViewController] SetBtnImageIndex:rowIndex * 3 + colIndex+1];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark-
#pragma mark - My methords
-(void)backToTandH
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
