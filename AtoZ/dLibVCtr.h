//
//  dLibVCtr.h
//  AtoZ
//
//  Created by Valtech on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "dLibCardNo.h"
#import "dRcrdVCtr.h"
#import "Place.h"
#import "PlaceMark.h"
#import "DDAnnotation.h"
#import "DDAnnotationView.h"
#import "GAITrackedViewController.h"
#import "dNewAboutVCtr.h"

@interface dLibVCtr : GAITrackedViewController <UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) NSString *strZip;
@property (nonatomic, readwrite) BOOL isViewLoaded;
@property (strong, nonatomic) IBOutlet UIView *vLeft;
@property (nonatomic, strong) NSArray *arOfLibraries;
@property (strong, nonatomic) IBOutlet UITableView *tableViewLibrary;

@property (strong, nonatomic) IBOutlet UIView *vRight;
@property (strong, nonatomic) IBOutlet MKMapView *mapViewLibrary;
@property (strong, nonatomic) dNewAboutVCtr *nxtdNewAboutVCtr;
@property (strong, nonatomic) DDAnnotation *annotation;
@property (strong, nonatomic) NSIndexPath *selectedIP;


@property (strong, nonatomic) IBOutlet UIView *vDtl;
@property (strong, nonatomic) IBOutlet UIView *vSelectLibrary;

@property (strong, nonatomic) IBOutlet UILabel *lblEnterLibCard;
@property (strong, nonatomic) IBOutlet UILabel *lblEnterLibCard2;
@property (strong, nonatomic) IBOutlet UILabel *lblGetStarted;
@property (strong, nonatomic) IBOutlet UILabel *lblGetStarted2;
@property (strong, nonatomic) IBOutlet UILabel *lblEnterCardBG;
@property (strong, nonatomic) IBOutlet UILabel *lblGetStartedBG;
@property (strong, nonatomic) IBOutlet UIImageView *imgVCallOut;
@property (strong, nonatomic) IBOutlet UILabel *lblCallout;
@property (strong, nonatomic) IBOutlet UIImageView *imgVArrowEnterCard;
@property (strong, nonatomic) IBOutlet UIButton *btnEnterCardText;

@property (strong, nonatomic) IBOutlet UILabel *lblLibraryTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnEnterCard;

@property (strong, nonatomic) UIPopoverController *pVCtr;
@property (strong, nonatomic) dLibCardNo *nxtdLibCardNo;
@property (strong, nonatomic) dRcrdVCtr *nxtdRcrdVCtr;
@property (strong, nonatomic) NSString *requestedDistance;

@property (nonatomic,readwrite) BOOL exists;
@property (nonatomic,readwrite) BOOL shouldLoadScrchScreenUsingCard;

@property (strong, nonatomic) CLLocationManager *location;

- (IBAction)btnShowHideTapped:(id)sender;

- (void)centerMap:(MKMapView*)mapView;
- (void)addPins;
- (NSInteger)indexOfTitle:(NSString*)strTitle;
- (void)selectSpecificPin:(NSDictionary *)dToSelect;
- (void)getNearByLibraries ;

- (void)enterToSearchScreen:(id)sender;

- (IBAction)btnEnterCardTapped:(id)sender;
- (IBAction)btnGetStartedTapped:(id)sender;
- (IBAction)btnInfoTapped:(id)sender;
- (IBAction)btnSettingsTapped:(id)sender;

- (void)checkForEnterLibCardToDisplayOrNot;
- (void)hideCallout_OrNot ;
@end
