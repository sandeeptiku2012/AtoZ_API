//
//  dSrchBusiness.h
//  AtoZ
//
//  Created by Valtech on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dSelectState.h"
#import "GAITrackedViewController.h"

@class dRcrdVCtr;

@interface dSrchBusiness : GAITrackedViewController <UITextFieldDelegate>

@property (nonatomic, assign) dRcrdVCtr *predRcrdVCtr;

@property (strong, nonatomic) IBOutlet UITextField *txtBName;
@property (strong, nonatomic) IBOutlet UITextField *txtCity;
@property (strong, nonatomic) IBOutlet UITextField *txtState;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sgBusinessRange;
@property (strong, nonatomic) IBOutlet UIImageView *imgVChck;
@property (strong,nonatomic) IBOutlet UIImageView *img2Miles;
@property (strong,nonatomic) IBOutlet UIImageView *img5Miles;
@property (strong,nonatomic) IBOutlet UIImageView *img10Miles;
@property (strong,nonatomic) NSString *strMiles;
@property (strong,nonatomic) IBOutlet UILabel *lblMiles;
@property (nonatomic, strong) dSelectState *nxtdSelectState;
@property (nonatomic, strong) NSString *strState;
@property (nonatomic, strong) NSString *strStateKey;
@property (strong, nonatomic) IBOutlet UIButton *btnEntireUs;
@property (strong, nonatomic) IBOutlet UIButton *btnCurrentLocation;
@property (strong, nonatomic) IBOutlet UIButton *btnCity;
- (IBAction)SearchBusinessTapped:(id)sender;
- (IBAction)CurrentLocationTapped:(id)sender;
- (IBAction)EntireUsTapped:(id)sender;
-(IBAction)btn10milesTapped:(id)sender;
-(IBAction)btn5milesTapped:(id)sender;
-(IBAction)btn2milesTapped:(id)sender;


- (IBAction)sgChanged:(id)sender;
- (IBAction)btnStateTapped:(id)sender;
- (IBAction)btnHQTapped:(id)sender;

- (NSString*)getAdrressFromLatLong : (CGFloat)lat lon:(CGFloat)lon;

- (void)createToken;

@end
