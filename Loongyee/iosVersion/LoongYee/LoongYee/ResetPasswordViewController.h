//
//  ResetPasswordViewController.h
//  LoongYee
//
//  Created by FelixMac on 13-12-25.
//  Copyright (c) 2013年 FelixMac. All rights reserved.
//

#import <UIKit/UIKit.h>
enum
{
    RESET_CONNECT_PASSWORD,
    RESET_USER_PASSWORD
    
};
@interface ResetPasswordViewController : UIViewController
{
    
}
- (IBAction)TextFiedReturnEditing:(id)sender;
@property (nonatomic, assign) int indexType;
@end
