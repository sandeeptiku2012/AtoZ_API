//
//  dLibCardNo.h
//  AtoZ
//
//  Created by Valtech on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GAITrackedViewController.h"

@class dLibVCtr;

@interface dLibCardNo : GAITrackedViewController <UIAlertViewDelegate,UITextFieldDelegate>

@property (nonatomic,assign) dLibVCtr *predLibVCtr;

@property (strong, nonatomic) IBOutlet UITextField *txtLCard;

@property (strong, nonatomic) IBOutlet UILabel *lblAlert;
@property (strong, nonatomic) IBOutlet UILabel *lblAlertMsg;

- (IBAction)saveTapped:(id)sender;

@end
