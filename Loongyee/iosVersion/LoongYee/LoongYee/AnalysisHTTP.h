//
//  AnalysisHTTP.h
//  LoongYee
//
//  Created by user on 14-4-15.
//  Copyright (c) 2014年 FelixMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@protocol AnalysisHTTPDelegate <NSObject>
@optional


- (void)AnalysisHTTPReturn:(NSString *)stringRead withTag:(NSInteger)tagIndex;

@end

@interface AnalysisHTTP : NSObject<ASIHTTPRequestDelegate>
{
    id <AnalysisHTTPDelegate>   delegate;
    
    NSMutableArray *DeviceListarr;
    NSMutableArray *DeviceItemsarr;
    NSMutableArray *DeviceItemStatus;
}

@property(nonatomic,assign)   id <AnalysisHTTPDelegate>   delegate;

@property (retain, nonatomic)  NSMutableArray *DeviceItemsarr;
-(void)GetTableList:(NSURL* )tableURL;


@end
