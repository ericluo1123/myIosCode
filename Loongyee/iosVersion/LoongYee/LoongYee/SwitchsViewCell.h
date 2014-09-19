//
//  SwitchsViewCell.h
//  LoongYee
//
//  Created by user on 14-4-2.
//  Copyright (c) 2014年 FelixMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SwitchsViewCell : UITableViewCell<UIAlertViewDelegate>
{
     
}
@property (assign)  NSInteger iPageTag;//用来标记是设定页面还是开关页面，设定页面为0，开关为1
@property (retain, nonatomic) IBOutlet UIButton *IconBtn;

@property (retain, nonatomic) IBOutlet UIButton *NameBtn;
@property (retain, nonatomic) IBOutlet UILabel *PowerLabel;
@property (retain, nonatomic) IBOutlet UIButton *OnandOffBtn;
@property (retain, nonatomic) IBOutlet UIPickerView *MyPicker;

- (IBAction)OnAndOffBtn:(id)sender;
- (void)SetTimeLongPress:(UILongPressGestureRecognizer*)press;
- (void)SetChangeNameLongPress:(UILongPressGestureRecognizer*)press;
//- (void)SetPageTag:(NSInteger)pageTag;
@end
