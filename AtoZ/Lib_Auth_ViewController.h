//
//  Lib_Auth_ViewController.h
//  AtoZdatabases
//
//  Created by Ankit Vyas on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarCtr.h"
#import "GAITrackedViewController.h"
@interface Lib_Auth_ViewController : GAITrackedViewController <UIAlertViewDelegate,UITextFieldDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblAddress;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet TabBarCtr *nxtTabBarCtr;

@property (strong, nonatomic) IBOutlet UIView *Vauth;
@property (strong, nonatomic) IBOutlet UITextField *txtLCard;
@property (strong, nonatomic) IBOutlet UILabel *lblAlert;
@property (strong, nonatomic) IBOutlet UILabel *lblAlertMsg;

@property (strong, nonatomic) NSString *strName;
@property (strong, nonatomic) NSString *strAddress;
@property (strong, nonatomic) NSString *strPhone;
@property (strong, nonatomic) NSString *strID;
@property (strong, nonatomic) NSDictionary *dforLibrary;

- (IBAction)saveTapped:(id)sender;
- (IBAction)btnBackTapped:(id)sender;
- (IBAction)infobuttonTapped:(id)sender ;
@end
