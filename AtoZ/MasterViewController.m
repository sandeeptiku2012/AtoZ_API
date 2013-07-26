//
//  MasterViewController.m
//  AtoZdatabases
//
//  Created by Ankit Vyas on 14/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "GAITracker.h"

@implementation MasterViewController

#define kCurrentLocationString      @"Current Location"

@synthesize detailViewController = _detailViewController;
@synthesize tabbar = _tabbar;
@synthesize mapViewLibrary = _mapViewLibrary;
@synthesize Viewmap = _Viewmap;
@synthesize VlibList = _VlibList;
@synthesize tableViewLibrary = _tableViewLibrary;
@synthesize selectedIP = _selectedIP;
@synthesize shouldLoadScrchScreenUsingCard = _shouldLoadScrchScreenUsingCard;
@synthesize arOfLibraries =_arOfLibraries;
@synthesize location = _location;
@synthesize requestedDistance = _requestedDistance;
@synthesize lblRangeMsg = _lblRangeMsg;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.trackedViewName=@"Library Listing Page";
    NSError *error = nil;
    [[GANTracker sharedTracker] trackPageview:@"Library Listing Page" withError:&error];
	NSUserDefaults *sDef = [NSUserDefaults standardUserDefaults];
    if([sDef valueForKey:@"id"] && [sDef valueForKey:@"card"] ) { 
        self.shouldLoadScrchScreenUsingCard=NO;
        [iNetMngr authenticateCard:[sDef valueForKey:@"card"] libraryAccountNo:[sDef valueForKey:@"id"] vCtrRef:self];
    } else {
        [self getNearByLibraries];
    }
	[self.tabbar setSelectedItem:[self.tabbar.items objectAtIndex:0]];
}

- (void)getNearByLibraries {
    self.shouldLoadScrchScreenUsingCard=YES;
    self.selectedIP=nil;
    [self.mapViewLibrary removeAnnotations:[self.mapViewLibrary annotations]];
    self.arOfLibraries=nil;
    [self.tableViewLibrary reloadData];
	
	if([[[UIDevice currentDevice] model] hasSuffix:@"Simulator"]) {
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
		self.shouldLoadScrchScreenUsingCard=NO;
        CLLocationCoordinate2D coOrd ; 
		
        coOrd.latitude  = 41.2039960;
        coOrd.longitude =-96.11559319999999;
        app.clatitude  = 41.2039;
        app.clongitude = -96.115;
        
        [iNetMngr startLoadingRestValue:[NSString stringWithFormat:WEB_NEAR_BY_LIB,coOrd.latitude,coOrd.longitude] vCtr:self title:@"Loading" message:@"Please wait..."];
	} else {
		self.location = [[CLLocationManager alloc] init];
		self.location.delegate = self;
		[self.location startUpdatingLocation];
	}
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
	if(item.tag == 1){
        self.Viewmap.hidden=FALSE;
		self.VlibList.hidden=TRUE;
	} else {
		self.Viewmap.hidden=TRUE;
		self.VlibList.hidden=FALSE;
	}
}

- (void)viewDidUnload {
	[self setTabbar:nil];
	[self setMapViewLibrary:nil];
	[self setViewmap:nil];
	[self setVlibList:nil];
    [self setLblRangeMsg:nil];
    [super viewDidUnload];
}

- (IBAction)infobuttonTapped:(id)sender {
   
    
	AboutVctr *abt=[[AboutVctr alloc] initWithNibName:@"AboutVctr" bundle:nil];
	UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:abt];
	nav.navigationBarHidden=YES;
	[self.navigationController presentModalViewController:nav animated:YES];
}

-(void)enterToSearchScreen:(id)sender{
	// go to search screen
	[self.navigationController pushViewController:[APP_DEL nxtTabBarCtr] animated:YES];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return  UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	AppDelegate *appdel=[[UIApplication sharedApplication] delegate];
	appdel.clatitude=newLocation.coordinate.latitude;
	appdel.clongitude=newLocation.coordinate.longitude;
	[self.location stopUpdatingLocation];

	self.location.delegate=nil;
    //self.location=nil;
    if(self.shouldLoadScrchScreenUsingCard) {
        self.shouldLoadScrchScreenUsingCard=NO;
        CLLocationCoordinate2D coOrd ; 
        coOrd = newLocation.coordinate;
		coOrd.latitude = 41.2039960;
		coOrd.longitude =-96.115593199999990;
        [iNetMngr startLoadingRestValue:[NSString stringWithFormat:WEB_NEAR_BY_LIB,coOrd.latitude,coOrd.longitude] vCtr:self title:@"Loading" message:@"Please wait..."];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    ALERT(@"Message", @"To access AtoZdatabases through this Application, enable Location Services in your settings on your iPad", @"OK", self, nil);
}
- (void)webRequestReceivedData:(NSData *)data {
    [COMMON_PARSER parseData:data];
    if( [[[iNetMngr requestObject] restValue] rangeOfString:@"authentication/account"].length>0 ) {
        COMMON_PARSER.dStatus = [[COMMON_PARSER jsonReponse] valueForKey:@"status"];
        if( [[COMMON_PARSER.dStatus valueForKey:@"message"] isEqualToString:@"Success"] && [[[COMMON_PARSER jsonReponse] valueForKey:@"valid"] boolValue] ) {
            [self performSelector:@selector(enterToSearchScreen:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.25];
        } else {
            self.location = [[CLLocationManager alloc] init];
            self.location.delegate = self;
            [self.location startUpdatingLocation];
        }
    } else {
        //NSLog(@"ok -> %@",COMMON_PARSER.jsonReponse);
        COMMON_PARSER.dStatus=[COMMON_PARSER.jsonReponse valueForKey:@"status"];
        if(![[COMMON_PARSER.dStatus valueForKey:@"message"] isKindOfClass:[NSNull class]]  &&[[COMMON_PARSER.dStatus valueForKey:@"message"] isEqualToString:@"Success"]) {
            self.arOfLibraries=[COMMON_PARSER.jsonReponse valueForKey:@"libraries"];
            self.requestedDistance = [COMMON_PARSER.jsonReponse valueForKey:@"requestedDistance"];
            self.lblRangeMsg.text = (self.arOfLibraries.count)?[NSString stringWithFormat:@"Displaying libraries within %@",self.requestedDistance]:@"No libraries found nearby your location.";
            [self.tableViewLibrary reloadData];
            [self addPins];
        } else {
        }
    }
}

#define kPinText        1
#define kTitle          2
#define kAddress        3
#define kPhone          4
#define kBackground     6
#define kBackGradient   88

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.arOfLibraries.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CCell" owner:self options:nil] objectAtIndex:0];
    }
    NSDictionary *dToAccess = [self.arOfLibraries objectAtIndex:indexPath.row];
    
    [(UILabel*)[cell viewWithTag:kPinText] setText:[NSString stringWithFormat:@"%i",indexPath.row+1]];
    [(UILabel*)[cell viewWithTag:kPinText] setTextColor:[UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1]];
    [(UILabel*)[cell viewWithTag:kTitle] setText:[dToAccess valueForKey:@"name"]];
    NSString *strAddress=[NSString stringWithFormat:@"%@, %@, %@",[dToAccess valueForKey:@"address"],[dToAccess valueForKey:@"city"],[dToAccess valueForKey:@"state"]];
    [(UILabel*)[cell viewWithTag:kAddress] setText:strAddress];
    [(UILabel*)[cell viewWithTag:kPhone] setText:([[dToAccess valueForKey:@"phoneNumber"] isKindOfClass:[NSNull class]])?@"":[dToAccess valueForKey:@"phoneNumber"]];  
    
    [(UIView*)[cell viewWithTag:kBackground] setBackgroundColor:(indexPath.row%2==0)?[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]];
    
    if(self.selectedIP && [self.selectedIP isEqual:indexPath]) {
        [(UILabel*)[cell viewWithTag:kPinText] setTextColor:[UIColor whiteColor]];
        [(UILabel*)[cell viewWithTag:kTitle] setTextColor:[UIColor colorWithRed:23/255.0 green:170/255.0 blue:232/255.0 alpha:1]];
        [(UILabel*)[cell viewWithTag:kAddress] setTextColor:[UIColor whiteColor]];
        [(UILabel*)[cell viewWithTag:kPhone] setTextColor:[UIColor whiteColor]];
        [(UIView*)[cell viewWithTag:kBackground] setBackgroundColor:[UIColor blackColor]];
        [(UIImageView*)[cell viewWithTag:kBackGradient] setHidden:NO];
    } else {
        [(UILabel*)[cell viewWithTag:kPinText] setTextColor:[UIColor whiteColor]];
        [(UILabel*)[cell viewWithTag:kTitle] setTextColor:[UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1]];
        [(UILabel*)[cell viewWithTag:kAddress] setTextColor:[UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1]];
        [(UILabel*)[cell viewWithTag:kPhone] setTextColor:[UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1]];
        [(UIView*)[cell viewWithTag:kBackground] setBackgroundColor:(indexPath.row%2==0)?[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]];
        [(UIImageView*)[cell viewWithTag:kBackGradient] setHidden:YES];
    }
    return cell;
}
    
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSError *error = nil;
    if (![[GANTracker sharedTracker] trackEvent:@"Library Selection"
                                         action:@"TrackEvent"
                                          label:[self.arOfLibraries objectAtIndex:indexPath.row]
                                          value:-1
                                      withError:&error]) {
        NSLog(@"Error Occured");
    }
    self.selectedIP=indexPath;
    [self selectSpecificPin:[self.arOfLibraries objectAtIndex:indexPath.row]];
    [self.tableViewLibrary reloadData]; 
    [self pushLibDtlVCtrWithDetails:[self.arOfLibraries objectAtIndex:self.selectedIP.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row>=self.arOfLibraries.count) {
        
    } else {
        [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:@"Library Selection"
            withAction:@"TrackEvent"
            withLabel:[self.arOfLibraries objectAtIndex:indexPath.row]
            withValue:[NSNumber numberWithInt:1]];
        
        NSError *error = nil;
        if (![[GANTracker sharedTracker] trackEvent:@"Library Selection"
        action:@"TrackEvent"
        label:[self.arOfLibraries objectAtIndex:indexPath.row]
            value:-1
            withError:&error]) {
            NSLog(@"Error Occured");
        }
        self.selectedIP=indexPath;
        [self selectSpecificPin:[self.arOfLibraries objectAtIndex:indexPath.row]];
        [self.tableViewLibrary reloadData];
		[self pushLibDtlVCtrWithDetails:[self.arOfLibraries objectAtIndex:self.selectedIP.row]];
    }
    
}

- (void)selectSpecificPin:(NSDictionary *)dToSelect {
    NSString *annotationTitle =  [dToSelect valueForKey:@"name"];
    if([[[[self.mapViewLibrary selectedAnnotations] objectAtIndex:0] title] isEqualToString:annotationTitle]) {
        return;
    }
    NSArray *arAnnotations = [self.mapViewLibrary annotations];
    for (id annotationToAccess in arAnnotations) {
        if([annotationTitle isEqualToString:[annotationToAccess title]]) {
            [self.mapViewLibrary selectAnnotation:annotationToAccess animated:YES];
            break;
        }
    }
}


#define kTagLabelPin    999

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;		
    }
    static NSString * const kPinAnnotationIdentifier2 = @"PinIdentifierOtherPins";
    MKPinAnnotationView *pin = (MKPinAnnotationView*)[self.mapViewLibrary dequeueReusableAnnotationViewWithIdentifier: kPinAnnotationIdentifier2];

    if(!pin) {
        pin=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kPinAnnotationIdentifier2];
        pin.userInteractionEnabled = YES;
        UIButton *disclosureButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [disclosureButton setFrame:CGRectMake(0, 0, 30, 30)];
        
        pin.rightCalloutAccessoryView = disclosureButton;
        pin.pinColor = MKPinAnnotationColorGreen;
        pin.animatesDrop = YES;
        [pin setEnabled:YES];
        
        
        // customize pin
        
        // add imageView
        UIImage *pinImage = [UIImage imageNamed:@"Red_bubble.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:pinImage] ;
        imageView.frame = CGRectMake(-3, -3, 23, 43);
        [pin addSubview:imageView];
        // add Lable
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(3, 0, 20, 21)];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setTextColor:[UIColor whiteColor]];
        [lbl setFont:[UIFont systemFontOfSize:17]];
        lbl.tag = kTagLabelPin;
        [pin addSubview:lbl];
        lbl.text=@"H";
        [pin setCanShowCallout:YES];
    }
    [(UILabel*)[pin viewWithTag:kTagLabelPin] setText:[NSString stringWithFormat:@"%i",1+[self indexOfTitle:[annotation title]]]];
    
    return pin;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSString *strTitle = [NSString stringWithFormat:@"%@",[view.annotation title]];
    if([strTitle isEqualToString:kCurrentLocationString]) return;
    NSArray *temp = self.arOfLibraries;
    NSDictionary *d;
    for (int i = 0; i<[temp count]; i++) {
        d = (NSDictionary*)[temp objectAtIndex:i];
        NSString *annotationTitle =  [d valueForKey:@"name"];
        if([annotationTitle isEqualToString:strTitle]) {
            self.selectedIP=[NSIndexPath indexPathForRow:[self.arOfLibraries indexOfObject:d] inSection:0];
            [self selectSpecificPin:d];
            [self.tableViewLibrary reloadData];
            PlaceMark *x=(PlaceMark*)view.annotation;
            [self performSelector:@selector(setPinToCenter:) withObject:x afterDelay:0.5];
            
            return;
        }
    }
}

- (void)setPinToCenter:(PlaceMark*)mark {
    [self.mapViewLibrary setCenterCoordinate:mark.coordinate animated:YES];
}

- (NSInteger)indexOfTitle:(NSString*)strTitle{
    for (NSDictionary *d in self.arOfLibraries) {
        if([[d valueForKey:@"name"] isEqualToString:strTitle]) {
            return [self.arOfLibraries indexOfObject:d];
        }
    }
    return -1;
}


- (void)addPins 
{
    for (NSDictionary *d in self.arOfLibraries) {
        Place* home = [[Place alloc] init];
        home.name = ([d valueForKey:@"name"] && [[d valueForKey:@"name"] length]>0)?[d valueForKey:@"name"]:@" ";
        //        home.description=[d valueForKey:@"address"];
        home.latitude = [[d valueForKey:@"lat"]floatValue];
        home.longitude = [[d valueForKey:@"lng"]floatValue];
        PlaceMark* from = [[PlaceMark alloc] initWithPlace:home];
        [self.mapViewLibrary addAnnotation:from];
    }
    [self centerMap:self.mapViewLibrary];
}

-(void) centerMap:(MKMapView*)mapView
{
    if(self.arOfLibraries.count==0 ) return;
    MKCoordinateRegion region;
    CLLocationDegrees maxLat = -90;
    CLLocationDegrees maxLon = -180;
    CLLocationDegrees minLat = 120;
    CLLocationDegrees minLon = 150;
    
    NSArray *temp = self.arOfLibraries;
    
    for (int i=0; i<[temp count];i++) {
        CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:[[[temp objectAtIndex:i] valueForKey:@"lat"]floatValue] longitude:[[[temp objectAtIndex:i] valueForKey:@"lng"]floatValue]];
        if(currentLocation.coordinate.latitude > maxLat)
            maxLat = currentLocation.coordinate.latitude;
        if(currentLocation.coordinate.latitude < minLat)
            minLat = currentLocation.coordinate.latitude;
        if(currentLocation.coordinate.longitude > maxLon)
            maxLon = currentLocation.coordinate.longitude;
        if(currentLocation.coordinate.longitude < minLon)
            minLon = currentLocation.coordinate.longitude;
        region.center.latitude     = (maxLat + minLat) / 2;
        region.center.longitude    = (maxLon + minLon) / 2;
        region.span.latitudeDelta  =  maxLat - minLat;
        region.span.longitudeDelta = maxLon - minLon;
    }
    
	
    // also count current location
    CLLocation *currentLocation = self.mapViewLibrary.userLocation.location;
    if(currentLocation.coordinate.latitude > maxLat)
        maxLat = currentLocation.coordinate.latitude;
    if(currentLocation.coordinate.latitude < minLat)
        minLat = currentLocation.coordinate.latitude;
    if(currentLocation.coordinate.longitude > maxLon)
        maxLon = currentLocation.coordinate.longitude;
    if(currentLocation.coordinate.longitude < minLon)
        minLon = currentLocation.coordinate.longitude;
    region.center.latitude     = (maxLat + minLat) / 2;
    region.center.longitude    = (maxLon + minLon) / 2;
    region.span.latitudeDelta  =  maxLat - minLat;
    region.span.longitudeDelta = maxLon - minLon;
    
    [self.mapViewLibrary setRegion:region animated:YES];
	[self.mapViewLibrary regionThatFits:region];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSString *strTitle = [NSString stringWithFormat:@"%@",[view.annotation title]];
    if([strTitle isEqualToString:kCurrentLocationString]) return;
    NSMutableDictionary *d;
    NSArray *temp = self.arOfLibraries;
    for (int i = 0; i<[temp count]; i++) {
        d = (NSMutableDictionary*)[temp objectAtIndex:i];
        NSString *strAddress =  [d valueForKey:@"name"];
        if([strAddress isEqualToString:strTitle]) {
            [self pushLibDtlVCtrWithDetails:d];
            return;
        }
    } 
}

- (void)pushLibDtlVCtrWithDetails:(NSDictionary*)d {
    if (!self.detailViewController) {
        self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    }
    
   
    
    NSString *annotationTitle =  [d valueForKey:@"name"];
    NSString *strPhone = ([[d valueForKey:@"phoneNumber"] isKindOfClass:[NSNull class]])?@"":[d valueForKey:@"phoneNumber"];
    NSString *strAddress=[NSString stringWithFormat:@"%@\n%@, %@ %@",[d valueForKey:@"address"],[d valueForKey:@"city"],[d valueForKey:@"state"], [d valueForKey:@"zip"]];
    strPhone = (strPhone.length)?strPhone:@"";
    strAddress = (strAddress.length)?strAddress:@"";
    BOOL exists=([[d valueForKey:@"libCardAccExists"] isKindOfClass:[NSNull class]])?NO:[[d valueForKey:@"libCardAccExists"] boolValue];
    self.detailViewController.strName=annotationTitle;
    self.detailViewController.strAddress = strAddress;
    self.detailViewController.strPhone=strPhone;
    self.detailViewController.exists = exists;
    self.detailViewController.fromMap = ([[self.tabbar items] indexOfObject:[self.tabbar selectedItem]]==0);
    self.detailViewController.strID = [NSString stringWithFormat:@"%i",[[d valueForKey:@"id"] intValue]];
    self.detailViewController.dOfLibrary=d;
    
    NSError *error = nil;
    if (![[GANTracker sharedTracker] trackEvent:@"Library Selection"
                                         action:@"TrackEvent"
                                          label:[d valueForKey:@"name"]
                                          value:-1
                                      withError:&error]) {
        NSLog(@"Error Occured ==>%@",error);
    }
    
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

@end
