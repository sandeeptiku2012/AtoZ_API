//
//  dSrchPerson.h
//  AtoZ
//
//  Created by Valtech on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dSelectState.h"
#import "GAITrackedViewController.h"

@class dRcrdVCtr;

@interface dSrchPerson : GAITrackedViewController <UITextFieldDelegate>

@property (nonatomic, assign) dRcrdVCtr *predRcrdVCtr;
@property (strong, nonatomic) IBOutlet UITextField *txtFName;
@property (strong, nonatomic) IBOutlet UITextField *txtLName;
@property (strong, nonatomic) IBOutlet UITextField *txtCity;
@property (strong, nonatomic) IBOutlet UITextField *txtState;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sgLocation;
- (IBAction)sgChanged:(id)sender;

@property (nonatomic, strong) dSelectState *nxtdSelectState;
@property (nonatomic, strong) NSString *strState;
@property (nonatomic, strong) NSString *strStateKey;
- (IBAction)btnBothTapped:(id)sender;
- (IBAction)btnBusinessesTapped:(id)sender;
- (IBAction)btnResiTapped:(id)sender;

@property (strong,nonatomic) IBOutlet UIImageView *img2Miles;
@property (strong,nonatomic) IBOutlet UIImageView *img5Miles;
@property (strong,nonatomic) IBOutlet UIImageView *img10Miles;
@property (strong,nonatomic) NSString *strMiles;
@property (strong,nonatomic) IBOutlet UILabel *lblMiles;

-(IBAction)btn10milesTapped:(id)sender;
-(IBAction)btn5milesTapped:(id)sender;
-(IBAction)btn2milesTapped:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *btnBoth;
@property (strong, nonatomic) IBOutlet UIImageView *btnBuiz;
@property (strong, nonatomic) IBOutlet UIImageView *btnResi;

@property (strong, nonatomic) IBOutlet UIButton *btnEntireUs;
@property (strong, nonatomic) IBOutlet UIButton *btnCurrentLocation;
@property (strong, nonatomic) IBOutlet UIButton *btnCity;

-(NSString*)getAdrressFromLatLong : (CGFloat)lat lon:(CGFloat)lon;
- (IBAction)EntireUsTapped:(id)sender;
- (IBAction)CurrentLocationTapped:(id)sender;
- (IBAction)CityStateTapped:(id)sender;
@end
