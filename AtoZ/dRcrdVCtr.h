//
//  dRcrdVCtr.h
//  AtoZ
//
//  Created by Valtech on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GAITrackedViewController.h"

#import "HJManagedImageV.h"

#import "Place.h"
#import "PlaceMark.h"

#import "dSrchBusiness.h"
#import "dSrchPerson.h"
#import "dSrchCategory.h"
#import "dSrchPhone.h"

#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"

#import "dNewAboutVCtr.h"

@class dLibVCtr;
@class dResultDtlVCtr;
@class dResdRcrdDtlVCtr;

@interface dRcrdVCtr : GAITrackedViewController  <UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate,ASIHTTPRequestDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) dNewAboutVCtr *nxtdNewAboutVCtr;

@property (nonatomic, strong) NSString *imgPath; //used for Logo Customer Library
@property (nonatomic, strong) NSString *strLibraryName; // used for customer name;
@property (nonatomic, assign) dLibVCtr *predLibVCtr;
@property (strong, nonatomic) IBOutlet HJManagedImageV *imgVLibLogo;
@property (nonatomic, strong) ASINetworkQueue *nQ;

// left side search related
@property (strong, nonatomic) IBOutlet UIView *vLeft;
@property (nonatomic, strong) NSArray *arOfRecords;
@property (nonatomic, strong) NSMutableArray *arOfFilteredRcrds;
@property (strong, nonatomic) IBOutlet UITableView *tableViewRecords;
@property (strong, nonatomic) IBOutlet UILabel *lblRecordsTitle;
@property (strong, nonatomic) IBOutlet UISearchBar *tableSrchBar;
@property (strong, nonatomic) NSIndexPath *selectedIP;
@property (readwrite, nonatomic) NSUInteger totalRecords;
@property (strong, nonatomic) NSNumber *numberFrom;
@property (strong, nonatomic) NSNumber *numberTo;
@property (readwrite, nonatomic) BOOL isSearching;

@property (strong, nonatomic) IBOutlet UIView *vRight;
@property (strong, nonatomic) IBOutlet MKMapView *mapViewRecords;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sgNextPrev;

@property (strong, nonatomic) IBOutlet UIView *vDtl;
@property (strong, nonatomic) IBOutlet UILabel *lblFullName;
@property (strong, nonatomic) IBOutlet UITextView *txtDetails;

// popOvers & search Options
@property (strong, nonatomic) UIPopoverController *pVCtr;
@property (strong, nonatomic) UINavigationController *nvCtr;
@property (strong, nonatomic) dSrchBusiness *nxtdSrchBusiness;
@property (strong, nonatomic) dSrchPerson *nxtdSrchPerson;
@property (strong, nonatomic) dSrchCategory *nxtdSrchCategory;
@property (strong, nonatomic) dSrchPhone *nxtdSrchPhone;
@property (strong, nonatomic) dResultDtlVCtr *nxtdResultDtlVCtr;
@property (strong, nonatomic) dResdRcrdDtlVCtr *nxtdResdRcrdDtlVCtr;
//@property (strong, nonatomic) NSString *strCategory;
@property (strong, nonatomic) NSDictionary *dForSearch;

@property (strong, nonatomic) IBOutlet UIToolbar *tBarNextPre;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barBtnBusiness;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barBtnPerson;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barBtnCategory;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barBtnPhone;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barBtnSettings;
@property (strong, nonatomic) IBOutlet UILabel *lblCustomerLogo;
@property (strong, nonatomic) IBOutlet UIButton *btnBusinessHidden;
@property (strong, nonatomic) IBOutlet UIButton *btnSearchbyPhone;
@property (strong, nonatomic) IBOutlet UIButton *btnSearchbycategory;
@property (strong, nonatomic) IBOutlet UIButton *btnSearchbyPerson;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnInnerSettings;

// array for cities
@property (nonatomic, strong) NSArray *arForStates;

@property (nonatomic, readwrite) BOOL isFetchingStates;
@property (nonatomic, readwrite) BOOL isFetchingRecords;
@property (nonatomic, readwrite) BOOL isLoginUsingSession;

- (void)centerMap:(MKMapView*)mapView;
- (void)addPins;
- (void)selectSpecificPin:(NSDictionary *)dToSelect;
- (void)setupRecordsResponse;
- (void)createToken;
- (void)resetProcess;

- (IBAction)sgChangedSrchOpt:(UISegmentedControl*)sender;
- (IBAction)sgNxtPrePage:(id)sender;
//- (IBAction)settingsTapped:(id)sender;
- (IBAction)btnSettingsTapped:(id)sender;
- (IBAction)btnByPhoneTapped:(id)sender;
- (IBAction)btnByCategoryTapped:(id)sender;
- (IBAction)btnPersonTapped:(id)sender;
- (IBAction)btnBusinessTapped:(id)sender;
- (IBAction)btnInfoTapped:(id)sender;

@property (strong, nonatomic) IBOutlet UISegmentedControl *sgSearchOptions;

@end
