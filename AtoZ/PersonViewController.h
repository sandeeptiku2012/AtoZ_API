//
//  PersonViewController.h
//  AtoZdatabases
//
//  Created by Ankit Vyas on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STControls.h"
#import "ResultViewController.h"
#import "AppDelegate.h"
#import "GAITrackedViewController.h"


@class TabBarCtr;
@class ResultViewController;
@interface PersonViewController : GAITrackedViewController <STComboTextDelegate>{
	BOOL isBackFromSearchPage;
}
@property (nonatomic,strong) ResultViewController *nxtResultViewController;
@property (nonatomic,strong)AppDelegate *appdel;
@property (assign, nonatomic) IBOutlet TabBarCtr *preTabBarCtr;
@property (strong, nonatomic) IBOutlet UIView *vHide;
@property (strong, nonatomic) IBOutlet UITextField *txtFName;
@property (strong, nonatomic) IBOutlet UITextField *txtLName;
@property (strong, nonatomic) IBOutlet UITextField *txtCity;
@property (strong, nonatomic) IBOutlet STComboText *txtState;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sgLocation;


@property (strong,nonatomic) IBOutlet UIImageView *img2miles;
@property (strong,nonatomic) IBOutlet UIImageView *img5miles;
@property (strong,nonatomic) IBOutlet UIImageView *img10miles;
@property (strong,nonatomic) IBOutlet UILabel *lblMiles;
@property (strong,nonatomic) NSString *strMiles;



-(IBAction)btn2milesTapped:(id)sender;
-(IBAction)btn5milesTapped:(id)sender;
-(IBAction)btn10milesTapped:(id)sender;

- (IBAction)sgChanged:(id)sender;

@property (nonatomic, strong) NSString *strState;
@property (nonatomic, strong) NSString *strStateKey;
- (IBAction)btnBothTapped:(id)sender;
- (IBAction)btnBusinessesTapped:(id)sender;
- (IBAction)btnResiTapped:(id)sender;

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
-(IBAction)searchTapped:(id)sender;
@end
