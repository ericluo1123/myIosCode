//
//  QQSectionHeaderView.m
//  TQQTableView
//
//  Created by Futao on 11-6-22.
//  Copyright 2011 ftkey.com. All rights reserved.
//

#import "QQSectionHeaderView.h"
#import "AppDelegate.h"

@implementation QQSectionHeaderView
@synthesize titleLabel, disclosureButton, delegate, section , opened;

-(id)initWithFrame:(CGRect)frame title:(NSString*)title section:(NSInteger)sectionNumber opened:(BOOL)isOpened delegate:(id)aDelegate{
    if (self = [super initWithFrame:frame]) {
		
        
        
		UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self 
																					  action:@selector(toggleAction:)] autorelease];
		[self addGestureRecognizer:tapGesture];
		self.userInteractionEnabled = YES;
		section = sectionNumber;
		delegate = aDelegate;
		opened = isOpened;
		CGRect titleLabelFrame = self.bounds;
        titleLabelFrame.origin.x += 15.0;
        titleLabelFrame.size.width -= 35.0;
        CGRectInset(titleLabelFrame, 0.0, 5.0);
        titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
        titleLabel.text = title;
        titleLabel.font = [UIFont fontWithName:@"Avenir Next" size:17];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLabel];
		
		
		disclosureButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        disclosureButton.frame = CGRectMake(280.0, 22.0, 25.0, 25.0);
        disclosureButton.backgroundColor = [UIColor clearColor];
		[disclosureButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
		[disclosureButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateSelected];
		disclosureButton.userInteractionEnabled = NO;
		disclosureButton.selected = isOpened;
        [self addSubview:disclosureButton];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 70.0, 320, 1)];
        lable.backgroundColor = [UIColor blackColor];
        [self addSubview:lable];
        [lable release];
		
		self.backgroundColor = [UIColor whiteColor];
        
        if (self.iPageTag == 0) {
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(LongPressToDo:)];
            longPress.minimumPressDuration = 1.0;
            [self addGestureRecognizer:longPress];
            
            [longPress release];
        }
        
	}
	return self;
}

-(IBAction)toggleAction:(id)sender {
	
	disclosureButton.selected = !disclosureButton.selected;
	
	if (disclosureButton.selected) {
		if ([delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
			[delegate sectionHeaderView:self sectionOpened:section];
		}
	}
	else {
		if ([delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
			[delegate sectionHeaderView:self sectionClosed:section];
		}
	}

}



- (void)dealloc {
	[titleLabel release];
    [disclosureButton release];
    [super dealloc];
}

- (void)LongPressToDo:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        if (self.iPageTag == 0) {
            UIAlertView* inputAlert = [[UIAlertView alloc]initWithTitle:[Contant getStringWithKey:@"SETTING_NAME"] message:nil delegate:self cancelButtonTitle:[Contant getStringWithKey:@"SWITH_OK"] otherButtonTitles:[Contant getStringWithKey:@"SWITH_CANCEL"],nil];
            inputAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
            inputAlert.delegate = self;
            [inputAlert textFieldAtIndex:0].text = titleLabel.text;
            [inputAlert show];
        }
        
        
    }
    
}

#pragma mark alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //與當前用戶的密碼對比
    //QQList *persons = [lists objectAtIndex:Cell_Section_index];
    if (buttonIndex ==0) {
        //輸入修改的名字
        NSString* inputNameStr = [alertView textFieldAtIndex:0].text;
        titleLabel.text = inputNameStr;
        [[AppDelegate GetStudyViewController]SetCellName:inputNameStr SetSection:titleLabel.tag];
        //[[self.DeviceItemsarr objectAtIndex:Cell_Section_index] setObject:inputNameStr forKey:@"P_KeyIDName"];
        NSLog(@"name = %@",inputNameStr);
    }
    
    alertView.delegate = nil;
    [alertView release];
}

@end
