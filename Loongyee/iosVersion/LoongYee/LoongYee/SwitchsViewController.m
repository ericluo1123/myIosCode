//
//  SwitchsViewController.m
//  LoongYee
//
//  Created by FelixMac on 13-12-17.
//  Copyright (c) 2013年 FelixMac. All rights reserved.
//

#import "SwitchsViewController.h"
#import "UIBarButtonItemAdditions.h"
#import "SwitchSettingsViewController.h"
#import "ASIHTTPRequest.h"
#import "SMXMLDocument.h"
#import "QQSectionHeaderView.h"
#import "QQList.h"
#import "SwitchsViewCell.h"
#import "SwitchsTableCell.h"
#import "SBTableAlert.h"
#import "AppDelegate.h"
#import "SwitchsSortViewController.h"

@interface SwitchsViewController ()<UITableViewDataSource, UITableViewDelegate,ASIHTTPRequestDelegate,QQSectionHeaderViewDelegate, SBTableAlertDataSource, SBTableAlertDelegate>//, FelixTelnetDelegate>
{
    NSMutableArray *devicearr;
    NSMutableDictionary *devicedic;
    NSMutableArray *DeviceListarr;
    NSMutableArray *lists;
    IBOutlet UITableView *tableViewSwtich;
}

@end

@implementation SwitchsViewController
@synthesize DeviceItemsarr;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = [Contant getStringWithKey:@"SWITH_TITLE"];
    
    UIBarButtonItemAdditions *leftItemBtn = [[UIBarButtonItemAdditions alloc] initWithMyMethodTitle:[NSString stringWithFormat:@"  %@",[Contant getStringWithKey:@"SWITH_BACK"]] img:@"item_btn_back_bk" target:self action:@selector(backToHome) font:10];
    UIBarButtonItemAdditions *rightItemBtn = [[UIBarButtonItemAdditions alloc] initWithMyMethodTitle:[Contant getStringWithKey:@"SWITH_EDIT"] img:@"item_btn_bk" target:self action:@selector(edit) font:-10];
    self.navigationItem.leftBarButtonItem = leftItemBtn;
    self.navigationItem.rightBarButtonItem = rightItemBtn;
    [leftItemBtn release];
    [rightItemBtn release];
    
    self.navigationItem.backBarButtonItem.title = @"Home";
    devicedic = [[NSMutableDictionary alloc]init];
    
     self.DeviceItemsarr = [[NSMutableArray alloc]init];
    

    //DeviceItemStatus= [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0", @"0",@"0",nil];
    
    //lists = [[NSMutableArray alloc]init];
    //[self StringAnalyze];

    [AppDelegate SetSwitchsViewController:self];
    
}

-(void)InitASIHTTP
{
    NSURL* reachableURL = [NSURL URLWithString:@"http://192.168.1.1/cgi-bin/uci_show?data=device"];
    ASIHTTPRequest* reachableRequest = [[ASIHTTPRequest alloc]initWithURL:reachableURL];
    [reachableRequest setShouldAttemptPersistentConnection:NO];
    [reachableRequest setValidatesSecureCertificate:NO];
    [reachableRequest setNumberOfTimesToRetryOnTimeout:2];  //如果失敗的時候重新發送請求的次數
    reachableRequest.delegate = self;
    [reachableRequest startAsynchronous];
}

-(void)viewDidAppear:(BOOL)animated
{
   // self.telnet.delegate = self;
    
}

-(void)viewWillAppear:(BOOL)animated
{
//    IsOpen = 0;
//    hudMBProgress = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:hudMBProgress];
//    hudMBProgress.labelText = @"Waiting...";
//    hudMBProgress.mode = MBProgressHUDModeIndeterminate;
//    [hudMBProgress show:YES];
    //[self GetDataValue];
    [self StringAnalyze];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if (DeviceItemsarr != nil) {
        [DeviceItemsarr release];
    }
    
    [DeviceItemStatus release];
    [DeviceListarr release];
    [lists release];
    [_MyPicker release];
    [super dealloc];
}

#pragma mark-
#pragma mark UITableViewDataSource

#pragma mark-
#pragma mark- UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row_index = indexPath.row;
//    if ([[[DeviceItemsarr objectAtIndex:indexPath.section]objectForKey:@"P_KeyIDName"] isEqualToString:@"01KEY"]) {
//        row_index = 1;
//    }
    if (row_index == 0) {
        return 44;
    }
    else
    {
        return 70;
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 71;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [DeviceItemsarr count]; // 分组数
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	QQList *persons = [lists objectAtIndex:section];
	if ([persons opened]) {
//        if ([[[DeviceItemsarr objectAtIndex:section]objectForKey:@"P_KeyIDName"] isEqualToString:@"01KEY"]) {
//            return ([persons.m_arrayPersons count]); // 人员数
//        }
//        else if(([[[DeviceItemsarr objectAtIndex:section]objectForKey:@"P_KeyIDName"] isEqualToString:@"03KEY"])||([[[DeviceItemsarr objectAtIndex:section]objectForKey:@"P_KeyIDName"] isEqualToString:@"05KEY"])||([[[DeviceItemsarr objectAtIndex:section]objectForKey:@"P_KeyIDName"] isEqualToString:@"06KEY"])||([[[DeviceItemsarr objectAtIndex:section]objectForKey:@"P_KeyIDName"] isEqualToString:@"07KEY"]))
//        {
//            NSString *strmessge = [NSString stringWithFormat:@"KeyID = %@\n%@",[[DeviceItemsarr objectAtIndex:section]objectForKey:@"P_KeyIDName"],[Contant getStringWithKey:@"ALTER_ERROR"]];
//            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"LoongYee"
//                                                          message:strmessge
//                                                         delegate:self cancelButtonTitle:nil
//                                                otherButtonTitles:[Contant getStringWithKey:@"SWITH_OK"],nil];
//            
//            [alert show];
//            [alert release];
//            [self backToHome];
//        }
        //else
        {
            return ([persons.m_arrayPersons count]+1); // 人员数
        }
		
        
	}else {
		return 0;	// 不展开
	}
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
	QQList *persons = [lists objectAtIndex:section];
    
	NSString *headString = [NSString stringWithFormat:@"%@",persons.m_strName];
  
	
	QQSectionHeaderView *sectionHeadView = [[QQSectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableViewSwtich.bounds.size.width, 70) title:headString section:section opened:persons.opened delegate:self] ;
    sectionHeadView.iPageTag = 1;
    if (tableViewSwtich.editing)
    {
        //UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
        //[btn setFrame:CGRectMake(10,24,23,23)];
        //[sectionHeadView.disclosureButton setImage:[UIImage imageNamed:@"Monitoring_cell_setting"] forState:UIControlStateNormal];
        //sectionHeadView.disclosureButton.tag = indexPath.row + 1;
        //[sectionHeadView.disclosureButton addTarget:self action:@selector(cellBtnEdit:) forControlEvents:UIControlEventTouchUpInside];
       
    }
	return [sectionHeadView autorelease];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row_index = indexPath.row;
//    if ([[[DeviceItemsarr objectAtIndex:indexPath.section]objectForKey:@"P_KeyIDName"] isEqualToString:@"01KEY"]) {
//        row_index = 1;
//    }
    
    if (row_index == 0) {
        
        static NSString *CellIdentifier = @"SwitchsTableCell";
        SwitchsTableCell *cell = (SwitchsTableCell *)[tableViewSwtich dequeueReusableCellWithIdentifier: CellIdentifier];
        // cell.selectedBackgroundView.backgroundColor = [UIColor blueColor];
        if(cell == nil)
        {
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed: @"SwitchsTableCell" owner: self options: nil];
            cell = [nib objectAtIndex: 0];
        }
        
        if (([[[DeviceItemsarr objectAtIndex:indexPath.section]objectForKey:@"P_RSSI"]integerValue] <= -85)) {
            [cell SetSignalImage:@"1"];
        }
        else if (([[[DeviceItemsarr objectAtIndex:indexPath.section]objectForKey:@"P_RSSI"]integerValue] > -85)&& ([[[DeviceItemsarr objectAtIndex:indexPath.section]objectForKey:@"P_RSSI"]integerValue] <= -75)) {
            [cell SetSignalImage:@"2"];
        }
        else if (([[[DeviceItemsarr objectAtIndex:indexPath.section]objectForKey:@"P_RSSI"]integerValue] > -75)&& ([[[DeviceItemsarr objectAtIndex:indexPath.section]objectForKey:@"P_RSSI"]integerValue] <= -65)) {
            [cell SetSignalImage:@"3"];
        }
        else if (([[[DeviceItemsarr objectAtIndex:indexPath.section]objectForKey:@"P_RSSI"]integerValue] > -65)&& ([[[DeviceItemsarr objectAtIndex:indexPath.section]objectForKey:@"P_RSSI"]integerValue] <= -55)) {
            [cell SetSignalImage:@"4"];
        }
        else if (([[[DeviceItemsarr objectAtIndex:indexPath.section]objectForKey:@"P_RSSI"]integerValue] > -55)) {
            [cell SetSignalImage:@"5"];
        }
        
        
        cell.backgroundColor = [UIColor clearColor];
        //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.AlloffBtn.tag = indexPath.section;
        return cell;
        
    }
    else
    {
        static NSString *CellIdentifier = @"SwitchsViewCell";
        SwitchsViewCell *cell = (SwitchsViewCell *)[tableViewSwtich dequeueReusableCellWithIdentifier: CellIdentifier];
        // cell.selectedBackgroundView.backgroundColor = [UIColor blueColor];
        if(cell == nil)
        {
            NSArray* nib = [[NSBundle mainBundle] loadNibNamed: @"SwitchsViewCell" owner: self options: nil];
            cell = [nib objectAtIndex: 0];
        }
        cell.backgroundColor = [UIColor clearColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.iPageTag=1;
        cell.PowerLabel.hidden = YES;
        //QQList *persons = [lists objectAtIndex:indexPath.section ];
        //[cell.NameBtn setTitle:[[persons.m_arrayPersons objectAtIndex:indexPath.row -1] m_strKeyName] forState:UIControlStateNormal];
        
        cell.IconBtn.tag = indexPath.section;
        cell.NameBtn.tag = row_index -1;
         NSLog(@"section = %ld, row = %ld, status = %@",(long)indexPath.section,(long)row_index,[[[[DeviceItemsarr objectAtIndex:indexPath.section]objectForKey:@"P_device_items"]objectAtIndex:row_index-1 ]objectForKey:@"P_ItemStatus" ]);
        [cell.NameBtn setTitle:[[[[DeviceItemsarr objectAtIndex:indexPath.section]objectForKey:@"P_device_items"]objectAtIndex:row_index-1 ]objectForKey:@"P_KeyName"] forState:UIControlStateNormal];
        
        if ( [[[[[DeviceItemsarr objectAtIndex:indexPath.section]objectForKey:@"P_device_items"]objectAtIndex:row_index-1 ]objectForKey:@"P_ImageName" ] length] > 15) {
            UIImage *tmpIconImage = [UIImage imageWithContentsOfFile:[[[[DeviceItemsarr objectAtIndex:indexPath.section]objectForKey:@"P_device_items"]objectAtIndex:row_index-1 ]objectForKey:@"P_ImageName" ]];
            if (tmpIconImage != nil) {
                [cell.IconBtn setBackgroundImage:tmpIconImage forState:UIControlStateNormal];
            }
            else
            {
                [cell.IconBtn setBackgroundImage:[UIImage imageNamed:@"default_pic-00"] forState:UIControlStateNormal];
            }
            
        }
        else
        {
            [cell.IconBtn setBackgroundImage:[UIImage imageNamed:[[[[DeviceItemsarr objectAtIndex:indexPath.section]objectForKey:@"P_device_items"]objectAtIndex:row_index-1 ]objectForKey:@"P_ImageName" ]] forState:UIControlStateNormal];
        }
        
        
        //[cell.IconBtn setBackgroundImage:[UIImage imageNamed:[[[[DeviceItemsarr objectAtIndex:indexPath.section]objectForKey:@"P_device_items"]objectAtIndex:row_index-1 ]objectForKey:@"P_ImageName" ]] forState:UIControlStateNormal];
        
        if ([[[[[DeviceItemsarr objectAtIndex:indexPath.section]objectForKey:@"P_device_items"]objectAtIndex:row_index-1 ]objectForKey:@"P_ItemStatus" ]integerValue] == 0) {
            [cell.OnandOffBtn setBackgroundImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
            [cell.OnandOffBtn setBackgroundImage:[UIImage imageNamed:@"red"] forState:UIControlStateSelected];
            
        }
        else
        {
            [cell.OnandOffBtn setBackgroundImage:[UIImage imageNamed:@"green"] forState:UIControlStateNormal];
            [cell.OnandOffBtn setBackgroundImage:[UIImage imageNamed:@"green"] forState:UIControlStateSelected];
        }
//   
//         //从list中获取数据
//         cell.NameBtn setTitle:[[persons.m_arrayPersons objectAtIndex:indexPath.row -1 ] m_strKeyName] forState:UIControlStateNormal];
//        [cell.IconBtn setBackgroundImage:[UIImage imageNamed:[[persons.m_arrayPersons objectAtIndex:indexPath.row -1] m_strImageName]] forState:UIControlStateNormal];
//        if ([[[persons.m_arrayPersons objectAtIndex:indexPath.row -1] m_strStatus]intValue] == 0) {
//            [cell.OnandOffBtn setBackgroundImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
//            [cell.OnandOffBtn setBackgroundImage:[UIImage imageNamed:@"red"] forState:UIControlStateSelected];
//            
//        }
//        else
//        {
//            [cell.OnandOffBtn setBackgroundImage:[UIImage imageNamed:@"green"] forState:UIControlStateNormal];
//            [cell.OnandOffBtn setBackgroundImage:[UIImage imageNamed:@"green"] forState:UIControlStateSelected];
//        }
//        
        return cell;
    }
  
    
    
}


-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section
{
	QQList *persons = [lists objectAtIndex:section];
	persons.opened = !persons.opened;
	
	// 收缩+动画 (如果不需要动画直接reloaddata)
	NSInteger countOfRowsToDelete = [tableViewSwtich numberOfRowsInSection:section];
    if (countOfRowsToDelete > 0)
    {
        persons.indexPaths = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++)
        {
            [persons.indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        }
        [tableViewSwtich deleteRowsAtIndexPaths:persons.indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
}

-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section
{
	QQList *persons = [lists objectAtIndex:section];
	persons.opened = !persons.opened;
	
	// 展开+动画 (如果不需要动画直接reloaddata)
	if(persons.indexPaths)
    {
		[tableViewSwtich insertRowsAtIndexPaths:persons.indexPaths withRowAnimation:UITableViewRowAnimationBottom];
	}
    else
    {
        [tableViewSwtich reloadData];
    }
    
	persons.indexPaths = nil;
}

-(void) loadQQData
{
    if (DeviceItemsarr == nil || [DeviceItemsarr count] <= 0) {
        [self SortSwitchs];
    }
    if (lists != nil) {
        [lists release];
        lists = [[NSMutableArray alloc]init];
    }
    else{
        lists = [[NSMutableArray alloc]init];
    }
 
    
    //用来判断本地有没有删除的设备
    for (int i = 0; i < [DeviceItemsarr count]; i++) {
        NSInteger isExistItem = 0;//用来标记这个设备是否存在，如果存在为1，不存在为0；
        for (int j = 0; j < [DeviceListarr count]; j++) {
            if ([[[DeviceListarr objectAtIndex:j] objectForKey:@"LoopCode"]isEqualToString:[[DeviceItemsarr objectAtIndex:i] objectForKey:@"P_LoopCode"] ]){
                isExistItem = 1;
            }
        }
        if (isExistItem == 0) {
            [DeviceItemsarr removeObjectAtIndex:i];
            i--;
        }
    }
    
    //用来添加新的设别
    for (int i = 0; i < [DeviceListarr count]; i++) {
        NSMutableDictionary *device_lists = [[NSMutableDictionary alloc]init];
       
        NSMutableArray *device_List_item = [[[NSMutableArray alloc]init]autorelease];
        NSInteger isExistItem = 0;//用来标记这个设备是否存在，如果存在为1，不存在为0；
        for (int j = 0; j < [DeviceItemsarr count]; j++) {
            if ([[[DeviceListarr objectAtIndex:i] objectForKey:@"LoopCode"]isEqualToString:[[DeviceItemsarr objectAtIndex:j] objectForKey:@"P_LoopCode"] ]){
                [device_lists setObject:[[DeviceListarr objectAtIndex:i] objectForKey:@"Status"] forKey:@"P_Status"];
                isExistItem = 1;
            }
        }
        if (isExistItem == 0) {
            //增加一项
            [device_lists setObject:[[DeviceListarr objectAtIndex:i] objectForKey:@"LoopCode"] forKey:@"P_LoopCode"];
            [device_lists setObject:[[DeviceListarr objectAtIndex:i] objectForKey:@"Status"] forKey:@"P_Status"];
            [device_lists setObject:[[DeviceListarr objectAtIndex:i] objectForKey:@"KeyID"] forKey:@"P_KeyID"];
            [device_lists setObject:[[DeviceListarr objectAtIndex:i] objectForKey:@"DeviceIndex"] forKey:@"P_DeviceIndex"];
            if ([[DeviceListarr objectAtIndex:i]objectForKey:@"GroupName"] == nil ||[[[DeviceListarr objectAtIndex:i]objectForKey:@"GroupName"] isEqualToString:@""] ) {
                [device_lists setObject:[NSString stringWithFormat:@"%@KEY",[[DeviceListarr objectAtIndex:i] objectForKey:@"KeyID"]] forKey:@"P_KeyIDName"];
            }
            else
            {
                [device_lists setObject:[[DeviceListarr objectAtIndex:i] objectForKey:@"GroupName"] forKey:@"P_KeyIDName"];
            }
            
            NSInteger items_num = [[[DeviceListarr objectAtIndex:i] objectForKey:@"KeyID"] intValue];
            if (items_num == 8) {
                items_num = 6;
            }
            
            NSMutableArray *itemsName = [[[NSMutableArray alloc]init]autorelease];
            if ([[[DeviceListarr objectAtIndex:i] objectForKey:@"KeyName"]isEqualToString:@""]||[[DeviceListarr objectAtIndex:i] objectForKey:@"KeyName"] == nil)
            {
                for (int m = 0; m < items_num; m++) {
                    [itemsName addObject:[NSString stringWithFormat:@"%@%d",[Contant getStringWithKey:@"SETTING_SET"],m+1]];
                }
            }
            else
            {
                
                itemsName = [NSMutableArray arrayWithArray: [[[DeviceListarr objectAtIndex:i] objectForKey:@"KeyName"] componentsSeparatedByString:@","]];//;
                
            }
            
            
            if (DeviceItemStatus == nil) {
                DeviceItemStatus  = [[NSMutableArray alloc ]initWithObjects:@"0",@"0",@"0",@"0", @"0",@"0", nil];
            }
            else
            {
                [DeviceItemStatus release];
                DeviceItemStatus  = [[NSMutableArray alloc ]initWithObjects:@"0",@"0",@"0",@"0", @"0",@"0", nil];
            }
            NSString *strItemStatus = [[DeviceListarr objectAtIndex:i] objectForKey:@"Status"];
            [self TenToTwo:[[strItemStatus substringWithRange:NSMakeRange(0, 1)] intValue] LeftAndRightTag:0];
            [self TenToTwo:[[strItemStatus substringWithRange:NSMakeRange(1, 1)] intValue] LeftAndRightTag:1];

            for (int j = 0; j < items_num; j++) {
                 NSMutableDictionary *device_items = [[[NSMutableDictionary alloc]init]autorelease];
                [device_items setObject:[itemsName objectAtIndex:j] forKey:@"P_KeyName"];
                [device_items setObject:@"default_pic-00" forKey:@"P_ImageName"];
                [device_items setObject:[DeviceItemStatus objectAtIndex:j] forKey:@"P_ItemStatus"];
                [device_List_item addObject:device_items];
            }
            [device_lists setObject:device_List_item forKey:@"P_device_items"];
            [self.DeviceItemsarr addObject:device_lists];
            [device_lists release];
        }
    }
    //用来显示新的设备信息
    if (lists != nil) {
        [lists release];
        lists = [[NSMutableArray alloc]init];
        
    }
    for (int i = 0; i < [DeviceItemsarr count]; i++)
    {
//        if (DeviceItemStatus == nil) {
//            DeviceItemStatus  = [[NSMutableArray alloc ]initWithObjects:@"0",@"0",@"0",@"0", @"0",@"0", nil];
//        }
//        else
//        {
//            [DeviceItemStatus release];
//            DeviceItemStatus  = [[NSMutableArray alloc ]initWithObjects:@"0",@"0",@"0",@"0", @"0",@"0", nil];
//        }
        
        QQList *list = [[[QQList alloc] init] autorelease];
		list.m_nID = i; //  分组依据
		list.m_arrayPersons = [[[NSMutableArray alloc] init] autorelease];
        
        list.opened = NO; // 默认bu展开
        
		
        list.m_strName = [[DeviceItemsarr objectAtIndex:i] objectForKey:@"P_KeyIDName"];
       // NSString *strItemStatus = [[DeviceItemsarr objectAtIndex:i] objectForKey:@"P_Status"];
        //[self TenToTwo:[[strItemStatus substringWithRange:NSMakeRange(0, 1)] intValue] LeftAndRightTag:0];
        //[self TenToTwo:[[strItemStatus substringWithRange:NSMakeRange(1, 1)] intValue] LeftAndRightTag:1];
        
        for (int j = 0; j < [[[DeviceItemsarr objectAtIndex:i] objectForKey:@"P_device_items"] count]; j++) {
            QQPerson *person = [[[QQPerson alloc] init] autorelease];
            person.m_strKeyName =[[[[DeviceItemsarr objectAtIndex:i] objectForKey:@"P_device_items"] objectAtIndex:j]objectForKey:@"P_KeyName"];
            person.m_strImageName =[[[[DeviceItemsarr objectAtIndex:i] objectForKey:@"P_device_items"] objectAtIndex:j]objectForKey:@"P_ImageName"];
            //person.m_strStatus = [DeviceItemStatus objectAtIndex:j];
            [list.m_arrayPersons addObject:person];
        }
        [lists addObject:list];
        
    }
    
    [self SetDataValue];
    [tableViewSwtich reloadData];
  
}

-(void)RefreshStatus:(NSInteger)deviceTag
{
    
    if (DeviceItemStatus == nil) {
        DeviceItemStatus  = [[NSMutableArray alloc ]initWithObjects:@"0",@"0",@"0",@"0", @"0",@"0", nil];
    }
    else
    {
        [DeviceItemStatus release];
        DeviceItemStatus  = [[NSMutableArray alloc ]initWithObjects:@"0",@"0",@"0",@"0", @"0",@"0", nil];
    }
    NSString *strItemStatus = [[DeviceItemsarr objectAtIndex:deviceTag] objectForKey:@"P_Status"];
    [self TenToTwo:[[strItemStatus substringWithRange:NSMakeRange(0, 1)] intValue] LeftAndRightTag:0];
    [self TenToTwo:[[strItemStatus substringWithRange:NSMakeRange(1, 1)] intValue] LeftAndRightTag:1];
    
    for (int j = 0; j < [[[DeviceItemsarr objectAtIndex:deviceTag] objectForKey:@"P_device_items"] count]; j++) {
        
        [[[[DeviceItemsarr objectAtIndex:deviceTag] objectForKey:@"P_device_items"] objectAtIndex:j] setObject:[DeviceItemStatus objectAtIndex:j] forKey:@"P_ItemStatus"];
        
    }
    
}

-(void)RefreshTable
{
    //用来显示新的设备信息
    if (lists != nil) {
        [lists release];
        lists = [[NSMutableArray alloc]init];
        
    }
    else{
        lists = [[NSMutableArray alloc]init];
    }
    
    for (int i = 0; i < [DeviceItemsarr count]; i++)
    {
        //        if (DeviceItemStatus == nil) {
        //            DeviceItemStatus  = [[NSMutableArray alloc ]initWithObjects:@"0",@"0",@"0",@"0", @"0",@"0", nil];
        //        }
        //        else
        //        {
        //            [DeviceItemStatus release];
        //            DeviceItemStatus  = [[NSMutableArray alloc ]initWithObjects:@"0",@"0",@"0",@"0", @"0",@"0", nil];
        //        }
        
        QQList *list = [[[QQList alloc] init] autorelease];
		list.m_nID = i; //  分组依据
		list.m_arrayPersons = [[[NSMutableArray alloc] init] autorelease];
        
        list.opened = NO; // 默认bu展开
        
		
        list.m_strName = [[DeviceItemsarr objectAtIndex:i] objectForKey:@"P_KeyIDName"];
        // NSString *strItemStatus = [[DeviceItemsarr objectAtIndex:i] objectForKey:@"P_Status"];
        //[self TenToTwo:[[strItemStatus substringWithRange:NSMakeRange(0, 1)] intValue] LeftAndRightTag:0];
        //[self TenToTwo:[[strItemStatus substringWithRange:NSMakeRange(1, 1)] intValue] LeftAndRightTag:1];
        
        for (int j = 0; j < [[[DeviceItemsarr objectAtIndex:i] objectForKey:@"P_device_items"] count]; j++) {
            QQPerson *person = [[[QQPerson alloc] init] autorelease];
            person.m_strKeyName =[[[[DeviceItemsarr objectAtIndex:i] objectForKey:@"P_device_items"] objectAtIndex:j]objectForKey:@"P_KeyName"];
            person.m_strImageName =[[[[DeviceItemsarr objectAtIndex:i] objectForKey:@"P_device_items"] objectAtIndex:j]objectForKey:@"P_ImageName"];
            //person.m_strStatus = [DeviceItemStatus objectAtIndex:j];
            [list.m_arrayPersons addObject:person];
        }
        [lists addObject:list];
        
    }
    
    //[self SetDataValue];
    [tableViewSwtich reloadData];
}

//-(void) loadQQData
//{
//
//    NSInteger isExistItem = 0;//用来标记这个设备是否存在，如果存在为1，不存在为0；
//	// 仔细看数据结构怎么定义的
//	for (int i=0; i<[DeviceListarr count]; i++)
//    {
//        NSMutableDictionary *device_lists = [[NSMutableDictionary alloc]init];
//        NSMutableDictionary *device_items = [[[NSMutableDictionary alloc]init]autorelease];
//        NSMutableArray *device_List_item = [[[NSMutableArray alloc]init]autorelease];
//        NSDictionary *dic = [DeviceListarr objectAtIndex:i];
//		QQList *list = [[[QQList alloc] init] autorelease];
//		list.m_nID = i; //  分组依据
//		//list.m_strName = [NSString stringWithFormat:@"Date:%@", strDate];
//		list.m_arrayPersons = [[[NSMutableArray alloc] init] autorelease];
//		list.opened = NO; // 默认bu展开
//        
//        NSString *strItemStatus = [dic objectForKey:@"Status"];
//        [self TenToTwo:[[strItemStatus substringWithRange:NSMakeRange(0, 1)] intValue] LeftAndRightTag:0];
//        [self TenToTwo:[[strItemStatus substringWithRange:NSMakeRange(1, 1)] intValue] LeftAndRightTag:1];
//        
//        list.m_strName = [NSString stringWithFormat:@"%@KEY",[[DeviceListarr objectAtIndex:i] objectForKey:@"KeyID"]];
//        NSInteger items_num = [[dic objectForKey:@"KeyID"] intValue];
//        
//        if (items_num == 8) {
//            items_num = 6;
//        }
//        for (int n = 0; n < [DeviceItemsarr count]; n++) {
//            if ([[dic objectForKey:@"LoopCode"]isEqualToString:[[DeviceItemsarr objectAtIndex:n] objectForKey:@"P_LoopCode"] ]) {
//                list.m_strName = [[DeviceItemsarr objectAtIndex:n] objectForKey:@"P_KeyIDName"];
//                for (int j = 0; j < items_num; j++) {
//                    
//                    QQPerson *person = [[[QQPerson alloc] init] autorelease];
//                    if ([[dic objectForKey:@"KeyName"]isEqualToString:@""]||[dic objectForKey:@"KeyName"] == nil)
//                    {
//                        person.m_strKeyName = @"Room";
//                    }
//                    else
//                    {
//                        person.m_strKeyName = [[[[DeviceItemsarr objectAtIndex:n] objectForKey:@"P_device_items" ]objectAtIndex:j]objectForKey:@"P_KeyName"];
//                    }
//                    person.m_strImageName = [[[[DeviceItemsarr objectAtIndex:n] objectForKey:@"P_device_items" ]objectAtIndex:j]objectForKey:@"P_ImageName"];
//                  
//                    person.m_strStatus = [DeviceItemStatus objectAtIndex:j];
//                    [list.m_arrayPersons addObject:person];
//                }
//                [lists addObject:list];
//                isExistItem = 1;
//                
//            }
//        }
//        
//        if (isExistItem == 0) {
//            
//            [device_lists setObject:[dic objectForKey:@"LoopCode"] forKey:@"P_LoopCode"];
//            [device_lists setObject:[NSString stringWithFormat:@"%@KEY",[[DeviceListarr objectAtIndex:i] objectForKey:@"KeyID"]] forKey:@"P_KeyIDName"];
//            // NSString *strItemStatus = [dic objectForKey:@"Status"];
//            for (int j = 0; j < items_num; j++) {
//                
//                QQPerson *person = [[[QQPerson alloc] init] autorelease];
//                if ([[dic objectForKey:@"KeyName"]isEqualToString:@""]||[dic objectForKey:@"KeyName"] == nil)
//                {
//                    person.m_strKeyName = @"Room";
//                }
//                else
//                {
//                    person.m_strKeyName = [dic objectForKey:@"KeyName"];
//                }
//                person.m_strImageName = @"default_pic-00";
//                [device_items setObject:person.m_strKeyName forKey:@"P_KeyName"];
//                [device_items setObject:@"default_pic-00" forKey:@"P_ImageName"];
//                [device_List_item addObject:device_items];
//                person.m_strStatus = [DeviceItemStatus objectAtIndex:j];
//                [list.m_arrayPersons addObject:person];
//            }
//            [device_lists setObject:device_List_item forKey:@"P_device_items"];
//            
//            [self.DeviceItemsarr addObject:device_lists];
//            [device_lists release];
//            [lists addObject:list];
//        }
//        else
//        {
//            isExistItem = 0;
//        }
//	}
//}

- (void)TenToTwo:(NSInteger)iten LeftAndRightTag:(NSInteger)tag//将十进制转化为2进止
{
   
    
    int index = 0;//用来表示数组的下标
    if (tag == 1)//表示为左边的值，就是数组的前3个值
    {
        index = 0;
    }
    else
    {
        index = 3;
    }
    if (iten == 1) {
        [DeviceItemStatus replaceObjectAtIndex:(0+index) withObject:@"1"];
    }
    else if(iten == 2)
    {
        [DeviceItemStatus replaceObjectAtIndex:(1+index) withObject:@"1"];
    }
    else if(iten == 3)
    {
        [DeviceItemStatus replaceObjectAtIndex:(0+index ) withObject:@"1"];
        [DeviceItemStatus replaceObjectAtIndex:(1+index) withObject:@"1"];
    }
    else if (iten == 4)
    {
        [DeviceItemStatus replaceObjectAtIndex:(2+index) withObject:@"1"];
    }
    else if (iten == 5)
    {
        [DeviceItemStatus replaceObjectAtIndex:(0+index ) withObject:@"1"];
        [DeviceItemStatus replaceObjectAtIndex:(2+index) withObject:@"1"];
    }
    else if (iten == 6)
    {
        [DeviceItemStatus replaceObjectAtIndex:(1+index) withObject:@"1"];
        [DeviceItemStatus replaceObjectAtIndex:(2+index) withObject:@"1"];
    }
    else if (iten == 7)
    {
        [DeviceItemStatus replaceObjectAtIndex:(0+index ) withObject:@"1"];
        [DeviceItemStatus replaceObjectAtIndex:(1+index) withObject:@"1"];
        [DeviceItemStatus replaceObjectAtIndex:(2+index) withObject:@"1"];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark-
#pragma mark My methods



-(void)backToHome
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)edit
{
    //[self hidePopView];
    SwitchsSortViewController *SwitchsSort = [[SwitchsSortViewController alloc]initWithNibName:@"SwitchsSortViewController" bundle:nil];
    [self.navigationController pushViewController:SwitchsSort animated:YES];
    [SwitchsSort release];

}



-(void)StringAnalyze
{
    
    [self GetDataValue];
    [self RefreshTable];
    
//    NSString *strData = @"uci_show?data";
//    NSString *strDevice = @"device";
//    if (TestTAG == 1) {
//        strData = @"key";
//        strDevice = @"data";
//    }
//    NSURL* GetTableListURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@=%@",URL_SERVICE,strData,strDevice]];
//    ASIHTTPRequest* TableListRequest = [[ASIHTTPRequest alloc]initWithURL:GetTableListURL];
//    [TableListRequest setShouldAttemptPersistentConnection:NO];
//    [TableListRequest setValidatesSecureCertificate:NO];
//    [TableListRequest setTimeOutSeconds:20];
//    TableListRequest.delegate = self;
//    [TableListRequest startSynchronous];
    
    
//    NSString *str = @"device.0.KeyName=\n\
//    device.0.LoopCode=010000\n\
//    device.1.KeyName=\n\
//    device.1.LoopCode=86AE5C\n\
//    device.2.KeyName=\n\
//    device.2.LoopCode=010101\n\
//    device.2.KeyID=01\n\
//    device.2.RSSI=-54\n\
//    device.2.Status=01\n\
//    device.0.KeyID=08\n\
//    device.0.RSSI=56\n\
//    device.0.Status=00\n\
//    device.1.KeyID=02\n\
//    device.1.RSSI=-65\n\
//    device.1.Status=00\n\
//    device.3.KeyName=\n\
//    device.3.LoopCode=010102\n\
//    device.3.KeyID=02\n\
//    device.3.RSSI=-54\n\
//    device.3.Status=02\n\
//    device.4.KeyName=\n\
//    device.4.LoopCode=010103\n\
//    device.4.KeyID=08\n\
//    device.4.RSSI=-54\n\
//    device.4.Status=01\n";
    
    
}

#pragma mark asihttprequest delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (hudMBProgress != nil)
    {
        [hudMBProgress removeFromSuperview];
        [hudMBProgress release];
        hudMBProgress = nil;
    }

    NSData *data = [request responseData];
    //NSData* data = [TableListRequest responseData];
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data:%@",str);
    if (data == nil) {
        
    }
    if (hudMBProgress != nil)
    {
        [hudMBProgress removeFromSuperview];
        [hudMBProgress release];
        hudMBProgress = nil;
    }
    if (DeviceListarr == nil) {
        DeviceListarr = [[NSMutableArray alloc]init];
    }
    else{
        [DeviceListarr release];
        DeviceListarr = [[NSMutableArray alloc]init];
    }
    
    
    NSArray *arr = [str componentsSeparatedByString:@"\n"];
    
    for (int j = 0;j < ([arr count]-1)/6;j++) {
        NSMutableDictionary *Devicedic = [[NSMutableDictionary alloc]init];
        
        for (int i = 0; i < [arr count] -1; i++) {
            NSString *tmpstr = [arr objectAtIndex:i];
            NSArray *tmpItemsarr = [tmpstr componentsSeparatedByString:@"."];
            if ([[tmpItemsarr objectAtIndex:1] intValue] == j) {
                [Devicedic setObject:[NSString stringWithFormat:@"%d",j] forKey:@"DeviceIndex"];
                NSArray *itemsValuearr = [[tmpItemsarr objectAtIndex:2]  componentsSeparatedByString:@"="];
                [Devicedic setObject:[itemsValuearr objectAtIndex:1] forKey:[itemsValuearr objectAtIndex:0]];
            }
        }
        [DeviceListarr addObject:Devicedic];
        [Devicedic release];
    }
    //[self SortSwitchs];
    [self GetDataValue];
    [self loadQQData];
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (hudMBProgress != nil)
    {
        [hudMBProgress removeFromSuperview];
        [hudMBProgress release];
        hudMBProgress = nil;
    }

    NSData *data = [request responseData];
    //NSData* data = [TableListRequest responseData];
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data:%@",str);
    NSLog(@"登入提交信息失敗:%@", request.error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"LoongYee" message: @"请检查网络连接是否正常"
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
}

#pragma mark switch sort
//第一次用时默认的排序方式是按key的大小排序
-(void)SortSwitchs
{
    

    for (int i = 0; i < [DeviceListarr count]; i++) {
       // NSMutableDictionary *Devicedic = [[NSMutableDictionary alloc]init];
       // Devicedic = [DeviceListarr objectAtIndex:i];
        NSInteger keyNum = [[[DeviceListarr objectAtIndex:i] objectForKey:@"KeyID"]integerValue];
        for (int j =i+1 ; j <  [DeviceListarr count]; j++) {
            if (keyNum < [[[DeviceListarr objectAtIndex:j] objectForKey:@"KeyID"]integerValue]) {
                keyNum = [[[DeviceListarr objectAtIndex:j] objectForKey:@"KeyID"]integerValue];
                id object = [DeviceListarr objectAtIndex:j];
                [object retain];
                [DeviceListarr removeObjectAtIndex:j];
                [DeviceListarr insertObject:object atIndex:i];
                [object release];
            }
        }
        
       // [Devicedic release];
    }
}


-(void)SetTiming:(NSInteger)deviceTag SetRow:(NSInteger)itemTag
{
    //self.MyPicker.hidden = NO;
    ideviceTag = deviceTag;
    iitemTag = itemTag;
    [self showTimerChooseBox];
}

-(void)OnAndOffSwitchs:(NSInteger)deviceTag setItemTag:(NSInteger)itemTag
{
    hudMBProgress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hudMBProgress];
    hudMBProgress.labelText = [Contant getStringWithKey:@"LOADING_WAITING"];
    hudMBProgress.mode = MBProgressHUDModeIndeterminate;
    [hudMBProgress show:YES];
    
    NSURL* GetTableListURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@spi_status",URL_SERVICE]];
    ASIHTTPRequest* TableListRequest = [[ASIHTTPRequest alloc]initWithURL:GetTableListURL];
    [TableListRequest setShouldAttemptPersistentConnection:NO];
    [TableListRequest setValidatesSecureCertificate:NO];
    [TableListRequest setTimeOutSeconds:20];
    [TableListRequest startSynchronous];
    //
    NSData* data = [TableListRequest responseData];
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data:%@",str);
    if ((str != nil)&&(![str isEqualToString:@""])) {
        NSArray *tmpItemsarr = [str componentsSeparatedByString:@":"];
        if (str.length >= 7) {
            if ([[str substringWithRange:NSMakeRange(0,7)]isEqualToString:@"Failure"]) {
                NSString *strmessge = [NSString stringWithFormat:@"%@\n%@",str,[Contant getStringWithKey:@"ALTER_ERROR"]];
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"LoongYee"
                                                              message:strmessge
                                                             delegate:self cancelButtonTitle:nil
                                                    otherButtonTitles:[Contant getStringWithKey:@"SWITH_OK"],nil];
                
                [alert show];
                [alert release];
                if (hudMBProgress != nil)
                {
                    [hudMBProgress removeFromSuperview];
                    [hudMBProgress release];
                    hudMBProgress = nil;
                }
                return;
            }
        }
        
        if([[[[tmpItemsarr objectAtIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@""]stringByReplacingOccurrencesOfString:@"\n" withString:@""] isEqualToString:@"Normal"])
        {
            [self performSelector:@selector(SwitchsONAndOff:) withObject:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld",(long)deviceTag],[NSString stringWithFormat:@"%ld",(long)itemTag], nil] afterDelay:0.1];

        }
        else if([[[[tmpItemsarr objectAtIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@""]stringByReplacingOccurrencesOfString:@"\n" withString:@""] isEqualToString:@"Busy"])
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"LoongYee"
                                                          message:[Contant getStringWithKey:@"SWITH_BUSY"]
                                                         delegate:self cancelButtonTitle:[Contant getStringWithKey:@"SWITH_OK"]
                                                otherButtonTitles:nil];
            alert.delegate = self;
            alert.tag = 1;//表示正在学习中
            [alert show];
            [alert release];
            
            if (hudMBProgress != nil)
            {
                [hudMBProgress removeFromSuperview];
                [hudMBProgress release];
                hudMBProgress = nil;
            }
            return;
        }

        

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"LoongYee"
                                                        message: [Contant getStringWithKey:@"ALTER_OPTION"]
                                                       delegate: nil
                                              cancelButtonTitle: [Contant getStringWithKey:@"SWITH_OK"]
                                              otherButtonTitles: nil];
        alert.delegate = self;
        alert.tag = 1;
        [alert show];
        [alert release];
        if (hudMBProgress != nil)
        {
            [hudMBProgress removeFromSuperview];
            [hudMBProgress release];
            hudMBProgress = nil;
        }
    }

    

    
}

-(void)SwitchsONAndOff:(NSArray *)inputArray
{
    //(NSInteger)deviceTag setItemTag:(NSInteger)itemTag
    NSInteger deviceTag = [[inputArray objectAtIndex:0] integerValue];
    NSInteger itemTag = [[inputArray objectAtIndex:1] integerValue];
    
    IsOpen = 1;
    NSString *strLoopCode = [[DeviceItemsarr objectAtIndex: deviceTag]objectForKey:@"P_LoopCode"];
    NSString *strKeyID = [[DeviceItemsarr objectAtIndex: deviceTag]objectForKey:@"P_KeyID"];
    NSInteger tmpItemTag = itemTag +1;
    if (itemTag >= 3) {
        tmpItemTag = itemTag +2;
    }
    NSString *strItemStatus = [NSString stringWithFormat:@"%02ld",(long)tmpItemTag];
    
    NSString *strData = @"spi_send?data";
    if (TestTAG == 1) {
        strData = @"key=lamp&value";
    }
    NSURL* GetTableListURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@=15,00,02,00,00,00,00,00,00,00,00,00,00,%@,%@,%@,%@,00,00,00,00,%@,0D",URL_SERVICE,strData,[strLoopCode substringWithRange:NSMakeRange(0, 2)],[strLoopCode substringWithRange:NSMakeRange(2, 2)],[strLoopCode substringWithRange:NSMakeRange(4, 2)],strItemStatus,strKeyID]];
    ASIHTTPRequest* TableListRequest = [[ASIHTTPRequest alloc]initWithURL:GetTableListURL];
    [TableListRequest setShouldAttemptPersistentConnection:NO];
    [TableListRequest setValidatesSecureCertificate:NO];
    [TableListRequest setTimeOutSeconds:20];
    [TableListRequest startSynchronous];
    //
    NSData* data = [TableListRequest responseData];
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data:%@",str);
    if ((str != nil)&&(![str isEqualToString:@""])) {
        if (str.length >= 7) {
            if ([[str substringWithRange:NSMakeRange(0,7)]isEqualToString:@"Failure"]) {
                NSString *strmessge = [NSString stringWithFormat:@"%@\n%@",str,[Contant getStringWithKey:@"ALTER_ERROR"]];
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"LoongYee"
                                                              message:strmessge
                                                             delegate:self cancelButtonTitle:nil
                                                    otherButtonTitles:[Contant getStringWithKey:@"SWITH_OK"],nil];
                
                [alert show];
                [alert release];
                if (hudMBProgress != nil)
                {
                    [hudMBProgress removeFromSuperview];
                    [hudMBProgress release];
                    hudMBProgress = nil;
                }
                return;
            }
        }
        
        NSArray *tmpItemsarr = [str componentsSeparatedByString:@","];
        NSString* strKeyID = [tmpItemsarr objectAtIndex:21];
        if ((![[strKeyID substringWithRange:NSMakeRange(0,1)] isEqualToString:@"0"]) || strtol([[strKeyID substringWithRange:NSMakeRange(1,1)] cStringUsingEncoding:NSUTF8StringEncoding],0,16) <1 || strtol([[strKeyID substringWithRange:NSMakeRange(1,1)] cStringUsingEncoding:NSUTF8StringEncoding],0,16) > 8) {
            NSString *strmessge = [NSString stringWithFormat:@"device.KeyID = %@\n%@",strKeyID,[Contant getStringWithKey:@"ALTER_ERROR"]];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"LoongYee"
                                                          message:strmessge
                                                         delegate:self cancelButtonTitle:nil
                                                otherButtonTitles:[Contant getStringWithKey:@"SWITH_OK"],nil];
            
            [alert show];
            [alert release];
            
            if (hudMBProgress != nil)
            {
                [hudMBProgress removeFromSuperview];
                [hudMBProgress release];
                hudMBProgress = nil;
            }
            return;
        }
        NSString *strStatus = [tmpItemsarr objectAtIndex:16];
        
        if (strtol([[strStatus substringWithRange:NSMakeRange(0,1)] cStringUsingEncoding:NSUTF8StringEncoding],0,16) <0 || strtol([[strStatus substringWithRange:NSMakeRange(0,1)] cStringUsingEncoding:NSUTF8StringEncoding],0,16) > 7 ||strtol([[strStatus substringWithRange:NSMakeRange(1,1)] cStringUsingEncoding:NSUTF8StringEncoding],0,16) <0 || strtol([[strStatus substringWithRange:NSMakeRange(1,1)] cStringUsingEncoding:NSUTF8StringEncoding],0,16) > 7) {
            NSString *strmessge = [NSString stringWithFormat:@"device.Status = %@\n%@",strStatus,[Contant getStringWithKey:@"ALTER_ERROR"]];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"LoongYee"
                                                          message:strmessge
                                                         delegate:self cancelButtonTitle:nil
                                                otherButtonTitles:[Contant getStringWithKey:@"SWITH_OK"],nil];
            
            [alert show];
            [alert release];
            
            if (hudMBProgress != nil)
            {
                [hudMBProgress removeFromSuperview];
                [hudMBProgress release];
                hudMBProgress = nil;
            }
            return;
        }
        
        [[DeviceItemsarr objectAtIndex:deviceTag] setObject:[tmpItemsarr objectAtIndex:16] forKey:@"P_Status"];
        [self RefreshStatus:deviceTag];
        //[self RefreshTable];
        [tableViewSwtich reloadData];
    }
    
    if (hudMBProgress != nil)
    {
        [hudMBProgress removeFromSuperview];
        [hudMBProgress release];
        hudMBProgress = nil;
    }
}

-(void)AllOffSwitchs:(NSInteger)deviceTag
{
    hudMBProgress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hudMBProgress];
    hudMBProgress.labelText = [Contant getStringWithKey:@"LOADING_WAITING"];
    hudMBProgress.mode = MBProgressHUDModeIndeterminate;
    [hudMBProgress show:YES];
    
    NSURL* GetTableListURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@spi_status",URL_SERVICE]];
    ASIHTTPRequest* TableListRequest = [[ASIHTTPRequest alloc]initWithURL:GetTableListURL];
    [TableListRequest setShouldAttemptPersistentConnection:NO];
    [TableListRequest setValidatesSecureCertificate:NO];
    [TableListRequest setTimeOutSeconds:20];
    [TableListRequest startSynchronous];
    //
    NSData* data = [TableListRequest responseData];
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data:%@",str);
    if ((str != nil)&&(![str isEqualToString:@""])) {
        NSArray *tmpItemsarr = [str componentsSeparatedByString:@":"];
        if (str.length >= 7) {
            if ([[str substringWithRange:NSMakeRange(0,7)]isEqualToString:@"Failure"]) {
                NSString *strmessge = [NSString stringWithFormat:@"%@\n%@",str,[Contant getStringWithKey:@"ALTER_ERROR"]];
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"LoongYee"
                                                              message:strmessge
                                                             delegate:self cancelButtonTitle:nil
                                                    otherButtonTitles:[Contant getStringWithKey:@"SWITH_OK"],nil];
                
                [alert show];
                [alert release];
                if (hudMBProgress != nil)
                {
                    [hudMBProgress removeFromSuperview];
                    [hudMBProgress release];
                    hudMBProgress = nil;
                }
                return;
            }
        }
        
        if([[[[tmpItemsarr objectAtIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@""]stringByReplacingOccurrencesOfString:@"\n" withString:@""] isEqualToString:@"Normal"])
        {
            [self performSelector:@selector(SwitchsAllOff:) withObject:[NSString stringWithFormat:@"%ld",(long)deviceTag] afterDelay:0.1];
            
        }
        else if([[[[tmpItemsarr objectAtIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@""]stringByReplacingOccurrencesOfString:@"\n" withString:@""] isEqualToString:@"Busy"])
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"LoongYee"
                                                          message:[Contant getStringWithKey:@"SWITH_BUSY"]
                                                         delegate:self cancelButtonTitle:[Contant getStringWithKey:@"SWITH_OK"]
                                                otherButtonTitles:nil];
            alert.delegate = self;
            alert.tag = 1;//表示正在学习中
            [alert show];
            [alert release];
            
            if (hudMBProgress != nil)
            {
                [hudMBProgress removeFromSuperview];
                [hudMBProgress release];
                hudMBProgress = nil;
            }
            return;
        }
        
        
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"LoongYee"
                                                        message: [Contant getStringWithKey:@"ALTER_OPTION"]
                                                       delegate: nil
                                              cancelButtonTitle: [Contant getStringWithKey:@"SWITH_OK"]
                                              otherButtonTitles: nil];
        alert.delegate = self;
        alert.tag = 1;
        [alert show];
        [alert release];
        if (hudMBProgress != nil)
        {
            [hudMBProgress removeFromSuperview];
            [hudMBProgress release];
            hudMBProgress = nil;
        }
    }
    

    
    
}

-(void)SwitchsAllOff:(NSString*)strdeviceTag
{
    NSInteger deviceTag = [strdeviceTag integerValue];
    IsOpen = 1;
    NSString *strLoopCode = [[DeviceItemsarr objectAtIndex: deviceTag]objectForKey:@"P_LoopCode"];
    NSString *strKeyID = [[DeviceItemsarr objectAtIndex: deviceTag]objectForKey:@"P_KeyID"];
    NSString *strData = @"spi_send?data";
    if (TestTAG == 1) {
        strData = @"key=lamp&value";
    }
    NSURL* GetTableListURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@=15,00,02,00,00,00,00,00,00,00,00,00,00,%@,%@,%@,00,00,00,00,00,%@,0D",URL_SERVICE,strData,[strLoopCode substringWithRange:NSMakeRange(0, 2)],[strLoopCode substringWithRange:NSMakeRange(2, 2)],[strLoopCode substringWithRange:NSMakeRange(4, 2)],strKeyID]];
    ASIHTTPRequest* TableListRequest = [[ASIHTTPRequest alloc]initWithURL:GetTableListURL];
    [TableListRequest setShouldAttemptPersistentConnection:NO];
    [TableListRequest setValidatesSecureCertificate:NO];
    [TableListRequest setTimeOutSeconds:20];
    [TableListRequest startSynchronous];
    //
    NSData* data = [TableListRequest responseData];
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data:%@",str);
    
    if ((str != nil)&&(![str isEqualToString:@""])) {
        if (str.length >= 7) {
            if ([[str substringWithRange:NSMakeRange(0,7)]isEqualToString:@"Failure"]) {
                NSString *strmessge = [NSString stringWithFormat:@"%@\n%@",str,[Contant getStringWithKey:@"ALTER_ERROR"]];
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"LoongYee"
                                                              message:strmessge
                                                             delegate:self cancelButtonTitle:nil
                                                    otherButtonTitles:[Contant getStringWithKey:@"SWITH_OK"],nil];
                
                [alert show];
                [alert release];
                if (hudMBProgress != nil)
                {
                    [hudMBProgress removeFromSuperview];
                    [hudMBProgress release];
                    hudMBProgress = nil;
                }
                return;
            }
        }
        
        NSArray *tmpItemsarr = [str componentsSeparatedByString:@","];
        NSString* strKeyID = [tmpItemsarr objectAtIndex:21];
        if ((![[strKeyID substringWithRange:NSMakeRange(0,1)] isEqualToString:@"0"]) || strtol([[strKeyID substringWithRange:NSMakeRange(1,1)] cStringUsingEncoding:NSUTF8StringEncoding],0,16) <1 || strtol([[strKeyID substringWithRange:NSMakeRange(1,1)] cStringUsingEncoding:NSUTF8StringEncoding],0,16) > 8) {
            NSString *strmessge = [NSString stringWithFormat:@"device.KeyID = %@\n%@",strKeyID,[Contant getStringWithKey:@"ALTER_ERROR"]];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"LoongYee"
                                                          message:strmessge
                                                         delegate:self cancelButtonTitle:nil
                                                otherButtonTitles:[Contant getStringWithKey:@"SWITH_OK"],nil];
            
            [alert show];
            [alert release];
            
            if (hudMBProgress != nil)
            {
                [hudMBProgress removeFromSuperview];
                [hudMBProgress release];
                hudMBProgress = nil;
            }
            return;
        }
        NSString *strStatus = [tmpItemsarr objectAtIndex:16];
        
        if (strtol([[strStatus substringWithRange:NSMakeRange(0,1)] cStringUsingEncoding:NSUTF8StringEncoding],0,16) <0 || strtol([[strStatus substringWithRange:NSMakeRange(0,1)] cStringUsingEncoding:NSUTF8StringEncoding],0,16) > 7 ||strtol([[strStatus substringWithRange:NSMakeRange(1,1)] cStringUsingEncoding:NSUTF8StringEncoding],0,16) <0 || strtol([[strStatus substringWithRange:NSMakeRange(1,1)] cStringUsingEncoding:NSUTF8StringEncoding],0,16) > 7) {
            NSString *strmessge = [NSString stringWithFormat:@"device.Status = %@\n%@",strStatus,[Contant getStringWithKey:@"ALTER_ERROR"]];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"LoongYee"
                                                          message:strmessge
                                                         delegate:self cancelButtonTitle:nil
                                                otherButtonTitles:[Contant getStringWithKey:@"SWITH_OK"],nil];
            
            [alert show];
            [alert release];
            
            if (hudMBProgress != nil)
            {
                [hudMBProgress removeFromSuperview];
                [hudMBProgress release];
                hudMBProgress = nil;
            }
            return;
        }
        
        [[DeviceItemsarr objectAtIndex:deviceTag] setObject:[tmpItemsarr objectAtIndex:16] forKey:@"P_Status"];
        [self RefreshStatus:deviceTag];
        //[self RefreshTable];
        [tableViewSwtich reloadData];
    }
    if (hudMBProgress != nil)
    {
        [hudMBProgress removeFromSuperview];
        [hudMBProgress release];
        hudMBProgress = nil;
    }
}

#pragma mark Picker
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerArray count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [pickerArray objectAtIndex:row];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    
    return 50.0;
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"select row = %d",row);
    //self.MyPicker.hidden = YES;
}

- (void)showTimerChooseBox
{
    SBTableAlert* tableAlert;
   

    //cellTextArr = [NSMutableArray arrayWithObjects:[Contant getStringWithKey:@"SHEET_CH1"], [Contant getStringWithKey:@"SHEET_CH2"], [Contant getStringWithKey:@"SHEET_CH3"], [Contant getStringWithKey:@"SHEET_CH4"], [Contant getStringWithKey:@"SHEET_CH5"], [Contant getStringWithKey:@"SHEET_CH6"], nil];
    
    //tableAlert	= [[SBTableAlert alloc] initWithTitle:[Contant getStringWithKey:@"SHEET_TITLE"] cancelButtonTitle:[Contant getStringWithKey:@"SHEET_CANCEL"] messageFormat:nil];
    tableAlert	= [[SBTableAlert alloc] initWithTitle:[Contant getStringWithKey:@"SWITH_TIMER"] cancelButtonTitle:[Contant getStringWithKey:@"SWITH_CANCEL"] messageFormat:nil];
    [tableAlert.view setTag:1];
    if (cellTextArr == nil) {
        cellTextArr = [[NSMutableArray alloc] initWithObjects:@"5",@"10",@"15",@"20", @"25", nil];
    }
    if (pickerArray == nil) {
        pickerArray = [[NSMutableArray alloc] initWithObjects:@"5 min",@"10 min",@"15 min",@"20 min", @"25 min", nil];
    }
    
    
    //創建的table alert 和 retain的數組 再選擇後釋放
    NSLog(@"cell Text Arrary:%@",cellTextArr);
   // pickerArray = cellTextArr.retain;
    
    [tableAlert setDelegate:self];
	[tableAlert setDataSource:self];
    [tableAlert setStyle:SBTableAlertStyleApple];
	//[tableAlert ];
	[tableAlert show];
    //[cellTextArr release];
}

#pragma mark alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    //輸入的密碼
//    NSString* inputPswdStr = [alertView textFieldAtIndex:0].text;
//    //與當前用戶的密碼對比
//    if ([inputPswdStr isEqualToString:[[AppDelegate GetCurrentUser] objectForKey:WINTEC_USER_PASSWORD]])
//    {
//        switch ([AppDelegate getCarState]) {
//            case icon_gray:
//                NSLog(@"請檢查網絡連接");
//                break;
//                
//            case icon_red:
//                [Contant notifyMessage:[Contant getStringWithKey:@"ALERT_MESSAGE_CAR_DISCONNECT"]];
//                return;
//                break;
//                
//            default:
//                break;
//        }
//        [self.view bringSubviewToFront:waitingView];
//        [self lockScreen:YES];
//        waitingTimer = [NSTimer scheduledTimerWithTimeInterval:WAITING_TIME target:self selector:@selector(TimerRun:) userInfo:nil repeats:NO];
//        [self sendRequest:BTN_LB];
//    }
//    else
//    {
//        [Contant notifyMessage:[Contant getStringWithKey:@"ALERT_MESSAGE_PSWD_ERROR"]];
//    }
//    alertView.delegate = nil;
//    [alertView release];
}

#pragma mark table alert data source
- (NSInteger)numberOfSectionsInTableAlert:(SBTableAlert *)tableAlert {
    
    return 1;
    
}
- (NSInteger)tableAlert:(SBTableAlert *)tableAlert numberOfRowsInSection:(NSInteger)section
{
    return pickerArray.count;
}

- (UITableViewCell *)tableAlert:(SBTableAlert *)tableAlert cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[[SBTableAlertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    
    [cell.textLabel setText:[pickerArray objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark table alert delegate
- (void)tableAlert:(SBTableAlert *)tableAlert didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *strLoopCode = [[DeviceItemsarr objectAtIndex: ideviceTag]objectForKey:@"P_LoopCode"];
    NSString *strKeyID = [[DeviceItemsarr objectAtIndex: ideviceTag]objectForKey:@"P_KeyID"];
    NSInteger tmpItemTag = iitemTag +1;
    if (iitemTag >= 3) {
        tmpItemTag = iitemTag +2;
    }
    NSString *strItemStatus = [NSString stringWithFormat:@"%02ld",(long)tmpItemTag];
    NSString *StrTimer = [cellTextArr objectAtIndex:indexPath.row];
     NSString *strData = @"spi_send?data";
    if (TestTAG == 1) {
        strData = @"key=delay&value";
    }
    NSURL* GetTableListURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@=15,00,02,00,00,00,00,00,00,00,00,00,00,%@,%@,%@,%@,80,%@,00,00,%@,0D",URL_SERVICE,strData,[strLoopCode substringWithRange:NSMakeRange(0, 2)],[strLoopCode substringWithRange:NSMakeRange(2, 2)],[strLoopCode substringWithRange:NSMakeRange(4, 2)],strItemStatus,StrTimer,strKeyID]];
    ASIHTTPRequest* TableListRequest = [[ASIHTTPRequest alloc]initWithURL:GetTableListURL];
    [TableListRequest setShouldAttemptPersistentConnection:NO];
    [TableListRequest setValidatesSecureCertificate:NO];
    [TableListRequest setTimeOutSeconds:20];
    [TableListRequest startSynchronous];
    //
    NSData* data = [TableListRequest responseData];
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data:%@",str);
    if ((str != nil)&&(![str isEqualToString:@""])) {
        //NSArray *tmpItemsarr = [str componentsSeparatedByString:@","];
        //[[DeviceItemsarr objectAtIndex:deviceTag] setObject:[tmpItemsarr objectAtIndex:16] forKey:@"P_Status"];
        //[self loadQQData];
        
        if ((str != nil)&&(![str isEqualToString:@""])) {
            if (str.length >= 7) {
                if ([[str substringWithRange:NSMakeRange(0,7)]isEqualToString:@"Failure"]) {
                    NSString *strmessge = [NSString stringWithFormat:@"%@\n%@",str,[Contant getStringWithKey:@"ALTER_ERROR"]];
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"LoongYee"
                                                                  message:strmessge
                                                                 delegate:self cancelButtonTitle:nil
                                                        otherButtonTitles:[Contant getStringWithKey:@"SWITH_OK"],nil];
                    
                    [alert show];
                    [alert release];
                    if (hudMBProgress != nil)
                    {
                        [hudMBProgress removeFromSuperview];
                        [hudMBProgress release];
                        hudMBProgress = nil;
                    }
                    return;
                }
            }
            
            NSArray *tmpItemsarr = [str componentsSeparatedByString:@","];
            NSString* strKeyID = [tmpItemsarr objectAtIndex:21];
            if ((![[strKeyID substringWithRange:NSMakeRange(0,1)] isEqualToString:@"0"]) || strtol([[strKeyID substringWithRange:NSMakeRange(1,1)] cStringUsingEncoding:NSUTF8StringEncoding],0,16) <1 || strtol([[strKeyID substringWithRange:NSMakeRange(1,1)] cStringUsingEncoding:NSUTF8StringEncoding],0,16) > 8) {
                NSString *strmessge = [NSString stringWithFormat:@"device.KeyID = %@\n%@",strKeyID,[Contant getStringWithKey:@"ALTER_ERROR"]];
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"LoongYee"
                                                              message:strmessge
                                                             delegate:self cancelButtonTitle:nil
                                                    otherButtonTitles:[Contant getStringWithKey:@"SWITH_OK"],nil];
                
                [alert show];
                [alert release];
                
                if (hudMBProgress != nil)
                {
                    [hudMBProgress removeFromSuperview];
                    [hudMBProgress release];
                    hudMBProgress = nil;
                }
                return;
            }
            NSString *strStatus = [tmpItemsarr objectAtIndex:16];
         
            if (strtol([[strStatus substringWithRange:NSMakeRange(0,1)] cStringUsingEncoding:NSUTF8StringEncoding],0,16) <0 || strtol([[strStatus substringWithRange:NSMakeRange(0,1)] cStringUsingEncoding:NSUTF8StringEncoding],0,16) > 7 ||strtol([[strStatus substringWithRange:NSMakeRange(1,1)] cStringUsingEncoding:NSUTF8StringEncoding],0,16) <0 || strtol([[strStatus substringWithRange:NSMakeRange(1,1)] cStringUsingEncoding:NSUTF8StringEncoding],0,16) > 7) {
                NSString *strmessge = [NSString stringWithFormat:@"device.Status = %@\n%@",strStatus,[Contant getStringWithKey:@"ALTER_ERROR"]];
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"LoongYee"
                                                              message:strmessge
                                                             delegate:self cancelButtonTitle:nil
                                                    otherButtonTitles:[Contant getStringWithKey:@"SWITH_OK"],nil];
                
                [alert show];
                [alert release];
                
                if (hudMBProgress != nil)
                {
                    [hudMBProgress removeFromSuperview];
                    [hudMBProgress release];
                    hudMBProgress = nil;
                }
                return;
            }
            [[DeviceItemsarr objectAtIndex:ideviceTag] setObject:[tmpItemsarr objectAtIndex:16] forKey:@"P_Status"];
            [self RefreshStatus:ideviceTag];
            //[self RefreshTable];
            [tableViewSwtich reloadData];

        }
        
    }

    
}

- (void)tableAlert:(SBTableAlert *)tableAlert didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //釋放長按事件中創建的變量
    [pickerArray release];
    pickerArray = nil;
    [tableAlert setDelegate:nil];
	[tableAlert setDataSource:nil];
	[tableAlert release];
}

#pragma mark get data
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

@end
