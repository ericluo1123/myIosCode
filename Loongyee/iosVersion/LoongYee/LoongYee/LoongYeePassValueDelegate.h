//
//  LoongYeePassValueDelegate.h
//  LoongYee
//
//  Created by FelixMac on 13-12-25.
//  Copyright (c) 2013年 FelixMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoongYeePassValueDelegate <NSObject>
@optional


-(void)passSettingsChannelIndex:(NSInteger)index;

@end