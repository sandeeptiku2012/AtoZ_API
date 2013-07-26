//
//  BusinessViewController.h
//  AtoZdatabases
//
//  Created by Ankit Vyas on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STControls.h"
#import <QuartzCore/QuartzCore.h>
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
#import "ResultViewController.h"
#import "AppDelegate.h"
#import "GAITrackedViewController.h"


@class TabBarCtr;
@class ResultViewController;

@interface BusinessViewController : GAITrackedViewController <UITextFieldDelegate,STComboTextDelegate,ASIHTTPRequestDelegate>{
	BOOL isBackFromSearchPage;
}

@property (assign, nonatomic) IBOutlet TabBarCtr *preTabBarCtr;
@property (strong,nonatomic) IBOutlet UIButton *btnSearch;
@property (nonatomic,strong)AppDelegate *appdel;
@property (strong,nonatomic) ResultViewController *nxtResultViewController;
@property (strong, nonatomic) IBOutlet UITextField *txtBName;
@property (strong, nonatomic) IBOutlet UITextField *txtCity;
@property (strong, nonatomic) IBOutlet STComboText *txtState;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sgBusinessRange;
@property (strong, nonatomic) IBOutlet UIImageView *imgVChck;
@property (strong,nonatomic)NSDictionary *dForSearch;
@property (nonatomic, strong) NSString *strState;
@property (nonatomic, strong) NSString *strStateKey;
@property (strong, nonatomic) IBOutlet UIButton *btnEntireUs;
@property (strong, nonatomic) IBOutlet UIButton *btnCurrentLocation;
@property (strong, nonatomic) IBOutlet UIButton *btnCity;
@property (strong, nonatomic) IBOutlet UIView *vHide;
@property (strong,nonatomic) NSString *strMiles;
@property (strong,nonatomic) IBOutlet UILabel *lblMiles;

@property (strong,nonatomic) IBOutlet UIImageView *img2miles;
@property (strong,nonatomic) IBOutlet UIImageView *img5miles;
@property (strong,nonatomic) IBOutlet UIImageView *img10miles;

-(IBAction)btn2milesTapped:(id)sender;
-(IBAction)btn5milesTapped:(id)sender;
-(IBAction)btn10milesTapped:(id)sender;

- (IBAction)SearchBusinessTapped:(id)sender;
- (IBAction)CurrentLocationTapped:(id)sender;
- (IBAction)EntireUsTapped:(id)sender;

- (IBAction)sgChanged:(id)sender;
- (IBAction)btnStateTapped:(id)sender;
- (IBAction)btnHQTapped:(id)sender;

@property (nonatomic, strong) ASINetworkQueue *nQ;
- (NSString*)getAdrressFromLatLong : (CGFloat)lat lon:(CGFloat)lon;
- (void)createToken;
-(IBAction)searchTapped:(id)sender ;

@end
