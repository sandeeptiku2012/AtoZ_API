//
//  dSrchBusiness.m
//  AtoZ
//
//  Created by Valtech on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "dSrchBusiness.h"
#import "dRcrdVCtr.h"

@implementation dSrchBusiness
@synthesize predRcrdVCtr = _predRcrdVCtr;
@synthesize txtBName = _txtBName;
@synthesize txtCity = _txtCity;
@synthesize txtState = _txtState;
@synthesize sgBusinessRange = _sgBusinessRange;
@synthesize imgVChck = _imgVChck;
@synthesize strMiles = _strMiles;

@synthesize nxtdSelectState = _nxtdSelectState;
@synthesize strState = _strState;
@synthesize strStateKey = _strStateKey;
@synthesize btnEntireUs = _btnEntireUs;
@synthesize btnCurrentLocation = _btnCurrentLocation;
@synthesize btnCity = _btnCity;
@synthesize img2Miles = _img2Miles;
@synthesize img5Miles = _img5Miles;
@synthesize img10Miles = _img10Miles;
@synthesize lblMiles = _lblMiles;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.title=@"Find a Business";
    self.navigationItem.title=@"Find a Business";
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchTapped:)];
    [item setStyle:UIBarButtonItemStyleDone];
    self.navigationItem.rightBarButtonItem=item;
    item=[[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearAll)];
    [item setStyle:UIBarButtonItemStylePlain];
    self.navigationItem.leftBarButtonItem = item;
	self.img2Miles.highlighted=YES;
	self.strMiles=@"2";
	[self CurrentLocationTapped:nil];
    
    if(![self.predRcrdVCtr arForStates] || [self.predRcrdVCtr arForStates].count==0 ) {
        [self createToken];
    }
    //NSLog(@"business loaded");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSError *error = nil;
    [[GANTracker sharedTracker] trackPageview:@"iPad Business Search Page" withError:&error];
    self.trackedViewName=@"iPad Business Search Page";
    
    
    CGSize size = CGSizeMake(337, 292); // size of view in popover
    self.contentSizeForViewInPopover = size;
    self.txtState.text = (self.strState)?self.strState:@"";
    if(self.sgBusinessRange.selectedSegmentIndex==0) {
        [self.predRcrdVCtr.pVCtr setPopoverContentSize:CGSizeMake(337, 355) animated:YES];
    } else {
        [self.predRcrdVCtr.pVCtr setPopoverContentSize:CGSizeMake(337, 210) animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self.sgBusinessRange.selectedSegmentIndex==0) {
        [self.predRcrdVCtr.pVCtr setPopoverContentSize:CGSizeMake(337, 355) animated:YES];
    } else {
        [self.predRcrdVCtr.pVCtr setPopoverContentSize:CGSizeMake(337, 210) animated:YES];
    }
}

- (void)setUpSize {
    [self.predRcrdVCtr.pVCtr setPopoverContentSize:CGSizeMake(337, 355) animated:NO];
}

- (void)viewDidUnload
{
    [self setTxtBName:nil];
    [self setTxtCity:nil];
    [self setTxtState:nil];
    [self setSgBusinessRange:nil];
    [self setImgVChck:nil];
    [self setBtnEntireUs:nil];
    [self setBtnCurrentLocation:nil];
    [self setBtnCity:nil];
    [super viewDidUnload];
}

#ifdef IOS_OLDER_THAN__IPHONE_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}
#endif

#ifdef IOS_NEWER_OR_EQUAL_TO__IPHONE_6_0
-(BOOL)shouldAutorotate
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskAll);
}
#endif

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return YES;
//}

- (IBAction)SearchBusinessTapped:(id)sender {
	self.sgBusinessRange.selectedSegmentIndex=0;
	self.lblMiles.hidden=YES;
    self.img2Miles.hidden=YES;
	self.img5Miles.hidden=YES;
	self.img10Miles.hidden=YES;
	self.btnCity.selected=YES;
	self.btnCurrentLocation.selected=NO;
	self.btnEntireUs.selected=NO;
	[self sgChanged:self.sgBusinessRange];
}

- (IBAction)CurrentLocationTapped:(id)sender {
	self.sgBusinessRange.selectedSegmentIndex=1;
	self.lblMiles.hidden=NO;
	self.img2Miles.hidden=NO;
	self.img5Miles.hidden=NO;
	self.img10Miles.hidden=NO;
	
	self.btnCity.selected=NO;
	self.btnCurrentLocation.selected=YES;
	self.btnEntireUs.selected=NO;
	[self sgChanged:self.sgBusinessRange];
}

- (IBAction)EntireUsTapped:(id)sender {
	self.sgBusinessRange.selectedSegmentIndex=2;
	self.lblMiles.hidden=YES;
	self.img2Miles.hidden=YES;
	self.img5Miles.hidden=YES;
	self.img10Miles.hidden=YES;
	self.btnCity.selected=NO;
	self.btnCurrentLocation.selected=NO;
	self.btnEntireUs.selected=YES;
	[self sgChanged:self.sgBusinessRange];
}
-(IBAction)btn2milesTapped:(id)sender{
	self.strMiles=@"2";
	self.img2Miles.highlighted=YES;
	self.img5Miles.highlighted=NO;
	self.img10Miles.highlighted=NO;
}
-(IBAction)btn5milesTapped:(id)sender{
	self.strMiles=@"5";
	self.img2Miles.highlighted=NO;
	self.img5Miles.highlighted=YES;
	self.img10Miles.highlighted=NO;
}
-(IBAction)btn10milesTapped:(id)sender{
	self.strMiles=@"10";
	self.img2Miles.highlighted=NO;
	self.img5Miles.highlighted=NO;
	self.img10Miles.highlighted=YES;
}
- (IBAction)sgChanged:(id)sender {
    if([(UISegmentedControl*)sender selectedSegmentIndex]==0) {
        [self.predRcrdVCtr.pVCtr setPopoverContentSize:CGSizeMake(337, 355) animated:YES];
    } else {
        [self.predRcrdVCtr.pVCtr setPopoverContentSize:CGSizeMake(337, 210) animated:YES];
    }
}

- (IBAction)btnStateTapped:(id)sender {
    [self.txtBName resignFirstResponder];
    [self.txtCity resignFirstResponder];
    self.nxtdSelectState=[[dSelectState alloc] initWithNibName:@"dSelectState" bundle:nil];
    self.nxtdSelectState.preVCtr=self;
    self.nxtdSelectState.arForStates=[self.predRcrdVCtr arForStates];
    self.nxtdSelectState.predRcrdVCtr=self.predRcrdVCtr;
    [self.navigationController pushViewController:self.nxtdSelectState animated:YES];
}

- (IBAction)btnHQTapped:(id)sender {
    self.imgVChck.highlighted=!self.imgVChck.highlighted;
}

-(void)searchTapped:(id)sender {
    if(self.txtBName.text.length>0 || self.txtCity.text.length>0 || self.txtState.text.length>0) {
        
        NSError *error = nil;
        if (![[GANTracker sharedTracker] trackEvent:@"iPad Business Search Tapped"action:@"TrackEvent" label:self.txtBName.text value:-1 withError:&error]) {
            NSLog(@"Error Occured ==>%@",error);
        }
          [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:@"iPad Business Search Tapped" withAction:@"TrackEvent" withLabel:self.txtBName.text withValue:[NSNumber numberWithInt:110]]; 
        
        
        [self.predRcrdVCtr resetProcess];
        
        NSMutableDictionary *dToSearch = [NSMutableDictionary dictionary];
        //
        if(self.txtBName.text.length>0) {
            //Rajeev Start
            [dToSearch setValue:self.txtBName.text forKey:@"Company_Name"];
            //           [dToSearch setValue:self.txtBName.text forKey:@"Company_Name_3"];
            //Rajeev End
        }
        
        if(self.sgBusinessRange.selectedSegmentIndex==0) {
            if(self.txtCity.text.length>0) {
                //Rajeev Start
                //                [dToSearch setValue:self.txtCity.text forKey:@"Physical_City"];
                [dToSearch setValue:self.txtCity.text forKey:@"Physical_City"];
                //Rajeev End
            }
            
            if(self.strStateKey.length>0) {
                //Rajeev Start
                //                [dToSearch setValue:self.strStateKey forKey:@"Physical_State"];
                [dToSearch setValue:self.strStateKey forKey:@"Physical_State"];
                //Rajeev End
            }
        } else if (self.sgBusinessRange.selectedSegmentIndex==1) {
            CLLocationCoordinate2D coOrd = self.predRcrdVCtr.mapViewRecords.userLocation.location.coordinate;
            NSString *strZip = [self getAdrressFromLatLong:coOrd.latitude lon:coOrd.longitude];
            if(strZip && strZip.length>0) {
                strZip = [NSString stringWithFormat:@"|%@|%@",strZip,self.strMiles];
                [dToSearch setValue:strZip forKey:@"proximity"];
            }
        }
        
        
        if(self.imgVChck.highlighted) {
            //Rajeev Start
            //            [dToSearch setValue:@"1" forKey:@"Location_Level"];
            [dToSearch setValue:@"1" forKey:@"locationlevel"];
            //Rajeev End
        }
        
        //Rajeev Start
        [dToSearch setValue:@"0" forKey:@"recordtype"];
        [dToSearch setValue:@"B" forKey:@"databasetype"];
        [dToSearch setValue:@"1" forKey:@"is_primaryExec"];
        //Rajeev End
        
        self.predRcrdVCtr.dForSearch=dToSearch;
        
        [self.predRcrdVCtr performSelector:@selector(createToken) withObject:nil afterDelay:0.2];
        
        [self.predRcrdVCtr.pVCtr dismissPopoverAnimated:YES];  
    } else {
        ALERT(@"Please enter the search criteria.", nil, @"OK", self, nil);
    }
}

- (void)clearAll {
    self.txtBName.text=self.txtCity.text=self.txtState.text=@"";
    self.sgBusinessRange.selectedSegmentIndex=0;
    self.imgVChck.highlighted=NO; 
    self.strState=self.strStateKey=nil;
	self.img2Miles.highlighted=YES;
	self.img5Miles.highlighted=NO;
	self.img10Miles.highlighted=NO;
	self.strMiles=@"2";
	[self CurrentLocationTapped:nil];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searchTapped:nil];
    return YES;
}

-(NSString*)getAdrressFromLatLong : (CGFloat)lat lon:(CGFloat)lon{
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
                return zip;
            } else {
                return nil;
                // 46923 68137
                // self.strZip=@"46923";
            }
        } else {
            return nil;
        }
    } else return nil;
}

#pragma mark - load states

- (void)createToken {
    [iNetMngr createToken:self];
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
                [iNetMngr getStates:self];
                //Rajeev End
            } else {
                                [self.predRcrdVCtr.pVCtr dismissPopoverAnimated:YES];
            }
            
            // 2. if data is for creating token
        } else if ([[[iNetMngr requestObject] restValue] rangeOfString:@"create?token"].length>0) {
            if(statusCode==201) {
                [iNetMngr setRqstDBToCombine:self];
            } else {
                [self.predRcrdVCtr.pVCtr dismissPopoverAnimated:YES];
            }
        } else if ([[[iNetMngr requestObject] restValue] rangeOfString:@"combined"].length>0) {
            if(statusCode==201) {
                [iNetMngr getStates:self];
            } else {
                [self.predRcrdVCtr.pVCtr dismissPopoverAnimated:YES];
            }
        } else if ([[[iNetMngr requestObject] restValue] rangeOfString:@"lookup/metadata/business"].length>0) {
            //NSLog(@"response is %@",COMMON_PARSER.jsonReponse);
            if(statusCode==200) {
                //Rajeev Start
                NSDictionary *dToAccess = [[COMMON_PARSER.jsonReponse valueForKey:@"Response"] valueForKey:@"responseDetails"];//[[COMMON_PARSER.jsonReponse valueForKey:@"response"] valueForKey:@"metaDataLookup"];
                NSLog(@"dToAccess = %@", [dToAccess description]);
                if(dToAccess && [dToAccess valueForKey:@"RefLookUpDetails"] && [[dToAccess valueForKey:@"RefLookUpDetails"] count]>0) {
                    NSArray *arOFSTATES=[dToAccess valueForKey:@"RefLookUpDetails"];
                    NSMutableArray *arStates = [NSMutableArray arrayWithObject:[NSDictionary dictionaryWithObjectsAndKeys:@"All",@"displayValue", nil]];
                    [arStates addObjectsFromArray:arOFSTATES];
                    
                     self.predRcrdVCtr.arForStates=arStates;
//                    self.preTabBarCtr.arForStates=arStates;
                    //Rajeev End
                }
            } else {
                                [self.predRcrdVCtr.pVCtr dismissPopoverAnimated:YES];
            }
        }
    } else {
        ALERT(@"Message", @"Please check your internet connection & try again later.", @"OK", self, nil);
    }
}


@end
