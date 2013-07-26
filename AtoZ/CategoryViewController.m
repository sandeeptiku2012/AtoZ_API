//
//  CategoryViewController.m
//  AtoZdatabases
//
//  Created by Ankit Vyas on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoryViewController.h"
#import "ResultViewController.h"

@implementation CategoryViewController
@synthesize arForCategory = _arForCategory;

@synthesize txtCCategory = _txtCCategory;
@synthesize txtCity = _txtCity;
@synthesize txtState = _txtState;
@synthesize sgLocation = _sgLocation;

@synthesize tblCategories = _tblCategories;
@synthesize selectedIP = _selectedIP;

@synthesize btnEntireUs = _btnEntireUs;
@synthesize btnCurrentLocation = _btnCurrentLocation;
@synthesize btnCity = _btnCity;

@synthesize strState = _strState;
@synthesize strStateKey = _strStateKey;
@synthesize scrMain = _scrMain;
@synthesize preTabBarCtr = _preTabBarCtr;
@synthesize vHide = _vHide;
@synthesize nxtResultViewController = _nxtResultViewController;
@synthesize img2miles = _img2miles;
@synthesize img5miles = _img5miles;
@synthesize img10miles = _img10miles;
@synthesize lblMiles = _lblMiles;
@synthesize strMiles = _strMiles;
@synthesize appdel = _appdel;


#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    
    NSError *error = nil;
    [[GANTracker sharedTracker] trackPageview:@"Category Search Page" withError:&error];
    self.trackedViewName=@"Category Search Page";

    
    
	[self.txtState resignFirstResponder];
    [self.txtCity resignFirstResponder];
    
	if (isBackFromSearchPage==NO) {
		self.img2miles.highlighted=YES;
		self.strMiles=@"2";
		self.img10miles.highlighted = NO;
		self.img5miles.highlighted = NO;
        
        self.txtCity.text = @"";
        self.txtCCategory.text = @"";
        self.txtState.text = @"";
		[self CurrentLocationTapped:nil];

		
	}else if(isBackFromSearchPage == YES)
		isBackFromSearchPage = NO;
   	[super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.txtState resignFirstResponder];
    [self.txtCity resignFirstResponder];
    if (isBackFromSearchPage != YES) {
        AppDelegate *appdel=[[UIApplication sharedApplication] delegate];
        appdel.isBackFromSearch = NO;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.appdel=[[UIApplication sharedApplication] delegate];
	
	NSLog(@"%0.2f",self.appdel.clatitude);
	self.tblCategories.layer.borderColor=[[UIColor blackColor]CGColor];
    self.tblCategories.layer.cornerRadius=4;
    self.tblCategories.layer.borderWidth=1;
	self.selectedIP=nil;
	self.strMiles=@"2";
	self.img2miles.highlighted=YES;
	[self CurrentLocationTapped:nil];
    self.arForCategory=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ECCategoriesArray" ofType:@"plist"]];
	
	self.scrMain.contentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height+100);
}

- (void)viewDidUnload
{
	[self setAppdel:nil];
	[self setStrMiles:nil];
	[self setLblMiles:nil];
	[self setArForCategory:nil];
	[self setTxtCity:nil];
	[self setTxtCCategory:nil];
	[self setTxtState:nil];
	[self setScrMain:nil];
	[self setStrState:nil];
	[self setVHide:nil];
	[self setImg2miles:nil];
	[self setImg5miles:nil];
	[self setImg10miles:nil];
    [self setNxtResultViewController:nil];
	[super viewDidUnload];
	
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return  UIInterfaceOrientationIsPortrait(interfaceOrientation);
}
-(IBAction)btn2milesTapped:(id)sender{
	self.strMiles=@"2";
	self.img2miles.highlighted=YES;
	self.img5miles.highlighted=NO;
	self.img10miles.highlighted=NO;
}
-(IBAction)btn5milesTapped:(id)sender{
	self.strMiles=@"5";
	self.img2miles.highlighted=NO;
	self.img5miles.highlighted=YES;
	self.img10miles.highlighted=NO;
}
-(IBAction)btn10milesTapped:(id)sender{
	self.strMiles=@"10";
	self.img2miles.highlighted=NO;
	self.img5miles.highlighted=NO;
	self.img10miles.highlighted=YES;
}
- (IBAction)CityStateTapped:(id)sender {
	[self.btnCity setBackgroundImage:[UIImage imageNamed:@"bg_wt.png"] forState:UIControlStateNormal];
	[self.btnCurrentLocation setBackgroundImage:[UIImage imageNamed:@"bg_gray.png"] forState:UIControlStateNormal];
	[self.btnEntireUs setBackgroundImage:[UIImage imageNamed:@"bg_gray.png"] forState:UIControlStateNormal];
	
	self.sgLocation.selectedSegmentIndex=0;
	self.btnCity.selected=YES;
	self.btnCurrentLocation.selected=NO;
	self.btnEntireUs.selected=NO;
	self.vHide.hidden=YES;
	self.lblMiles.hidden=YES;
	self.img10miles.hidden=YES;
	self.img2miles.hidden=YES;
	self.img5miles.hidden=YES;
}

- (IBAction)CurrentLocationTapped:(id)sender {
	[self.btnCity setBackgroundImage:[UIImage imageNamed:@"bg_gray.png"] forState:UIControlStateNormal];
	[self.btnEntireUs setBackgroundImage:[UIImage imageNamed:@"bg_gray.png"] forState:UIControlStateNormal];
	[self.btnCurrentLocation setBackgroundImage:[UIImage imageNamed:@"bg_wt.png"] forState:UIControlStateNormal];
    self.txtCity.text=@"";
    self.txtState.text=@"";
	self.sgLocation.selectedSegmentIndex=1;
	self.btnCity.selected=NO;
	self.btnCurrentLocation.selected=YES;
	self.btnEntireUs.selected=NO;
	self.vHide.hidden=NO;
	self.lblMiles.hidden=NO;
	self.img10miles.hidden=NO;
	self.img2miles.hidden=NO;
	self.img5miles.hidden=NO;
}

- (IBAction)EntireUsTapped:(id)sender {
	
	[self.btnEntireUs setBackgroundImage:[UIImage imageNamed:@"bg_wt.png"] forState:UIControlStateNormal];
	[self.btnCity setBackgroundImage:[UIImage imageNamed:@"bg_gray.png"] forState:UIControlStateNormal];
	[self.btnCurrentLocation setBackgroundImage:[UIImage imageNamed:@"bg_gray.png"] forState:UIControlStateNormal];
	
	
    self.txtCity.text=@"";
    self.txtState.text=@"";
	self.sgLocation.selectedSegmentIndex=2;
	self.btnCity.selected=NO;
	self.btnCurrentLocation.selected=NO;
	self.btnEntireUs.selected=YES;
	self.vHide.hidden=NO;
	self.lblMiles.hidden=YES;
	self.img10miles.hidden=YES;
	self.img2miles.hidden=YES;
	self.img5miles.hidden=YES;
    [self.txtCity resignFirstResponder];
}
- (IBAction)sgChanged:(id)sender {
    
}
-(IBAction)searchTapped:(id)sender {
    
    if(self.selectedIP || self.txtCCategory.text.length>0 || self.txtCity.text.length>0 || self.txtState.text.length>0) {
         
        NSError *error = nil;
        if (![[GANTracker sharedTracker] trackEvent:@"Category Search Tapped"
            action:@"TrackEvent"
            label:[[self.arForCategory objectAtIndex:self.selectedIP.row] valueForKey:@"name"]
            value:-1
            withError:&error]) {
            NSLog(@"Error Occured ==>%@",error);
        }
        [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:@"Category Search Tapped" withAction:@"TrackEvent" withLabel:[[self.arForCategory objectAtIndex:self.selectedIP.row] valueForKey:@"name"] withValue:[NSNumber numberWithInt:6]];
        
        NSMutableDictionary *dToSearch = [NSMutableDictionary dictionary];
        
        if(self.sgLocation.selectedSegmentIndex==0) {
            if(self.txtCity.text.length>0) {
                [dToSearch setValue:self.txtCity.text forKey:@"Physical_City"];
            }
            
            if(self.strStateKey.length>0) {
                [dToSearch setValue:self.strStateKey forKey:@"Physical_State"];
            }
        } else if (self.sgLocation.selectedSegmentIndex==1) {
            NSString *strZip = [self getAdrressFromLatLong:self.appdel.clatitude lon:self.appdel.clongitude];
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
        
		if(self.nxtResultViewController)
			[self setNxtResultViewController:nil];
		
		self.nxtResultViewController=[[ResultViewController alloc] initWithNibName:@"ResultViewController" bundle:nil];
		 [self.nxtResultViewController resetProcess];
		self.nxtResultViewController.SearchIndex=3;
        self.nxtResultViewController.dForSearch=dToSearch;
        [self.nxtResultViewController performSelector:@selector(createToken) withObject:nil afterDelay:0.2];
		isBackFromSearchPage = YES;
		AppDelegate *appdel=[[UIApplication sharedApplication] delegate];
		appdel.isBackFromSearch = YES;

		[self.preTabBarCtr.navigationController pushViewController:self.nxtResultViewController animated:YES];
    } else {
        ALERT(@"Please enter the search criteria.", nil, @"OK", self, nil);
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
        //[self searchTapped:nil];
		[textField resignFirstResponder];
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

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.scrMain scrollRectToVisible:CGRectMake(0, 0, 320, 100) animated:YES];
    if([textField isEqual:self.txtCCategory] && self.txtCCategory.text.length>0) {
        [(UITableViewCell*)[self.tblCategories cellForRowAtIndexPath:self.selectedIP] setAccessoryType:UITableViewCellAccessoryNone];
        self.selectedIP=nil;
        [self.tblCategories reloadData];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if(textField==self.txtCity) {
        [self.scrMain scrollRectToVisible:CGRectMake(0, 85, 320, 100) animated:YES];
    }
}

- (void)clearAll { 
    [(UITableViewCell*)[self.tblCategories cellForRowAtIndexPath:self.selectedIP] setAccessoryType:UITableViewCellAccessoryNone];
    self.selectedIP=nil;
    self.strState=self.strStateKey=nil;
    self.txtCCategory.text=self.txtCity.text=self.txtState.text=nil;
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

// return NO to disallow editing.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {   
    if([textField isKindOfClass:[STComboText class]]) {
        [(STComboText*)textField showOptions];
        return NO;
    }
    return YES;
}

- (NSString*)stComboText:(STComboText*)stComboText textForRow:(NSUInteger)row {
    return [[self.preTabBarCtr.arForStates objectAtIndex:row] valueForKey:@"displayValue"];
}

- (NSInteger)stComboText:(STComboText*)stComboTextNumberOfOptions {
    return self.preTabBarCtr.arForStates.count;
}

- (void)stComboText:(STComboText*)stComboText didSelectRow:(NSUInteger)row {
    self.strStateKey = [[self.preTabBarCtr.arForStates objectAtIndex:row] valueForKey:@"value"];
    self.strState = self.txtState.text = [[self.preTabBarCtr.arForStates objectAtIndex:row] valueForKey:@"displayValue"];
}

@end
