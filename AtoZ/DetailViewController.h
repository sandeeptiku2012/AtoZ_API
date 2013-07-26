//
//  DetailViewController.h
//  AtoZdatabases
//
//  Created by Ankit Vyas on 14/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EasyTracker.h"
#import "GANTracker.h"
@class Lib_Auth_ViewController;
#import "GAITrackedViewController.h"

@interface DetailViewController : GAITrackedViewController

@property (strong, nonatomic) Lib_Auth_ViewController *lib_Auth_ViewController;
- (IBAction)BackTapped:(id)sender;
- (IBAction)LibAuthTapped:(id)sender;
- (IBAction)GetStartedTapped:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *VLibAuthCard;

@property (strong, nonatomic) IBOutlet UIView *VGet_Staryted;

@property (strong, nonatomic) NSString *strName;
@property (strong, nonatomic) NSString *strAddress;
@property (strong, nonatomic) NSString *strPhone;
@property (strong, nonatomic) NSString *strID;
@property (strong, nonatomic) NSDictionary *dOfLibrary;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblAddress;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblName;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imgVCallOut;
@property (readwrite, nonatomic) BOOL exists;
@property (readwrite, nonatomic) BOOL fromMap;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnBack;
- (IBAction)infobuttonTapped:(id)sender; 
@end
