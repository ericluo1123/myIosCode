//
//  FelixTelnet.m
//  LoongYee
//
//  Created by FelixMac on 14-1-1.
//  Copyright (c) 2014年 FelixMac. All rights reserved.
//

#import "FelixTelnet.h"

static GCDAsyncSocket *clientSocket;

@interface FelixTelnet()<GCDAsyncSocketDelegate>
{
    NSString *strUsername;
    NSString *strPassword;
    BOOL bConnect;
    NSInteger currentStatus;
}

@end

@implementation FelixTelnet
@synthesize delegate;


- (id)init
{
    if (self = [super init])
    {
        if (clientSocket == nil)
        {
            clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        }
	}
    return self;
}


-(void)telnetLogin:(NSString *)stringUserName withPassword:(NSString *)stringPassword
{
    strUsername = stringUserName;
    strPassword = stringPassword;
    
    if (![clientSocket isConnected])
    {
        NSError *error = nil;
        
        currentStatus = TAG_CONNECT;
        if (![clientSocket connectToHost:HOST_ADDRESS onPort:HOST_PORT withTimeout:TIME_OUT error:&error])
        {
            NSLog(@"Error connecting: %@", error);
            [delegate telnetReturn:@"Err" withTag:TAG_CONNECT];
        }
        
    }
}

-(void)telnetGetLightList
{
    [self writeCommand:@"gtcmd_light.sh getlight all" withTag:TAG_GET_LIGHT_ALL];
}

-(void)telnetGetLightStatus:(NSInteger)groupID
{
    [self writeCommand:[NSString stringWithFormat:@"gtcmd_light.sh getlight light_status %d", groupID] withTag:TAG_GET_GROUP_LIGHT_STATUS];
}

-(void)telnetSetLightStatus:(NSInteger)indexLight withID:(NSInteger)groupID
{
    [self writeCommand:[NSString stringWithFormat:@"gtcmd_light.sh setlight  %d %d", indexLight, groupID] withTag:TAG_SET_LIGHT_STATUS];
}

-(void)telnetSetLightStatus:(NSInteger)indexLight withID:(NSInteger)groupID withTime:(NSInteger)time
{
    [self writeCommand:[NSString stringWithFormat:@"gtcmd_light.sh setlight  %d %d %d", indexLight, groupID, time] withTag:TAG_GET_GROUP_LIGHT_STATUS];
}

-(void)telnetSetLightStatus:(NSInteger)indexLight withRemoteCode:(NSString *)groupRemoteCode
{
    [self writeCommand:[NSString stringWithFormat:@"cc2500cmd setlight %d %@", indexLight, groupRemoteCode] withTag:TAG_SET_LIGHT_STATUS];
}

-(void)uninit
{
    [clientSocket disconnect];
    [clientSocket release];
}

-(void)writeCommand:(NSString *)cmd withTag:(long)tag
{
    currentStatus = tag;
    NSMutableData *cmdData = [NSMutableData dataWithData:[cmd dataUsingEncoding:NSUTF8StringEncoding]];
    [cmdData appendData:[GCDAsyncSocket CRLFData]];
    [cmdData retain];
    [clientSocket writeData:cmdData withTimeout:-1 tag:tag];
    [clientSocket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:tag];
}

#pragma mark-
#pragma mark Socket Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	NSLog(@"socket:%p didConnectToHost:%@ port:%hu", sock, host, port);
            bConnect = YES;
      [sock readDataWithTimeout:-1 tag:TAG_CONNECT];
}

- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
	NSLog(@"socketDidSecure:%p", sock);

}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
	NSLog(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	NSLog(@"socket:%p didReadData:withTag:%ld", sock, tag);
	NSLog(@"%@", data);
    NSMutableData *dataTemp = [[NSMutableData alloc] initWithData:data];
	NSString *readString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", readString);
	


    /*
    if (bConnect && [[[data subdataWithRange:NSMakeRange(0,1)] description] isEqualToString:@"<ff>"] && [data length] == 15)
    {
        bConnect = NO;
         [clientSocket readDataWithTimeout:-1 tag:tag];
        return;
    }
    */
    switch (currentStatus)
    {

        case TAG_CONNECT:

        {
            
            NSRange rangeFind = [readString rangeOfString:@"login:"];
            if (rangeFind.length == 0)
            {

                [sock readDataWithTimeout:-1 tag:0];
                return;
            }
            
            NSString *login = @"login: ";
            if ([dataTemp length] < [login length]) {
                 [sock readDataWithTimeout:-1 tag:tag];
                return;            }
            
            NSData *temp = [dataTemp subdataWithRange:NSMakeRange([dataTemp length] - [login length], [login length])];
            NSLog(@"%@", temp);
            NSString *stringFromData = [[[NSString alloc] initWithData: temp encoding:NSUTF8StringEncoding] autorelease];
            
            if ([stringFromData isEqualToString:login])
            {
                [self writeCommand:@"admin" withTag:TAG_USERNAME];
                return;
            }
            break;
        }
        case TAG_USERNAME:
        {
            NSRange rangeFind = [readString rangeOfString:@"Password:"];
            if (rangeFind.length == 0)
            {
                
                [sock readDataWithTimeout:-1 tag:0];
                return;
            }
            NSString *login = @"Password: ";
            if ([dataTemp length] < [login length]) {
                [sock readDataWithTimeout:-1 tag:tag];
                return;            }
            
            NSData *temp = [dataTemp subdataWithRange:NSMakeRange([dataTemp length] - [login length], [login length])];
            NSLog(@"%@", temp);
            NSString *stringFromData = [[[NSString alloc] initWithData: temp encoding:NSUTF8StringEncoding] autorelease];
            
            if ([stringFromData isEqualToString:login])
            {
                [self writeCommand:@"admin" withTag:TAG_PASSWORD];
                return;
            }
            break;
        }
        case TAG_PASSWORD:
        {
            [delegate telnetReturn:@"YES" withTag:TAG_LOGIN];
             currentStatus = 0;
            [sock readDataWithTimeout:-1 tag:0];
            
            break;
        }
        case TAG_GET_LIGHT_ALL:
        {
            NSArray *arr = [readString componentsSeparatedByString:@"\r\n"];
            if ([arr count] < 3) {
                [sock readDataWithTimeout:-1 tag:tag];
                return;
            }
            
            [delegate telnetReturn:readString withTag:TAG_GET_LIGHT_ALL];
             currentStatus = 0;
             [sock readDataWithTimeout:-1 tag:0];
           
            break;
        }
            
        case TAG_GET_GROUP_LIGHT_STATUS:
        {
            
            if ([readString length] == 4 && [[readString substringFromIndex:2] isEqualToString:@"\r\n"])
            {
                [delegate telnetReturn:readString withTag:TAG_GET_GROUP_LIGHT_STATUS];
                  currentStatus = 0;
                [sock readDataWithTimeout:-1 tag:0];
                return;
            }
            
            NSRange rangeFind = [readString rangeOfString:@"fail"];
            if (rangeFind.length != 0)
            {
                [delegate telnetReturn:@"error" withTag:TAG_GET_GROUP_LIGHT_STATUS];
                  currentStatus = 0;
                [sock readDataWithTimeout:-1 tag:0];
                return;
            }
            
            rangeFind = [readString rangeOfString:@"error"];
            if (rangeFind.length != 0)
            {
                [delegate telnetReturn:@"error" withTag:TAG_GET_GROUP_LIGHT_STATUS];
                  currentStatus = 0;
                [sock readDataWithTimeout:-1 tag:0];
                return;
            }
            
            [sock readDataWithTimeout:-1 tag:TAG_GET_GROUP_LIGHT_STATUS];
           
         
            break;

        }
        case TAG_SET_LIGHT_STATUS:
        {
            NSRange rangeFind = [readString rangeOfString:@"light_status="];
            if (rangeFind.length != 0)
            {
                [delegate telnetReturn:readString withTag:TAG_SET_LIGHT_STATUS];
                  currentStatus = 0;
                [sock readDataWithTimeout:-1 tag:0];
                return;
            }
            
            rangeFind = [readString rangeOfString:@"error"];
            if (rangeFind.length != 0)
            {
                [delegate telnetReturn:@"error" withTag:TAG_SET_LIGHT_STATUS];
                  currentStatus = 0;
                [sock readDataWithTimeout:-1 tag:0];
                return;
            }
            
            rangeFind = [readString rangeOfString:@"fail"];
            if (rangeFind.length != 0)
            {
                [delegate telnetReturn:@"error" withTag:TAG_SET_LIGHT_STATUS];
                  currentStatus = 0;
                [sock readDataWithTimeout:-1 tag:0];
                return;
            }
            
            [sock readDataWithTimeout:-1 tag:TAG_SET_LIGHT_STATUS];
            

            break;
        }
        default:
        {

            NSRange rangeFind = [readString rangeOfString:@"light_status="];
            if (rangeFind.length != 0)
            {
                currentStatus = 0;
                [sock readDataWithTimeout:-1 tag:0];
                [delegate telnetReturn:readString withTag:TAG_SET_LIGHT_STATUS];
                return;
            }
            
            break;
        }
          
    }

	
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    [delegate telnetReturn:@"Err" withTag:TAG_CONNECT];
	NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
}


@end
