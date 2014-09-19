//
//  SwitchsViewCell.m
//  LoongYee
//
//  Created by user on 14-4-2.
//  Copyright (c) 2014年 FelixMac. All rights reserved.
//

#import "SwitchsViewCell.h"
#import "AppDelegate.h"
#import "ImageListViewController.h"
#import "Contant.h"
@implementation SwitchsViewCell

- (void)awakeFromNib
{
    // Initialization code
    
    //添加長按事件
    UILongPressGestureRecognizer *btnLongTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(SetTimeLongPress:)];
    
    btnLongTap.minimumPressDuration = 1;  //長按時間1秒
    [self.IconBtn addGestureRecognizer:btnLongTap];
    [btnLongTap release];
    self.NameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.NameBtn.adjustsImageWhenHighlighted = NO;
    self.NameBtn.adjustsImageWhenDisabled = NO;
  
    //添加長按事件
    UILongPressGestureRecognizer *LabelLongTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(SetChangeNameLongPress:)];
        
    btnLongTap.minimumPressDuration = 1;  //長按時間1秒
    [self.NameBtn addGestureRecognizer:LabelLongTap];
    [LabelLongTap release];
    
    
    //pickerArray = [NSArray arrayWithObjects:@"5 min",@"10 min",@"15 min",@"20 min", @"25 min",@"取消",nil];
//    self.MyPicker.delegate = self;
//    self.MyPicker.dataSource = self;
//    self.MyPicker.frame = CGRectMake(0, 0, 320, 216);
//    [super addSubview: self.MyPicker];
    //self.MyPicker.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_IconBtn release];
    
    [_PowerLabel release];
    [_OnandOffBtn release];
    [_MyPicker release];
    [_NameBtn release];
    [super dealloc];
}


#pragma mark Long Press
//-(void)SetTimeLongPress
//{
//    NSLog(@"长按时间");
//    //用来设定定时关闭的时间
//    //self.MyPicker.hidden = NO;
//    [[AppDelegate GetSwitchsViewController] SetTiming];
//}

- (void)SetTimeLongPress:(UILongPressGestureRecognizer*)press
{
    //只響應第一次長按 如果不加判斷 則在手沒有鬆開的這段時間內將一直響應長按事件
    if (press.state == UIGestureRecognizerStateEnded) {
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        if (self.iPageTag == 0) {
            //设置图标
            
            [[AppDelegate GetStudyViewController] SetImageBtnIcon:self.IconBtn.tag SetRow:self.NameBtn.tag];
            
        }
        else
        {
            [[AppDelegate GetSwitchsViewController] SetTiming:self.IconBtn.tag SetRow:self.NameBtn.tag];
        }
        
    }
}

- (void)SetChangeNameLongPress:(UILongPressGestureRecognizer*)press
{
    //只響應第一次長按 如果不加判斷 則在手沒有鬆開的這段時間內將一直響應長按事件
    if (press.state == UIGestureRecognizerStateEnded) {
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        if (self.iPageTag == 0) {
            //[[AppDelegate GetSwitchsViewController] SetTiming];
            UIAlertView* inputAlert = [[UIAlertView alloc]initWithTitle:[Contant getStringWithKey:@"SETTING_NAME"] message:nil delegate:self cancelButtonTitle:[Contant getStringWithKey:@"SWITH_OK"] otherButtonTitles:[Contant getStringWithKey:@"SWITH_CANCEL"],nil];
            inputAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
            inputAlert.delegate = self;
            [inputAlert textFieldAtIndex:0].text = self.NameBtn.titleLabel.text;
            [inputAlert show];
        }
        else
        {
            return;
        }
        
    }
}




- (IBAction)OnAndOffBtn:(id)sender {
    //开启或关闭按钮
    //[self.OnandOffBtn setImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];
    //音效文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Windows Ding" ofType:@"wav"];
    //组装并播放音效
    SystemSoundID soundID;
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    AudioServicesPlaySystemSound(soundID);
    
    [[AppDelegate GetSwitchsViewController] OnAndOffSwitchs:self.IconBtn.tag setItemTag:self.NameBtn.tag];
    
}



//#pragma mark Picker
//-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
//    return 1;
//}
//-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
//    return 6;
//}
//-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    return 1;
//}
//
//-(void)textFieldDidEndEditing:(UITextField *)textField{
//    //NSInteger row = [selectPicker selectedRowInComponent:0];
//    //self.textField.text = [pickerArray objectAtIndex:row];
//}


#pragma mark alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    //與當前用戶的密碼對比
    
    if (buttonIndex ==0) {
        //輸入修改的名字
        NSString* inputNameStr = [alertView textFieldAtIndex:0].text;
        [self.NameBtn setTitle:inputNameStr forState:UIControlStateNormal];
        [[AppDelegate GetStudyViewController]SetItemName:inputNameStr SetSection:self.IconBtn.tag SetRow:self.NameBtn.tag];
        NSLog(@"section = %d,row = %d",self.IconBtn.tag,self.NameBtn.tag);
    }
  
    alertView.delegate = nil;
    [alertView release];
}

@end
