//
//  QQList.m
//  TQQTableView
//
//  Created by Futao on 11-6-21.
//  Copyright 2011 ftkey.com. All rights reserved.
//

#import "QQList.h"



@implementation QQPerson
@synthesize DeviceIndex;
@synthesize m_strKeyID;
@synthesize m_strKeyName;
@synthesize m_strLoopCode;
@synthesize m_strRSSI;
@synthesize m_strStatus;
@synthesize m_strImageName;

- (void)dealloc
{
    [m_strStatus release];
	[m_strRSSI release];
    [m_strLoopCode release];
    [m_strKeyName release];
    [m_strKeyID release];
    [m_strImageName release];
	
    [super dealloc];
}
@end

@implementation QQListBase
@synthesize m_nID;
@synthesize m_strName;
@synthesize m_arrayPersons;

- (void)dealloc
{
    [m_strName release];
	[m_arrayPersons release];
    [super dealloc];
}
@end

@implementation QQList
@synthesize opened,indexPaths;
- (void)dealloc
{
	[indexPaths release];
    [super dealloc];
}
@end

