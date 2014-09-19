//
//  SwitchsTableCell.h
//  LoongYee
//
//  Created by user on 14-4-2.
//  Copyright (c) 2014年 FelixMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchsTableCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIButton *AlloffBtn;
@property (retain, nonatomic) IBOutlet UIImageView *signalImageView;
- (IBAction)ToAllOffBtn:(id)sender;

//用来设置imagede 图片
-(void)SetSignalImage:(NSString *)ImageName;
@end
