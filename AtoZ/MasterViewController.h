//
//  MasterViewController.h
//  AtoZdatabases
//
//  Created by Ankit Vyas on 14/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Place.h"
#import "PlaceMark.h"
#import "EasyTracker.h"
#import "GANTracker.h"
#import "GAITrackedViewController.h"

@class DetailViewController;

@interface MasterViewController : GAITrackedViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) IBOutlet UITabBar *tabbar;
@property (strong, nonatomic) IBOutlet UIView *Viewmap;
@property (strong, nonatomic) IBOutlet UIView *VlibList;


@property (strong, nonatomic) IBOutlet MKMapView *mapViewLibrary;
@property (strong, nonatomic) IBOutlet UITableView *tableViewLibrary;

@property (strong, nonatomic) NSIndexPath *selectedIP;
@property (nonatomic,readwrite) BOOL shouldLoadScrchScreenUsingCard;
@property (nonatomic, strong) NSArray *arOfLibraries;

@property (strong, nonatomic) CLLocationManager *location;

@property (strong, nonatomic) NSString *requestedDistance;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblRangeMsg;

- (IBAction)infobuttonTapped:(id)sender;

-(void)enterToSearchScreen:(id)sender;
- (IBAction)infobuttonTapped:(id)sender;
- (void)getNearByLibraries;
- (void)selectSpecificPin:(NSDictionary *)dToSelect;
- (NSInteger)indexOfTitle:(NSString*)strTitle;
- (void)addPins ;
- (void) centerMap:(MKMapView*)mapView;
- (void)pushLibDtlVCtrWithDetails:(NSDictionary*)d ;
@end
