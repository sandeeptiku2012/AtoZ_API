//
//  pRcdtVctr.m
//  AtoZdatabases
//
//  Created by Ankit Vyas on 13/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "pRcdtVctr.h"

@implementation pRcdtVctr
@synthesize lblTitle = _lblTitle;
@synthesize tbl1 = _tbl1;
@synthesize vOverView = _vOverView;
@synthesize vNHInfo = _vNHInfo;
@synthesize arForQuickLinks = _arForQuickLinks;
@synthesize dForDtl = _dForDtl;
@synthesize nxtpPrintVCtr = _nxtpPrintVCtr;
@synthesize dForResult;
@synthesize addToContactInfoDic;

#pragma mark - Memory Management
- (void)viewDidUnload
{
	[self setTbl1:nil];
	[self setLblTitle:nil];
	[self setVNHInfo:nil];
	[self setVOverView:nil];
	[self setArForQuickLinks:nil];
	[self setDForDtl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.addToContactInfoDic = [[NSMutableDictionary alloc] init];
	self.arForQuickLinks=[NSArray arrayWithObjects:@"Overview",@"Neighborhood Information", nil];
	self.vOverView.layer.borderColor=[[UIColor blackColor] CGColor];
    self.vNHInfo.layer.borderColor=[[UIColor blackColor] CGColor];
    
    self.vOverView.layer.cornerRadius=4;
    self.vOverView.layer.borderWidth=1;
    
    self.vNHInfo.layer.cornerRadius=4;
    self.vNHInfo.layer.borderWidth=1;
    
    //Rajeev Start
    //NSString *str = [NSString stringWithFormat:WEB_RCRD_DTL,[self.dForDtl valueForKey:@"Database Type"],[self.dForDtl valueForKey:@"id"]];
    //[iNetMngr startLoadingRestValue:str vCtr:self title:@"Loading" message:@"Please wait..."];
    
//    NSString *str = [WEB_SERVICE_URL stringByAppendingFormat:WEB_RCRD_DTL,[[self.dForResult valueForKey:@"Database Type"] lowercaseString],[self.dForResult valueForKey:@"id"]];
//    [iNetMngr getDetails:self withAPI:str];
    
    [self loadByID:[self.dForResult valueForKey:@"id"]];
    
    //Rajeev End
}

- (void)loadByID :(NSString*)idValue {
    //Rajeev Start
    NSString *str = [WEB_SERVICE_URL stringByAppendingFormat:WEB_RCRD_DTL,[[self.dForResult valueForKey:@"Database Type"] lowercaseString],idValue];
    //[iNetMngr startLoadingRestValue:str vCtr:self title:@"Loading" message:@"Please wait..."];
    [iNetMngr getDetails:self withAPI:str];
    //Rajeev End
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSError *error = nil;
    [[GANTracker sharedTracker] trackPageview:@"Residential Record Detail Page" withError:&error];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
	return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row==0) {
        BOOL isExpanded = ![(UIButton*)[self.vOverView viewWithTag:77777] isSelected];
        return isExpanded?295:35;
    } else if(indexPath.row==1){
        BOOL isExpanded = ![(UIButton*)[self.vNHInfo viewWithTag:77777] isSelected];
        return isExpanded?270:35;
    } else {
        return 22;
    }
}

#define kInnerTag   9999

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    [[cell viewWithTag:kInnerTag]removeFromSuperview];
    
	if(indexPath.row==0) {
		BOOL isExpanded = ![(UIButton*)[self.vOverView viewWithTag:77777] isSelected];
		self.vOverView.tag=kInnerTag;
		self.vOverView.frame=(isExpanded)?CGRectMake(0, 0, 320, 290):CGRectMake(0, 0, 320, 30);
		[cell addSubview:self.vOverView];
	} else if(indexPath.row==1) {
		BOOL isExpanded = ![(UIButton*)[self.vNHInfo viewWithTag:77777] isSelected];
		self.vNHInfo.tag=kInnerTag;
		self.vNHInfo.frame=(isExpanded)?CGRectMake(0, 0, 320, 265):CGRectMake(0, 0, 320, 30);
		[cell addSubview:self.vNHInfo];
	}
  
    return cell;
}

- (void)addContactToAddressBook
{
    NSDictionary *dToSet = self.addToContactInfoDic;
    NSString *strFirstName = ( ([dToSet valueForKey:@"First_Name"] && ![[dToSet valueForKey:@"First_Name"] isKindOfClass:[NSNull class]] && ![[dToSet valueForKey:@"First_Name"] isEqualToString:@"N/A"]) ?[dToSet valueForKey:@"First_Name"] : @"");
    
    NSString *strMiddleName = ( ([dToSet valueForKey:@"Middle_Initial"] && ![[dToSet valueForKey:@"Middle_Initial"] isKindOfClass:[NSNull class]] && ![[dToSet valueForKey:@"Middle_Initial"] isEqualToString:@"N/A"]) ?[dToSet valueForKey:@"Middle_Initial"] : @"");
    
    NSString *strLastName = ( ([dToSet valueForKey:@"Last_Name"] && ![[dToSet valueForKey:@"Last_Name"] isKindOfClass:[NSNull class]] && ![[dToSet valueForKey:@"Last_Name"] isEqualToString:@"N/A"]) ?[dToSet valueForKey:@"Last_Name"] : @"");
    
    NSString *strPhyAdd = ( ([dToSet valueForKey:@"Physical_Address"] && ![[dToSet valueForKey:@"Physical_Address"] isKindOfClass:[NSNull class]] && ![[dToSet valueForKey:@"Physical_Address"] isEqualToString:@"N/A"]) ?[dToSet valueForKey:@"Physical_Address"] : @"");
    NSString *_strPhyAdd = [strPhyAdd stringByReplacingOccurrencesOfString:@"<br />" withString:@" "];
    
    NSString *strCity = ( ([dToSet valueForKey:@"Physical_City"] && ![[dToSet valueForKey:@"Physical_City"] isKindOfClass:[NSNull class]] && ![[dToSet valueForKey:@"Physical_City"] isEqualToString:@"N/A"]) ?[dToSet valueForKey:@"Physical_City"] : @"") ;
    
    NSString *strState = ( ([dToSet valueForKey:@"Physical_State"] && ![[dToSet valueForKey:@"Physical_State"] isKindOfClass:[NSNull class]] && ![[dToSet valueForKey:@"Physical_State"] isEqualToString:@"N/A"]) ?[dToSet valueForKey:@"Physical_State"] : @"") ;
    
    NSString *strZip = ( ([dToSet valueForKey:@"Physical_Zip"] && ![[dToSet valueForKey:@"Physical_Zip"] isKindOfClass:[NSNull class]] && ![[dToSet valueForKey:@"Physical_Zip"] isEqualToString:@"N/A"] && ![[dToSet valueForKey:@"Physical_Zip"] isEqualToString:@"0"]) ?[dToSet valueForKey:@"Physical_Zip"] : @"") ;
    
    NSString *strPhone = ( ([dToSet valueForKey:@"Phone"] && ![[dToSet valueForKey:@"Phone"] isKindOfClass:[NSNull class]] && ![[dToSet valueForKey:@"Phone"] isEqualToString:@"N/A"] && ![[dToSet valueForKey:@"Phone"] isEqualToString:@"0"]) ?[dToSet valueForKey:@"Phone"] : @"") ;
    
    NSString *strZip4 = ( ([dToSet valueForKey:@"Physical_Zip_Plus_4"] && ![[dToSet valueForKey:@"Physical_Zip_Plus_4"] isKindOfClass:[NSNull class]] && ![[dToSet valueForKey:@"Physical_Zip_Plus_4"] isEqualToString:@"N/A"] && ![[dToSet valueForKey:@"Physical_Zip_Plus_4"] isEqualToString:@"0"]) ? [dToSet valueForKey:@"Physical_Zip_Plus_4"] : @"") ;
    if (![strZip4 isEqualToString:@""])
        strZip=[strZip stringByAppendingFormat:@"-%@",strZip4];
    
    CFErrorRef error = NULL;
    ABAddressBookRef iPhoneAddressBook = ABAddressBookCreate();
    ABRecordRef newPerson = ABPersonCreate();
    CFTypeRef ctr = CFBridgingRetain(strFirstName);
    ABRecordSetValue(newPerson, kABPersonFirstNameProperty,ctr,&error);
    CFTypeRef ctrTwo = CFBridgingRetain(strMiddleName);
    ABRecordSetValue(newPerson, kABPersonMiddleNameProperty,ctrTwo,&error);
    CFTypeRef ctrThree = CFBridgingRetain(strLastName);
    ABRecordSetValue(newPerson, kABPersonLastNameProperty,ctrThree,&error);
    CFTypeRef ctrPhone = CFBridgingRetain(strPhone);
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiPhone, ctrPhone, kABPersonPhoneMainLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone,nil);
    CFRelease(multiPhone);
    CFRelease(ctr);
    CFRelease(ctrPhone);
    ABMutableMultiValueRef multiAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
    [addressDictionary setObject:_strPhyAdd forKey:(NSString *) kABPersonAddressStreetKey];
    [addressDictionary setObject:strCity forKey:(NSString *)kABPersonAddressCityKey];
    [addressDictionary setObject:strState forKey:(NSString *)kABPersonAddressStateKey];
    [addressDictionary setObject:strZip forKey:(NSString *)kABPersonAddressZIPKey];
    CFTypeRef ctr1 = CFBridgingRetain(addressDictionary);
    ABMultiValueAddValueAndLabel(multiAddress,ctr1, kABWorkLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonAddressProperty, multiAddress,&error);
    CFRelease(multiAddress);
    ABAddressBookAddRecord(iPhoneAddressBook, newPerson, &error);
    ABAddressBookSave(iPhoneAddressBook, &error);
    if (error != NULL)  {
        //NSLog(@"Danger Will Robinson! Danger!");
    }else{
        ALERT(@"Message", @"Contact added successfully", @"OK", self, nil);
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
}

- (IBAction)btnAddToContacts:(id)sender {
if IOS_NEWER_OR_EQUAL_TO__IPHONE_6_0 {
    // Request authorization to Address Book
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            // First time access has been granted, add the contact
            [self addContactToAddressBook];
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        [self addContactToAddressBook];
    }
    else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
    }
} else if IOS_OLDER_THAN__IPHONE_6_0 {
    [self addContactToAddressBook];
}    
}

#pragma Email
- (IBAction)MailTapped:(id)sender {
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil) {
		if ([mailClass canSendMail]) {
			[self displayComposerSheet];
		}
		else
		{
			[self launchMailAppOnDevice];
		}
	}
	else
	{
		[self launchMailAppOnDevice];
	}
    
}
-(void)displayComposerSheet 
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
    //Name
	NSString *strName = ( ([self.addToContactInfoDic valueForKey:@"Name"] && ![[self.addToContactInfoDic valueForKey:@"Name"] isKindOfClass:[NSNull class]] && ![[self.addToContactInfoDic valueForKey:@"Name"] isEqualToString:@"N/A"]) ?[self.addToContactInfoDic valueForKey:@"Name"] : @"");
	
	[picker setSubject:[NSString stringWithFormat:@"%@ Details (AtoZdatabases Mobile App)",strName]];
	
	
	// Set up recipients
	NSArray *toRecipients = nil;
	
	[picker setToRecipients:toRecipients];
    
	NSString *emailBody = [self generateHTMLStringForReport];
	[picker setMessageBody:emailBody isHTML:YES];
	
	[self presentModalViewController:picker animated:YES];
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			//NSLog( @"Result: canceled");
			break;
		case MFMailComposeResultSaved:
			//NSLog( @"Result: saved");
			break;
		case MFMailComposeResultSent:
			//NSLog( @"Result: sent");
			break;
		case MFMailComposeResultFailed:
			//NSLog( @"Result: failed");
			break;
		default:
			//NSLog( @"Result: not sent");
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Print Methods

- (IBAction)btnPrintTapped:(id)sender{
	
	if(!self.nxtpPrintVCtr) {
        self.nxtpPrintVCtr = [[pPrintVctr alloc] initWithNibName:@"pPrintVctr" bundle:nil];
    }
    [self presentModalViewController:self.nxtpPrintVCtr animated:YES];
    [self.nxtpPrintVCtr.webViewPrint loadHTMLString:[self generateHTMLStringForReport] baseURL:nil];
	
	
}


- (NSString*)generateHTMLStringForReport {
    NSString *strCompleteOuter = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rescomplete" ofType:@"html"]
                                                           encoding:NSUTF8StringEncoding
                                                              error:nil];
    
    NSString *strOverView = [(UIWebView*)[self.vOverView viewWithTag:1] stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    
    NSString *strNHInfo = [(UIWebView*)[self.vNHInfo viewWithTag:1] stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
	
    
    strCompleteOuter = [NSString stringWithFormat:strCompleteOuter,strOverView,strNHInfo];
    
    return strCompleteOuter;
}


#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
	NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=";
	NSString *body = @"";
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

#pragma mark createToken

- (void)createToken
{
    //Rajeev Start
    //    if([APP_DEL strToken] && [APP_DEL strToken].length>0) {
    //        [self clearUpCriteria];
    //    } else {
    //Rajeev End
    [iNetMngr createToken:self];
    //}
}

- (void)webRequestReceivedData:(NSData *)data {
    [COMMON_PARSER parseData:data];
    //NSLog(@"COMMON_PARSER.jsonReponse = %@", [COMMON_PARSER.jsonReponse description]);
    
    NSInteger responseCode = [[[COMMON_PARSER.jsonReponse objectForKey:@"Response"] objectForKey:@"responseCode"] integerValue];
    if(([[[COMMON_PARSER.jsonReponse objectForKey:@"Response"] objectForKey:@"responseCode"] isEqualToString:@"A-512"] && [[COMMON_PARSER.jsonReponse objectForKey:@"Response"] objectForKey:@"responseMessage"]) || ([[[COMMON_PARSER.jsonReponse objectForKey:@"Response"] objectForKey:@"responseCode"] isEqualToString:@"I-501"] && [[COMMON_PARSER.jsonReponse objectForKey:@"Response"] objectForKey:@"responseMessage"])/*statusCode==401 && [COMMON_PARSER.dStatus valueForKey:@"message"]*/) {
        if([[[COMMON_PARSER.jsonReponse objectForKey:@"Response"] objectForKey:@"responseMessage"] rangeOfString:@"Invalid Access Token or Access Token has expired"].length>0 || [[[COMMON_PARSER.jsonReponse objectForKey:@"Response"] objectForKey:@"responseMessage"] rangeOfString:@"Invalid Token"].length>0) {
            [APP_DEL setStrToken:nil];
            [self createToken]; return;
        }
    }
    
    if([[[iNetMngr requestObject] restValue] rangeOfString:@"auth/subscriber/?AccessToken"].length>0) {
        if(responseCode==200) {
            //Rajeev Start
            COMMON_PARSER.dToken=nil;//[[COMMON_PARSER.jsonReponse valueForKey:@"response"] valueForKey:@"token"];
            COMMON_PARSER.responseDetails = [[COMMON_PARSER.jsonReponse valueForKey:@"Response"] valueForKey:@"responseDetails"];
            //NSLog(@"COMMON_PARSER.responseDetails = %@", [COMMON_PARSER.responseDetails description]);
            COMMON_PARSER.strActiveToken=[COMMON_PARSER.responseDetails objectForKey:@"TokenID"];//[COMMON_PARSER.dToken valueForKey:@"guid"];
            //NSLog(@"TokenID = %@", COMMON_PARSER.strActiveToken);
            [APP_DEL setStrToken:COMMON_PARSER.strActiveToken];
            
            [self loadByID:[self.dForResult valueForKey:@"id"]];
            return;
            //Rajeev End
        }
    }
    
    
    if (responseCode == 500 && [[[COMMON_PARSER.jsonReponse objectForKey:@"Response"] objectForKey:@"responseMessage"] isEqualToString:@"Get Record Detail Service Exception"]) {
        [self loadByID:[self.dForResult valueForKey:@"id"]];
        return;
    }
    
//    NSArray *ar = (NSArray*)COMMON_PARSER.jsonReponse;
//    if([ar count]>0) {
//        NSDictionary *dToSet = [ar objectAtIndex:0];
    if (responseCode == 200) {
        self.dForDtl = [[[COMMON_PARSER.jsonReponse objectForKey:@"Response"] objectForKey:@"responseDetails"] objectForKey:@"RecordDetail"];
        NSDictionary *dToSet = self.dForDtl;
        
        self.dForDtl=dToSet;
        [self setUpOverView:dToSet];
        [self setUpNHInfo:dToSet];
    }
}

-(NSString *) phoneNumberFormatterWithNum:(NSString *) number
{
    if ([number isEqualToString:@"N/A"] || [number isEqualToString:@"0"]) {
        number = @"N/A";
        return number;
    }
    
    if ([number length] != 10)
        return number;
    
    NSMutableString *mutNumber = [number mutableCopy];
    [mutNumber insertString:@"(" atIndex:0];
    [mutNumber insertString:@")" atIndex:4];
    [mutNumber insertString:@" " atIndex:5];
    [mutNumber insertString:@"-" atIndex:9];
    
    NSLog(@"mutNumber = %@", mutNumber);
    
    return mutNumber;
}

#pragma mark - OverViewDetails

-(void)setUpOverView:(NSDictionary*)dToSet {
    NSURL *baseURL = [NSURL fileURLWithPath:[[[NSBundle mainBundle] pathForResource:@"rstloverview" ofType:@"html"] stringByDeletingLastPathComponent]];
    NSString *str = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rstloverview" ofType:@"html"] encoding:NSStringEncodingConversionAllowLossy error:nil];
    
    //Rajeev Start
    
	NSArray *searchResultRecord = [dToSet objectForKey:@"searchResultRecord"];
    
    if ([searchResultRecord count] == 0)
        return;
    NSDictionary *resultFields = [searchResultRecord objectAtIndex:0];
    
    if ([resultFields count] == 0)
        return;
    NSArray *resultFieldsChild = [resultFields objectForKey:@"resultFields"];
    
    //Name
    
    NSMutableDictionary *elementDic = [[NSMutableDictionary alloc] init];
    for (NSDictionary *dic in resultFieldsChild) {
        if ([elementDic count] == 3)
            break;
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"First_Name"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"First_Name"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Middle_Initial"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Middle_Initial"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Last_Name"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Last_Name"];
            }
        }
    }
	
    NSString *First_Name = ([[elementDic objectForKey:@"First_Name"] isEqualToString:@"N/A"])?@"":[elementDic objectForKey:@"First_Name"];
    NSString *Middle_Initial = ([[elementDic objectForKey:@"Middle_Initial"] isEqualToString:@"N/A"])?@"":[elementDic objectForKey:@"Middle_Initial"];
    NSString *Last_Name = ([[elementDic objectForKey:@"Last_Name"] isEqualToString:@"N/A"])?@"":[elementDic objectForKey:@"Last_Name"];
    
    [self.addToContactInfoDic setObject:[NSString stringWithFormat:@"%@ %@ %@", First_Name,Middle_Initial,Last_Name] forKey:@"Name"];
    [self.addToContactInfoDic setObject:First_Name forKey:@"First_Name"];
    [self.addToContactInfoDic setObject:Middle_Initial forKey:@"Middle_Initial"];
    [self.addToContactInfoDic setObject:Last_Name forKey:@"Last_Name"];
    
    NSString *_strBName = nil;
    if ([First_Name isEqualToString:@""] && [Middle_Initial isEqualToString:@""] && [Last_Name isEqualToString:@""]) {
        _strBName = @"N/A";
    }
    else {
        _strBName = [NSString stringWithFormat:@"%@ %@ %@", First_Name, Middle_Initial, Last_Name];
    }
    [self.addToContactInfoDic setObject:_strBName forKey:@"Name"];
//	NSString *strBName = ([dToSet valueForKey:@"Name"] && ![[dToSet valueForKey:@"Name"] isKindOfClass:[NSNull class]] ) ?[dToSet valueForKey:@"Name"] : @"N/A";
	//self.lblTitle.text=strBName;
	NSString *strBName = ([_strBName isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",_strBName];
	
	//Physical Address ( add space here in last )
    
    [elementDic removeAllObjects];
    for (NSDictionary *dic in resultFieldsChild) {
        if ([elementDic count] == 5)
            break;
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Physical_Address"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Physical_Address"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Physical_City"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Physical_City"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Physical_State"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Physical_State"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Physical_Zip"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Physical_Zip"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Physical_Zip_Plus_4"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Physical_Zip_Plus_4"];
            }
        }
    }
    
    NSString *Physical_Address = ([[elementDic objectForKey:@"Physical_Address"] isEqualToString:@"N/A"])?@"":[elementDic objectForKey:@"Physical_Address"];
    NSString *Physical_City = ([[elementDic objectForKey:@"Physical_City"] isEqualToString:@"N/A"])?@"":[elementDic objectForKey:@"Physical_City"];
    NSString *Physical_State = ([[elementDic objectForKey:@"Physical_State"] isEqualToString:@"N/A"])?@"":[elementDic objectForKey:@"Physical_State"];
     NSString *Physical_Zip = ([[elementDic objectForKey:@"Physical_Zip"] isEqualToString:@"N/A"] || [[elementDic objectForKey:@"Physical_Zip"] isEqualToString:@"0"])?@"":[elementDic objectForKey:@"Physical_Zip"];
    NSString *Physical_Zip_Plus_4 = ([[elementDic objectForKey:@"Physical_Zip_Plus_4"] isEqualToString:@"N/A"] || [[elementDic objectForKey:@"Physical_Zip_Plus_4"] isEqualToString:@"0"])?@"":[elementDic objectForKey:@"Physical_Zip_Plus_4"];
    
    [self.addToContactInfoDic setObject:Physical_Address forKey:@"Physical_Address"];
    [self.addToContactInfoDic setObject:Physical_City forKey:@"Physical_City"];
    [self.addToContactInfoDic setObject:Physical_State forKey:@"Physical_State"];
    [self.addToContactInfoDic setObject:Physical_Zip forKey:@"Physical_Zip"];
    [self.addToContactInfoDic setObject:Physical_Zip_Plus_4 forKey:@"Physical_Zip_Plus_4"];
    
    NSString *_strLName = nil;
    if ([Physical_Address isEqualToString:@""] && [Physical_City isEqualToString:@""] && [Physical_State isEqualToString:@""] && [Physical_Zip isEqualToString:@""] && [Physical_Zip_Plus_4 isEqualToString:@""]) {
        _strLName = @"N/A";
    } else if ([Physical_Zip_Plus_4 isEqualToString:@""]) {
        _strLName = [NSString stringWithFormat:@"%@<br />%@, %@ %@<br />", Physical_Address,Physical_City,Physical_State,Physical_Zip];
    } else {
        _strLName = [NSString stringWithFormat:@"%@<br />%@, %@ %@ - %@<br />", Physical_Address,Physical_City,Physical_State,Physical_Zip,Physical_Zip_Plus_4];
    }
//    NSString *strLName = ([dToSet valueForKey:@"Physical Address "] && ![[dToSet valueForKey:@"Physical Address "] isKindOfClass:[NSNull class]] ) ?[dToSet valueForKey:@"Physical Address "] : @"N/A";
	
	NSString *strLName = ([_strLName isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",_strLName];
    
    // Google Map
    
    NSString *_strGoogle = nil;
    if ([Physical_Address isEqualToString:@""] && [Physical_City isEqualToString:@""] && [Physical_State isEqualToString:@""] && [Physical_Zip isEqualToString:@""] && [Physical_Zip_Plus_4 isEqualToString:@""]) {
        _strGoogle = @"";
    }
    else {
        _strGoogle = [NSString stringWithFormat:@"<a href=%@%@,%@,%@,%@target=""_blank"">Maps & Directions</a>",@"http://maps.google.com/maps?q=",Physical_Address,Physical_City,Physical_State,Physical_Zip];
    }
    
    NSString *strGoogle = (![_strGoogle isEqualToString:@""]) ?_strGoogle : @"";
    strGoogle = ([strGoogle isEqualToString:@""])?@"":[NSString stringWithFormat:@"<strong>%@</strong>",strGoogle];
    
	strLName = [strLName stringByAppendingString:strGoogle];
    
	//Phone
    
    NSString *element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Phone"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
    NSString *strPhyAdd = (element && ![element isKindOfClass:[NSNull class]] && ![element isEqualToString:@"0"] ) ?element : @"N/A";
	[self.addToContactInfoDic setObject:strPhyAdd forKey:@"Phone"];
    
	strPhyAdd = ([strPhyAdd isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",[self phoneNumberFormatterWithNum:element]];
	
	//Metro Area
    
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"GeoCode_cbsatitle"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
	NSString *strPhone = (element && ![element isKindOfClass:[NSNull class]] && ![element isEqualToString:@"N/A"] ) ?element : @"N/A";
	
	strPhone = ([strPhone isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
	
	//County
    
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"County_Description"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
	NSString *strKeyEx = (element && ![element isKindOfClass:[NSNull class]] && ![element isEqualToString:@"N/A"]) ?element : @"N/A";
	
	strKeyEx = ([strKeyEx isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
	
	//Gender
    
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Gender"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
	NSString *strMainLB = nil;
    if (element && ![element isKindOfClass:[NSNull class]] && ![element isEqualToString:@"N/A"]) {
        if ([element isEqualToString:@"U"])
            element = @"Unknown";
        else if ([element isEqualToString:@"M"])
            element = @"Male";
        else if ([element isEqualToString:@"F"])
            element = @"Female";
    }
    else {
      strMainLB = @"N/A";
    }
    //= (element && ![element isKindOfClass:[NSNull class]] && ![element isEqualToString:@"N/A"]) ?element : @"N/A";
	
	strMainLB = ([strMainLB isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
	
	//Length of Residency
    
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Length_Of_Residence"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
	NSString *strWebSite = (element && ![element isKindOfClass:[NSNull class]] && ![element isEqualToString:@"0"]) ?element : @"N/A";
	
	strWebSite = ([strWebSite isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@ Years</strong>",element];
	
	//Rajeev End
	
    NSString *strHTML = [NSString stringWithFormat:str,strBName,strLName,strPhyAdd, strPhone,strKeyEx,strMainLB,strWebSite];
    [(UIWebView*)[self.vOverView viewWithTag:1] loadHTMLString:strHTML baseURL:baseURL];
}

#pragma mark - Neighborhood Information

-(void)setUpNHInfo:(NSDictionary*)dToSet{
    NSURL *baseURL = [NSURL fileURLWithPath:[[[NSBundle mainBundle] pathForResource:@"overview" ofType:@"html"] stringByDeletingLastPathComponent]];
    NSString *str = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"neighborhoodinfo" ofType:@"html"] encoding:NSStringEncodingConversionAllowLossy error:nil];
    
	
	//Rajeev Start
    
	NSArray *searchResultRecord = [dToSet objectForKey:@"searchResultRecord"];
    
    if ([searchResultRecord count] == 0)
        return;
    NSDictionary *resultFields = [searchResultRecord objectAtIndex:0];
    
    if ([resultFields count] == 0)
        return;
    NSArray *resultFieldsChild = [resultFields objectForKey:@"resultFields"];
	
	//Estimated Household Income
    
    NSString *element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Income_Estimated_Household_Ranges_Description"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
    NSString *Estimated_Household_Income = (element && ![element isKindOfClass:[NSNull class]] && ![element isEqualToString:@"N/A"]) ?element : @"N/A";
	
	Estimated_Household_Income = ([Estimated_Household_Income isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
	
	
	//Home Market Value
    
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Home_Value_Code_Description"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
    NSString *Home_Market_Value = (element && ![element isKindOfClass:[NSNull class]] && ![element isEqualToString:@"N/A"]) ?element : @"N/A";
	
	Home_Market_Value = ([Home_Market_Value isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
	
	//Median Home Income in 2000 Census
    
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Median_HseHld_Income_Description"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
    NSString *Median_Home_Income_Census = (element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A";
	
	Median_Home_Income_Census = ([Median_Home_Income_Census isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
	
	
	//Median Home Value in 2000 Census
    
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Median_Home_Value_Description_Old"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
	NSString *Median_Home_Value_Census = (element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A";
	
	Median_Home_Value_Census = ([Median_Home_Value_Census isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
	
	//Lattitude / Longitude
    
    NSMutableDictionary *elementDic = [[NSMutableDictionary alloc] init];
    for (NSDictionary *dic in resultFieldsChild) {
        if ([elementDic count] == 2)
            break;
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Latitude"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Latitude"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Longitude"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Longitude"];
            } 
        }
    }
    
    NSString *Lattitude = ([[elementDic objectForKey:@"Latitude"] isEqualToString:@"N/A"])?@"":[elementDic objectForKey:@"Latitude"];
    NSString *Longitude = ([[elementDic objectForKey:@"Longitude"] isEqualToString:@"N/A"])?@"":[elementDic objectForKey:@"Longitude"];
    
    NSString *_latlan = nil;
    if ([Lattitude isEqualToString:@""] && [Longitude isEqualToString:@""]) {
        _latlan = @"N/A";
    }
    else {
        _latlan = [NSString stringWithFormat:@"%@ / %@", Lattitude,Longitude];
    }
    
	NSString *latlan = (_latlan && ![_latlan isKindOfClass:[NSNull class]] ) ?_latlan : @"N/A";
	
	latlan = ([latlan isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",_latlan];
	
	
	
	NSString *strHTML = [NSString stringWithFormat:str,Estimated_Household_Income,Home_Market_Value,Median_Home_Income_Census,Median_Home_Value_Census,latlan];
    [(UIWebView*)[self.vNHInfo viewWithTag:1] loadHTMLString:strHTML baseURL:baseURL];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if(navigationType==UIWebViewNavigationTypeLinkClicked || navigationType==UIWebViewNavigationTypeFormSubmitted || navigationType==UIWebViewNavigationTypeFormResubmitted) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    } else return YES;
}


- (IBAction)btnBackTapped:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}
- (IBAction)justReloadData:(id)sender {
	UIButton *btn=(UIButton*)sender;
    btn.selected=!btn.selected;
    [self.tbl1 reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

@end
