//
//  Contant.m
//  Wintec
//
//  Created by teamsourcing on 12-11-7.
//  Copyright (c) 2012年 teamsourcing. All rights reserved.
//

#import "Contant.h"
#import "AppDelegate.h"
@implementation Contant

+ (NSString*)getStringWithKey:(NSString*)key
{
    NSString* strTable = [NSString stringWithFormat:@"Language%d", [AppDelegate GetCurrentLanguage]];
    return NSLocalizedStringFromTable(key, strTable, nil);
}

@end
