//
//  TandHViewController.m
//  LoongYee
//
//  Created by FelixMac on 13-12-17.
//  Copyright (c) 2013年 FelixMac. All rights reserved.
//

#import "TandHViewController.h"
#import "UIBarButtonItemAdditions.h"
#import "ImageListViewController.h"
#import "Contant.h"

#define IPHONE_640_1136 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface TandHViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UIView *popEditView;
    IBOutlet UIButton *btnIcon;
    
    UIScrollView *listScrollView;
    
    UIView *popupView;
    UIView *coverView;
    CGAffineTransform initialPopupTransform;
   
}

- (IBAction)editIcon:(id)sender;
- (IBAction)cancelEdit:(id)sender;
- (IBAction)confirmEdit:(id)sender;
@end

@implementation TandHViewController

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
    self.navigationItem.title =[Contant getStringWithKey:@"T_H_TITLE"];

    UIBarButtonItemAdditions *leftItemBtn = [[UIBarButtonItemAdditions alloc] initWithMyMethodTitle: [Contant getStringWithKey:@"SWITH_BACK"] img:@"item_btn_back_bk" target:self action:@selector(backToHome) font:10];
    UIBarButtonItemAdditions *rightItemBtn = [[UIBarButtonItemAdditions alloc] initWithMyMethodTitle:[Contant getStringWithKey:@"SWITH_EDIT"]  img:@"item_btn_bk" target:self action:@selector(edit) font:-10];
    self.navigationItem.leftBarButtonItem = leftItemBtn;
    self.navigationItem.rightBarButtonItem = rightItemBtn;
    [leftItemBtn release];
    [rightItemBtn release];


    [self addIconListView];
    [self addPopupView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [popEditView release];
    [btnIcon release];
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
    [btnIcon setImage:image forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    return;
}

#pragma mark-
#pragma mark My methods

-(void)addIconListView
{
    NSInteger iOriginY = 323;
    if (IPHONE_640_1136)
    {
        iOriginY = 367;
    }
    else
    {
        iOriginY = 323;
    }
    
    listScrollView  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, iOriginY, 320, 81)];
    
    for (int i = 0 ; i < 3; ++i)
    {
        
//        UIImageView * imageView = [[UIImageView alloc]initWithImage: [UIImage imageNamed:[NSString stringWithFormat:@"default_pic-%02d" , i + 1]]];
//        
//        imageView.contentMode = UIViewContentModeScaleToFill;
//        
//        imageView.frame = CGRectMake(i*81 + 19 * (i +1), 0, 81, 81);
//        
//        
//        [listScrollView addSubview:imageView];
//        [imageView release];
        
        UIImageView * imageView = [[UIImageView alloc]initWithImage: [UIImage imageNamed:[NSString stringWithFormat:@"default_pic_3D-%02d" , i ]]];
        
        imageView.contentMode = UIViewContentModeScaleToFill;
        
        imageView.frame = CGRectMake(i*81 + 19 * (i +1), 0, 81, 81);
        
        
        [listScrollView addSubview:imageView];
        [imageView release];

        
    }
    listScrollView.scrollEnabled = NO;
    listScrollView.contentSize = CGSizeMake(81*3 + 190, 81);
    [self.view addSubview:listScrollView];
}

-(void)addPopupView
{
    popupView = [[UIView alloc] initWithFrame:popEditView.frame];
    popupView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    [popupView addSubview:popEditView];
    
    coverView = [[UIView alloc] initWithFrame:self.view.bounds];
    coverView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    coverView.backgroundColor = [UIColor colorWithRed:00/255.0 green:00/255.0 blue:00/255.0 alpha:0.5];
    [self.view addSubview:coverView];
    
    
    [coverView addSubview:popupView];
    popupView.center = CGPointMake(coverView.bounds.size.width/2, coverView.bounds.size.height/2);
    
    coverView.alpha = 0;
}

-(void)showPopView
{

    
    initialPopupTransform = popupView.transform;
    popupView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.3f
                     animations:^{
                         popupView.transform = CGAffineTransformIdentity;
                         coverView.alpha = 1;
                     }];
    

}

-(void)hidePopView
{
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         coverView.alpha = 0;
                         popupView.transform = initialPopupTransform;
                     }];
    
}

-(void)backToHome
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)edit
{
    [self showPopView];
}

- (IBAction)editIcon:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"選擇一張圖片"
                                                            delegate:self
                                                            cancelButtonTitle:@"取消"
                                                            destructiveButtonTitle:@"選擇默認圖片"
                                                            otherButtonTitles:@"從相冊選取",@"拍照",nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showInView:self.view];
}

- (IBAction)cancelEdit:(id)sender
{
    [self hidePopView];
}

- (IBAction)confirmEdit:(id)sender
{
     [self hidePopView];
}
@end
