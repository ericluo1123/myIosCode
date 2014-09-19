//
//  PlugSettingsViewController.m
//  LoongYee
//
//  Created by FelixMac on 13-12-25.
//  Copyright (c) 2013年 FelixMac. All rights reserved.
//

#import "PlugSettingsViewController.h"
#import "UIBarButtonItemAdditions.h"
#import "ImageListViewController.h"

@interface PlugSettingsViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>//, FelixTelnetDelegate
{
    
    IBOutlet UIScrollView *scrollViewPlugList;
    UIButton *lastBtn;
    //FelixTelnet *telnet;
    NSMutableArray *arrayLight;
}

@end

@implementation PlugSettingsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"監視器设定";
    
    UIBarButtonItemAdditions *leftItemBtn = [[UIBarButtonItemAdditions alloc] initWithMyMethodTitle:@"  返回" img:@"item_btn_back_bk" target:self action:@selector(backToHome) font:10];
    self.navigationItem.leftBarButtonItem = leftItemBtn;
    [leftItemBtn release];

    arrayLight = [[NSMutableArray alloc] initWithObjects:@"light1",@"light2",@"light3",nil];
    
    [self addPlugListView];
    //telnet.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [scrollViewPlugList release];
    [super dealloc];
}

#pragma mark -
#pragma mark UIActionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        ImageListViewController *listView = [[ImageListViewController alloc] initWithNibName:@"ImageListViewController" bundle:nil];
        listView.arrImageList = [[NSMutableArray alloc] init];
        for (int i = 0; i < 15; i++)
        {
            [listView.arrImageList addObject:[NSString stringWithFormat:@"default_pic-%02d" , i + 1]];
        }
        
        [self.navigationController pushViewController:listView animated:YES];
        [listView release];
    }
    else if (buttonIndex == 1)
    {
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        [imgPicker setAllowsEditing:YES];
        [imgPicker setDelegate:self];
        [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
        
    }
    else if (buttonIndex == 2)
    {
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        [imgPicker setAllowsEditing:YES];
        [imgPicker setDelegate:self];
        [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
        
    }
    
    return;
}


#pragma mark-
#pragma mark navigationController delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

#pragma mark-
#pragma mark UIImagePickerController delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    [lastBtn setImage:image forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    return;
}

-(void)telnetReturn:(NSString *)stringRead withTag:(NSInteger)tagIndex
{
    //[hudMBProgress removeFromSuperview];
    //[hudMBProgress release];
    
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
//            if([stringRead isEqualToString: @"fail"])
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
//                NSString *strStatus = [NSString stringWithFormat:@"%@%@", [self unicharTo2:[stringRead characterAtIndex:0]], [self unicharTo2:[stringRead characterAtIndex:1]]];
//                
//                NSMutableArray *arrayStatus =[[NSMutableArray alloc] init];
//                
//                for (int i = [arrayLight count] - 1; i >= 0; i--)
//                {
//                    if ([strStatus characterAtIndex:i] == '0')
//                    {
//                        [arrayStatus addObject:@"NO"];
//                    }
//                    else
//                    {
//                        
//                        [arrayStatus addObject:@"YES"];
//                        
//                    }
//                }
//                
//                if ([[arrayStatus objectAtIndex:lastBtn.tag - 1] boolValue])
//                {
//                    [lastBtn setImage:[UIImage imageNamed:@"plug_on"] forState:UIControlStateNormal];
//                }
//                else
//                {
//                    [lastBtn setImage:[UIImage imageNamed:@"plug_off"] forState:UIControlStateNormal];
//                }
//            }
//            break;
//        }
//            
//        default:
//            break;
//    }
//    
    
}

#pragma mark-
#pragma mark My Methords


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


-(void)addPlugListView
{
    for (int i = 0 ; i < [arrayLight count]; ++i)
    {
        
        UIView * plugView = [[UIView alloc] initWithFrame:CGRectMake(37, 20 + i * 230, 246, 210)];
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plug_bk"]];
        [plugView addSubview:bgImageView];
        [bgImageView release];
        
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 206, 20)];
        labelTitle.textAlignment = NSTextAlignmentCenter;
        labelTitle.backgroundColor = [UIColor clearColor];
        labelTitle.text = [NSString stringWithFormat:@"Plug1-%d", i + 1];
        [plugView addSubview:labelTitle];
        [labelTitle release];
        
        UIButton *btnIcon =  [UIButton buttonWithType:UIButtonTypeCustom];
        [btnIcon setFrame:CGRectMake(20, 70, 79, 79)];
        [btnIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"default_pic-0%d", i + 1]] forState:UIControlStateNormal];
        btnIcon.tag = i + 1;
        [btnIcon addTarget:self action:@selector(editIcon:) forControlEvents:UIControlEventTouchUpInside];
        [plugView addSubview:btnIcon];
        
        UIButton *btnSwitch =  [UIButton buttonWithType:UIButtonTypeCustom];
        [btnSwitch setFrame:CGRectMake(140, 75, 42, 42)];
        if ([[arrayLight objectAtIndex:i] boolValue])
        {
             [btnSwitch setImage:[UIImage imageNamed:@"plug_on"] forState:UIControlStateNormal];
        }
        else
        {
            [btnSwitch setImage:[UIImage imageNamed:@"plug_off"] forState:UIControlStateNormal];
        }

        btnSwitch.tag = i + 1;
        [btnSwitch addTarget:self action:@selector(editSwith:) forControlEvents:UIControlEventTouchUpInside];
        [plugView addSubview:btnSwitch];
        
        UILabel *labelDetails= [[UILabel alloc] initWithFrame:CGRectMake(100, 130, 125, 20)];
        labelDetails.font = [UIFont systemFontOfSize:14];
        labelDetails.textAlignment = NSTextAlignmentCenter;
        labelDetails.backgroundColor = [UIColor clearColor];
        labelDetails.text = @"消耗功率：135W";
        [plugView addSubview:labelDetails];
        [labelDetails release];
        
        
        [scrollViewPlugList addSubview:plugView];
        [plugView release];
        
        
    }
    scrollViewPlugList.scrollEnabled = YES;
    scrollViewPlugList.contentSize = CGSizeMake(320, 20 + [arrayLight count]* 230);
}


-(void)backToHome
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)editIcon:(UIButton *)btn
{
    lastBtn = btn;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"選擇一張圖片"
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:@"選擇默認圖片"
                                                   otherButtonTitles:@"從相冊選取",@"拍照",nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showInView:self.view];
}

-(void)editSwith:(UIButton *)btn
{
    lastBtn = btn;
    //[telnet telnetSetLightStatus:btn.tag withID:self.groupID];
}

@end
