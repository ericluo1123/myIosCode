//
//  AnalysisHTTP.m
//  LoongYee
//
//  Created by user on 14-4-15.
//  Copyright (c) 2014年 FelixMac. All rights reserved.
//

#import "AnalysisHTTP.h"
#import "Contant.h"


@implementation AnalysisHTTP
@synthesize delegate;
@synthesize DeviceItemsarr;

//- (id)init
//{
//    if (self = [super init])
//    {
//        if (httpRequest == nil)
//        {
//            clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
//            httpRequest = [ASIHTTPRequest alloc] ini
//            
//            ASIHTTPRequest* TableListRequest = [[ASIHTTPRequest alloc]initWithURL:GetTableListURL];
//            [TableListRequest setShouldAttemptPersistentConnection:NO];
//            [TableListRequest setValidatesSecureCertificate:NO];
//            [TableListRequest setTimeOutSeconds:20];
//            TableListRequest.delegate = self;
//            [TableListRequest startSynchronous];
//        }
//	}
//    return self;
//}

-(void)GetTableList:(NSURL* )tableURL
{
    ASIHTTPRequest* TableListRequest = [[ASIHTTPRequest alloc]initWithURL:tableURL];
    [TableListRequest setShouldAttemptPersistentConnection:NO];
    [TableListRequest setValidatesSecureCertificate:NO];
    [TableListRequest setTimeOutSeconds:20];
    TableListRequest.delegate = self;
    [TableListRequest startSynchronous];
    [TableListRequest release];
}

#pragma mark asihttprequest delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
 
    NSData *data = [request responseData];
    //NSData* data = [TableListRequest responseData];
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data:%@",str);
    if (str == nil || [str isEqualToString:@""]) {
  
        
        if (DeviceItemsarr != nil) {
            [DeviceItemsarr removeAllObjects];
        }
        if (DeviceItemsarr == nil) {
            DeviceItemsarr = [[NSMutableArray alloc]init];
        }
        [self SetDataValue];
        [delegate AnalysisHTTPReturn:[Contant getStringWithKey:@"ALTER_DEVICE"] withTag:0];
        return;
    }
    else
    {
        
    if ((str.length >= 7)) {
        if ([[str substringWithRange:NSMakeRange(0,7)]isEqualToString:@"Failure"]) {
            NSString *strmessge = [NSString stringWithFormat:@"%@\n%@",str,[Contant getStringWithKey:@"ALTER_ERROR"]];
            
            [delegate AnalysisHTTPReturn:strmessge withTag:0];
            return;
        }
        
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
            NSString* strKeyID = [Devicedic objectForKey:@"KeyID"];
            if ((![[strKeyID substringWithRange:NSMakeRange(0,1)] isEqualToString:@"0"]) || strtol([[strKeyID substringWithRange:NSMakeRange(1,1)] cStringUsingEncoding:NSASCIIStringEncoding],0,16) <1 || strtol([[strKeyID substringWithRange:NSMakeRange(1,1)] cStringUsingEncoding:NSASCIIStringEncoding],0,16) > 8) {
                NSString *strmessge = [NSString stringWithFormat:@"device.%@.KeyID = %@\n%@",[Devicedic objectForKey:@"DeviceIndex"],strKeyID,[Contant getStringWithKey:@"ALTER_ERROR"]];
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"LoongYee"
                                                              message:strmessge
                                                             delegate:self cancelButtonTitle:nil
                                                    otherButtonTitles:[Contant getStringWithKey:@"SWITH_OK"],nil];
                
                [alert show];
                [alert release];
                [Devicedic release];
                continue;
            }
            [DeviceListarr addObject:Devicedic];
            [Devicedic release];
        }
        //[self SortSwitchs];
        [self GetDataValue];
        [self loadQQData];
        
        [delegate AnalysisHTTPReturn:@"Success" withTag:1];
    }
    
    
    
    
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSData *data = [request responseData];
    //NSData* data = [TableListRequest responseData];
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data:%@",str);

    [delegate AnalysisHTTPReturn:[Contant getStringWithKey:@"ALTER_OPTION"] withTag:0];
    NSLog(@"登入提交信息失敗:%@", request.error);
}

-(void) loadQQData
{
    if (DeviceItemsarr == nil || [DeviceItemsarr count] <= 0) {
        if (DeviceItemsarr == nil) {
            DeviceItemsarr = [[NSMutableArray alloc]init];
        }
        [self SortSwitchs];
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
                [[DeviceItemsarr objectAtIndex:j] setObject:[[DeviceListarr objectAtIndex:i] objectForKey:@"Status"] forKey:@"P_Status"];
                
                if ([[DeviceListarr objectAtIndex:i]objectForKey:@"GroupName"] == nil ||[[[DeviceListarr objectAtIndex:i]objectForKey:@"GroupName"] isEqualToString:@""] ) {
                    [[DeviceItemsarr objectAtIndex:j] setObject:[NSString stringWithFormat:@"%@KEY",[[DeviceListarr objectAtIndex:i] objectForKey:@"KeyID"]] forKey:@"P_KeyIDName"];
                }
                else
                {
                    [[DeviceItemsarr objectAtIndex:j] setObject:[[DeviceListarr objectAtIndex:i] objectForKey:@"GroupName"] forKey:@"P_KeyIDName"];
                }
                
                
                NSInteger items_num = [[[DeviceItemsarr objectAtIndex:j] objectForKey:@"P_device_items"] count];
      
                
                NSMutableArray *itemsName = [[[NSMutableArray alloc]init] autorelease];
                if ([[[DeviceListarr objectAtIndex:i] objectForKey:@"KeyName"]isEqualToString:@""]||[[DeviceListarr objectAtIndex:i] objectForKey:@"KeyName"] == nil)
                {
                    for (int m = 0; m < items_num; m++) {
                        [itemsName addObject:[NSString stringWithFormat:@"%@%d",[Contant getStringWithKey:@"SETTING_SET"],m+1]];
                    }
                }
                else
                {
                    itemsName = [NSMutableArray arrayWithArray: [[[DeviceListarr objectAtIndex:i] objectForKey:@"KeyName"] componentsSeparatedByString:@","]];
                    for (int m = 0; m < [itemsName count]; m++) {
                        if ([[itemsName objectAtIndex:m] isEqualToString:@""] || [itemsName objectAtIndex:m] == nil ) {
                            //[itemsName addObject:[NSString stringWithFormat:@"%@%d",[Contant getStringWithKey:@"SETTING_SET"],m+1]];
                            [itemsName replaceObjectAtIndex:m withObject:[NSString stringWithFormat:@"%@%d",[Contant getStringWithKey:@"SETTING_SET"],m+1]];
                        }
                        
                    }
                    //;
                    
                }
                
                if (DeviceItemStatus == nil) {
                    DeviceItemStatus  = [[NSMutableArray alloc ]initWithObjects:@"0",@"0",@"0",@"0", @"0",@"0", nil];
                }
                else
                {
                    [DeviceItemStatus release];
                    DeviceItemStatus  = [[NSMutableArray alloc ]initWithObjects:@"0",@"0",@"0",@"0", @"0",@"0", nil];
                }
                NSString *strItemStatus = [[DeviceItemsarr objectAtIndex:j] objectForKey:@"P_Status"];
                [self TenToTwo:[[strItemStatus substringWithRange:NSMakeRange(0, 1)] intValue] LeftAndRightTag:0];
                [self TenToTwo:[[strItemStatus substringWithRange:NSMakeRange(1, 1)] intValue] LeftAndRightTag:1];
                
                
                for (int n = 0; n < items_num; n++) {
                   
                    [[[[DeviceItemsarr objectAtIndex:j] objectForKey:@"P_device_items"] objectAtIndex:n]setObject:[itemsName objectAtIndex:n] forKey:@"P_KeyName"];
                    [[[[DeviceItemsarr objectAtIndex:j] objectForKey:@"P_device_items"] objectAtIndex:n] setObject:[DeviceItemStatus objectAtIndex:n] forKey:@"P_ItemStatus"];
                }
               
                isExistItem = 1;
            }
        }
        if (isExistItem == 0) {
            //增加一项
            [device_lists setObject:[[DeviceListarr objectAtIndex:i] objectForKey:@"RSSI"] forKey:@"P_RSSI"];
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
                for (int m = 0; m < [itemsName count]; m++) {
                    if ([[itemsName objectAtIndex:m] isEqualToString:@""] || [itemsName objectAtIndex:m] == nil ) {
                        //[itemsName addObject:[NSString stringWithFormat:@"%@%d",[Contant getStringWithKey:@"SETTING_SET"],m+1]];
                        [itemsName replaceObjectAtIndex:m withObject:[NSString stringWithFormat:@"%@%d",[Contant getStringWithKey:@"SETTING_SET"],m+1]];
                    }
                    
                }
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
   
    
    [self SetDataValue];
}

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
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:datafullFileName])
    {
        self.DeviceItemsarr =[NSMutableArray arrayWithContentsOfFile:datafullFileName];
    }
    
    
}

@end
