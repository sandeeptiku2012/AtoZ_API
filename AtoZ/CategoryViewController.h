//
//  CategoryViewController.h
//  AtoZdatabases
//
//  Created by Ankit Vyas on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STControls.h"
#import <QuartzCore/QuartzCore.h>
#import "dSelectState.h"
#import "AppDelegate.h"
#import "GAITrackedViewController.h"

@class ResultViewController;

@interface CategoryViewController : GAITrackedViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,STComboTextDelegate,UIScrollViewDelegate>{
	BOOL isBackFromSearchPage;
}

@property (nonatomic,strong) ResultViewController *nxtResultViewController;
@property (nonatomic,strong)AppDelegate *appdel;
@property (assign, nonatomic) IBOutlet TabBarCtr *preTabBarCtr;
@property (strong, nonatomic) IBOutlet UIView *vHide;
@property(strong,nonatomic)NSArray *arForCategory;

@property (strong, nonatomic) IBOutlet UITextField *txtCCategory;
@property (strong, nonatomic) IBOutlet UITextField *txtCity;
@property (strong, nonatomic) IBOutlet STComboText *txtState;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sgLocation;
@property (strong, nonatomic) IBOutlet UITableView *tblCategories;
@property (nonatomic,strong) NSIndexPath *selectedIP;

@property (nonatomic, strong) NSString *strState;
@property (nonatomic, strong) NSString *strStateKey;
@property (strong, nonatomic) IBOutlet UIScrollView *scrMain;

@property (strong, nonatomic) IBOutlet UIButton *btnEntireUs;
@property (strong, nonatomic) IBOutlet UIButton *btnCurrentLocation;
@property (strong, nonatomic) IBOutlet UIButton *btnCity;

@property (strong,nonatomic) IBOutlet UIImageView *img2miles;
@property (strong,nonatomic) IBOutlet UIImageView *img5miles;
@property (strong,nonatomic) IBOutlet UIImageView *img10miles;
@property (strong,nonatomic) IBOutlet UILabel *lblMiles;
@property (strong,nonatomic) NSString *strMiles;

-(IBAction)btn2milesTapped:(id)sender;
-(IBAction)btn5milesTapped:(id)sender;
-(IBAction)btn10milesTapped:(id)sender;


- (IBAction)sgChanged:(id)sender;
//- (IBAction)btnStateTapped:(id)sender ;

-(NSString*)getAdrressFromLatLong : (CGFloat)lat lon:(CGFloat)lon;
- (IBAction)EntireUsTapped:(id)sender;
- (IBAction)CurrentLocationTapped:(id)sender;
- (IBAction)CityStateTapped:(id)sender;
-(IBAction)searchTapped:(id)sender;
@end
