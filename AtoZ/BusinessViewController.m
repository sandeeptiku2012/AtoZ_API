//
//  BusinessViewController.m
//  AtoZdatabases
//
//  Created by Ankit Vyas on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BusinessViewController.h"
#import "TabBarCtr.h"

@implementation BusinessViewController

@synthesize txtBName = _txtBName;
@synthesize txtCity = _txtCity;
@synthesize txtState = _txtState;
@synthesize sgBusinessRange = _sgBusinessRange;
@synthesize imgVChck = _imgVChck;

@synthesize strState = _strState;
@synthesize strStateKey = _strStateKey;
@synthesize btnEntireUs = _btnEntireUs;
@synthesize btnCurrentLocation = _btnCurrentLocation;
@synthesize btnCity = _btnCity;
@synthesize preTabBarCtr = _preTabBarCtr;
@synthesize vHide = _vHide;
@synthesize nQ = _nQ;
@synthesize dForSearch = _dForSearch;
@synthesize nxtResultViewController = _nxtResultViewController;
@synthesize btnSearch = _btnSearch;
@synthesize img2miles = _img2miles;
@synthesize img5miles = _img5miles;
@synthesize img10miles = _img10miles;
@synthesize appdel = _appdel;
@synthesize strMiles = _strMiles;
@synthesize lblMiles = _lblMiles;


#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
	
    NSError *error = nil;
    [[GANTracker sharedTracker] trackPageview:@"Business Search Page" withError:&error];
    self.trackedViewName=@"Business Search Page";
    [self.txtBName resignFirstResponder];
    [self.txtState resignFirstResponder];
    [self.txtCity resignFirstResponder];

    
	if (isBackFromSearchPage==NO) {
		self.txtState.text = (self.strState)?self.strState:@"";
		//self.txtBName.text = @"";
        self.txtCity.text = @"";
		self.img2miles.highlighted=YES;
		self.img10miles.highlighted = NO;
		self.img5miles.highlighted = NO;
		self.imgVChck.highlighted = NO;
		self.strMiles=@"2";
                
		[self CurrentLocationTapped:nil];

	}else if(isBackFromSearchPage == YES)
		isBackFromSearchPage = NO;
	
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.txtBName resignFirstResponder];
    [self.txtState resignFirstResponder];
    [self.txtCity resignFirstResponder];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	
	
	self.img2miles.highlighted=YES;
	self.strMiles=@"2";
    [self CurrentLocationTapped:nil];
    
    if(![self.preTabBarCtr arForStates] || [self.preTabBarCtr arForStates].count==0 ) {
        [self createToken];
    }
}
- (void)viewDidUnload
{
	[self setLblMiles:nil];
	[self setStrMiles:nil];
	[self setAppdel:nil];
	[self setImg2miles:nil];
	[self setImg5miles:nil];
	[self setImg10miles:nil];
	[self setBtnSearch:nil];
    [self setTxtBName:nil];
    [self setTxtCity:nil];
    [self setTxtState:nil];
    [self setSgBusinessRange:nil];
    [self setImgVChck:nil];
    [self setBtnEntireUs:nil];
    [self setBtnCurrentLocation:nil];
    [self setBtnCity:nil];
	[self setNQ:nil];
	[self setDForSearch:nil];
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

- (IBAction)SearchBusinessTapped:(id)sender {

    [self.txtBName resignFirstResponder];
    [self.txtState resignFirstResponder];
    [self.txtCity resignFirstResponder];

    [self.txtBName setTag:111];
    [self.txtBName setReturnKeyType:UIReturnKeyDone];
	self.lblMiles.hidden=YES;
	[self.btnCity setBackgroundImage:[UIImage imageNamed:@"bg_wt.png"] forState:UIControlStateNormal];
	[self.btnCurrentLocation setBackgroundImage:[UIImage imageNamed:@"bg_gray.png"] forState:UIControlStateNormal];
	[self.btnEntireUs setBackgroundImage:[UIImage imageNamed:@"bg_gray.png"] forState:UIControlStateNormal];
	self.sgBusinessRange.selectedSegmentIndex=0;
	self.btnCity.selected=YES;
	self.btnCity.highlighted=YES;
	self.btnCurrentLocation.highlighted=NO;
	self.btnEntireUs.highlighted=NO;
	self.btnCurrentLocation.selected=NO;
	self.btnEntireUs.selected=NO;
    self.vHide.hidden=YES;
	self.lblMiles.hidden=YES;
	self.img2miles.hidden=YES;
	self.img5miles.hidden=YES;
	self.img10miles.hidden=YES;
	[self sgChanged:self.sgBusinessRange];
}

- (IBAction)CurrentLocationTapped:(id)sender {
    
    [self.txtBName resignFirstResponder];
    [self.txtState resignFirstResponder];
    [self.txtCity resignFirstResponder];

    
    [self.txtBName setTag:123];
    [self.txtBName setReturnKeyType:UIReturnKeySearch];
	self.appdel=[[UIApplication sharedApplication] delegate];
	[self.btnCity setBackgroundImage:[UIImage imageNamed:@"bg_gray.png"] forState:UIControlStateNormal];
	[self.btnEntireUs setBackgroundImage:[UIImage imageNamed:@"bg_gray.png"] forState:UIControlStateNormal];
	[self.btnCurrentLocation setBackgroundImage:[UIImage imageNamed:@"bg_wt.png"] forState:UIControlStateNormal];
	self.sgBusinessRange.selectedSegmentIndex=1;
    self.txtCity.text=@"";
    self.txtState.text=@"";
    
	self.btnCity.selected=NO;
	self.btnCurrentLocation.selected=YES;
	self.btnEntireUs.selected=NO;
    self.vHide.hidden=NO;
	self.lblMiles.hidden=NO;
	self.img2miles.hidden=NO;
	self.img5miles.hidden=NO;
	self.img10miles.hidden=NO;
    [self.txtCity resignFirstResponder];
	[self sgChanged:self.sgBusinessRange];
	
}

- (IBAction)EntireUsTapped:(id)sender {
    
    [self.txtBName resignFirstResponder];
    [self.txtState resignFirstResponder];
    [self.txtCity resignFirstResponder];

    
    [self.txtBName setTag:123];
    [self.txtBName setReturnKeyType:UIReturnKeySearch];
	[self.btnEntireUs setBackgroundImage:[UIImage imageNamed:@"bg_wt.png"] forState:UIControlStateNormal];
	[self.btnCity setBackgroundImage:[UIImage imageNamed:@"bg_gray.png"] forState:UIControlStateNormal];
	[self.btnCurrentLocation setBackgroundImage:[UIImage imageNamed:@"bg_gray.png"] forState:UIControlStateNormal];
	self.lblMiles.hidden=YES;
    self.sgBusinessRange.selectedSegmentIndex=2;
    self.txtCity.text=@"";
    self.txtState.text=@"";
	self.btnCity.selected=NO;
	self.btnCurrentLocation.selected=NO;
	self.btnEntireUs.selected=YES;
    self.vHide.hidden=NO;
	self.lblMiles.hidden=YES;
	self.img2miles.hidden=YES;
	self.img5miles.hidden=YES;
	self.img10miles.hidden=YES;
    [self.txtBName resignFirstResponder];
    [self.txtCity resignFirstResponder];
	[self sgChanged:self.sgBusinessRange];
}

- (IBAction)sgChanged:(id)sender {
    if([(UISegmentedControl*)sender selectedSegmentIndex]==0) {
//        [self.predRcrdVCtr.pVCtr setPopoverContentSize:CGSizeMake(337, 336) animated:YES];
    } else {
//        [self.predRcrdVCtr.pVCtr setPopoverContentSize:CGSizeMake(337, 190) animated:YES];
    }
}

- (IBAction)btnStateTapped:(id)sender {
    [self.txtBName resignFirstResponder];
    [self.txtCity resignFirstResponder];
//    self.nxtdSelectState=[[dSelectState alloc] initWithNibName:@"dSelectState" bundle:nil];
//    self.nxtdSelectState.preVCtr=self;
//    self.nxtdSelectState.arForStates=[self.predRcrdVCtr arForStates];
//    self.nxtdSelectState.predRcrdVCtr=self.predRcrdVCtr;
//    [self.navigationController pushViewController:self.nxtdSelectState animated:YES];
}

- (IBAction)btnHQTapped:(id)sender {
    self.imgVChck.highlighted=!self.imgVChck.highlighted;
}

- (IBAction)searchTapped:(id)sender {
    NSLog(@"self.txtBName.text %@",self.txtBName.text);
    
    NSError *error = nil;
    if (![[GANTracker sharedTracker] trackEvent:@"Business Search Tapped"action:@"TrackEvent" label:self.txtBName.text value:-1 withError:&error]) {
        NSLog(@"Error Occured ==>%@",error);
    }
    [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:@"Business Search Tapped" withAction:@"TrackEvent" withLabel:self.txtBName.text withValue:[NSNumber numberWithInt:4]]; 
    
    if(self.txtBName.text.length>0 || self.txtCity.text.length>0 || self.txtState.text.length>0) {
	[self.nxtResultViewController resetProcess];
		
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
            NSString *strZip = [self getAdrressFromLatLong:self.appdel.clatitude lon:self.appdel.clongitude];
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
        
		if(self.nxtResultViewController)
			[self setNxtResultViewController:nil];
        
        
		
		self.nxtResultViewController=[[ResultViewController alloc] initWithNibName:@"ResultViewController" bundle:nil];
		self.nxtResultViewController.dForSearch=dToSearch;
		self.nxtResultViewController.numberFrom=[NSNumber numberWithInt:1];
		self.nxtResultViewController.numberTo=[NSNumber numberWithInt:25];
		self.nxtResultViewController.SearchIndex=1;
        [self.nxtResultViewController performSelector:@selector(createToken) withObject:nil afterDelay:0.2];
		isBackFromSearchPage = YES;
		AppDelegate *appdel=[[UIApplication sharedApplication] delegate];
		appdel.isBackFromSearch = YES;
        
		[self.preTabBarCtr.navigationController pushViewController:self.nxtResultViewController animated:YES];
        
    } else {
        ALERT(@"Please enter the search criteria.", nil, @"OK", self, nil);
    }
}

- (void)clearAll {
    self.txtBName.text=self.txtCity.text=self.txtState.text=@"";
    self.sgBusinessRange.selectedSegmentIndex=0;
    self.imgVChck.highlighted=NO; 
    self.strState=self.strStateKey=nil;
}
// return NO to disallow editing.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {   
    if([textField isKindOfClass:[STComboText class]]) {
        [(STComboText*)textField showOptions];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [self searchTapped:nil];
    
    if ([textField tag]==123) {
        NSLog(@"self.txtBName.text %@",self.txtBName.text);
        
        NSError *error = nil;
        if (![[GANTracker sharedTracker] trackEvent:@"Business Search Tapped"action:@"TrackEvent" label:self.txtBName.text value:-1 withError:&error]) {
            NSLog(@"Error Occured ==>%@",error);
        }
        [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:@"Business Search Tapped" withAction:@"TrackEvent" withLabel:self.txtBName.text withValue:[NSNumber numberWithInt:4]];
        
        if(self.txtBName.text.length>0 || self.txtCity.text.length>0 || self.txtState.text.length>0) {
            [self.nxtResultViewController resetProcess];
            
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
                NSString *strZip = [self getAdrressFromLatLong:self.appdel.clatitude lon:self.appdel.clongitude];
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
            
            if(self.nxtResultViewController)
                [self setNxtResultViewController:nil];
            
            
            
            self.nxtResultViewController=[[ResultViewController alloc] initWithNibName:@"ResultViewController" bundle:nil];
            self.nxtResultViewController.dForSearch=dToSearch;
            self.nxtResultViewController.numberFrom=[NSNumber numberWithInt:1];
            self.nxtResultViewController.numberTo=[NSNumber numberWithInt:25];
            self.nxtResultViewController.SearchIndex=1;
            [self.nxtResultViewController performSelector:@selector(createToken) withObject:nil afterDelay:0.2];
            isBackFromSearchPage = YES;
            AppDelegate *appdel=[[UIApplication sharedApplication] delegate];
            appdel.isBackFromSearch = YES;
            
            [self.preTabBarCtr.navigationController pushViewController:self.nxtResultViewController animated:YES];
            
        } else {
            ALERT(@"Please enter the search criteria.", nil, @"OK", self, nil);
        }

        
    }else{
        [textField resignFirstResponder];
    }
    
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
#pragma mark - WebServices Related

// 3. now set all set criterias
- (void)setSearchCriteria
{
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
	
//    if(self.SearchIndex==3 && !self.nxtCategoryViewController)
//		self.nxtCategoryViewController=[[CategoryViewController alloc] initWithNibName:@"CategoryViewController" bundle:nil];
	
    //	if( (self.SearchIndex==1) || (self.SearchIndex==3 && self.nxtCategoryViewController.selectedIP ) ) {
    //        strURL = [WEB_SERVICE_URL stringByAppendingFormat:WEB_SET_BUSINESSTYPE,COMMON_PARSER.strActiveToken];
    //        NSLog(@"API hit -> %@",strURL);
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
	//    //NSLog(@"All criterias set now -> ready to fetch records");
    [[iNetMngr requestObject] hideProgressHUD];
//    [iNetMngr getRecords:self pageNumber:[self.numberFrom stringValue] numberOfRecords:[self.numberTo stringValue]];
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
            } else if ([[COMMON_PARSER.dStatus valueForKey:@"responseCode"] isEqualToString:@"Q-506"]) {
                [self createToken];
//                [self.predRcrdVCtr.pVCtr dismissPopoverAnimated:YES];
            }
            
            // 2. if data is for creating token
        } else if ([[[iNetMngr requestObject] restValue] rangeOfString:@"create?token"].length>0) {
            if(statusCode==201) {
                [iNetMngr setRqstDBToCombine:self];
            } else {
//                [self.predRcrdVCtr.pVCtr dismissPopoverAnimated:YES];
            }
        } else if ([[[iNetMngr requestObject] restValue] rangeOfString:@"combined"].length>0) {
            if(statusCode==201) {
                //[iNetMngr getStates:self];
            } else {
//                [self.predRcrdVCtr.pVCtr dismissPopoverAnimated:YES];
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
                    
                    self.preTabBarCtr.arForStates=arStates;
                //Rajeev End
                }
            } else {
//                [self.predRcrdVCtr.pVCtr dismissPopoverAnimated:YES];
            }
        }
    } else {
        ALERT(@"Message", @"Please check your internet connection & try again later.", @"OK", self, nil);
    }
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
