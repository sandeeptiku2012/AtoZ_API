//
//  PersonViewController.m
//  AtoZdatabases
//
//  Created by Ankit Vyas on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PersonViewController.h"
#import "TabBarCtr.h"

@implementation PersonViewController

@synthesize preTabBarCtr = _preTabBarCtr;
@synthesize vHide = _vHide;
@synthesize btnBoth = _btnBoth;
@synthesize btnBuiz = _btnBuiz;
@synthesize btnResi = _btnResi;
@synthesize txtFName = _txtFName;
@synthesize txtLName = _txtLName;
@synthesize txtCity = _txtCity;
@synthesize txtState = _txtState;
@synthesize sgLocation = _sgLocation;
@synthesize nxtResultViewController = _nxtResultViewController;

@synthesize btnEntireUs = _btnEntireUs;
@synthesize btnCurrentLocation = _btnCurrentLocation;
@synthesize btnCity = _btnCity;

@synthesize strState = _strState;
@synthesize strStateKey = _strStateKey;



@synthesize img2miles = _img2miles;
@synthesize img5miles = _img5miles;
@synthesize img10miles = _img10miles;
@synthesize lblMiles = _lblMiles;
@synthesize strMiles = _strMiles;

@synthesize appdel = _appdel;

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    
    NSError *error = nil;
    [[GANTracker sharedTracker] trackPageview:@"Person Search Page" withError:&error];
    
    self.trackedViewName=@"Person Search Page";
    
    [self.txtLName resignFirstResponder];
    [self.txtFName resignFirstResponder];
    [self.txtState resignFirstResponder];
    [self.txtCity resignFirstResponder];

    
	if (isBackFromSearchPage==NO) {
        //self.txtFName.text = @"";
        //self.txtLName.text = @"";
        self.txtCity.text = @"";
        self.txtState.text = @"";
		self.img2miles.highlighted=YES;
		self.img10miles.highlighted = NO;
		self.img5miles.highlighted = NO;
		self.btnBuiz.highlighted=NO;
		self.btnResi.highlighted=NO;
		self.btnBoth.highlighted=YES;
        
		self.strMiles=@"2";
		[self CurrentLocationTapped:nil];
		
	}else if(isBackFromSearchPage == YES)
		isBackFromSearchPage = NO;
	
	[super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [self.txtLName resignFirstResponder];
    [self.txtFName resignFirstResponder];
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
    [self btnBothTapped:nil];
	self.strMiles=@"2";
	self.img2miles.highlighted=YES;
	[self CurrentLocationTapped:nil];	
}
- (void)viewDidUnload
{
    [super viewDidUnload];
	[self setLblMiles:nil];
	[self setImg2miles:nil];
	[self setImg5miles:nil];
	[self setImg10miles:nil];
	[self btnBothTapped:nil];
	[self CityStateTapped:nil];
    [self setTxtFName:nil];
    [self setTxtLName:nil];
    [self setSgLocation:nil];
    [self setTxtCity:nil];
    [self setTxtState:nil];
    [self setBtnBoth:nil];
    [self setBtnBuiz:nil];
    [self setBtnResi:nil];
	[self setNxtResultViewController:nil];
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
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return  UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (IBAction)CityStateTapped:(id)sender {
    
    [self.txtLName resignFirstResponder];
    [self.txtFName resignFirstResponder];
    [self.txtState resignFirstResponder];
    [self.txtCity resignFirstResponder];
    

    
    [self.txtFName setTag:111];
    [self.txtLName setTag:111];
    [self.txtFName setReturnKeyType:UIReturnKeyDone];
    [self.txtLName setReturnKeyType:UIReturnKeyDone];
	[self.btnCity setBackgroundImage:[UIImage imageNamed:@"bg_wt.png"] forState:UIControlStateNormal];
	[self.btnCurrentLocation setBackgroundImage:[UIImage imageNamed:@"bg_gray.png"] forState:UIControlStateNormal];
	[self.btnEntireUs setBackgroundImage:[UIImage imageNamed:@"bg_gray.png"] forState:UIControlStateNormal];
 	
	self.sgLocation.selectedSegmentIndex=0;
	self.btnCity.selected=YES;
	self.btnCurrentLocation.selected=NO;
	self.btnEntireUs.selected=NO;
    self.vHide.hidden=YES;
	self.img2miles.hidden=YES;
	self.img5miles.hidden=YES;
	self.img10miles.hidden=YES;
    self.lblMiles.hidden=YES;
	[self sgChanged:self.sgLocation];
}

- (IBAction)CurrentLocationTapped:(id)sender {
    
    [self.txtLName resignFirstResponder];
    [self.txtFName resignFirstResponder];
    [self.txtState resignFirstResponder];
    [self.txtCity resignFirstResponder];
    

    
    [self.txtFName setTag:123];
    [self.txtLName setTag:124];
    [self.txtFName setReturnKeyType:UIReturnKeySearch];
    [self.txtLName setReturnKeyType:UIReturnKeySearch];
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
	self.img2miles.hidden=NO;
	self.img5miles.hidden=NO;
	self.img10miles.hidden=NO;
	self.lblMiles.hidden=NO;
	[self sgChanged:self.sgLocation];
}

- (IBAction)EntireUsTapped:(id)sender {
    
    [self.txtLName resignFirstResponder];
    [self.txtFName resignFirstResponder];
    [self.txtState resignFirstResponder];
    [self.txtCity resignFirstResponder];
    

	
    [self.txtFName setTag:123];
    [self.txtLName setTag:124];
    [self.txtFName setReturnKeyType:UIReturnKeySearch];
    [self.txtLName setReturnKeyType:UIReturnKeySearch];
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
	self.img2miles.hidden=YES;
	self.img5miles.hidden=YES;
	self.img10miles.hidden=YES;
	self.lblMiles.hidden=YES;
   
	
	[self sgChanged:self.sgLocation];
}

- (IBAction)sgChanged:(id)sender {
    
}

-(IBAction)searchTapped:(id)sender {
    
    if(self.txtFName.text.length>0 || self.txtLName.text.length>0 || self.txtCity.text.length>0 || self.txtState.text.length>0) {
		
		
        [self.nxtResultViewController resetProcess];
        
        NSMutableDictionary *dToSearch = [NSMutableDictionary dictionary];
        
        if(self.txtFName.text.length>0) {
            [dToSearch setValue:self.txtFName.text forKey:@"First_Name"];
        }
        
        if(self.txtLName.text.length>0) {
            [dToSearch setValue:self.txtLName.text forKey:@"Last_Name"];
        }
        
        NSString *strText= [NSString stringWithFormat:@"%@ %@",self.txtFName.text,self.txtLName.text];
        NSError *error = nil;
        if (![[GANTracker sharedTracker] trackEvent:@"Person Search Tapped"
            action:@"TrackEvent"
            label:strText
            value:-1
            withError:&error]) {
            NSLog(@"Error Occured ==>%@",error);
        }

        [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:@"Person Search Tapped" withAction:@"TrackEvent" withLabel:strText withValue:[NSNumber numberWithInt:5]];  
        
        if(self.sgLocation.selectedSegmentIndex==0) {
            if(self.txtCity.text.length>0) {
                [dToSearch setValue:self.txtCity.text forKey:@"Physical_City"];
            }
            
            if(self.strStateKey.length>0) {
                [dToSearch setValue:self.strStateKey forKey:@"Physical_State"];
            }
        } else if (self.sgLocation.selectedSegmentIndex==1) {
            CLLocationCoordinate2D coOrd = self.nxtResultViewController.mapViewRecords.userLocation.location.coordinate;
            NSString *strZip = [self getAdrressFromLatLong:coOrd.latitude lon:coOrd.longitude];
            if(strZip && strZip.length>0) {
                //strZip = [NSString stringWithFormat:@"|%@|20",strZip];
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
		        
        
        
		if(self.nxtResultViewController)
			[self setNxtResultViewController:nil];
		
		self.nxtResultViewController=[[ResultViewController alloc] initWithNibName:@"ResultViewController" bundle:nil];
		self.nxtResultViewController.SearchIndex=2;	
		self.nxtResultViewController.dForSearch=dToSearch;
		self.nxtResultViewController.numberFrom=[NSNumber numberWithInt:1];
		self.nxtResultViewController.numberTo=[NSNumber numberWithInt:25];
		[self.nxtResultViewController performSelector:@selector(createToken) withObject:nil afterDelay:0.2];
        isBackFromSearchPage = YES;
        AppDelegate *appdel=[[UIApplication sharedApplication] delegate];
		appdel.isBackFromSearch = YES;
		[self.preTabBarCtr.navigationController pushViewController:self.nxtResultViewController animated:YES];
	}
	else {
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if([textField isKindOfClass:[STComboText class]]) {
        [(STComboText*)textField showOptions];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //    [self searchTapped:nil];
    if ([textField tag]==123 || [textField tag]==124){
        
        if(self.txtFName.text.length>0 || self.txtLName.text.length>0 || self.txtCity.text.length>0 || self.txtState.text.length>0) {
            
            
            [self.nxtResultViewController resetProcess];
            
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
                CLLocationCoordinate2D coOrd = self.nxtResultViewController.mapViewRecords.userLocation.location.coordinate;
                NSString *strZip = [self getAdrressFromLatLong:coOrd.latitude lon:coOrd.longitude];
                if(strZip && strZip.length>0) {
                    //strZip = [NSString stringWithFormat:@"|%@|20",strZip];
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
            
            if(self.nxtResultViewController)
                [self setNxtResultViewController:nil];
            
            self.nxtResultViewController=[[ResultViewController alloc] initWithNibName:@"ResultViewController" bundle:nil];
            self.nxtResultViewController.SearchIndex=2;	
            self.nxtResultViewController.dForSearch=dToSearch;
            self.nxtResultViewController.numberFrom=[NSNumber numberWithInt:1];
            self.nxtResultViewController.numberTo=[NSNumber numberWithInt:25];
            [self.nxtResultViewController performSelector:@selector(createToken) withObject:nil afterDelay:0.2];
            isBackFromSearchPage = YES;
            AppDelegate *appdel=[[UIApplication sharedApplication] delegate];
            appdel.isBackFromSearch = YES;
            [self.preTabBarCtr.navigationController pushViewController:self.nxtResultViewController animated:YES];
        }
        else {
            ALERT(@"Please enter the search criteria.", nil, @"OK", self, nil);
        }

        
    }else
        [textField resignFirstResponder];
    return YES;
}

- (void)clearAll {
    self.txtCity.text=self.txtFName.text=self.txtLName.text=self.txtState.text=@"";
    self.sgLocation.selectedSegmentIndex=0;
    self.btnBoth.highlighted=YES;
    self.btnBuiz.highlighted=NO;
    self.btnResi.highlighted=NO;
    self.strState=self.strStateKey=nil;
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


/*
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
}*/

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
