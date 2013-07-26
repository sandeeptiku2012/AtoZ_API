//
//  dSrchPerson.m
//  AtoZ
//
//  Created by Valtech on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "dSrchPerson.h"
#import "dRcrdVCtr.h"

@implementation dSrchPerson
@synthesize btnBoth = _btnBoth;
@synthesize btnBuiz = _btnBuiz;
@synthesize btnResi = _btnResi;
@synthesize predRcrdVCtr = _predRcrdVCtr;
@synthesize txtFName = _txtFName;
@synthesize txtLName = _txtLName;
@synthesize txtCity = _txtCity;
@synthesize txtState = _txtState;
@synthesize sgLocation = _sgLocation;

@synthesize btnEntireUs = _btnEntireUs;
@synthesize btnCurrentLocation = _btnCurrentLocation;
@synthesize btnCity = _btnCity;

@synthesize nxtdSelectState = _nxtdSelectState;
@synthesize strState = _strState;
@synthesize strStateKey = _strStateKey;
@synthesize strMiles = _strMiles;
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
    
  
    self.title=@"Find a Person";
    self.navigationItem.title=@"Find a Person";
    
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchTapped:)];
    [item setStyle:UIBarButtonItemStyleDone];
    self.navigationItem.rightBarButtonItem=item;
    
    item=[[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearAll)];
    [item setStyle:UIBarButtonItemStylePlain];
    self.navigationItem.leftBarButtonItem = item;
    [self btnBothTapped:nil];
	self.img2Miles.highlighted=YES;
	self.strMiles=@"2";
	[self CurrentLocationTapped:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSError *error = nil;
    [[GANTracker sharedTracker] trackPageview:@"iPad Person Search Page" withError:&error];
    self.trackedViewName=@"iPad Person Search Page";
    
    CGSize size = CGSizeMake(337, 292); // size of view in popover
    self.contentSizeForViewInPopover = size;
    self.txtState.text = (self.strState)?self.strState:@"";
    if(self.sgLocation.selectedSegmentIndex==0) {
        [self.predRcrdVCtr.pVCtr setPopoverContentSize:CGSizeMake(337, 360) animated:YES];
    } else {
        [self.predRcrdVCtr.pVCtr setPopoverContentSize:CGSizeMake(337, 210) animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(self.sgLocation.selectedSegmentIndex==0) {
        [self.predRcrdVCtr.pVCtr setPopoverContentSize:CGSizeMake(337, 360) animated:YES];
    } else {
        [self.predRcrdVCtr.pVCtr setPopoverContentSize:CGSizeMake(337, 210) animated:YES];
    }
}

- (void)viewDidUnload
{
    [self setTxtFName:nil];
    [self setTxtLName:nil];
    [self setSgLocation:nil];
    [self setTxtCity:nil];
    [self setTxtState:nil];
    [self setBtnBoth:nil];
    [self setBtnBuiz:nil];
    [self setBtnResi:nil];
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

- (IBAction)btnStateTapped:(id)sender {
    [self.txtCity resignFirstResponder];
    [self.txtFName resignFirstResponder];
    [self.txtLName resignFirstResponder];
    
    self.nxtdSelectState=[[dSelectState alloc] initWithNibName:@"dSelectState" bundle:nil];
    self.nxtdSelectState.preVCtr=self;
    self.nxtdSelectState.arForStates=[self.predRcrdVCtr arForStates];
    self.nxtdSelectState.predRcrdVCtr=self.predRcrdVCtr;
    [self.navigationController pushViewController:self.nxtdSelectState animated:YES];
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

- (IBAction)CityStateTapped:(id)sender {
	self.sgLocation.selectedSegmentIndex=0;
	self.lblMiles.hidden=YES;
    self.img2Miles.hidden=YES;
	self.img5Miles.hidden=YES;
	self.img10Miles.hidden=YES;
	self.btnCity.selected=YES;
	self.btnCurrentLocation.selected=NO;
	self.btnEntireUs.selected=NO;
	[self sgChanged:self.sgLocation];
}

- (IBAction)CurrentLocationTapped:(id)sender {
	self.sgLocation.selectedSegmentIndex=1;
	self.lblMiles.hidden=NO;
    self.img2Miles.hidden=NO;
	self.img5Miles.hidden=NO;
	self.img10Miles.hidden=NO;
	self.btnCity.selected=NO;
	self.btnCurrentLocation.selected=YES;
	self.btnEntireUs.selected=NO;
	[self sgChanged:self.sgLocation];
}

- (IBAction)EntireUsTapped:(id)sender {
	self.sgLocation.selectedSegmentIndex=2;
	self.lblMiles.hidden=YES;
    self.img2Miles.hidden=YES;
	self.img5Miles.hidden=YES;
	self.img10Miles.hidden=YES;
	self.btnCity.selected=NO;
	self.btnCurrentLocation.selected=NO;
	self.btnEntireUs.selected=YES;
	[self sgChanged:self.sgLocation];
}




- (IBAction)sgChanged:(id)sender {
    if([(UISegmentedControl*)sender selectedSegmentIndex]==0) {
        [self.predRcrdVCtr.pVCtr setPopoverContentSize:CGSizeMake(337, 360) animated:YES];
    } else {
        [self.predRcrdVCtr.pVCtr setPopoverContentSize:CGSizeMake(337, 210) animated:YES];
    }
}

-(void)searchTapped:(id)sender {
    if(self.txtFName.text.length>0 || self.txtLName.text.length>0 || self.txtCity.text.length>0 || self.txtState.text.length>0) {
        
        NSError *error = nil;
        if (![[GANTracker sharedTracker] trackEvent:@"iPad Person Search Tapped"action:@"TrackEvent" label:[NSString stringWithFormat:@"%@ %@",self.txtFName.text,self.txtLName.text] value:-1 withError:&error]) {
            NSLog(@"Error Occured ==>%@",error);
        }
        
          [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:@"Person Search Tapped" withAction:@"TrackEvent" withLabel:[NSString stringWithFormat:@"%@ %@",self.txtFName.text,self.txtLName.text] withValue:[NSNumber numberWithInt:111]]; 
        
        [self.predRcrdVCtr resetProcess];
        
        NSMutableDictionary *dToSearch = [NSMutableDictionary dictionary];
        
        if(self.txtFName.text.length>0) {
            [dToSearch setValue:self.txtFName.text forKey:@"First_Name"];
        }
        
        if(self.txtLName.text.length>0) {
            [dToSearch setValue:self.txtLName.text forKey:@"Last_Name"];
        }
        
        if(self.sgLocation.selectedSegmentIndex==0) {
            if(self.txtCity.text.length>0) {
                [dToSearch setValue:self.txtCity.text forKey:@"Physical_City"];
            }
            
            if(self.strStateKey.length>0) {
                [dToSearch setValue:self.strStateKey forKey:@"Physical_State"];
            }
        } else if (self.sgLocation.selectedSegmentIndex==1) {
            CLLocationCoordinate2D coOrd = self.predRcrdVCtr.mapViewRecords.userLocation.location.coordinate;
            NSString *strZip = [self getAdrressFromLatLong:coOrd.latitude lon:coOrd.longitude];
            if(strZip && strZip.length>0) {
                strZip = [NSString stringWithFormat:@"|%@|%@",strZip,self.strMiles];
                [dToSearch setValue:strZip forKey:@"proximity"];
            }
        }
        
        //Rajeev Start
        [dToSearch setValue:@"0" forKey:@"recordtype"];
        [dToSearch setValue:@"1" forKey:@"is_primaryExec"];
        //Rajeev End
        
        if(self.btnBoth.highlighted) {
        } else if(self.btnBuiz.highlighted) {
            [dToSearch setValue:@"B" forKey:@"databasetype"];
        } else if(self.btnResi.highlighted) {
            [dToSearch setValue:@"C" forKey:@"databasetype"];         
        }
        
        self.predRcrdVCtr.dForSearch=dToSearch;
        
        [self.predRcrdVCtr performSelector:@selector(createToken) withObject:nil afterDelay:0.2];
        
        [self.predRcrdVCtr.pVCtr dismissPopoverAnimated:YES];  
    } else {
        ALERT(@"Please enter the search criteria.", nil, @"OK", self, nil);
    }
}

- (IBAction)btnBothTapped:(id)sender {
    self.btnBuiz.highlighted=NO;
    self.btnResi.highlighted=NO;
    self.btnBoth.highlighted=YES;
}

- (IBAction)btnBusinessesTapped:(id)sender {
    self.btnResi.highlighted=NO;
    self.btnBoth.highlighted=NO;
    self.btnBuiz.highlighted=YES;
}

- (IBAction)btnResiTapped:(id)sender {
    self.btnBoth.highlighted=NO;
    self.btnBuiz.highlighted=NO;
    self.btnResi.highlighted=YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searchTapped:nil];
    return YES;
}

- (void)clearAll {
    self.txtCity.text=self.txtFName.text=self.txtLName.text=self.txtState.text=@"";
    self.sgLocation.selectedSegmentIndex=0;
    self.btnBoth.highlighted=YES;
    self.btnBuiz.highlighted=NO;
    self.btnResi.highlighted=NO;
    self.strState=self.strStateKey=nil;
	self.img2Miles.highlighted=YES;
	self.img5Miles.highlighted=NO;
	self.img10Miles.highlighted=NO;
	self.strMiles=@"2";
	[self CurrentLocationTapped:nil];
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

@end
