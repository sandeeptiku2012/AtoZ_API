//
//  dLibVCtr.m
//  AtoZ
//
//  Created by Valtech on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

//"lat" : 34.05069270,
//"lng" : -118.25947620

#import "dLibVCtr.h"

@implementation dLibVCtr

@synthesize location = _location;

@synthesize strZip = _strZip;
@synthesize isViewLoaded = _isViewLoaded;

@synthesize arOfLibraries = _arOfLibraries;
@synthesize tableViewLibrary = _tableViewLibrary;
@synthesize mapViewLibrary = _mapViewLibrary;
@synthesize vLeft = _vLeft;
@synthesize vRight = _vRight;
@synthesize annotation = _annotation;
@synthesize selectedIP = _selectedIP;
@synthesize vDtl = _vDtl;
@synthesize vSelectLibrary = _vSelectLibrary;
@synthesize lblEnterLibCard = _lblEnterLibCard;
@synthesize lblEnterLibCard2 = _lblEnterLibCard2;
@synthesize lblGetStarted = _lblGetStarted;
@synthesize lblGetStarted2 = _lblGetStarted2;
@synthesize lblEnterCardBG = _lblEnterCardBG;
@synthesize lblGetStartedBG = _lblGetStartedBG;
@synthesize imgVCallOut = _imgVCallOut;
@synthesize lblCallout = _lblCallout;
@synthesize imgVArrowEnterCard = _imgVArrowEnterCard;
@synthesize btnEnterCard = _btnEnterCard;
@synthesize lblLibraryTitle = _lblLibraryTitle;
@synthesize nxtdNewAboutVCtr = _nxtdNewAboutVCtr;
@synthesize lblAddress = _lblAddress;
@synthesize btnEnterCardText = _btnEnterCardText;

@synthesize pVCtr = _pVCtr;
@synthesize nxtdLibCardNo = _nxtdLibCardNo;
@synthesize nxtdRcrdVCtr = _nxtdRcrdVCtr;
@synthesize requestedDistance = _requestedDistance;

@synthesize exists = _exists;
@synthesize shouldLoadScrchScreenUsingCard = _shouldLoadScrchScreenUsingCard;


#define kCurrentLocationString      @"Current Location"

- (void)setDisplaySearch {
    if(!self.selectedIP) {
        self.vSelectLibrary.hidden=NO;
    } else {
        self.vSelectLibrary.hidden=YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
    self.trackedViewName=@"iPad Library Listing Page";

    NSError *error = nil;
    [[GANTracker sharedTracker] trackPageview:@"iPad Library Listing Page" withError:&error];
    self.isViewLoaded=YES;
    self.nxtdLibCardNo = [[dLibCardNo alloc] initWithNibName:@"dLibCardNo" bundle:nil];
    self.pVCtr=[[UIPopoverController alloc] initWithContentViewController:self.nxtdLibCardNo];
    self.selectedIP=nil;
    [self setDisplaySearch];
    self.lblGetStartedBG.layer.borderColor=[[UIColor blackColor]CGColor];
    self.lblGetStartedBG.layer.cornerRadius=4;
    self.lblGetStartedBG.layer.borderWidth=1;
    self.lblEnterCardBG.layer.borderColor=[[UIColor blackColor]CGColor];
    self.lblEnterCardBG.layer.cornerRadius=4;
    self.lblEnterCardBG.layer.borderWidth=1;
    
    NSUserDefaults *sDef = [NSUserDefaults standardUserDefaults];
    if([sDef valueForKey:@"id"] && [sDef valueForKey:@"card"] ) { 
        self.shouldLoadScrchScreenUsingCard=NO;
        [iNetMngr authenticateCard:[sDef valueForKey:@"card"] libraryAccountNo:[sDef valueForKey:@"id"] vCtrRef:self];
    } else {
        [self getNearByLibraries];
    }
}

- (void)getNearByLibraries {
    self.shouldLoadScrchScreenUsingCard=YES;
    self.selectedIP=nil;
    [self setDisplaySearch];
    [self performSelector:@selector(btnShowHideTapped:) withObject:nil afterDelay:0.25];
    [self.mapViewLibrary removeAnnotations:[self.mapViewLibrary annotations]];
    self.arOfLibraries=nil;
    [self.tableViewLibrary reloadData];
	
	if([[[UIDevice currentDevice] model] hasSuffix:@"Simulator"]) {
		self.shouldLoadScrchScreenUsingCard=NO;
        CLLocationCoordinate2D coOrd ; 
        coOrd.latitude = 41.25844955444335937500;
        coOrd.longitude = -95.93585968017578125000;
        [iNetMngr startLoadingRestValue:[NSString stringWithFormat:WEB_NEAR_BY_LIB,coOrd.latitude,coOrd.longitude] vCtr:self title:@"Loading" message:@"Please wait..."];
	} else {
		self.location = [[CLLocationManager alloc] init];
		self.location.delegate = self;
		[self.location startUpdatingLocation];
	}
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.location.delegate=nil;
    self.location=nil;
    if(self.shouldLoadScrchScreenUsingCard) {
        self.shouldLoadScrchScreenUsingCard=NO;
        CLLocationCoordinate2D coOrd ; 
        //coOrd = newLocation.coordinate;
        //coOrd.latitude = 41.25844955444335937500;
        //coOrd.longitude = -95.93585968017578125000;
        
        coOrd.latitude = 41.2039960;
		coOrd.longitude =-96.115593199999990;
        
        [iNetMngr startLoadingRestValue:[NSString stringWithFormat:WEB_NEAR_BY_LIB,coOrd.latitude,coOrd.longitude] vCtr:self title:@"Loading" message:@"Please wait..."];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    ALERT(@"Message", @"To access AtoZdatabases through this Application, enable Location Services in your settings on your iPad", @"OK", self, nil);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


-(void)getAdrressFromLatLong : (CGFloat)lat lon:(CGFloat)lon{
    NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=false",lat,lon];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    NSURLResponse *response = nil;
    NSError *requestError = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    NSString *responseString = [[NSString alloc] initWithData: responseData encoding:NSUTF8StringEncoding];
    
    if ([responseString length]>0) {
        
        if ([[[responseString JSONValue] valueForKey:@"status"] isEqualToString:@"OK"] ) {
            NSArray *resultsArray = [[responseString JSONValue] valueForKey:@"results"];
            NSString *zip = nil;
            
            if ([resultsArray count]>0) {
                NSArray *resultComponents = [[resultsArray objectAtIndex:0] valueForKey:@"address_components"];
                for (NSDictionary *dForComponents in resultComponents) {
                    if([[dForComponents valueForKey:@"types"] containsObject:@"postal_code"]) {
                        zip = [dForComponents valueForKey:@"long_name"];
                    }
                }
            }
            if(zip && zip.length>0){
                self.strZip=zip;
            } else {
                self.strZip=@"68137";
            }
            [iNetMngr getNearByLibraries:self zipCode:self.strZip];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle: @"Message"
                                                               message: @"No libraries found nearby your location"
                                                              delegate:nil
                                                     cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
            [alertView show];
        }
    }
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
            [self.tableViewLibrary reloadData];
            [self addPins];
        } else {
        }
    }
}

- (void)viewDidUnload
{
    [self setTableViewLibrary:nil];
    [self setMapViewLibrary:nil];
    [self setVLeft:nil];
    [self setVRight:nil];
    [self setLblEnterLibCard:nil];
    [self setLblEnterLibCard2:nil];
    [self setLblGetStarted:nil];
    [self setLblGetStarted2:nil];
    [self setLblLibraryTitle:nil];
    [self setLblAddress:nil];
    [self setVDtl:nil];
    [self setLblEnterCardBG:nil];
    [self setLblGetStartedBG:nil];
    [self setNxtdLibCardNo:nil];
    [self setPVCtr:nil];
    [self setNxtdRcrdVCtr:nil];
    [self setBtnEnterCard:nil];
    [self setImgVCallOut:nil];
    [self setStrZip:nil];
    [self setBtnEnterCard:nil];
    [self setImgVArrowEnterCard:nil];
    [self setNxtdNewAboutVCtr:nil];
    [self setVSelectLibrary:nil];
    [self setLblCallout:nil];
    [super viewDidUnload];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)hideCallout_OrNot {
     NSDictionary *dToSelect = [self.arOfLibraries objectAtIndex:self.selectedIP.row];
    NSString *strPhone = ([[dToSelect valueForKey:@"phoneNumber"] isKindOfClass:[NSNull class]])?@"":[dToSelect valueForKey:@"phoneNumber"];
    
    if(!strPhone || [strPhone isKindOfClass:[NSNull class]] || [strPhone length]==0 ) {
        self.imgVCallOut.hidden=YES;
    } else {
        self.imgVCallOut.hidden=NO;
    }
}

#ifdef IOS_OLDER_THAN__IPHONE_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation)toInterfaceOrientation
{
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        self.lblGetStarted.hidden=self.lblEnterLibCard2.hidden=self.lblGetStarted2.hidden=self.lblEnterLibCard.hidden=NO;
        self.lblEnterCardBG.hidden=
        self.lblEnterLibCard.hidden=
        self.lblEnterLibCard2.hidden= !(self.exists);
        self.lblCallout.hidden=NO;
        self.imgVCallOut.hidden=NO;
        [self hideCallout_OrNot];
    } else {
        self.lblGetStarted.hidden=self.lblEnterLibCard2.hidden=self.lblGetStarted2.hidden=self.lblEnterLibCard.hidden=NO;
        self.lblCallout.hidden=YES;
        self.imgVCallOut.hidden=YES;
    }
    
    if(self.selectedIP) {
        BOOL isLandscape = UIInterfaceOrientationIsLandscape(self.interfaceOrientation);
        NSUInteger x = isLandscape?505:661;
        self.vDtl.frame = CGRectMake(0, x, self.vDtl.frame.size.width, isLandscape?200:300);
    } else {
        BOOL isLandscape = UIInterfaceOrientationIsLandscape(self.interfaceOrientation);
        NSUInteger x = isLandscape?680:935;
        self.vDtl.frame = CGRectMake(0, x, self.vDtl.frame.size.width, isLandscape?200:300);
    }
    
    [self checkForEnterLibCardToDisplayOrNot];
	return YES;
}
#endif

#ifdef IOS_NEWER_OR_EQUAL_TO__IPHONE_6_0
-(BOOL)shouldAutorotate
{
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        self.lblGetStarted.hidden=self.lblEnterLibCard2.hidden=self.lblGetStarted2.hidden=self.lblEnterLibCard.hidden=NO;
        self.lblEnterCardBG.hidden=
        self.lblEnterLibCard.hidden=
        self.lblEnterLibCard2.hidden= !(self.exists);
        self.lblCallout.hidden=NO;
        self.imgVCallOut.hidden=NO;
        [self hideCallout_OrNot];
    } else {
        self.lblGetStarted.hidden=self.lblEnterLibCard2.hidden=self.lblGetStarted2.hidden=self.lblEnterLibCard.hidden=NO;
        self.lblCallout.hidden=YES;
        self.imgVCallOut.hidden=YES;
    }
    
    if(self.selectedIP) {
        BOOL isLandscape = UIInterfaceOrientationIsLandscape(self.interfaceOrientation);
        NSUInteger x = isLandscape?505:661;
        self.vDtl.frame = CGRectMake(0, x, self.vDtl.frame.size.width, isLandscape?200:300);
    } else {
        BOOL isLandscape = UIInterfaceOrientationIsLandscape(self.interfaceOrientation);
        NSUInteger x = isLandscape?680:935;
        self.vDtl.frame = CGRectMake(0, x, self.vDtl.frame.size.width, isLandscape?200:300);
    }
    
    [self checkForEnterLibCardToDisplayOrNot];
	return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskAll);
}
#endif

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    if(UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
//        self.lblGetStarted.hidden=self.lblEnterLibCard2.hidden=self.lblGetStarted2.hidden=self.lblEnterLibCard.hidden=NO;
//        self.lblEnterCardBG.hidden=
//        self.lblEnterLibCard.hidden=
//        self.lblEnterLibCard2.hidden= !(self.exists);
//        self.lblCallout.hidden=NO;
//        self.imgVCallOut.hidden=NO;
//        [self hideCallout_OrNot];
//    } else {
//        self.lblGetStarted.hidden=self.lblEnterLibCard2.hidden=self.lblGetStarted2.hidden=self.lblEnterLibCard.hidden=NO;
//        self.lblCallout.hidden=YES;
//        self.imgVCallOut.hidden=YES;
//    }
//    
//    if(self.selectedIP) {
//        BOOL isLandscape = UIInterfaceOrientationIsLandscape(interfaceOrientation); 
//        NSUInteger x = isLandscape?505:661;
//        self.vDtl.frame = CGRectMake(0, x, self.vDtl.frame.size.width, isLandscape?200:300);
//    } else {
//        BOOL isLandscape = UIInterfaceOrientationIsLandscape(interfaceOrientation); 
//        NSUInteger x = isLandscape?680:935;
//        self.vDtl.frame = CGRectMake(0, x, self.vDtl.frame.size.width, isLandscape?200:300);
//    }
//    
//    [self checkForEnterLibCardToDisplayOrNot];
//	return YES;
//}

- (void)checkForEnterLibCardToDisplayOrNot{

    NSDictionary *dToSelect = [self.arOfLibraries objectAtIndex:self.selectedIP.row];
    BOOL exists=([[dToSelect valueForKey:@"libCardAccExists"] isKindOfClass:[NSNull class]])?NO:[[dToSelect valueForKey:@"libCardAccExists"] boolValue];
    
    
    
    
    self.exists=exists;
    
    self.lblEnterCardBG.hidden=!exists;
    self.lblEnterCardBG.hidden=!exists;
    self.lblEnterLibCard.hidden=!exists;
    self.lblEnterLibCard2.hidden=!exists;
    self.imgVArrowEnterCard.hidden=!exists;
    self.btnEnterCardText.hidden=!exists;
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if(UIInterfaceOrientationIsLandscape([self interfaceOrientation])) {
        self.lblGetStarted.hidden=self.lblEnterLibCard2.hidden=self.lblGetStarted2.hidden=self.lblEnterLibCard.hidden=NO;
        self.lblEnterCardBG.hidden=
        self.lblEnterLibCard.hidden=
        self.lblEnterLibCard2.hidden= !(self.exists);
        self.lblCallout.hidden=NO;
        self.imgVCallOut.hidden=NO;
        [self hideCallout_OrNot];
    } else {
        self.lblGetStarted.hidden=self.lblEnterLibCard2.hidden=self.lblGetStarted2.hidden=self.lblEnterLibCard.hidden=NO;
        self.lblCallout.hidden=YES;
        self.imgVCallOut.hidden=YES;
    }
    
    if(self.selectedIP) {
        BOOL isLandscape = UIInterfaceOrientationIsLandscape([self interfaceOrientation]); 
        NSUInteger x = isLandscape?505:661;
        self.vDtl.frame = CGRectMake(0, x, self.vDtl.frame.size.width, isLandscape?200:300);
    } else {
        BOOL isLandscape = UIInterfaceOrientationIsLandscape([self interfaceOrientation]); 
        NSUInteger x = isLandscape?680:935;
        self.vDtl.frame = CGRectMake(0, x, self.vDtl.frame.size.width, isLandscape?200:300);
    }
    [self checkForEnterLibCardToDisplayOrNot];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arOfLibraries count]+1;
}

#define kPinText        1
#define kTitle          2
#define kAddress        3
#define kPhone          4
#define kBackground     6
#define kBackGradient   88

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    if(indexPath.row>=self.arOfLibraries.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.textLabel setFont:[UIFont fontWithName:@"Trebuchet MS" size:14]];
            [cell.textLabel setTextAlignment:UITextAlignmentCenter];             
			[cell.textLabel setTextColor:[UIColor colorWithRed:27/255.0 green:152/255.0 blue:194/255.0 alpha:1]];
        }
        cell.textLabel.text= (self.arOfLibraries.count)?[NSString stringWithFormat:@"Displaying libraries within %@",self.requestedDistance]:@"No libraries found nearby your location.";
        
        return cell;
    } else {
        UITableViewCell *cell = nil;
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CCell" owner:self options:nil] objectAtIndex:0];
        
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
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    self.selectedIP=indexPath;
    [self setDisplaySearch];
    [self selectSpecificPin:[self.arOfLibraries objectAtIndex:indexPath.row]];
    [self.tableViewLibrary reloadData];  
    
    [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:@"iPad Library Selection"
        withAction:@"TrackEvent"
        withLabel:[self.arOfLibraries objectAtIndex:indexPath.row] withValue:[NSNumber numberWithInt:101]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row>=self.arOfLibraries.count) {
        
    } else {
        
        [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:@"iPad Library Selection"
        withAction:@"TrackEvent"
        withLabel:[self.arOfLibraries objectAtIndex:indexPath.row]
        withValue:[NSNumber numberWithInt:101]];
        
        NSError *error = nil;
        if (![[GANTracker sharedTracker] trackEvent:@"iPad Library Selection"action:@"TrackEvent"label:[self.arOfLibraries objectAtIndex:indexPath.row] value:-1 withError:&error]) {
            NSLog(@"Error Occured");
        }
        self.selectedIP=indexPath;
        [self selectSpecificPin:[self.arOfLibraries objectAtIndex:indexPath.row]];
        [self setDisplaySearch];
        [self.tableViewLibrary reloadData];
    }
    
}


#pragma mark - MapViewDelegate

- (void)addPins 
{
    for (NSDictionary *d in self.arOfLibraries) {
        Place* home = [[Place alloc] init];
        home.name = ([d valueForKey:@"name"] && [[d valueForKey:@"name"] length]>0)?[d valueForKey:@"name"]:@" ";
        home.latitude = [[d valueForKey:@"lat"]floatValue];
        home.longitude = [[d valueForKey:@"lng"]floatValue];
        PlaceMark* from = [[PlaceMark alloc] initWithPlace:home];
        [self.mapViewLibrary addAnnotation:from];
    }
    [self centerMap:self.mapViewLibrary];
}

- (void)selectSpecificPin:(NSDictionary *)dToSelect {
    if(self.vDtl.frame.origin.y>510) {
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationDuration: 0.4f];
        BOOL isLandscape = UIInterfaceOrientationIsLandscape([self interfaceOrientation]); 
        NSUInteger x = isLandscape?505:661;
        self.vDtl.frame = CGRectMake(0, x, self.vDtl.frame.size.width, isLandscape?200:300);
        [UIView commitAnimations];
    }
    NSString *annotationTitle =  [dToSelect valueForKey:@"name"];
    self.lblLibraryTitle.text = [dToSelect valueForKey:@"name"];
    NSString *strPhone = ([[dToSelect valueForKey:@"phoneNumber"] isKindOfClass:[NSNull class]])?@"":[dToSelect valueForKey:@"phoneNumber"];
    
    NSDictionary *dToAccess=dToSelect;
    
    NSString *strAddress=[NSString stringWithFormat:@"%@\n%@, %@ %@",[dToAccess valueForKey:@"address"],[dToAccess valueForKey:@"city"],[dToAccess valueForKey:@"state"], [dToAccess valueForKey:@"zip"]];
    
    strPhone = (strPhone.length)?strPhone:@"";
    strAddress = (strAddress.length)?strAddress:@"";
    self.lblAddress.text = [NSString stringWithFormat:@"%@\n%@",strAddress,strPhone];
    
    if(!strPhone || [strPhone isKindOfClass:[NSNull class]] || [strPhone length]==0 ) {
        self.imgVCallOut.hidden=YES;
    } else {
        self.imgVCallOut.hidden=!UIInterfaceOrientationIsLandscape([self interfaceOrientation]);
    }
    
    // setting up EnterLibrary card - hidden - yes/no libCardAccExists
    
    BOOL exists=([[dToSelect valueForKey:@"libCardAccExists"] isKindOfClass:[NSNull class]])?NO:[[dToSelect valueForKey:@"libCardAccExists"] boolValue];
    self.exists=exists;
    
    self.lblEnterCardBG.hidden=!exists;
    
    self.lblEnterCardBG.hidden=!exists;
    self.lblEnterLibCard.hidden=!exists;
    self.lblEnterLibCard2.hidden=!exists;
    self.imgVArrowEnterCard.hidden=!exists;
    self.btnEnterCardText.hidden=!exists;
    
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

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {	
    if (oldState == MKAnnotationViewDragStateDragging) {
        DDAnnotation *annotation = (DDAnnotation *)annotationView.annotation;
        annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
        self.annotation.subtitle = [NSString stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
    }
}

#define kTagLabelPin    999

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;		
    }
    static NSString * const kPinAnnotationIdentifier1 = @"PinIdentifierCurrentLocation";
    static NSString * const kPinAnnotationIdentifier2 = @"PinIdentifierOtherPins";
    MKAnnotationView *draggablePinView = [self.mapViewLibrary dequeueReusableAnnotationViewWithIdentifier:kPinAnnotationIdentifier1];
    MKPinAnnotationView *pin = (MKPinAnnotationView *) [self.mapViewLibrary dequeueReusableAnnotationViewWithIdentifier: kPinAnnotationIdentifier2];
    if([[annotation title] isEqualToString:kCurrentLocationString]) {
        if (draggablePinView) {
            draggablePinView.annotation = annotation;
        } else {
            draggablePinView = [DDAnnotationView annotationViewWithAnnotation:annotation reuseIdentifier:kPinAnnotationIdentifier1 mapView:self.mapViewLibrary];
            if ([draggablePinView isKindOfClass:[DDAnnotationView class]]) {
                // draggablePinView is DDAnnotationView on iOS 3.
            } else if([draggablePinView isKindOfClass:[Place class]]) {
                // draggablePinView instance will be built-in draggable MKPinAnnotationView when running on iOS 4.
            }
        }
        return draggablePinView;
    } else {
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
}

- (NSInteger)indexOfTitle:(NSString*)strTitle{
    for (NSDictionary *d in self.arOfLibraries) {
        if([[d valueForKey:@"name"] isEqualToString:strTitle]) {
            return [self.arOfLibraries indexOfObject:d];
        }
    }
    return -1;
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
            [self setDisplaySearch];
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

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSString *strTitle = [NSString stringWithFormat:@"%@",[view.annotation title]];
    if([strTitle isEqualToString:kCurrentLocationString]) return;
    NSMutableDictionary *d;
    NSArray *temp = self.arOfLibraries;
    for (int i = 0; i<[temp count]; i++) {
        d = (NSMutableDictionary*)[temp objectAtIndex:i];
        NSString *strAddress =  [d valueForKey:@"name"];
        if([strAddress isEqualToString:strTitle]) {
            [self performSelector:@selector(btnShowHideTapped:) withObject:nil afterDelay:0.25];
            return;
        }
    } 
}

- (IBAction)btnShowHideTapped:(id)sender {
    [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:@"iPad Library Show/Hide"
        withAction:@"TrackEvent" withLabel:@"btnShowHideTapped" withValue:[NSNumber numberWithInt:105]];
    
    NSError *error = nil;
    if (![[GANTracker sharedTracker] trackEvent:@"iPad Library Show/Hide" action:@"TrackEvent"
        label:@"btnShowHideTapped" value:-1 withError:&error]) {
        NSLog(@"Error Occured ==>%@",error);
    }
    if(self.selectedIP) {
       NSUInteger heightToCheck = UIInterfaceOrientationIsLandscape([self interfaceOrientation])?505:761;
        if(self.vDtl.frame.origin.y>heightToCheck) {
            [UIView beginAnimations: nil context: nil];
            [UIView setAnimationDuration: 0.4f];
            BOOL isLandscape = UIInterfaceOrientationIsLandscape([self interfaceOrientation]); 
            NSUInteger x = isLandscape?505:661;
            self.vDtl.frame = CGRectMake(0, x, self.vDtl.frame.size.width, isLandscape?200:300);
            
            [UIView commitAnimations];
        } else {
            [UIView beginAnimations: nil context: nil];
            [UIView setAnimationDuration: 0.4f];
            BOOL isLandscape = UIInterfaceOrientationIsLandscape([self interfaceOrientation]); 
            NSUInteger x = isLandscape?680:935;
            self.vDtl.frame = CGRectMake(0, x, self.vDtl.frame.size.width, isLandscape?200:300);
            [UIView commitAnimations];
        }
    } else {
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationDuration: 0.4f];
        BOOL isLandscape = UIInterfaceOrientationIsLandscape([self interfaceOrientation]); 
        NSUInteger x = isLandscape?680:935;
        self.vDtl.frame = CGRectMake(0, x, self.vDtl.frame.size.width, isLandscape?200:300);
        [UIView commitAnimations];
    }
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
}


- (void)enterToSearchScreen:(id)sender {
    [self.pVCtr dismissPopoverAnimated:YES];
//    if(!self.nxtdRcrdVCtr)
    self.nxtdRcrdVCtr=[[dRcrdVCtr alloc] initWithNibName:@"dRcrdVCtr" bundle:nil];
    self.nxtdRcrdVCtr.predLibVCtr=self;
    self.nxtdRcrdVCtr.imgPath=[[self.arOfLibraries objectAtIndex:self.selectedIP.row] valueForKey:@"logoPath"];
	self.nxtdRcrdVCtr.strLibraryName=[[self.arOfLibraries objectAtIndex:self.selectedIP.row] valueForKey:@"name"];
   
    if(sender && [sender isKindOfClass:[NSNumber class]]) {
        self.nxtdRcrdVCtr.isLoginUsingSession=YES;
    }
    [self.navigationController pushViewController:self.nxtdRcrdVCtr animated:YES];
}

- (IBAction)btnEnterCardTapped:(id)sender {
    [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:@"iPad Library Card Number"
        withAction:@"TrackEvent" withLabel:@"btnEnterCardTapped" withValue:[NSNumber numberWithInt:102]];
    
    NSError *error = nil;
    if (![[GANTracker sharedTracker] trackEvent:@"iPad Library Card Number"
                                         action:@"TrackEvent"
                                          label:@"btnEnterCardTapped"
                                          value:-1
                                      withError:&error]) {
        NSLog(@"Error Occured ==>%@",error);
    }
    
    self.nxtdLibCardNo.predLibVCtr=self;
    [self.pVCtr presentPopoverFromBarButtonItem:self.btnEnterCard permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    [self.pVCtr setPopoverContentSize:CGSizeMake(382, 194) animated:YES];
}

- (IBAction)btnGetStartedTapped:(id)sender {
    [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:@"Get Started Tapped"
        withAction:@"TrackEvent" withLabel:self.lblLibraryTitle.text withValue:[NSNumber numberWithInt:103]];
    NSError *error = nil;
    if (![[GANTracker sharedTracker] trackEvent:@"Get Started Tapped"
        action:@"TrackEvent"
        label:self.lblLibraryTitle.text
        value:-1
        withError:&error]) {
        NSLog(@"Error Occured ==>%@",error);
    }
    [self enterToSearchScreen:nil];
}

- (IBAction)btnInfoTapped:(id)sender {
    [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:@"iPad infoButton"
        withAction:@"TrackEvent" withLabel:@"btnInfoTapped" withValue:[NSNumber numberWithInt:104]];
    NSError *error = nil;
    if (![[GANTracker sharedTracker] trackEvent:@"iPad infoButton" action:@"TrackEvent" 
      label:@"btnInfoTapped" value:-1 withError:&error]) {
        NSLog(@"Error Occured ==>%@",error);
    }
    if(!self.nxtdNewAboutVCtr) {
        self.nxtdNewAboutVCtr = [[dNewAboutVCtr alloc] init];
    }
    [self presentModalViewController:self.nxtdNewAboutVCtr animated:YES];
}

- (IBAction)btnSettingsTapped:(id)sender {
    
}




@end
