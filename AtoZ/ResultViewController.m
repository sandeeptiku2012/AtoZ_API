//
//  ResultViewController.m
//  AtoZdatabases
//
//  Created by Ankit Vyas on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ResultViewController.h"
#import "CategoryViewController.h"

@implementation ResultViewController
@synthesize VforMap;
@synthesize mapViewRecords = _mapViewRecords;
@synthesize VforList;
@synthesize ibutton;
@synthesize nQ = _nQ;
@synthesize dForSearch = _dForSearch;
@synthesize totalRecords = _totalRecords;
@synthesize lblRecordsTitle = _lblRecordsTitle;
@synthesize sgNextPrev = _sgNextPrev;
@synthesize tableViewRecords = _tableViewRecords;
@synthesize arOfRecords = _arOfRecords;
@synthesize arForStates = _arForStates;
@synthesize isFetchingStates = _isFetchingStates;
@synthesize isFetchingRecords = _isFetchingRecords;
@synthesize isLoginUsingSession = _isLoginUsingSession;
@synthesize selectedIP = _selectedIP;
@synthesize numberFrom = _numberFrom;
@synthesize numberTo = _numberTo;
@synthesize isSearching = _isSearching;
@synthesize tBarNextPre = _tBarNextPre;
@synthesize arOfFilteredRcrds = _arOfFilteredRcrds;
@synthesize btnNS = _btnNS;
@synthesize btnPS = _btnPS;
@synthesize tabbar = _tabbar;
@synthesize SearchIndex = _SearchIndex;
@synthesize nxtCategoryViewController = _nxtCategoryViewController;
@synthesize nxtpRcrdDtls = _nxtpRcrdDtls;
@synthesize nxtpRcdtVctr = _nxtpRcdtVctr;

#define kCurrentLocationString      @"Current Location"




- (void)viewDidUnload
{
	[self setNxtpRcdtVctr:nil];
    [self setNxtpRcrdDtls:nil];
	[self setVforMap:nil];
    [self setVforList:nil];
    [self setMapViewRecords:nil];
	[self setLblRecordsTitle:nil];
	[self setSgNextPrev:nil];
    [self setArForStates:nil];
	[self setArOfRecords:nil];
	[self setTBarNextPre:nil];
	[self setArOfFilteredRcrds:nil];
	[self setBtnNS:nil];
	[self setBtnPS:nil];
	[self setTabbar:nil];
	[self setNxtCategoryViewController:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)resetProcess
{
    // reset process 

    self.numberFrom=[NSNumber numberWithInt:1];
    self.numberTo=[NSNumber numberWithInt:25];
    self.arOfRecords=nil;
    self.selectedIP=nil;
    self.lblRecordsTitle.text=@"";
    self.totalRecords=0;
    self.isSearching=NO;
    
    self.isFetchingRecords=YES; 
    self.isFetchingStates=NO;
    
    [self.tableViewRecords reloadData];
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
	
    if(self.SearchIndex==3 && !self.nxtCategoryViewController)
		self.nxtCategoryViewController=[[CategoryViewController alloc] initWithNibName:@"CategoryViewController" bundle:nil];
	
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
    //}
}


- (void)webRequestReceivedData:(NSData *)data {
    if(data && [data length]>0) {
        // parse data if available
        [COMMON_PARSER parseData:data];

        //Rajeev Start
        
        //NSLog(@"COMMON_PARSER.jsonReponse = %@", [COMMON_PARSER.jsonReponse description]);
        
        COMMON_PARSER.dStatus = [NSDictionary dictionaryWithObjectsAndKeys:[[COMMON_PARSER.jsonReponse valueForKey:@"Response"] valueForKey:@"responseCode"],@"responseCode",[[COMMON_PARSER.jsonReponse valueForKey:@"Response"] valueForKey:@"responseMessage"],@"responseMessage",nil];
        //NSLog(@"COMMON_PARSER.dStatus = %@", [COMMON_PARSER.dStatus description]);
        NSInteger statusCode = [[COMMON_PARSER.dStatus valueForKey:@"responseCode"] intValue];
        //NSLog(@"statusCode = %d", statusCode);
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
                //NSLog(@"COMMON_PARSER.responseDetails = %@", [COMMON_PARSER.responseDetails description]);
                COMMON_PARSER.strActiveToken=[COMMON_PARSER.responseDetails objectForKey:@"TokenID"];//[COMMON_PARSER.dToken valueForKey:@"guid"];
                //NSLog(@"TokenID = %@", COMMON_PARSER.strActiveToken);
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
//                } else {
//					[self clearUpCriteria];
//				}
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
		
		//Comma seperator Calculation
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
		self.btnPS.enabled=NO;
        [self.sgNextPrev setEnabled:NO forSegmentAtIndex:0];
    } else {
		self.btnPS.enabled=YES;
        [self.sgNextPrev setEnabled:YES forSegmentAtIndex:0];
    }
    
    if([self.numberTo intValue]>=self.totalRecords) {
		[self.sgNextPrev setEnabled:NO forSegmentAtIndex:1];
		self.btnNS.enabled=NO;
    } else {
		self.btnNS.enabled=YES;
		[self.sgNextPrev setEnabled:YES forSegmentAtIndex:1]; 
    }
    
    [self.tableViewRecords reloadData];
    [self.mapViewRecords removeAnnotations:[self.mapViewRecords annotations]];
    [self addPins];
}

#pragma mark - View lifecycle

-(void)BarButtonAdd
{
	if(ibutton == 1){
	UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(MapTapped:)];          
		self.navigationItem.rightBarButtonItem = anotherButton;	}
	else{
		UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"List" style:UIBarButtonItemStylePlain target:self action:@selector(ListTapped:)];          
		self.navigationItem.rightBarButtonItem = anotherButton;
	}
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.selectedIP=nil;
    self.arOfFilteredRcrds = [NSMutableArray array];

	[self.tabbar setSelectedItem:[self.tabbar.items objectAtIndex:0]];
	ibutton=1;
	
	
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    NSError *error = nil;
    [[GANTracker sharedTracker] trackPageview:@"Search Result Page" withError:&error];
    self.trackedViewName=@"Search Result Page";
    [super viewWillAppear:animated];
}
-(void)MapTapped:(id)sender
{
	ibutton=0;
	self.VforList.hidden=TRUE;	
	self.VforMap.hidden=FALSE;
	[self BarButtonAdd];
}
-(void)ListTapped:(id)sender
{
	ibutton=1;
	self.VforList.hidden=FALSE;
	self.VforMap.hidden=TRUE;	
	[self BarButtonAdd];
}
- (IBAction)sgNxtPrePage:(id)sender {
    BOOL toFetch = NO;
    //UISegmentedControl *SegPN = (UISegmentedControl*)sender;
    if(self.totalRecords>0) {
        if([sender tag] == 11) {
			NSLog(@"numberFrom==>%i",[self.numberFrom intValue]);
            if (! (([self.numberFrom intValue]-25) <=0 )) {
                if([self.numberTo intValue]==self.totalRecords) {
					self.btnPS.enabled=YES;
                    self.numberTo = [NSNumber numberWithInt:[self.numberFrom intValue]-1];
                    self.numberFrom = [NSNumber numberWithInt:[self.numberFrom intValue]-25];
                } else  {
                    self.numberFrom = [NSNumber numberWithInt:[self.numberFrom intValue]-25];
                    self.numberTo = [NSNumber numberWithInt:[self.numberTo intValue]-25];
                }
                toFetch=YES;
            }
        } else if([sender tag] == 22) {
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
        [UIView commitAnimations];
        self.arOfRecords=nil;
        self.selectedIP=nil;
        self.isSearching=NO;
        [iNetMngr getRecords:self pageNumber:[self.numberFrom stringValue] numberOfRecords:[self.numberTo stringValue]];
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
	if(item.tag == 1){
        self.VforMap.hidden=YES;
		self.VforList.hidden=NO;
	} else {
		self.VforMap.hidden=NO;
		self.VforList.hidden=YES;
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
    //NSLog(@"strAddress==>%@",strAddress);
	
    NSString *str = nil;
	if ([strAddress isEqualToString:@"N/A"]) {
        str = [NSString stringWithFormat:@"%@, %@",[dToAccess valueForKey:@"city"],[dToAccess valueForKey:@"state"]];
    } else {
        str=([strAddress isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"%@, %@, %@",[dToAccess valueForKey:@"address"],[dToAccess valueForKey:@"city"],[dToAccess valueForKey:@"state"]];
    }
    
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
    //[self selectSpecificPin:d];
    if([[d valueForKey:@"Database Type"] isEqualToString:@"Business"]) {
		self.nxtpRcrdDtls = [[pRcrdDtls alloc] initWithNibName:@"pRcrdDtls" bundle:nil];
		//self.nxtpRcrdDtls.dForDtl=d;
        self.nxtpRcrdDtls.dForResult=d;
		self.nxtpRcrdDtls.quickLinkSelectedIndex = indexPath.row;
		[self.navigationController presentModalViewController:self.nxtpRcrdDtls animated:YES];
	} else if ([[d valueForKey:@"Database Type"] isEqualToString:@"Consumer"]) {
		self.nxtpRcdtVctr=[[pRcdtVctr alloc] initWithNibName:@"pRcdtVctr" bundle:nil];
		//self.nxtpRcdtVctr.dForDtl=d;
        self.nxtpRcdtVctr.dForResult=d;
		[self.navigationController presentModalViewController:self.nxtpRcdtVctr animated:YES];
	}
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.selectedIP=indexPath;
    [self.tableViewRecords reloadData];
    NSDictionary *d = [self.arOfRecords objectAtIndex:indexPath.row];
    
    NSError *error = nil;
    if (![[GANTracker sharedTracker] trackEvent:@"Record Selected" action:@"TrackEvent" label:[d valueForKey:@"companyname"] value:-1 withError:&error]) {
        NSLog(@"Error Occured ==>%@",error);
    }
//    [self.tracker sendEventWithCategory:@"Record Selected" withAction:@"TrackEvent" withLabel:[d valueForKey:@"companyname"] withValue:[NSNumber numberWithInt:8]];
    ([[[GAI sharedInstance] defaultTracker] sendEventWithCategory:@"Record Selected" withAction:@"TrackEvent" withLabel:[d valueForKey:@"companyname"] withValue:[NSNumber numberWithInt:8]]) ? NSLog(@"*** Success ***") : NSLog(@"*** Fail ***");    
    
    if([[d valueForKey:@"Database Type"] isEqualToString:@"Business"]) {
		self.nxtpRcrdDtls = [[pRcrdDtls alloc] initWithNibName:@"pRcrdDtls" bundle:nil];
		//self.nxtpRcrdDtls.dForDtl=d;
        self.nxtpRcrdDtls.dForResult=d;
		self.nxtpRcrdDtls.quickLinkSelectedIndex = indexPath.row;
		[self.navigationController presentModalViewController:self.nxtpRcrdDtls animated:YES];
	} else if ([[d valueForKey:@"Database Type"] isEqualToString:@"Consumer"]) {
		self.nxtpRcdtVctr=[[pRcdtVctr alloc] initWithNibName:@"pRcdtVctr" bundle:nil];
//		self.nxtpRcdtVctr.dForDtl=d;
        self.nxtpRcdtVctr.dForResult=d;
		[self.navigationController presentModalViewController:self.nxtpRcdtVctr animated:YES];
	}

}



#pragma mark - MapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
}

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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;		
    }
    static NSString * const kPinAnnotationIdentifier2 = @"PinIdentifierOtherPins";
    MKPinAnnotationView *pin = (MKPinAnnotationView*)[self.mapViewRecords dequeueReusableAnnotationViewWithIdentifier: kPinAnnotationIdentifier2];
	
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
		self.nxtpRcrdDtls = [[pRcrdDtls alloc] initWithNibName:@"pRcrdDtls" bundle:nil];
		//self.nxtpRcrdDtls.dForDtl=d;
        self.nxtpRcrdDtls.dForResult=d;
		[self.navigationController presentModalViewController:self.nxtpRcrdDtls animated:YES];
	}
	 else if ([[d valueForKey:@"Database Type"] isEqualToString:@"Consumer"]) {
		 self.nxtpRcdtVctr=[[pRcdtVctr alloc] initWithNibName:@"pRcdtVctr" bundle:nil];
		 //self.nxtpRcdtVctr.dForDtl=d;
         self.nxtpRcdtVctr.dForResult=d;
		 [self.navigationController presentModalViewController:self.nxtpRcdtVctr animated:YES];
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
	
//For showing Current Location 
	
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

- (void)setPinToCenter:(PlaceMark*)mark {
    [self.mapViewRecords setCenterCoordinate:mark.coordinate animated:YES];
}

- (NSInteger)indexOfTitle:(NSString*)strTitle{
    for (NSDictionary *d in self.arOfRecords) {
        //Rajeev Start
        NSString *strCompName = [d valueForKey:@"companyname"];
        NSArray *sep = [strCompName componentsSeparatedByString:@"<strong>"];
        NSArray *sep1 = nil;
        if ([sep count] >= 2)
            sep1 = [[sep objectAtIndex:1] componentsSeparatedByString:@"</strong>"];
        else
            sep1 = [NSArray arrayWithObjects:[sep objectAtIndex:0], nil];
        //Rajeev End
        if ([sep1 count] >= 1) {
            if([/*[d valueForKey:@"companyname"]*/[sep1 objectAtIndex:0] isEqualToString:strTitle]) {
            return [self.arOfRecords indexOfObject:d];
            }
        }
        else {
            return -1;
        }
    }
    return -1;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return  UIInterfaceOrientationIsPortrait(interfaceOrientation);
}
- (IBAction)BackTapped:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIAlertViewDelegateMethods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
