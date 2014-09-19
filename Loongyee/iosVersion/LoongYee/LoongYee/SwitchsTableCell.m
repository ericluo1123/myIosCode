//
//  SwitchsTableCell.m
//  LoongYee
//
//  Created by user on 14-4-2.
//  Copyright (c) 2014年 FelixMac. All rights reserved.
//

#import "SwitchsTableCell.h"
#import "AppDelegate.h"

@implementation SwitchsTableCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [self.AlloffBtn setTitle:[Contant getStringWithKey:@"STUDY_ALL_OFF"] forState:UIControlStateNormal];
    
}

- (void)dealloc {
    [_AlloffBtn release];
    [_signalImageView release];
    [super dealloc];
}
- (IBAction)ToAllOffBtn:(id)sender {
    //使所有设备都关闭
    [[AppDelegate GetSwitchsViewController] AllOffSwitchs:self.AlloffBtn.tag];
}

-(void)SetSignalImage:(NSString *)ImageName
{
    [self.signalImageView setImage:[UIImage imageNamed:ImageName]];
}

@end
