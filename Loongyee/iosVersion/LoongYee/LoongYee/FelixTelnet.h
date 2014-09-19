//
//  FelixTelnet.h
//  LoongYee
//
//  Created by FelixMac on 14-1-1.
//  Copyright (c) 2014年 FelixMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "GCDAsyncSocket.h"

#define HOST_ADDRESS @"10.10.10.254"
//#define HOST_ADDRESS @"192.168.8.203"
#define HOST_PORT    23
#define TIME_OUT     20
#define TAG_CONNECT  1001
#define TAG_USERNAME 1002
#define TAG_PASSWORD 1003
#define TAG_LOGIN   1004
#define TAG_GET_LIGHT_ALL           1005
#define TAG_GET_GROUP_LIGHT_STATUS 1006
#define TAG_SET_LIGHT_STATUS 1007


@protocol FelixTelnetDelegate <NSObject>
@optional


- (void)telnetReturn:(NSString *)stringRead withTag:(NSInteger)tagIndex;

@end

@interface FelixTelnet : NSObject
{
    id <FelixTelnetDelegate>   delegate;
}

@property(nonatomic,assign)   id <FelixTelnetDelegate>   delegate;

-(id)init;
-(void)telnetLogin:(NSString *)stringUserName withPassword:(NSString *)stringPassword;
-(void)telnetGetLightList;
-(void)telnetGetLightStatus:(NSInteger)groupID;
-(void)telnetSetLightStatus:(NSInteger)indexLight withID:(NSInteger)groupID;
-(void)telnetSetLightStatus:(NSInteger)indexLight withID:(NSInteger)groupID withTime:(NSInteger)time;
-(void)telnetSetLightStatus:(NSInteger)indexLight withRemoteCode:(NSString *)groupRemoteCode;
-(void)uninit;

@end

