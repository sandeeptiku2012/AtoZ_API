//
//  dRcrdVCtr.m
//  AtoZ
//
//  Created by Valtech on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "dRcrdVCtr.h"
#import "dLibVCtr.h"
#import "AppDelegate.h"
#import "dResultDtlVCtr.h"
#import "dResdRcrdDtlVCtr.h"

@implementation dRcrdVCtr

@synthesize nxtdNewAboutVCtr = _nxtdNewAboutVCtr;

@synthesize sgSearchOptions = _sgSearchOptions;

@synthesize imgPath = _imgPath;
@synthesize strLibraryName = _strLibraryName;
@synthesize imgVLibLogo = _imgVLibLogo;
@synthesize predLibVCtr = _predLibVCtr;

@synthesize arOfRecords = _arOfRecords;
@synthesize arOfFilteredRcrds = _arOfFilteredRcrds;
@synthesize tableViewRecords = _tableViewRecords;
@synthesize mapViewRecords = _mapViewRecords;
@synthesize sgNextPrev = _sgNextPrev;
@synthesize vLeft = _vLeft;
@synthesize vRight = _vRight;
@synthesize selectedIP = _selectedIP;
@synthesize totalRecords = _totalRecords;
@synthesize numberFrom = _numberFrom;
@synthesize numberTo = _numberTo;
@synthesize isSearching = _isSearching;
@synthesize vDtl = _vDtl;
@synthesize lblFullName = _lblFullName;
@synthesize txtDetails = _txtDetails;

@synthesize pVCtr = _pVCtr;
@synthesize nvCtr = _nvCtr;
@synthesize nxtdSrchBusiness = _nxtdSrchBusiness;
@synthesize nxtdSrchPerson = _nxtdSrchPerson;
@synthesize nxtdSrchCategory = _nxtdSrchCategory;
@synthesize nxtdSrchPhone = _nxtdSrchPhone;
@synthesize nxtdResultDtlVCtr = _nxtdResultDtlVCtr;
@synthesize nxtdResdRcrdDtlVCtr = _nxtdResdRcrdDtlVCtr;
@synthesize dForSearch = _dForSearch;
@synthesize nQ = _nQ;
@synthesize arForStates = _arForStates;
@synthesize tBarNextPre = _tBarNextPre;

@synthesize barBtnBusiness = _barBtnBusiness;
@synthesize barBtnPerson = _barBtnPerson;
@synthesize barBtnCategory = _barBtnCategory;
@synthesize barBtnPhone = _barBtnPhone;
@synthesize barBtnSettings = _barBtnSettings;
@synthesize lblCustomerLogo = _lblCustomerLogo;
@synthesize btnBusinessHidden = _btnBusinessHidden;
@synthesize btnSearchbyPhone = _btnSearchbyPhone;
@synthesize btnSearchbycategory = _btnSearchbycategory;
@synthesize btnSearchbyPerson = _btnSearchbyPerson;
@synthesize btnInnerSettings = _btnInnerSettings;
@synthesize lblRecordsTitle = _lblRecordsTitle;
@synthesize tableSrchBar = _tableSrchBar;

@synthesize isFetchingStates = _isFetchingStates;
@synthesize isFetchingRecords = _isFetchingRecords;
@synthesize isLoginUsingSession = _isLoginUsingSession;

#define kCurrentLocationString      @"Current Location"

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
    NSError *error = nil;
    [[GANTracker sharedTracker] trackPageview:@"iPad Search Result Page" withError:&error];
    self.trackedViewName=@"iPad Search Result Page";    
    
    
	CALayer *l=[self.imgVLibLogo layer];
	l.borderWidth=1;
	l.borderColor=[[UIColor colorWithRed:105/255.0 green:106/255.0 blue:106/255.0 alpha:1] CGColor];
    UIFont *font = [UIFont fontWithName:@"Trebuchet MS" size:13];
	
    if([ [[UIDevice currentDevice] systemVersion] hasPrefix:@"5" ] ) {
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];
        [self.sgSearchOptions setTitleTextAttributes:attributes 
                                            forState:UIControlStateNormal];
    }
    
    for (id objX in self.tableSrchBar.subviews) {
        if([objX isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField*)objX;
            [textField setFont:[UIFont fontWithName:@"Trebuchet MS" size:14]];
            [textField setTextColor:[UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1]];
        }
    }
    	
    self.selectedIP=nil;
    self.arOfFilteredRcrds = [NSMutableArray array];
    self.nxtdSrchBusiness=[[dSrchBusiness alloc] initWithNibName:@"dSrchBusinesses" bundle:nil];
    self.nxtdSrchPerson=[[dSrchPerson alloc] initWithNibName:@"dSrchPerson" bundle:nil];
    self.nxtdSrchCategory=[[dSrchCategory alloc] initWithNibName:@"dSrchCategory" bundle:nil];
    self.nxtdSrchPhone=[[dSrchPhone alloc] initWithNibName:@"dSrchPhone" bundle:nil];
    self.nxtdSrchBusiness.predRcrdVCtr=self.nxtdSrchPerson.predRcrdVCtr=self.nxtdSrchCategory.predRcrdVCtr=self.nxtdSrchPhone.predRcrdVCtr=self;
    
    self.nvCtr = [[UINavigationController alloc] initWithRootViewController:self.nxtdSrchBusiness];
    
    self.pVCtr=[[UIPopoverController alloc] initWithContentViewController:self.nvCtr];
    [self performSelector:@selector(setUpTheImage:) withObject:nil afterDelay:0.5];
}

- (void)resetProcess
{
    // reset process 
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration: 0.4f];
    self.vDtl.frame = CGRectMake(0, 1000, self.vDtl.frame.size.width, self.vDtl.frame.size.height);
    [UIView commitAnimations];
    self.numberFrom=[NSNumber numberWithInt:1];
    self.numberTo=[NSNumber numberWithInt:25];
    self.arOfRecords=nil;
    self.selectedIP=nil;
    self.lblRecordsTitle.text=@"";
    self.totalRecords=0;
    self.isSearching=NO;
    self.tableSrchBar.text=@"";
    
    self.isFetchingRecords=YES; 
    self.isFetchingStates=NO;
    
    [self.tableSrchBar resignFirstResponder];
    [self.tableViewRecords reloadData];
}

- (void)setUpTheImage:(id)sender {
    NSUserDefaults *sDef = [NSUserDefaults standardUserDefaults];
    NSString *str=nil;
	
    if(self.isLoginUsingSession) {
        // old logic
//        str = [NSString stringWithFormat:@"%@%@",WEB_IMAGES_URL,[sDef valueForKey:@"llogo"]];
        str = [sDef valueForKey:@"llogo"];
		self.lblCustomerLogo.text=[sDef valueForKey:@"lname"];
        //[self.btnInnerSettings addTarget:self action:@selector(btnSettingsTapped:) forControlEvents:UIControlEventTouchDown];
       // [self.btnInnerSettings setBackgroundImage:[UIImage imageNamed:@"settingIcon.png"] forState:UIControlStateNormal];
    } else {
        // old logic
//        str = [NSString stringWithFormat:@"%@%@",WEB_IMAGES_URL,self.imgPath];
        str = self.imgPath;
		self.lblCustomerLogo.text=self.strLibraryName;
        //[self.btnInnerSettings removeTarget:self action:@selector(btnSettingsTapped:) forControlEvents:UIControlEventTouchDown];
       // [self.btnInnerSettings setBackgroundImage:nil forState:UIControlStateNormal];
    }
    [self.imgVLibLogo clear];
    
    if(![str isKindOfClass:[NSNull class]]) 
        self.imgVLibLogo.url=[NSURL URLWithString:str];
    [GlobalCacheManager manage:self.imgVLibLogo];
}

- (void)viewWillAppear:(BOOL)animated {
	NSUserDefaults *sDef = [NSUserDefaults standardUserDefaults];
    if([sDef valueForKey:@"id"] && [sDef valueForKey:@"card"]) {
		self.btnInnerSettings.hidden=NO;
	}else
		self.btnInnerSettings.hidden=YES;
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
	[self setStrLibraryName:nil];
	[self setImgPath:nil];
    [self setTableViewRecords:nil];
    [self setMapViewRecords:nil];
    [self setArOfFilteredRcrds:nil];
    [self setVLeft:nil];
    [self setVRight:nil];
    [self setVDtl:nil];
    [self setPVCtr:nil];
    [self setNvCtr:nil];
    [self setNxtdSrchBusiness:nil];
    [self setNxtdSrchCategory:nil];
    [self setNxtdSrchPerson:nil];
    [self setNxtdSrchPhone:nil];
    [self setBarBtnBusiness:nil];
    [self setBarBtnPerson:nil];
    [self setBarBtnCategory:nil];
    [self setBarBtnPhone:nil];
    [self setTableSrchBar:nil];
    [self setLblRecordsTitle:nil];
    [self setDForSearch:nil];
    [self setNQ:nil];
    [self setArForStates:nil];
    [self setNumberFrom:nil];
    [self setNumberTo:nil];
    [self setTBarNextPre:nil];
    [self setLblFullName:nil];
    [self setTxtDetails:nil];
    [self setImgVLibLogo:nil];
    [self setBarBtnSettings:nil];
    [self setSgNextPrev:nil];
	[self setLblCustomerLogo:nil];
    [self setSgSearchOptions:nil];
    [self setNxtdNewAboutVCtr:nil];
    [self setBtnBusinessHidden:nil];
	[self setBtnSearchbyPhone:nil];
	[self setBtnSearchbycategory:nil];
	[self setBtnSearchbyPerson:nil];
    [self setBtnInnerSettings:nil];
    [super viewDidUnload];
}

#ifdef IOS_OLDER_THAN__IPHONE_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation)toInterfaceOrientation
{
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        
    } else {
        
    }
	return YES;
}
#endif

#ifdef IOS_NEWER_OR_EQUAL_TO__IPHONE_6_0
-(BOOL)shouldAutorotate
{
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        
    } else {
        
    }
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
//        
//    } else {
//
//    }
//	return YES;
//}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if(UIInterfaceOrientationIsLandscape([self interfaceOrientation])) {

    } else {

    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.isSearching)?[self.arOfFilteredRcrds count]:[self.arOfRecords count];
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CCell" owner:self options:nil] objectAtIndex:0];
    }
    
    NSDictionary *dToAccess = (self.isSearching)?[self.arOfFilteredRcrds objectAtIndex:indexPath.row]:[self.arOfRecords objectAtIndex:indexPath.row];
    
    [(UILabel*)[cell viewWithTag:kPinText] setText:[NSString stringWithFormat:@"%i",indexPath.row+1]];
    
    BOOL isBusiness = ([[dToAccess valueForKey:@"Database Type"] isEqualToString:@"Business"])  ;
    
    //Rajeev Start
    NSString *strCompName = [dToAccess valueForKey:@"companyname"];
    NSArray *sep = [strCompName componentsSeparatedByString:@"<strong>"];
    NSArray *sep1 = nil;
    if ([sep count] >= 2)
        sep1 = [[sep objectAtIndex:1] componentsSeparatedByString:@"</strong>"];
    else
        sep1 = [NSArray arrayWithObjects:[sep objectAtIndex:0], nil];
    //Rajeev End
    NSString *strName = nil;
    if ([sep1 count] >= 1)
        strName = isBusiness ? [sep1 objectAtIndex:0]/*[dToAccess valueForKey:@"companyname"]*/ : [[dToAccess valueForKey:@"firstname"] stringByAppendingFormat:@" %@",[dToAccess valueForKey:@"lastname"]]/*[dToAccess valueForKey:@"fullname"]*/;
    else
        strName = @"";
    [(UILabel*)[cell viewWithTag:kTitle] setText:strName];
    
    NSString *strAddress = ([dToAccess valueForKey:@"address"] && [[dToAccess valueForKey:@"address"] length]>0 && ![[dToAccess valueForKey:@"address"]isEqualToString:@"(null)"])?[dToAccess valueForKey:@"address"]:@"N/A";
    
    NSString *str=([strAddress isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"%@, %@, %@",[dToAccess valueForKey:@"address"],[dToAccess valueForKey:@"city"],[dToAccess valueForKey:@"state"]];
    
    [(UILabel*)[cell viewWithTag:kAddress] setText:str];
    [(UILabel*)[cell viewWithTag:kPhone] setText:[dToAccess valueForKey:@"phone"]];  
    
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
    self.selectedIP=indexPath;
    [self.tableViewRecords reloadData];
    NSDictionary *d = [self.arOfRecords objectAtIndex:indexPath.row];
    [self selectSpecificPin:d];
    
    NSError *error = nil;
    if (![[GANTracker sharedTracker] trackEvent:@"Detail of Record" action:@"TrackEvent" label:[d valueForKey:@"companyname"] value:-1 withError:&error]) {
        NSLog(@"Error Occured ==>%@",error);
    }
    
    if([[d valueForKey:@"Database Type"] isEqualToString:@"Business"]) {
        self.nxtdResultDtlVCtr=[[dResultDtlVCtr alloc] initWithNibName:@"dResultDtlVCtr" bundle:nil];
//        self.nxtdResultDtlVCtr.dForDtl=d;
        self.nxtdResultDtlVCtr.dForResult=d;
        self.nxtdResultDtlVCtr.predRcrdVCtr=self;
        [self.nvCtr setNavigationBarHidden:YES animated:NO];
        [self.nvCtr setViewControllers:[NSArray arrayWithObject:self.nxtdResultDtlVCtr]];
        [self.navigationController presentModalViewController:self.nvCtr animated:YES];
    } else if ([[d valueForKey:@"Database Type"] isEqualToString:@"Consumer"]) {
        self.nxtdResdRcrdDtlVCtr=[[dResdRcrdDtlVCtr alloc] initWithNibName:@"dResdRcrdDtlVCtr" bundle:nil];
        //self.nxtdResdRcrdDtlVCtr.dForDtl=d;
        self.nxtdResdRcrdDtlVCtr.dForResult=d;
        self.nxtdResdRcrdDtlVCtr.predRcrdVCtr=self;
        [self.nvCtr setViewControllers:[NSArray arrayWithObject:self.nxtdResdRcrdDtlVCtr]];
        [self.nvCtr setNavigationBarHidden:YES animated:NO];
        [self.navigationController presentModalViewController:self.nvCtr animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIP=indexPath;
    [self.tableViewRecords reloadData];
    NSDictionary *d = [self.arOfRecords objectAtIndex:indexPath.row];
    [self selectSpecificPin:d];
    
    NSError *error = nil;
    if (![[GANTracker sharedTracker] trackEvent:@"Resulting Record Selected" action:@"TrackEvent" label:[d valueForKey:@"companyname"] value:-1 withError:&error]) {
        NSLog(@"Error Occured ==>%@",error);
    }
}

#pragma mark - MapViewDelegate

//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
//    
//}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    
}

- (void)addPins 
{
    int i=0;
    for (NSDictionary *d in self.arOfRecords) {
        float lat = [[d valueForKey:@"latitude"] floatValue];
        float lng = [[d valueForKey:@"longitude"] floatValue];
        Place* home = [[Place alloc] init];
        
        BOOL isBusiness = ([[d valueForKey:@"Database Type"] isEqualToString:@"Business"])  ;
        //Rajeev Start
        NSString *strCompName = [d valueForKey:@"companyname"];
        NSArray *sep = [strCompName componentsSeparatedByString:@"<strong>"];
        NSArray *sep1 = nil;
        if ([sep count] >= 2)
            sep1 = [[sep objectAtIndex:1] componentsSeparatedByString:@"</strong>"];
        else
            sep1 = [NSArray arrayWithObjects:[sep objectAtIndex:0], nil];
        //Rajeev End
        NSString *strName = nil;
        if ([sep1 count] >= 1)
            strName = isBusiness ? [sep1 objectAtIndex:0]/*[d valueForKey:@"companyname"]*/ : [[d valueForKey:@"firstname"] stringByAppendingFormat:@" %@",[d valueForKey:@"lastname"]]/*[d valueForKey:@"fullname"]*/;
        else
            strName = @"";
        
        home.name = (strName && strName.length>0)?strName:@" "; //[d valueForKey:@"fullname"];
        NSString *str=[NSString stringWithFormat:@"%@, %@, %@",[d valueForKey:@"address"],[d valueForKey:@"city"],[d valueForKey:@"state"]];
        home.description=str;
        home.latitude = lat;        
        home.longitude = lng;       
        home.index=++i;
        PlaceMark* from = [[PlaceMark alloc] initWithPlace:home];
        [self.mapViewRecords addAnnotation:from];
    }
    [self centerMap:self.mapViewRecords];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setupPins) userInfo:nil repeats:YES];
}

#define kTagLabelPin    999

- (void)setupPins {
    for (id annotation in self.mapViewRecords.annotations) {
        if([annotation isKindOfClass:[PlaceMark class]]) {
            PlaceMark *x = (PlaceMark*)annotation;
            MKAnnotationView *anView = [self.mapViewRecords viewForAnnotation:x];
            [(UILabel*)[anView viewWithTag:kTagLabelPin] setText:[NSString stringWithFormat:@"%i",x.place.index]];
        }
    }
}

- (void)selectSpecificPin:(NSDictionary *)dToSelect {
    NSInteger index = [self.arOfRecords indexOfObject:dToSelect];
    NSArray *arAnnotations = [self.mapViewRecords annotations];
    for (id annotationToAccess in arAnnotations) {
        if([annotationToAccess isKindOfClass:[PlaceMark class]] && [(PlaceMark*)annotationToAccess place].index==(index+1) ) {
            [self.mapViewRecords selectAnnotation:annotationToAccess animated:NO];
            [self.mapViewRecords setCenterCoordinate:[(PlaceMark*)annotationToAccess coordinate] animated:YES];
            break;
        }
    }
}

- (IBAction)btnInfoTapped:(id)sender {
    if(!self.nxtdNewAboutVCtr) {
        self.nxtdNewAboutVCtr = [[dNewAboutVCtr alloc] init];
    }
    [self presentModalViewController:self.nxtdNewAboutVCtr animated:YES];
}

- (IBAction)sgChangedSrchOpt:(UISegmentedControl*)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self.nvCtr setViewControllers:[NSArray arrayWithObject:self.nxtdSrchBusiness]];
            [self.pVCtr setContentViewController:self.nvCtr];
            [self.nvCtr setNavigationBarHidden:NO animated:NO];
            [self.pVCtr setPopoverContentSize:CGSizeMake(337, 336) animated:YES];
            [self.pVCtr presentPopoverFromBarButtonItem:self.barBtnBusiness permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            break;
        case 1:
            [self.nvCtr setViewControllers:[NSArray arrayWithObject:self.nxtdSrchPerson]];
            [self.pVCtr setContentViewController:self.nvCtr];
            [self.nvCtr setNavigationBarHidden:NO animated:NO];
            [self.pVCtr setPopoverContentSize:CGSizeMake(337, 336) animated:YES];
            [self.pVCtr presentPopoverFromBarButtonItem:self.barBtnPerson permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            break;
        case 2:
            [self.nvCtr setViewControllers:[NSArray arrayWithObject:self.nxtdSrchCategory]];
            [self.nvCtr setNavigationBarHidden:NO animated:NO];
            [self.pVCtr setContentViewController:self.nvCtr];
            [self.pVCtr setPopoverContentSize:CGSizeMake(337, 474) animated:YES];
            [self.pVCtr presentPopoverFromBarButtonItem:self.barBtnCategory permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            break;
        case 3:
            [self.nvCtr setViewControllers:[NSArray arrayWithObject:self.nxtdSrchPhone]];
            [self.nvCtr setNavigationBarHidden:NO animated:NO];
            [self.pVCtr setContentViewController:self.nvCtr];
            [self.pVCtr setPopoverContentSize:CGSizeMake(337, 132) animated:YES];
            [self.pVCtr presentPopoverFromBarButtonItem:self.barBtnPhone permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            break;
        default:
            break;
    }
    
}

- (IBAction)sgNxtPrePage:(id)sender {
    BOOL toFetch = NO;
    UISegmentedControl *SegPN = (UISegmentedControl*)sender;
    if(self.totalRecords>0) {
        if([SegPN selectedSegmentIndex]==0) {
            if (! (([self.numberFrom intValue]-25) <=0 )) {
                if([self.numberTo intValue]==self.totalRecords) {
                    self.numberTo = [NSNumber numberWithInt:[self.numberFrom intValue]-1];
                    self.numberFrom = [NSNumber numberWithInt:[self.numberFrom intValue]-25];
                } else  {
                    self.numberFrom = [NSNumber numberWithInt:[self.numberFrom intValue]-25];
                    self.numberTo = [NSNumber numberWithInt:[self.numberTo intValue]-25];
                }
                toFetch=YES;
            }
        } else {
            if(! (([self.numberTo intValue]+25) >=self.totalRecords )) {
                self.numberFrom = [NSNumber numberWithInt:[self.numberFrom intValue]+25];
                self.numberTo = [NSNumber numberWithInt:[self.numberTo intValue]+25];
                toFetch=YES;
            } else if ( [self.numberTo intValue] < self.totalRecords ) {
                toFetch=YES;
                self.numberFrom = [NSNumber numberWithInt:[self.numberFrom intValue]+25];
                self.numberTo = [NSNumber numberWithInt:self.totalRecords];
            }
        }
    }
    
    if(toFetch) {
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationDuration: 0.4f];
        self.vDtl.frame = CGRectMake(0, 1000, self.vDtl.frame.size.width, self.vDtl.frame.size.height);
        [UIView commitAnimations];
        self.arOfRecords=nil;
        self.selectedIP=nil;
        self.isSearching=NO;
        self.tableSrchBar.text=@"";
        [iNetMngr getRecords:self pageNumber:[self.numberFrom stringValue] numberOfRecords:[self.numberTo stringValue]];
    }
}

- (IBAction)btnSettingsTapped:(id)sender {
    NSUserDefaults *sDef = [NSUserDefaults standardUserDefaults];
    if([sDef valueForKey:@"id"] && [sDef valueForKey:@"card"]) {
        UIActionSheet *aSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to remove your library card & navigate to a list of AtoZdatabases subscriber near you?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"YES" otherButtonTitles:@"NO",nil];
        [aSheet showFromBarButtonItem:self.barBtnSettings animated:YES];
    } else {
        ALERT(@"Message", @"No library card details stored.", @"OK", self, nil);
    }
}

- (IBAction)btnByPhoneTapped:(id)sender {
    self.sgSearchOptions.selectedSegmentIndex=3;
	self.btnBusinessHidden.selected=NO;
	self.btnSearchbycategory.selected=NO;
	self.btnSearchbyPerson.selected=NO;
	self.btnSearchbyPhone.selected=YES;
    [self sgChangedSrchOpt:self.sgSearchOptions];
}

- (IBAction)btnByCategoryTapped:(id)sender {
    self.sgSearchOptions.selectedSegmentIndex=2;
	self.btnBusinessHidden.selected=NO;
	self.btnSearchbycategory.selected=YES;
	self.btnSearchbyPerson.selected=NO;
	self.btnSearchbyPhone.selected=NO;
    [self sgChangedSrchOpt:self.sgSearchOptions];
}

- (IBAction)btnPersonTapped:(id)sender {
    self.sgSearchOptions.selectedSegmentIndex=1;
	self.btnBusinessHidden.selected=NO;
	self.btnSearchbycategory.selected=NO;
	self.btnSearchbyPerson.selected=YES;
	self.btnSearchbyPhone.selected=NO;
    [self sgChangedSrchOpt:self.sgSearchOptions];
}

- (IBAction)btnBusinessTapped:(id)sender {
    self.sgSearchOptions.selectedSegmentIndex=0;
	self.btnBusinessHidden.selected=YES;
	self.btnSearchbycategory.selected=NO;
	self.btnSearchbyPerson.selected=NO;
	self.btnSearchbyPhone.selected=NO;
	
    [self sgChangedSrchOpt:self.sgSearchOptions];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex==0) {
        NSUserDefaults *sDef = [NSUserDefaults standardUserDefaults];
        [sDef removeObjectForKey:@"library"];
        [sDef removeObjectForKey:@"card"];
        [sDef removeObjectForKey:@"lname"];
        [sDef removeObjectForKey:@"laddress"];
        [sDef removeObjectForKey:@"lphone"];
        [sDef removeObjectForKey:@"llogo"];
        [sDef removeObjectForKey:@"id"];
        [sDef synchronize];
        [self.navigationController popViewControllerAnimated:YES];
        
        self.predLibVCtr.location = [[CLLocationManager alloc] init];
        self.predLibVCtr.location.delegate = self.predLibVCtr;
        [self.predLibVCtr.location startUpdatingLocation];
        
        [self.predLibVCtr performSelector:@selector(getNearByLibraries) withObject:nil afterDelay:0.25];
        [self.pVCtr dismissPopoverAnimated:NO];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;		
    }
    static NSString * const kPinAnnotationIdentifier2 = @"PinIdentifierOtherPins";
    MKPinAnnotationView *pin = (MKPinAnnotationView *) [self.mapViewRecords dequeueReusableAnnotationViewWithIdentifier: kPinAnnotationIdentifier2];
    if(!pin) {
        pin=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kPinAnnotationIdentifier2];
        pin.userInteractionEnabled = YES;
        UIButton *disclosureButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [disclosureButton setFrame:CGRectMake(0, 0, 30, 30)];
        
        pin.rightCalloutAccessoryView = disclosureButton;
        pin.pinColor = MKPinAnnotationColorGreen;
        pin.animatesDrop = YES;
        [pin setEnabled:YES];
        [pin setCanShowCallout:YES];
        [pin setCanShowCallout:YES];
        // customize pin
    
        // add imageView
        UIImage *pinImage = [UIImage imageNamed:@"Red_bubble.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:pinImage] ;
        imageView.frame = CGRectMake(-3, -3, 23, 43);
        [pin addSubview:imageView];
        // add Lable
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(-3, 0, 20, 21)];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setTextColor:[UIColor whiteColor]];
        [lbl setTextAlignment:UITextAlignmentCenter];
        [lbl setFont:[UIFont boldSystemFontOfSize:15]];
        lbl.tag = kTagLabelPin;
        [pin addSubview:lbl];
        lbl.text=@"H";
        [lbl setUserInteractionEnabled:NO];
        [imageView setUserInteractionEnabled:NO];
        [pin setCanShowCallout:YES];
    }
    
    PlaceMark *mark=(PlaceMark*)pin.annotation;
    [(UILabel*)[pin viewWithTag:kTagLabelPin] setText:[NSString stringWithFormat:@"%i",mark.place.index]];
    return pin;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    for (id annotation in self.mapViewRecords.annotations) {
        if([annotation isKindOfClass:[PlaceMark class]]) {
            PlaceMark *x = (PlaceMark*)annotation;
            MKAnnotationView *anView = [self.mapViewRecords viewForAnnotation:x];
            [(UILabel*)[anView viewWithTag:kTagLabelPin] setText:[NSString stringWithFormat:@"%i",x.place.index]];
        }
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if([view.annotation isKindOfClass:[MKUserLocation class]]) return;
    PlaceMark *mark=(PlaceMark*)view.annotation;
    //NSLog(@"index is %i",mark.place.index);
    self.selectedIP=[NSIndexPath indexPathForRow:(mark.place.index-1) inSection:0];
    
    [self.tableViewRecords scrollToRowAtIndexPath:self.selectedIP atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    [self.tableViewRecords reloadData];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    PlaceMark *mark=(PlaceMark*)view.annotation;
    //NSLog(@"index is %i",mark.place.index);
    NSDictionary *d = [self.arOfRecords objectAtIndex:(mark.place.index-1)]; 
    
    if([[d valueForKey:@"Database Type"] isEqualToString:@"Business"]) {
        self.nxtdResultDtlVCtr=[[dResultDtlVCtr alloc] initWithNibName:@"dResultDtlVCtr" bundle:nil];
//        self.nxtdResultDtlVCtr.dForDtl=d;
        self.nxtdResultDtlVCtr.dForResult=d;
        self.nxtdResultDtlVCtr.predRcrdVCtr=self;
        [self.nvCtr setNavigationBarHidden:YES animated:NO];
        [self.nvCtr setViewControllers:[NSArray arrayWithObject:self.nxtdResultDtlVCtr]];
        [self.navigationController presentModalViewController:self.nvCtr animated:YES];
    } else if ([[d valueForKey:@"Database Type"] isEqualToString:@"Consumer"]) {
        self.nxtdResdRcrdDtlVCtr=[[dResdRcrdDtlVCtr alloc] initWithNibName:@"dResdRcrdDtlVCtr" bundle:nil];
        //self.nxtdResdRcrdDtlVCtr.dForDtl=d;
        self.nxtdResdRcrdDtlVCtr.dForResult=d;
        self.nxtdResdRcrdDtlVCtr.predRcrdVCtr=self;
        [self.nvCtr setViewControllers:[NSArray arrayWithObject:self.nxtdResdRcrdDtlVCtr]];
        [self.nvCtr setNavigationBarHidden:YES animated:NO];
        [self.navigationController presentModalViewController:self.nvCtr animated:YES];
    }
}

-(void) centerMap:(MKMapView*)mapView
{
    if(self.arOfRecords.count==0 ) return;
    MKCoordinateRegion region;
    CLLocationDegrees maxLat = -90;
    CLLocationDegrees maxLon = -180;
    CLLocationDegrees minLat = 120;
    CLLocationDegrees minLon = 150;
    
    NSArray *temp = self.arOfRecords;
    
    for (int i=0; i<[temp count];i++) {
        CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:[[[temp objectAtIndex:i] valueForKey:@"latitude"]floatValue] longitude:[[[temp objectAtIndex:i] valueForKey:@"longitude"]floatValue]];
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
    
    if(self.mapViewRecords.userLocation.location.coordinate.latitude > maxLat)
        maxLat = self.mapViewRecords.userLocation.location.coordinate.latitude;
    if(self.mapViewRecords.userLocation.location.coordinate.latitude < minLat)
        minLat = self.mapViewRecords.userLocation.location.coordinate.latitude;
    if(self.mapViewRecords.userLocation.location.coordinate.longitude > maxLon)
        maxLon = self.mapViewRecords.userLocation.location.coordinate.longitude;
    if(self.mapViewRecords.userLocation.location.coordinate.longitude < minLon)
        minLon = self.mapViewRecords.userLocation.location.coordinate.longitude;
    
    region.center.latitude     = (maxLat + minLat) / 2;
    region.center.longitude    = (maxLon + minLon) / 2;
    region.span.latitudeDelta  =  maxLat - minLat;
    region.span.longitudeDelta = maxLon - minLon;
    
    [self.mapViewRecords setRegion:region animated:YES];
}

#pragma mark - WebServices Related

// 3. now set all set criterias
- (void)setSearchCriteria
{
    //Rajeev Start
//    [self.nQ cancelAllOperations];
//    self.nQ=[ASINetworkQueue queue];
//    [self.nQ setDelegate:self];
//    [self.nQ cancelAllOperations];
//    [self.nQ setQueueDidFinishSelector:@selector(allRequestFinished:)];
//    [self.nQ setMaxConcurrentOperationCount:1];
//    
//    NSString *strURL = [WEB_SERVICE_URL stringByAppendingFormat:WEB_CLEAR_CRITERIA,[APP_DEL strToken]];
//    //NSLog(@"API hit -> %@",strURL);
//    ASIHTTPRequest *req=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:strURL]];
//    req.delegate=self;
//    req.username=strURL;
//    [self.nQ addOperation:req];
//    
//    for (NSString *strKey in self.dForSearch) {
//        NSString *strURL = [WEB_SERVICE_URL stringByAppendingFormat:WEB_SET_CRITERIA,strKey,[self.dForSearch valueForKey:strKey],COMMON_PARSER.strActiveToken];
//        strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
//        NSLog(@"API hit -> %@",strURL);
//        NSURL *url = [NSURL URLWithString:strURL];
//        ASIHTTPRequest *req=[ASIHTTPRequest requestWithURL:url];
//        req.delegate=self;
//        [req setUsername:strURL];
//        [self.nQ addOperation:req];
//    }
//    strURL = [WEB_SERVICE_URL stringByAppendingFormat:WEB_HIDDEN_PARA,COMMON_PARSER.strActiveToken];
//	NSLog(@"API hit -> %@",strURL);
//    //NSLog(@"API hit -> %@",strURL);
//    req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:strURL]];
//    [req setDelegate:self];
//    [req setUsername:strURL];
//    [self.nQ addOperation:req];
	//Rajeev End
    [self.nQ cancelAllOperations];
    self.nQ=[ASINetworkQueue queue];
    [self.nQ setDelegate:self];
    [self.nQ cancelAllOperations];
    [self.nQ setQueueDidFinishSelector:@selector(allRequestFinished:)];
    [self.nQ setMaxConcurrentOperationCount:1];
    
    //Rajeev Start
    
    NSString *strURL = [WEB_SERVICE_URL stringByAppendingString:WEB_CLEAR_CRITERIA];
    NSLog(@"API hit -> %@",strURL);
    ASIHTTPRequest *req=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:strURL]];
    [req addRequestHeader:@"TokenID" value:[APP_DEL strToken]];
    [req setRequestMethod:@"DELETE"];
    req.delegate=self;
    req.username=strURL;
    [self.nQ addOperation:req];
    
    NSString *strURLSetCrit = [WEB_SERVICE_URL stringByAppendingString:WEB_SET_CRITERIA];
    //strURL = [strURL stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
    NSLog(@"API hit -> %@",strURLSetCrit);
    NSURL *url = [NSURL URLWithString:strURLSetCrit];
    ASIHTTPRequest *reqSetCrit=[ASIHTTPRequest requestWithURL:url];
    [reqSetCrit addRequestHeader:@"Content-Type" value:@"application/json"];
    [reqSetCrit addRequestHeader:@"TokenID" value:[APP_DEL strToken]];
    [reqSetCrit setRequestMethod:@"PUT"];
    
    /* We iterate the dictionary now
     and append each pair to an array
     formatted like <KEY>=<VALUE> */
    NSMutableArray *pairs = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSString *key in self.dForSearch) {
        [pairs addObject:[NSString stringWithFormat:@"\"%@\":\"%@\"", key, [self.dForSearch objectForKey:key]]];
    }
    /* We finally join the pairs of our array
     using the ',\n' */
    NSString *requestParams = [pairs componentsJoinedByString:@",\n"];
    NSString *finalStr = [NSString stringWithFormat:@"{\n%@\n}",requestParams];
    NSLog(@"finalStr = %@", finalStr);
    NSMutableData *postData = [[NSMutableData alloc] initWithData:[finalStr dataUsingEncoding:NSUTF8StringEncoding]];
    [reqSetCrit setPostBody:postData];
    
    reqSetCrit.delegate=self;
    [reqSetCrit setUsername:strURLSetCrit];
    [self.nQ addOperation:reqSetCrit];
    
    //    strURL = [WEB_SERVICE_URL stringByAppendingFormat:WEB_HIDDEN_PARA,COMMON_PARSER.strActiveToken];
    //    NSLog(@"API hit -> %@",strURL);
    //    req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:strURL]];
    //    [req setDelegate:self];
    //    [req setUsername:strURL];
    //    [self.nQ addOperation:req];
    
//    if( (self.sgSearchOptions.selectedSegmentIndex==0) || (self.sgSearchOptions.selectedSegmentIndex==2 && self.nxtdSrchCategory.selectedIP ) ) {
//        strURL = [WEB_SERVICE_URL stringByAppendingFormat:WEB_SET_BUSINESSTYPE,COMMON_PARSER.strActiveToken];
//        //NSLog(@"API hit -> %@",strURL);
//        req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:strURL]];
//        [req setDelegate:self];
//        [req setUsername:strURL];
//        [self.nQ addOperation:req];
//    }
    
    //Rajeev End
    
    [self.nQ go];
}

- (void)requestFinished:(ASIHTTPRequest *)request {

}

// 4. start setting search criterias again if failed.
- (void)requestFailed:(ASIHTTPRequest *)request {

}

// 5. start fetching records after setting search criterias
- (void)allRequestFinished:(ASINetworkQueue*)netQ {
   NSLog(@"All criterias set now -> ready to fetch records");
    [[iNetMngr requestObject] hideProgressHUD];
    [iNetMngr getRecords:self pageNumber:[self.numberFrom stringValue] numberOfRecords:[self.numberTo stringValue]];
}


// 1. clear criterias
- (void)clearUpCriteria {
    [[iNetMngr requestObject] showProgressHUD:@"Please wait..." title:@"Loading"];
    [self setSearchCriteria];
}

- (void)createToken {
    //Rajeev Start
//    if([APP_DEL strToken] && [APP_DEL strToken].length>0) {
//        [self clearUpCriteria];
//    } else {
    //Rajeev End
        [iNetMngr createToken:self];
//    }
}


- (void)webRequestReceivedData:(NSData *)data {
    if(data && [data length]>0) {
        // parse data if available
        [COMMON_PARSER parseData:data];
        
        //Rajeev Start
        
        NSLog(@"COMMON_PARSER.jsonReponse = %@", [COMMON_PARSER.jsonReponse description]);
        
        COMMON_PARSER.dStatus = [NSDictionary dictionaryWithObjectsAndKeys:[[COMMON_PARSER.jsonReponse valueForKey:@"Response"] valueForKey:@"responseCode"],@"responseCode",[[COMMON_PARSER.jsonReponse valueForKey:@"Response"] valueForKey:@"responseMessage"],@"responseMessage",nil];
        NSLog(@"COMMON_PARSER.dStatus = %@", [COMMON_PARSER.dStatus description]);
        NSInteger statusCode = [[COMMON_PARSER.dStatus valueForKey:@"responseCode"] intValue];
        NSLog(@"statusCode = %d", statusCode);
        //COMMON_PARSER.dStatus=[[COMMON_PARSER.jsonReponse valueForKey:@"response"] valueForKey:@"status"];
        //NSInteger statusCode = [[COMMON_PARSER.dStatus valueForKey:@"statusCode"] intValue];
        
        if(([[COMMON_PARSER.dStatus valueForKey:@"responseCode"] isEqualToString:@"A-512"] && [COMMON_PARSER.dStatus valueForKey:@"responseMessage"]) || ([[COMMON_PARSER.dStatus valueForKey:@"responseCode"] isEqualToString:@"I-501"] && [COMMON_PARSER.dStatus valueForKey:@"responseMessage"]) || [[COMMON_PARSER.dStatus valueForKey:@"responseCode"] isEqualToString:@"Q-506"]/*statusCode==401 && [COMMON_PARSER.dStatus valueForKey:@"message"]*/) {
            if([[COMMON_PARSER.dStatus valueForKey:@"responseMessage"] rangeOfString:@"Invalid Access Token or Access Token has expired"].length>0 || [[COMMON_PARSER.dStatus valueForKey:@"responseMessage"] rangeOfString:@"Invalid Token"].length>0) {
                [APP_DEL setStrToken:nil];
                [self createToken]; return;
            }
        }
        //Rajeev End
        
        // verify what kind of data has arrived
        // 1. if data is for token request
        if([[[iNetMngr requestObject] restValue] isKindOfClass:[NSNull class]]) return;
        
        if([[[iNetMngr requestObject] restValue] rangeOfString:@"auth/subscriber/?AccessToken"].length>0) {
            // set token value
            if(statusCode==200) {
                //Rajeev Start
                COMMON_PARSER.dToken=nil;//[[COMMON_PARSER.jsonReponse valueForKey:@"response"] valueForKey:@"token"];
                COMMON_PARSER.responseDetails = [[COMMON_PARSER.jsonReponse valueForKey:@"Response"] valueForKey:@"responseDetails"];
                NSLog(@"COMMON_PARSER.responseDetails = %@", [COMMON_PARSER.responseDetails description]);
                COMMON_PARSER.strActiveToken=[COMMON_PARSER.responseDetails objectForKey:@"TokenID"];//[COMMON_PARSER.dToken valueForKey:@"guid"];
                NSLog(@"TokenID = %@", COMMON_PARSER.strActiveToken);
                [APP_DEL setStrToken:COMMON_PARSER.strActiveToken];
                // generate request for
                //[iNetMngr createSession:self];
                //[iNetMngr getStates:self];
                [self clearUpCriteria];
                //Rajeev End
            } else {
                [iNetMngr createToken:self];
            }
            
            // 2. if data is for creating token, Create Session.
        } else if ([[[iNetMngr requestObject] restValue] rangeOfString:@"create?token"].length>0) {
            if(statusCode==201) {
                [iNetMngr setRqstDBToCombine:self];
            } else {
                [iNetMngr createToken:self];
            }
            
            // 3. if data is for setting up user details
        } else if ([[[iNetMngr requestObject] restValue] rangeOfString:@"username"].length>0) {
            if(statusCode==201) {
                [iNetMngr setRqstIP:self ip:IP_ADDRESS];
            } else {
                [iNetMngr createToken:self];
            }
            
            // 4. if data is for setting up user ip
        } else if ([[[iNetMngr requestObject] restValue] rangeOfString:@"userip"].length>0) {
            if(statusCode==201) {
                [iNetMngr setRqstDBToCombine:self];
            } else {
                [iNetMngr createToken:self];
            }
            
            // 5. if data is for setting up database access
        }
//        else if ([[[iNetMngr requestObject] restValue] rangeOfString:@"combined"].length>0) {
//            if(statusCode==201) {
//                if(self.isFetchingRecords && !self.isFetchingStates) {
//                    [self clearUpCriteria];
//                } else if(self.isFetchingStates && !self.isFetchingRecords) {
//                    
//                }
//            } else {
//                [iNetMngr createToken:self];
//            }
//        }
        else if ([[[iNetMngr requestObject] restValue] rangeOfString:@"search/combined/"].length>0) {
            //NSLog(@"response is %@",COMMON_PARSER.jsonReponse);
            if(statusCode==200) {
                [self setupRecordsResponse];
            } else {
                ALERT(@"Message", @"No records found", @"OK", self, nil);
            }
        }
    } else {
        ALERT(@"Message", @"Please check your internet connection & try again later.", @"OK", self, nil);
    }
}

- (void)setupRecordsResponse{
    self.tableSrchBar.text=@"";
    [self.tableSrchBar resignFirstResponder];
    self.isSearching=NO;
    
    self.totalRecords = [[[[[COMMON_PARSER.jsonReponse valueForKey:@"Response"] valueForKey:@"responseDetails"] valueForKey:@"SearchResult"] valueForKey:@"totalCount"] intValue];
    
    if(self.totalRecords==0) {
        ALERT(@"Message", @"No records found", @"OK", self, nil);
    }
    
    if(self.totalRecords<25) {
        self.numberTo=[NSNumber numberWithInt:self.totalRecords];
        self.sgNextPrev.hidden=YES;
    } else {
        self.sgNextPrev.hidden=NO;
    }
    
    NSArray *arOfRecords = [[[[COMMON_PARSER.jsonReponse valueForKey:@"Response"] valueForKey:@"responseDetails"] valueForKey:@"SearchResult"] valueForKey:@"searchResultRecord"];
	
    if([arOfRecords isKindOfClass:[NSDictionary class]]) {
        NSArray *arOfFieldValues = [[[[[COMMON_PARSER.jsonReponse valueForKey:@"Response"] valueForKey:@"responseDetails"] valueForKey:@"SearchResult"] valueForKey:@"searchResultRecord"] valueForKey:@"resultFields"];
        NSMutableDictionary *dOfSingleRecord = [NSMutableDictionary dictionary];
        for (NSDictionary *dFieldValue in arOfFieldValues) {
            [dOfSingleRecord setValue:[dFieldValue valueForKey:@"fieldValue"]
                               forKey:[dFieldValue valueForKey:@"fieldName"]
             ];
            [dOfSingleRecord setValue:[dFieldValue valueForKey:@"fieldID"]
                               forKey:@"fieldID"
             ];
        }
        self.arOfRecords=[NSArray arrayWithObject:dOfSingleRecord];
    } else {
        NSMutableArray *arOfProperRecords = [NSMutableArray array];
        for (NSDictionary *dRecordField in arOfRecords) {
            if([dRecordField valueForKey:@"resultFields"]) {
                NSArray *arOfFieldValues = [dRecordField valueForKey:@"resultFields"];
                NSMutableDictionary *dOfSingleRecord = [NSMutableDictionary dictionary];
                for (NSDictionary *dFieldValue in arOfFieldValues) {
                    [dOfSingleRecord setValue:[dFieldValue valueForKey:@"fieldValue"]
                                       forKey:[dFieldValue valueForKey:@"fieldName"]
                     ];
                    [dOfSingleRecord setValue:[dFieldValue valueForKey:@"fieldID"]
                                       forKey:@"fieldID"
                     ];
                }
                [arOfProperRecords addObject:dOfSingleRecord];
            }
        }
        self.arOfRecords=[NSArray arrayWithArray:arOfProperRecords];
    }
    if(self.arOfRecords.count>0) {
        self.tableViewRecords.hidden=NO;
        self.lblRecordsTitle.hidden=NO;
        self.tBarNextPre.hidden=NO;
        self.tableSrchBar.selectedScopeButtonIndex=0;
		
		//Ankit
		
		NSNumber *number = [NSNumber numberWithInt:self.totalRecords];
		NSNumberFormatter *frmtr = [[NSNumberFormatter alloc] init];
		[frmtr setGroupingSize:3];
		[frmtr setGroupingSeparator:@","];
		[frmtr setUsesGroupingSeparator:YES];
		NSString *commaString = [frmtr stringFromNumber:number];		
        self.lblRecordsTitle.text=[NSString stringWithFormat:@"%@ Results\nDisplaying %@ to %@",commaString,[self.numberFrom stringValue],[self.numberTo stringValue]];
    } else {
        self.tableViewRecords.hidden=YES;
        self.lblRecordsTitle.hidden=YES;
        self.tBarNextPre.hidden=YES;
    }
    
    if([self.numberFrom intValue]==1) {
        [self.sgNextPrev setEnabled:NO forSegmentAtIndex:0];
    } else {
        [self.sgNextPrev setEnabled:YES forSegmentAtIndex:0];
    }
    
    if([self.numberTo intValue]>=self.totalRecords) {
       [self.sgNextPrev setEnabled:NO forSegmentAtIndex:1];
    } else {
       [self.sgNextPrev setEnabled:YES forSegmentAtIndex:1]; 
    }
    
    [self.tableViewRecords reloadData];
    [self.mapViewRecords removeAnnotations:[self.mapViewRecords annotations]];
    [self addPins];
}

@end
