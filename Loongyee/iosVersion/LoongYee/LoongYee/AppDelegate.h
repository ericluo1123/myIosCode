//
//  AppDelegate.h
//  LoongYee
//
//  Created by FelixMac on 13-12-6.
//  Copyright (c) 2013年 FelixMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLNavigationController.h"
#import "SwitchsViewController.h"
#import "StudyViewController.h"
#import "SwitchsViewCell.h"
#import "Contant.h"
//#define URL_SERVICE              @"http://192.168.1.123:8097/API/LyAPI/Device.aspx?"
#define URL_SERVICE              @"http://192.168.103.1/cgi-bin/"
#define TestTAG             0//用来区分本地服务和客户服务，1为本地
#define Setting_Version     @"0.9 beta build 07"

#define IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface AppDelegate : UIResponder <UIApplicationDelegate>
 
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, assign) enum MulLanguage eCurLanguage;
@property (strong, nonatomic) SwitchsViewController * SwitchsView;
@property (strong, nonatomic) StudyViewController * StudyView;
@property (strong, nonatomic) SwitchsViewCell * SwitchsCellView;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (void)SetSwitchsViewController:(SwitchsViewController*)SwitchsView;
+(SwitchsViewController*)GetSwitchsViewController;

+ (void)SetStudyViewController:(StudyViewController*)StudyView;
+(StudyViewController*)GetStudyViewController;

+ (void)SetSwitchsCellView:(StudyViewController*)SwitchsCellView;
+(StudyViewController*)GetSwitchsCellView;

//獲取當前使用的語言
+ (enum MulLanguage)GetCurrentLanguage;
@end
