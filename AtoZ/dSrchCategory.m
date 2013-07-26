//
//  dSrchCategory.m
//  AtoZ
//
//  Created by Valtech on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "dSrchCategory.h"
#import "dRcrdVCtr.h"

@implementation dSrchCategory
@synthesize predRcrdVCtr = _predRcrdVCtr;
@synthesize txtCCategory = _txtCCategory;
@synthesize txtCity = _txtCity;
@synthesize txtState = _txtState;
@synthesize sgLocation = _sgLocation;

@synthesize tblCategories = _tblCategories;
@synthesize arForCategory = _arForCategory;
@synthesize selectedIP = _selectedIP;

@synthesize btnEntireUs = _btnEntireUs;
@synthesize btnCurrentLocation = _btnCurrentLocation;
@synthesize btnCity = _btnCity;


@synthesize nxtdSelectState = _nxtdSelectState;
@synthesize strState = _strState;
@synthesize strStateKey = _strStateKey;
@synthesize scrMain = _scrMain;


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
    [self.scrMain setContentSize:CGSizeMake(337, 600)];
    
    self.tblCategories.layer.borderColor=[[UIColor blackColor]CGColor];
    self.tblCategories.layer.cornerRadius=4;
    self.tblCategories.layer.borderWidth=1;
    self.title=@"Search by Category";;
    self.navigationItem.title=@"Search by Category";
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchTapped:)];
    [item setStyle:UIBarButtonItemStyleDone];
    self.navigationItem.rightBarButtonItem=item;
    
    item=[[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearAll)];
    [item setStyle:UIBarButtonItemStylePlain];
    self.navigationItem.leftBarButtonItem = item;
    
    self.selectedIP=nil;
	self.img2Miles.highlighted=YES;
	self.strMiles=@"2";
	[self CurrentLocationTapped:nil];
    self.arForCategory=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ECCategoriesArray" ofType:@"plist"]];
}

- (void)viewWillAppear:(BOOL)animated { // 337 + 44 = 381
    [super viewWillAppear:animated];
    
    NSError *error = nil;
    [[GANTracker sharedTracker] trackPageview:@"iPad Category Search Page" withError:&error];
    self.trackedViewName=@"iPad Category Search Page";

    
    
    
    
    CGSize size = CGSizeMake(337, 381); // size of view in popover
    self.contentSizeForViewInPopover = size;
    self.txtState.text = (self.strState)?self.strState:@"";
    if(self.sgLocation.selectedSegmentIndex==0) {
        [self.predRcrdVCtr.pVCtr setPopoverContentSize:CGSizeMake(337, 390) animated:YES];
    } else {
        [self.predRcrdVCtr.pVCtr setPopoverContentSize:CGSizeMake(337, 270) animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(self.sgLocation.selectedSegmentIndex==0) {
        [self.predRcrdVCtr.pVCtr setPopoverContentSize:CGSizeMake(337, 390) animated:YES];
    } else {
        [self.predRcrdVCtr.pVCtr setPopoverContentSize:CGSizeMake(337, 270) animated:YES];
    }
}

- (void)viewDidUnload
{
    [self setTxtCCategory:nil];
    [self setTxtCity:nil];
    [self setTxtState:nil];
    [self setSgLocation:nil];
    [self setTblCategories:nil];
    [self setArForCategory:nil];
    [self setSelectedIP:nil];
    [self setScrMain:nil];
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

-(void)searchTapped:(id)sender {
    
    if(self.selectedIP || self.txtCCategory.text.length>0 || self.txtCity.text.length>0 || self.txtState.text.length>0) {
        
  NSError *error = nil;
  if (![[GANTracker sharedTracker] trackEvent:@"Category Search Tapped" action:@"TrackEvent"
            label:[[self.arForCategory objectAtIndex:self.selectedIP.row] valueForKey:@"name"]
        value:-1 withError:&error]) {
            NSLog(@"Error Occured ==>%@",error);
        }        
        
        [self.predRcrdVCtr resetProcess];
        
        NSMutableDictionary *dToSearch = [NSMutableDictionary dictionary];
        
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

        if(self.selectedIP || self.txtCCategory.text.length>0) {
            if(self.selectedIP) {
                NSString *strSIC = [[self.arForCategory objectAtIndex:self.selectedIP.row] valueForKey:@"id"];
                //Rajeev Start
                //[dToSearch setValue:strSIC forKey:@"SIC_Description"];
                [dToSearch setValue:strSIC forKey:@"SICS"];
                //Rajeev End
            } else {
                //Rajeev Start
                //[dToSearch setValue:self.txtCCategory.text forKey:@"Company_Name_3"];
                [dToSearch setValue:self.txtCCategory.text forKey:@"Company_Name"];
                //Rajeev End
            }
        }
        
        //Rajeev Start
        [dToSearch setValue:@"0" forKey:@"recordtype"];
        [dToSearch setValue:@"1" forKey:@"is_primaryExec"];
        //Rajeev End
        
        self.predRcrdVCtr.dForSearch=dToSearch;
        [self.predRcrdVCtr performSelector:@selector(createToken) withObject:nil afterDelay:0.2];   
        [self.predRcrdVCtr.pVCtr dismissPopoverAnimated:YES];  
    } else {
        ALERT(@"Please enter the search criteria.", nil, @"OK", self, nil);
    }
}

- (IBAction)sgChanged:(id)sender {
    if([(UISegmentedControl*)sender selectedSegmentIndex]==0) {
        [self.predRcrdVCtr.pVCtr setPopoverContentSize:CGSizeMake(337, 390) animated:YES];
    } else {
        [self.predRcrdVCtr.pVCtr setPopoverContentSize:CGSizeMake(337, 270) animated:YES];
    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arForCategory count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        [cell.textLabel setTextColor:[UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    [cell setAccessoryType:([indexPath isEqual:self.selectedIP])?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone];
    
    if([indexPath isEqual:self.selectedIP]) {
        [cell.backgroundView setBackgroundColor:[UIColor lightGrayColor]];
    } else {
        [cell.backgroundView setBackgroundColor:[UIColor whiteColor]];
    }
    
    cell.textLabel.text=[[self.arForCategory objectAtIndex:indexPath.row] valueForKey:@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.selectedIP) {
        [(UITableViewCell*)[self.tblCategories cellForRowAtIndexPath:self.selectedIP] setAccessoryType:UITableViewCellAccessoryNone];
    }
    self.selectedIP=indexPath;
    [(UITableViewCell*)[self.tblCategories cellForRowAtIndexPath:self.selectedIP] setAccessoryType:UITableViewCellAccessoryCheckmark];
    self.txtCCategory.text=@"";
    [self.txtCCategory resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(self.txtCity==textField || self.txtCCategory==textField) {
        [self searchTapped:nil];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if([textField isEqual:self.txtCCategory]) {
        [self performSelector:@selector(checkTextLength) withObject:nil afterDelay:0.3];
    }
    return YES;
}

- (void)checkTextLength {
    if(self.txtCCategory.text.length>0) {
        [(UITableViewCell*)[self.tblCategories cellForRowAtIndexPath:self.selectedIP] setAccessoryType:UITableViewCellAccessoryNone];
        self.selectedIP=nil;
        [self.tblCategories reloadData];
    }
}

- (IBAction)btnStateTapped:(id)sender {
    [self.txtCCategory resignFirstResponder];
    [self.txtCity resignFirstResponder];
    
    self.nxtdSelectState=[[dSelectState alloc] initWithNibName:@"dSelectState" bundle:nil];
    self.nxtdSelectState.preVCtr=self;
    self.nxtdSelectState.arForStates=[self.predRcrdVCtr arForStates];
    self.nxtdSelectState.predRcrdVCtr=self.predRcrdVCtr;
    [self.navigationController pushViewController:self.nxtdSelectState animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.scrMain scrollRectToVisible:CGRectMake(0, 0, 337, 100) animated:YES];
    if([textField isEqual:self.txtCCategory] && self.txtCCategory.text.length>0) {
        [(UITableViewCell*)[self.tblCategories cellForRowAtIndexPath:self.selectedIP] setAccessoryType:UITableViewCellAccessoryNone];
        self.selectedIP=nil;
        [self.tblCategories reloadData];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if(textField==self.txtCity) {
        [self.scrMain scrollRectToVisible:CGRectMake(0, 95, 337, 337) animated:YES];
    }
}

- (void)clearAll { 
    [(UITableViewCell*)[self.tblCategories cellForRowAtIndexPath:self.selectedIP] setAccessoryType:UITableViewCellAccessoryNone];
    self.selectedIP=nil;
    self.strState=self.strStateKey=nil;
    self.txtCCategory.text=self.txtCity.text=self.txtState.text=nil;
	self.img2Miles.highlighted=YES;
	self.img5Miles.highlighted=NO;
	self.img10Miles.highlighted=NO;
	self.strMiles=@"2";
	[self CurrentLocationTapped:nil];
    [self.tblCategories reloadData];
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
