//
//  Contant.h
//  Wintec
//
//  Created by teamsourcing on 12-11-7.
//  Copyright (c) 2012年 teamsourcing. All rights reserved.
//

#import <Foundation/Foundation.h>
//
enum MulLanguage
{
    SCHINESE = 1,  //简中
    ENGLISH = 2,
    TCHINESE = 3
};

@interface Contant : NSObject

//根據key獲得字符串
+ (NSString*)getStringWithKey:(NSString*)key;

@end
