//
//  SwitchSettingsViewController.m
//  LoongYee
//
//  Created by FelixMac on 13-12-26.
//  Copyright (c) 2013年 FelixMac. All rights reserved.
//

#import "SwitchSettingsViewController.h"
#import "UIBarButtonItemAdditions.h"
#import "MBProgressHUD.h"
#import "Contant.h"

@interface SwitchSettingsViewController ()<UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate,UIPickerViewDataSource>//, FelixTelnetDelegate>
{
    IBOutlet UITableView *tableViewSwtich;

    NSMutableArray *arrayName;
    NSMutableArray *arrayLightStatus;

    
    UIPickerView *pickViewTimer;
    NSMutableArray *pickerArray;
    UIActionSheet *actionSheet;
    
     MBProgressHUD *hudMBProgress;
    NSInteger indexSelected;
    BOOL b2KeyClose;
}

- (IBAction)offAllSwitch:(id)sender;
@end

@implementation SwitchSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.keyID == 8)
    {
         self.navigationItem.title = @"Gordon's House";
         arrayName = [[NSMutableArray alloc] initWithObjects:@"living room", @"restaurant", @"kitchen", @"restroom", @"front porch", @"garage", nil];
    }
    else if (self.keyID == 2)
    {
        self.navigationItem.title = @"Second Floor";
          arrayName = [[NSMutableArray alloc] initWithObjects:@"hallway", @"restroom", nil];
    }
    else
    {
        self.navigationItem.title = @"Basement";
          arrayName = [[NSMutableArray alloc] initWithObjects:@"basement", nil];
    }
    
    arrayLightStatus = [[NSMutableArray alloc] initWithObjects:@"NO", @"NO", @"NO", @"NO", @"NO", @"NO", nil];
    
    pickerArray = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"5", @"10",@"30", nil];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    //self.telnet.delegate = self;
    
    hudMBProgress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hudMBProgress];
    hudMBProgress.labelText = [Contant getStringWithKey:@"LOADING_WAITING"];
    hudMBProgress.mode = MBProgressHUDModeIndeterminate;
    [hudMBProgress show:YES];
    
    b2KeyClose = NO;
    //[self.telnet telnetGetLightStatus:self.groupID];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [arrayLightStatus release];
    [arrayName release];
    [super dealloc];
}


#pragma mark-
#pragma mark UIPickViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pickerArray count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([[pickerArray objectAtIndex:row] integerValue] == 1)
    {
        return @"1 minute";
    }
    else
    {
        return [NSString stringWithFormat:@"%@ minutes", [pickerArray objectAtIndex:row]];
    }
    return [pickerArray objectAtIndex:row];
}

#pragma mark-
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayName count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"SwitchCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									   reuseIdentifier:identifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	}
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *cellBk= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Monitoring_cell_bk"]];
    cellBk.frame = CGRectMake(0, 0, 320, 71);
    cell.backgroundView = cellBk;
    
    cell.imageView.image = [UIImage imageNamed:@"default_pic-04"];
    
    UIImage *imageBtnbg;
    UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    if ([[arrayLightStatus objectAtIndex:indexPath.row] boolValue])
    {
        imageBtnbg = [UIImage imageNamed:@"switch_on"];
    }
    else
    {
        imageBtnbg = [UIImage imageNamed:@"switch_off"];
    }
   

    
    [btn setFrame:CGRectMake(0,0,imageBtnbg.size.width,imageBtnbg.size.height)];
    
    
    [btn setBackgroundImage: imageBtnbg forState:UIControlStateNormal];
    
    btn.tag = indexPath.row + 1;
    [btn addTarget:self action:@selector(cellBtnAccessory:) forControlEvents:UIControlEventTouchUpInside];

    
    cell.accessoryView = btn;
    
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = [arrayName objectAtIndex:indexPath.row];
    
    
    return cell;
    
}



#pragma mark-
#pragma mark- UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    indexSelected = indexPath.row + 1;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self showTimeSettings];
    
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}




#pragma mark-
#pragma mark FelixTelnetDelegate

-(void)telnetReturn:(NSString *)stringRead withTag:(NSInteger)tagIndex
{
    if (hudMBProgress != nil)
    {
        [hudMBProgress removeFromSuperview];
        [hudMBProgress release];
        hudMBProgress = nil;
    }

    
//    switch (tagIndex)
//    {
//        case TAG_CONNECT:
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"LoongYee"
//                                                            message: @"communication error"
//                                                           delegate: nil
//                                                  cancelButtonTitle: @"OK"
//                                                  otherButtonTitles: nil];
//            [alert show];
//            [alert release];
//            return;
//            break;
//        }
//        case TAG_SET_LIGHT_STATUS:
//        {
//
//            if([stringRead isEqualToString: @"error"])
//            {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"LoongYee"
//                                                                message: @"communication error"
//                                                               delegate: nil
//                                                      cancelButtonTitle: @"OK"
//                                                      otherButtonTitles: nil];
//                [alert show];
//                [alert release];
//                return;
//            }
//            else
//            {
//                NSRange rangeFind = [stringRead rangeOfString:@"light_status="];
//                NSString *strTemp = [stringRead substringWithRange:NSMakeRange(rangeFind.location + rangeFind.length, 2)];
//                
//                NSString *strStatus = [NSString stringWithFormat:@"%@%@", [self unicharTo2:[strTemp characterAtIndex:1]], [self unicharTo2:[strTemp characterAtIndex:0]]];
//                
//                
//                for (int i = 3; i > 0; i--)
//                {
//                    if ([strStatus characterAtIndex:i] == '0')
//                    {
//                        [arrayLightStatus replaceObjectAtIndex:3 - i withObject:@"NO"];
//                    }
//                    else
//                    {
//                        [arrayLightStatus replaceObjectAtIndex:3 - i withObject:@"YES"];
//                    }
//                }
//                
//                
//                for (int i = 7; i > 4; i--)
//                {
//                    if ([strStatus characterAtIndex:i] == '0')
//                    {
//                        [arrayLightStatus replaceObjectAtIndex:10 - i withObject:@"NO"];
//                    }
//                    else
//                    {
//                        [arrayLightStatus replaceObjectAtIndex:10 - i withObject:@"YES"];
//                    }
//                }
//                NSLog(@"******************");
//                [tableViewSwtich reloadData];
//                
//            }
//            break;
//        }
//
//        case TAG_GET_GROUP_LIGHT_STATUS:
//        {
//            if([stringRead isEqualToString: @"error"])
//            {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"LoongYee"
//                                                                message: @"communication error"
//                                                               delegate: nil
//                                                      cancelButtonTitle: @"OK"
//                                                      otherButtonTitles: nil];
//                [alert show];
//                [alert release];
//                return;
//            }
//            else
//            {
//                NSString *strStatus = [NSString stringWithFormat:@"%@%@", [self unicharTo2:[stringRead characterAtIndex:1]], [self unicharTo2:[stringRead characterAtIndex:0]]];
//                
//                
//                for (int i = 3; i > 0; i--)
//                {
//                    if ([strStatus characterAtIndex:i] == '0')
//                    {
//                        [arrayLightStatus replaceObjectAtIndex:3 - i withObject:@"NO"];
//                    }
//                    else
//                    {
//                        [arrayLightStatus replaceObjectAtIndex:3 - i withObject:@"YES"];
//                    }
//                }
//
//                
//                for (int i = 7; i > 4; i--)
//                {
//                    if ([strStatus characterAtIndex:i] == '0')
//                    {
//                        [arrayLightStatus replaceObjectAtIndex:10 - i withObject:@"NO"];
//                    }
//                    else
//                    {
//                        [arrayLightStatus replaceObjectAtIndex:10 - i withObject:@"YES"];
//                    }
//                }
//                
//                if (b2KeyClose)
//                {
//                    b2KeyClose = NO;
//                    [self performSelector:@selector(close2key) withObject:nil afterDelay:0.3f];
//                }
//                else
//                {
//                    [tableViewSwtich reloadData];
//                }
//                
//            }
//            break;
//        }
//            
//        default:
//            break;
//    }
    
    
}



#pragma mark-
#pragma mark My methods

-(void)cellBtnAccessory:(UIButton *)btn
{
    hudMBProgress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hudMBProgress];
    hudMBProgress.labelText = [Contant getStringWithKey:@"LOADING_WAITING"];
    hudMBProgress.mode = MBProgressHUDModeIndeterminate;
    [hudMBProgress show:YES];
    
//    if(btn.tag < 4)
//    {
//        [self.telnet telnetSetLightStatus:btn.tag withRemoteCode:self.remoteCode];
//    }
//    else
//    {
//        [self.telnet telnetSetLightStatus:btn.tag + 1 withRemoteCode:self.remoteCode];
//    }
    
}

-(NSString *)unicharTo2:(unichar)character
{
    NSString *str = [[[NSString alloc] init] autorelease];
    switch (character)
    {
        case '0':
        {
            str = @"0000";
            break;
        }
        case '1':
        {
            str = @"0001";
            break;
        }
        case '2':
        {
            str = @"0010";
            break;
        }
        case '3':
        {
            str = @"0011";
            break;
        }
        case '4':
        {
            str = @"0100";
            break;
        }
        case '5':
        {
            str = @"0101";
            break;
        }
        case '6':
        {
            str = @"0110";
            break;
        }
        case '7':
        {
            str = @"0111";
            break;
        }
        case '8':
        {
            str = @"1000";
            break;
        }
        case '9':
        {
            str = @"1001";
            break;
        }
        case 'A':
        {
            str = @"1010";
            break;
        }
        case 'B':
        {
            str = @"1011";
            break;
        }
        case 'C':
        {
            str = @"1100";
            break;
        }
        case 'D':
        {
            str = @"1101";
            break;
        }
        case 'E':
        {
            str = @"1110";
            break;
        }
        case 'F':
        {
            str = @"1111";
            break;
        }
            
        default:
            break;
    }
    
    return str;
}

-(void)backToHome
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showTimeSettings
{
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:nil
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    
    pickViewTimer = [[UIPickerView alloc] initWithFrame:pickerFrame];
    pickViewTimer.showsSelectionIndicator = YES;
    pickViewTimer.dataSource = self;
    pickViewTimer.delegate = self;
    
    [actionSheet addSubview:pickViewTimer];
    
    UISegmentedControl *doneButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Done"]];
    doneButton.momentary = YES;
    doneButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    doneButton.segmentedControlStyle = UISegmentedControlStyleBar;
    doneButton.tintColor = [UIColor blackColor];
    [doneButton addTarget:self action:@selector(doneActionSheet:) forControlEvents:UIControlEventValueChanged];
    [actionSheet addSubview:doneButton];
    [doneButton release];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Cancel"]];
    closeButton.momentary = YES;
    closeButton.frame = CGRectMake(10, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(cancelActionSheet:) forControlEvents:UIControlEventValueChanged];
    [actionSheet addSubview:closeButton];
    [closeButton release];
    

    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    
    [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
    //[actionSheet showFromRect:CGRectMake(0, 0, 320, 485) inView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    
}
-(void)cancelActionSheet:(UIButton *)btn
{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    [pickViewTimer release];
}

-(void)doneActionSheet:(UIButton *)btn
{
   [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    hudMBProgress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hudMBProgress];
    hudMBProgress.labelText = [Contant getStringWithKey:@"LOADING_WAITING"];
    hudMBProgress.mode = MBProgressHUDModeIndeterminate;
    [hudMBProgress show:YES];
    
    NSInteger index = indexSelected;
    if(indexSelected < 4)
    {

    }
    else
    {
        index++;
    }
    
//    {
//        [self.telnet telnetSetLightStatus:index withID:self.groupID withTime:[[pickerArray objectAtIndex:[pickViewTimer selectedRowInComponent:0]] integerValue]];
//        [pickViewTimer release];
//    }
}

-(void)close2key
{
    if (self.keyID == 2)
    {
        for (int i = 0; i < 2; i++)
        {
            if ([[arrayLightStatus objectAtIndex:i] boolValue])
            {
                //[self.telnet telnetSetLightStatus:i + 1 withRemoteCode:self.remoteCode];
            }
        }
    }
    else
    {
        for (int i = 0; i < 1; i++)
        {
            if ([[arrayLightStatus objectAtIndex:i] boolValue])
            {
                //[self.telnet telnetSetLightStatus:i + 1 withRemoteCode:self.remoteCode];
            }
        }
    }
    

}

- (IBAction)offAllSwitch:(id)sender
{
    hudMBProgress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hudMBProgress];
    hudMBProgress.labelText = [Contant getStringWithKey:@"LOADING_WAITING"];
    hudMBProgress.mode = MBProgressHUDModeIndeterminate;
    [hudMBProgress show:YES];
    
    if (self.keyID == 8)
    {
       // [self.telnet telnetSetLightStatus:0 withID:self.groupID withTime:0];
    }
    else if (self.keyID == 2)
    {
        b2KeyClose = YES;
        //[self.telnet telnetGetLightStatus:self.groupID];
    }
    else
    {
        b2KeyClose = YES;
        //[self.telnet telnetGetLightStatus:self.groupID];
    }
}

@end
