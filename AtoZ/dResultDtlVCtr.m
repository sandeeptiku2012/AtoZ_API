
//
//  dResultDtlVCtr.m
//  AtoZ
//
//  Created by Valtech on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "dResultDtlVCtr.h"
#import "dRcrdVCtr.h"
#import "dTblMainItems.h"
#import "dTblCompetitors.h"
#import "dTblExDir.h"
#import "dTblNearBy.h"
#import "dNewAboutVCtr.h"
#import "dPrintVCtr.h"

@implementation dResultDtlVCtr
@synthesize lblBoldFont;
@synthesize lblNormalFont;
@synthesize temp;
@synthesize Nearby;
@synthesize toolbar;
@synthesize tbl1;
@synthesize tbl2;
@synthesize vOverView;
@synthesize vOwnerShip;
@synthesize vDemoGPrf;
@synthesize vIndPrfl;
@synthesize vCrpLnk;
@synthesize vOtherImpInfo;
@synthesize vQRCode;
@synthesize vRevenueTrend;
@synthesize vCompetitors;
@synthesize vExDir;
@synthesize vNearBy;


@synthesize dForDtl = _dForDtl;
@synthesize predRcrdVCtr = _predRcrdVCtr;
@synthesize nxtdDtlHelpPopOverVCtr = _nxtdDtlHelpPopOverVCtr;
@synthesize popVCtr = _popVCtr;
@synthesize lblTitle;
@synthesize nxtdNewAboutVCtr = _nxtdNewAboutVCtr;
@synthesize nxtdPrintVCtr = _nxtdPrintVCtr;
@synthesize tblMainItems;
@synthesize tableCompetitors;
@synthesize tableExDir;
@synthesize tableNearBy;
@synthesize yearsDic;
@synthesize dForResult;
@synthesize addToContactInfoDic;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.addToContactInfoDic = [[NSMutableDictionary alloc] init];
    self.tableCompetitors.predResultDtlVCtr=self;
    self.tableNearBy.predResultDtlVCtr=self;
    
    self.nxtdDtlHelpPopOverVCtr = [[dDtlHelpPopOverVCtr alloc] initWithNibName:@"dDtlHelpPopOverVCtr" bundle:nil];
    UINavigationController *nCtr = [[UINavigationController alloc] initWithRootViewController:self.nxtdDtlHelpPopOverVCtr];
    self.popVCtr = [[UIPopoverController alloc] initWithContentViewController:nCtr];
    
    self.tblMainItems.predResultDtlVCtr=self;
    
    self.tblMainItems.tableView.delegate=self.tblMainItems;
    self.tblMainItems.tableView.dataSource=self.tblMainItems;
    
    [iNetMngr setView:self.view];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Back to Search" style:UIBarButtonItemStylePlain target:self action:@selector(backTapped:)];
    self.navigationItem.leftBarButtonItem=item;
    UIView *vQuickLinks = [self.view viewWithTag:56];
    
    self.vCrpLnk.layer.borderColor=[[UIColor blackColor] CGColor];
    self.vDemoGPrf.layer.borderColor=[[UIColor blackColor] CGColor];
    self.vIndPrfl.layer.borderColor=[[UIColor blackColor] CGColor];
    self.vOverView.layer.borderColor=[[UIColor blackColor] CGColor];
    self.vOwnerShip.layer.borderColor=[[UIColor blackColor] CGColor];
    self.vOtherImpInfo.layer.borderColor=[[UIColor blackColor] CGColor];
    self.vQRCode.layer.borderColor=[[UIColor blackColor] CGColor];
    self.vRevenueTrend.layer.borderColor=[[UIColor blackColor] CGColor];
    vQuickLinks.layer.borderColor=[[UIColor blackColor] CGColor];
    self.vCompetitors.layer.borderColor=[[UIColor blackColor] CGColor];
    self.vExDir.layer.borderColor=[[UIColor blackColor] CGColor];
    self.vNearBy.layer.borderColor=[[UIColor blackColor] CGColor];
    
    self.vOverView.layer.cornerRadius=4;
    self.vOverView.layer.borderWidth=1;
    
    self.vDemoGPrf.layer.cornerRadius=4;
    self.vDemoGPrf.layer.borderWidth=1;
    
    self.vIndPrfl.layer.cornerRadius=4;
    self.vIndPrfl.layer.borderWidth=1;
    
    self.vCrpLnk.layer.cornerRadius=4;
    self.vCrpLnk.layer.borderWidth=1;
    
    self.vOwnerShip.layer.cornerRadius=4;
    self.vOwnerShip.layer.borderWidth=1;
    
    self.vOtherImpInfo.layer.cornerRadius=4;
    self.vOtherImpInfo.layer.borderWidth=1;
    
    self.vQRCode.layer.cornerRadius=4;
    self.vQRCode.layer.borderWidth=1;
    
    self.vRevenueTrend.layer.cornerRadius=4;
    self.vRevenueTrend.layer.borderWidth=1;
    
    self.vCompetitors.layer.cornerRadius=4;
    self.vCompetitors.layer.borderWidth=1;
    
    self.vExDir.layer.cornerRadius=4;
    self.vExDir.layer.borderWidth=1;
    
    self.vNearBy.layer.cornerRadius=4;
    self.vNearBy.layer.borderWidth=1;
    
    vQuickLinks.layer.cornerRadius=4;
    vQuickLinks.layer.borderWidth=1;
    [self loadByID:[self.dForResult valueForKey:@"id"]];
}

- (void)webRequestReceivedData:(NSData *)data {
    [COMMON_PARSER parseData:data];
    NSLog(@"COMMON_PARSER.jsonReponse = %@", [COMMON_PARSER.jsonReponse description]);
    
    NSInteger responseCode = [[[COMMON_PARSER.jsonReponse objectForKey:@"Response"] objectForKey:@"responseCode"] integerValue];
    
    if ([[[iNetMngr requestObject] restValue] rangeOfString:@"portlet/business_search_detail_historical_data"].length>0) {
        if (responseCode == 200) {
            NSDictionary *responseDetails = [[COMMON_PARSER.jsonReponse valueForKey:@"Response"] valueForKey:@"responseDetails"];
            NSDictionary *uielements = [[responseDetails objectForKey:@"PortletDetail"] objectForKey:@"uielements"];
            NSArray *uielement = [uielements objectForKey:@"uielement"];
            
            self.yearsDic = [[NSMutableDictionary alloc] init];
            for (NSDictionary *dic in uielement) {
                if ([self.yearsDic count] == 2)
                    break;
                
                if ([[dic objectForKey:@"id"] isEqualToString:@"lbl_sales_years"]) {
                    NSDictionary *regExDic = [dic objectForKey:@"regEx"];
                    if ([[regExDic objectForKey:@"isApplicable"] isEqualToString:@"true"]) {
                        NSString *regExFormat = [regExDic objectForKey:@"regExFormat"];
                        NSString *finalStr = [regExFormat stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"'|"""]];
                        [self.yearsDic setObject:[finalStr componentsSeparatedByString:@" "] forKey:@"lbl_sales_years"];
                    }
                }
                else if ([[dic objectForKey:@"id"] isEqualToString:@"lbl_employee_year"]) {
                    NSDictionary *regExDic = [dic objectForKey:@"regEx"];
                    if ([[regExDic objectForKey:@"isApplicable"] isEqualToString:@"true"]) {
                        NSString *regExFormat = [regExDic objectForKey:@"regExFormat"];
                        NSString *finalStr = [regExFormat stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"'|"""]];
                        [self.yearsDic setObject:[finalStr componentsSeparatedByString:@" "] forKey:@"lbl_employee_year"];
                    }
                }
            }
        }
        
        [self startFeedDataToDetailsScreen];
        return;
    }
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
    
    if (responseCode == 200) {
        self.dForDtl = [[[COMMON_PARSER.jsonReponse objectForKey:@"Response"] objectForKey:@"responseDetails"] objectForKey:@"RecordDetail"];
        NSDictionary *dToSet = self.dForDtl;
        
        [self getYearsListRelatedToRevenueTrend];
        //        [self setUpOverView:dToSet]; //Completed
        //        [self setUpDemoGraphic:dToSet]; //Completed
        //        [self setUpOwnerShip:dToSet]; //Completed
        ////        [self setUpCorporate:dToSet];   //PENDING
        //        [self setUpIndustry:dToSet]; //Completed
        //        [self setUpOtherImpInfo:dToSet]; //Completed
        //        [self setUpQRCode:dToSet]; //Completed
        //        [self setUpRevenueTrend:dToSet];
        //        [self setUpEmployeeTrend:dToSet];
        //
        //        NSArray *ar=[dToSet valueForKey:@"Competitors"];
        //        self.tableCompetitors.arForTable=ar;
        //        [self.tableCompetitors shouldReloadThings];
        //
        //        ar=[dToSet valueForKey:@"Executive Directory"];
        //        self.tableExDir.arForTable=ar;
        //        [self.tableExDir shouldReloadThings];
        //
        //        ar=[dToSet valueForKey:@"Nearby Businesses"];
        //        self.tableNearBy.arForTable=ar;
        //        [self.tableNearBy shouldReloadThings];
    }
    
    //NSArray *ar = (NSArray*)COMMON_PARSER.jsonReponse;
    //    if([ar count]>0) {
    //        NSDictionary *dToSet = [ar objectAtIndex:0];
    //        self.dForDtl = dToSet;
    //        [self setUpOverView:dToSet];
    //        [self setUpDemoGraphic:dToSet];
    //        [self setUpOwnerShip:dToSet];
    //        [self setUpCorporate:dToSet];
    //        [self setUpIndustry:dToSet];
    //        [self setUpOtherImpInfo:dToSet];
    //        [self setUpQRCode:dToSet];
    //        [self setUpRevenueTrend:dToSet];
    //        [self setUpEmployeeTrend:dToSet];
    //
    //        NSArray *ar=[dToSet valueForKey:@"Competitors"];
    //        self.tableCompetitors.arForTable=ar;
    //        [self.tableCompetitors shouldReloadThings];
    //
    //        ar=[dToSet valueForKey:@"Executive Directory"];
    //        self.tableExDir.arForTable=ar;
    //        [self.tableExDir shouldReloadThings];
    //        
    //        ar=[dToSet valueForKey:@"Nearby Businesses"];
    //        self.tableNearBy.arForTable=ar;
    //        [self.tableNearBy shouldReloadThings];
    //				
    //    }
}

#pragma mark - OverViewDetails

-(void)setUpOverView:(NSDictionary*)dToSet{
    NSURL *baseURL = [NSURL fileURLWithPath:[[[NSBundle mainBundle] pathForResource:@"overview" ofType:@"html"] stringByDeletingLastPathComponent]];
    NSString *str = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"overview" ofType:@"html"] encoding:NSStringEncodingConversionAllowLossy error:nil];

	
	//Rajeev Start
    
	NSArray *searchResultRecord = [dToSet objectForKey:@"searchResultRecord"];
    
    if ([searchResultRecord count] == 0)
        return;
    NSDictionary *resultFields = [searchResultRecord objectAtIndex:0];
    
    if ([resultFields count] == 0)
        return;
    NSArray *resultFieldsChild = [resultFields objectForKey:@"resultFields"];
    
	//Business Name
    NSString *element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Company_Name"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
	
    //	NSString *strBName = ([dToSet valueForKey:@"Business Name"] && ![[dToSet valueForKey:@"Business Name"] isKindOfClass:[NSNull class]] ) ?[dToSet valueForKey:@"Business Name"] : @"N/A";
    
    //    strBName = ([strBName isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",[dToSet valueForKey:@"Business Name"]];
    
    NSString *strBName = (element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A";
	[self.addToContactInfoDic setObject:strBName forKey:@"Company_Name"];
    if ([strBName isEqualToString:@"N/A"]) {
        self.lblTitle.text = @"Details";
    } else {
        self.lblTitle.text = strBName;
    }
    
	strBName = ([strBName isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
	
	
    
    //self.lblTitle.text=( ([dToSet valueForKey:@"Business Name"] && ![[dToSet valueForKey:@"Business Name"] isKindOfClass:[NSNull class]] ) ?[dToSet valueForKey:@"Business Name"] : @"");
    
	
	
	//Legal Name
	
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Company_Name_2"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
	NSString *strLName = (element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A";
    
    if ([strLName isEqualToString:@"N/A"])
        strLName = @"--same as business name--";
	
	strLName = ([strLName isEqualToString:@"N/A"] || [strLName isEqualToString:@"--same as business name--"])?strLName:[NSString stringWithFormat:@"<strong>%@</strong>",element];
	
	
	//  physical Address
    
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Physical_Address"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    [self.addToContactInfoDic setObject:element forKey:@"Physical_Address"];
    NSString *Physical_Address = element;
    
    NSString *strPhyAdd = (element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A";
	
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Physical_City"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    [self.addToContactInfoDic setObject:element forKey:@"Physical_City"];
    NSString *Physical_City = element;
    //    strPhyAdd = [strPhyAdd stringByAppendingString: (element && ![element isKindOfClass:[NSNull class]] ) ?element : @""];
    
    strPhyAdd = [strPhyAdd stringByAppendingFormat:@"<br />%@", (element && ![element isEqualToString:@"N/A"] && ![element isKindOfClass:[NSNull class]] ) ?element : @""];
    
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Physical_State"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    [self.addToContactInfoDic setObject:element forKey:@"Physical_State"];
    NSString *Physical_State = element;
    //    strPhyAdd = [strPhyAdd stringByAppendingString:(element && ![element isKindOfClass:[NSNull class]] ) ?element : @""];
    
    strPhyAdd = [strPhyAdd stringByAppendingFormat:@", %@",(element && ![element isEqualToString:@"N/A"] && ![element isKindOfClass:[NSNull class]] ) ?element : @""];
    
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Physical_Zip"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    [self.addToContactInfoDic setObject:element forKey:@"Physical_Zip"];
    NSString *Physical_Zip = element;
    //    strPhyAdd = [strPhyAdd stringByAppendingString:(element && ![element isKindOfClass:[NSNull class]] ) ?element : @""];
    
    strPhyAdd = [strPhyAdd stringByAppendingFormat:@" %@",(element && ![element isEqualToString:@"N/A"] && ![element isEqualToString:@"0"] && ![element isKindOfClass:[NSNull class]] ) ?element : @""];
	
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Physical_Zip_Plus_4"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    [self.addToContactInfoDic setObject:element forKey:@"Physical_Zip_Plus_4"];
    //    strPhyAdd = [strPhyAdd stringByAppendingString:(element && ![element isKindOfClass:[NSNull class]] ) ?element : @""];
     if (element && ![element isEqualToString:@"N/A"] && ![element isEqualToString:@"0"] && ![element isKindOfClass:[NSNull class]] )
            strPhyAdd = [strPhyAdd stringByAppendingFormat:@"-%@",element];
    
    //self.phyAdd = strPhyAdd;
//    [self.addToContactInfoDic setObject:strPhyAdd forKey:@"Physical_Address"];
    
    //    if(!([strPhyAdd rangeOfString:@"N/A"].length>0)) {
    //        strPhyAdd = [strPhyAdd stringByAppendingString:( ([dToSet valueForKey:@"Google Map"] && ![[dToSet valueForKey:@"Google Map"] isKindOfClass:[NSNull class]] ) ?[dToSet valueForKey:@"Google Map"] : @"")];
    //    }
	
	strPhyAdd = ([strPhyAdd isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",strPhyAdd];
    
    NSString *_strGoogle = [NSString stringWithFormat:@"<a href=%@%@,%@,%@,%@target=""_blank"">Maps & Directions</a>",@"http://maps.google.com/maps?q=",[Physical_Address stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]],Physical_City,Physical_State,Physical_Zip];
    
	strPhyAdd = [strPhyAdd stringByAppendingFormat:@"<br />%@", _strGoogle];
	//Phone
    
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Phone"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
    NSString *formattedPhone = [self phoneNumberFormatterWithNum:element];
	NSString *strPhone = (element && ![element isKindOfClass:[NSNull class]] ) ?formattedPhone : @"N/A";
    [self.addToContactInfoDic setObject:strPhone forKey:@"Phone"];
	
	strPhone = ([strPhone isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",formattedPhone];
	
    
	//Key Executive, Title
    
    NSMutableDictionary *elementDic = [[NSMutableDictionary alloc] init];
    for (NSDictionary *dic in resultFieldsChild) {
        if ([elementDic count] == 5)
            break;
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Prefix_01"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Prefix_01"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"First_Name_01"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"First_Name_01"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Last_Name_01"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Last_Name_01"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Executive_Title_01"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Executive_Title_01"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Middle_Initial_01"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Middle_Initial_01"];
            }
        }
    }
    
    NSString *Prefix_01 = ([elementDic objectForKey:@"Prefix_01"] && ![[elementDic objectForKey:@"Prefix_01"] isEqualToString:@"N/A"]) ? [elementDic objectForKey:@"Prefix_01"]: @"";
    NSString *First_Name_01 = ([elementDic objectForKey:@"First_Name_01"] && ![[elementDic objectForKey:@"First_Name_01"] isEqualToString:@"N/A"]) ? [elementDic objectForKey:@"First_Name_01"]: @"";
    NSString *Last_Name_01 = ([elementDic objectForKey:@"Last_Name_01"] && ![[elementDic objectForKey:@"Last_Name_01"] isEqualToString:@"N/A"]) ? [elementDic objectForKey:@"Last_Name_01"]: @"";
    NSString *Executive_Title_01 = ([elementDic objectForKey:@"Executive_Title_01"] && ![[elementDic objectForKey:@"Executive_Title_01"] isEqualToString:@"N/A"]) ? [elementDic objectForKey:@"Executive_Title_01"]: @"";
    NSString *Middle_Initial_01 = ([elementDic objectForKey:@"Middle_Initial_01"] && ![[elementDic objectForKey:@"Middle_Initial_01"] isEqualToString:@"N/A"]) ? [elementDic objectForKey:@"Middle_Initial_01"]: @"";
    
    
    NSString *finalStr = nil;
    if ([Prefix_01 isEqualToString:@""] && [First_Name_01 isEqualToString:@""] && [Last_Name_01 isEqualToString:@""] && [Executive_Title_01 isEqualToString:@""] && [Middle_Initial_01 isEqualToString:@""]) {
        finalStr = @"N/A";
    } else if ([Executive_Title_01 isEqualToString:@""]) {
        finalStr = [NSString stringWithFormat:@"%@ %@ %@ %@",Prefix_01,First_Name_01,Middle_Initial_01,Last_Name_01];
    } else {
        finalStr = [NSString stringWithFormat:@"%@ %@ %@ %@, %@",Prefix_01,First_Name_01,Middle_Initial_01,Last_Name_01,Executive_Title_01];
    }
    
	NSString *strKeyEx = (finalStr && ![finalStr isKindOfClass:[NSNull class]] ) ?finalStr : @"N/A";
	
	strKeyEx = ([strKeyEx isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",finalStr];
	
	//Main Line of Business
	
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Primary_Industry_Description"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
	NSString *strMainLB = (element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A";
	
	strMainLB = ([strMainLB isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
	
	//Website
    
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"URL"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
    NSString *strWebSite = nil;
    
    if (element && ![element isKindOfClass:[NSNull class]] && ![element isEqualToString:@"N/A"]) {
        if ([element rangeOfString:@"www"].length>0)
            strWebSite = [NSString stringWithFormat:@"<a href=%@%@ target=""_blank"">%@</a>",@"http://",element,element];
        else
            strWebSite = [NSString stringWithFormat:@"<a href=%@%@ target=""_blank"">%@%@</a>",@"http://www.",element,@"www.",element];
    }
    else {
        strWebSite = @"N/A";
    }
    
	strWebSite = ([strWebSite isEqualToString:@"N/A"])?@"N/A":strWebSite/*[NSString stringWithFormat:@"<strong>%@</strong>",element]*/;
    
    //	NSString *strWebSite = (element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A";
    //
    //	strWebSite = ([strWebSite isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
	
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
    
	NSString *strCountry = (element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A";
	
	strCountry = ([strCountry isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
	
	//Metro Area
    
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"CBSA_Description"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
	NSString *strMetroArea = (element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A";
	
	strMetroArea = ([strMetroArea isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
	
	//Mailing Address
    
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Mailing_Address"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
	NSString *strMailingAdd = (element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A";
    
    
    
    strMailingAdd = ([strMailingAdd isEqualToString:@"N/A"] || [strMailingAdd isEqualToString:@"--same as physical address--"])?strMailingAdd:[NSString stringWithFormat:@"<strong>%@</strong>",element];
    ;
	
    if(![strMailingAdd isEqualToString:@"--same as physical address--"] && ![strMailingAdd isEqualToString:@"N/A"]) {
        
        element = nil;
        for (NSDictionary *dic in resultFieldsChild) {
            @autoreleasepool {
                if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Mailing_City"]) {
                    element = [dic objectForKey:@"fieldValue"];
                    break;
                }
            }
        }
        
        strMailingAdd = [strMailingAdd stringByAppendingFormat:@"<br />%@", (element && ![element isEqualToString:@"N/A"] && ![element isKindOfClass:[NSNull class]] ) ?element : @""/*stringByAppendingString:(element && ![element isEqualToString:@"N/A"] && ![element isKindOfClass:[NSNull class]] ) ?element : @""*/];
        
        element = nil;
        for (NSDictionary *dic in resultFieldsChild) {
            @autoreleasepool {
                if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Mailing_State"]) {
                    element = [dic objectForKey:@"fieldValue"];
                    break;
                }
            }
        }
        
        if (element && ![element isEqualToString:@"N/A"] && ![element isKindOfClass:[NSNull class]] )
            strMailingAdd = [strMailingAdd stringByAppendingFormat:@", %@",element];
        
        element = nil;
        for (NSDictionary *dic in resultFieldsChild) {
            @autoreleasepool {
                if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Mailing_Zip"]) {
                    element = [dic objectForKey:@"fieldValue"];
                    break;
                }
            }
        }
        
        strMailingAdd = [strMailingAdd stringByAppendingFormat:@" %@",(element && ![element isEqualToString:@"0"] && ![element isEqualToString:@"0"] && ![element isKindOfClass:[NSNull class]] ) ?element : @""];
        
        element = nil;
        for (NSDictionary *dic in resultFieldsChild) {
            @autoreleasepool {
                if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Mailing_Zip_Plus_4"]) {
                    element = [dic objectForKey:@"fieldValue"];
                    break;
                }
            }
        }
        
//        if ([element isEqualToString:@"0"])
//            element = @"0000";
//        strMailingAdd = [strMailingAdd stringByAppendingFormat:@"-%@",(element && ![element isKindOfClass:[NSNull class]] ) ?element : @""];
        if (element && ![element isEqualToString:@"N/A"] && ![element isEqualToString:@"0"] && ![element isKindOfClass:[NSNull class]] )
            strMailingAdd = [strMailingAdd stringByAppendingFormat:@"-%@",element];
        
        //        strMailingAdd = [strMailingAdd stringByAppendingString:(element && ![element isEqualToString:@"0"] && ![element isEqualToString:@"N/A"] && ![element isKindOfClass:[NSNull class]] ) ?element : @""];
        
        strMailingAdd = ([strMailingAdd isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",strMailingAdd];
    }
    
	//Fax
    
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Fax"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
    NSString *formattedFax = [self phoneNumberFormatterWithNum:element];
	NSString *strFax = (element && ![element isKindOfClass:[NSNull class]] ) ?formattedFax : @"N/A";
	
	strFax = ([strFax isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",formattedFax];
	
	
    
    NSString *strHTML = [NSString stringWithFormat:str,strBName,strLName,strPhyAdd, strPhone,strKeyEx,strMainLB,strWebSite,strCountry,strMetroArea,strMailingAdd,strFax];
    
    //Rajeev End
    
    [(UIWebView*)[self.vOverView viewWithTag:1] loadHTMLString:strHTML baseURL:baseURL];
}

#pragma mark - demographic

-(void)setUpDemoGraphic:(NSDictionary*)dToSet{
    NSURL *baseURL = [NSURL fileURLWithPath:[[[NSBundle mainBundle] pathForResource:@"overview" ofType:@"html"] stringByDeletingLastPathComponent]];
    NSString *str = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"demogrprf" ofType:@"html"] encoding:NSStringEncodingConversionAllowLossy error:nil];

    //    NSString *strForGoogle = [NSString stringWithFormat:@"%@ %@",
    //                              ( ([dToSet valueForKey:@"Google Search"] && ![[dToSet valueForKey:@"Google Search"] isKindOfClass:[NSNull class]] ) ?[dToSet valueForKey:@"Google Search"] : @"") ,
    //                              ( ([dToSet valueForKey:@"Google Finance"] && ![[dToSet valueForKey:@"Google Finance"] isKindOfClass:[NSNull class]] ) ?[dToSet valueForKey:@"Google Finance"] : @"")
    //                              ];
    
    //Rajeev Start
    
	NSArray *searchResultRecord = [dToSet objectForKey:@"searchResultRecord"];
    
    if ([searchResultRecord count] == 0)
        return;
    NSDictionary *resultFields = [searchResultRecord objectAtIndex:0];
    
    if ([resultFields count] == 0)
        return;
    NSArray *resultFieldsChild = [resultFields objectForKey:@"resultFields"];
    
    NSMutableDictionary *elementDic = [[NSMutableDictionary alloc] init];
    for (NSDictionary *dic in resultFieldsChild) {
        if ([elementDic count] == 2)
            break;
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Exchange_Description"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Exchange_Description"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Ticker"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Ticker"];
            }
        }
    }
    
    NSString *strStockDtl = ( ([elementDic objectForKey:@"Exchange_Description"] && ![[elementDic objectForKey:@"Exchange_Description"] isKindOfClass:[NSNull class]] ) ? [elementDic objectForKey:@"Exchange_Description"] : @"N/A" );
    
    NSString *tickerStr = ( ([elementDic objectForKey:@"Ticker"] && ![[elementDic objectForKey:@"Ticker"] isKindOfClass:[NSNull class]] ) ? [elementDic objectForKey:@"Ticker"] : @"N/A" );
    
    
    NSString *strForGoogle = nil;
    if ([tickerStr isEqualToString:@"N/A"])
        strForGoogle = @"";
    else
        strForGoogle = [NSString stringWithFormat:@"%@%@%@%@%@",@"<a href=\"http://www.google.com/search?q=STOCK+",tickerStr,@"\" target=\"_blank\">Stock Info</a> <a href=\"http://www.google.com/finance?q=",tickerStr,@"\" target=\"_blank\">Google Finance</a>"];
    
    NSString *strForStockExchange = [NSString stringWithFormat:@"%@ %@", strStockDtl,strForGoogle];
    
	NSString *Ticker_Symbol=(tickerStr && ![tickerStr isKindOfClass:[NSNull class]] ) ?tickerStr : @"N/A";
	
	Ticker_Symbol=([Ticker_Symbol isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",tickerStr];
	
	//Location Type
    
    [elementDic removeAllObjects];
    for (NSDictionary *dic in resultFieldsChild) {
        if ([elementDic count] == 2)
            break;
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Employees_Location"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Employees_Location"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Employees_Total"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Employees_Total"];
            }
        }
    }
    
    NSString *finalStr = [NSString stringWithFormat:@"Location: %@<br />Corporate: %@<br />", [[self currencyNumberFormatterWithNum:[elementDic objectForKey:@"Employees_Location"]] stringByReplacingOccurrencesOfString:@"$" withString:@""],[[self currencyNumberFormatterWithNum:[elementDic objectForKey:@"Employees_Total"]] stringByReplacingOccurrencesOfString:@"$" withString:@""]];
    
    
	NSString *Employees = (finalStr && ![finalStr isKindOfClass:[NSNull class]] ) ?finalStr : @"N/A";
	
	Employees = ([Employees isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",finalStr];
	
	//Revenue / Yr
    
    NSString *element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Sales_Volume"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
    NSString *salesFinalStr = [self currencyNumberFormatterWithNum:element];
	NSString *Revenue_Yr=(salesFinalStr && ![salesFinalStr isKindOfClass:[NSNull class]] ) ?salesFinalStr : @"N/A";
	
	Revenue_Yr=([Revenue_Yr isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",salesFinalStr];
	
    
	//Year of Incorporation
    
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Year_Established"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
	NSString *Year_of_Incorporation=(element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A";
	
	Year_of_Incorporation=([Year_of_Incorporation isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
	
	//Public / Private
	
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Public_Description"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
	NSString *Public_Private=(element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A";
	
	Public_Private=([Public_Private isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
	
    //	//Ticker Symbol
    //
    //    element = nil;
    //    for (NSDictionary *dic in resultFieldsChild) {
    //        @autoreleasepool {
    //            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Ticker"]) {
    //                element = [dic objectForKey:@"fieldValue"];
    //                break;
    //            }
    //        }
    //    }
    //
    //	NSString *Ticker_Symbol=(element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A";
    //
    //	Ticker_Symbol=([Ticker_Symbol isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
	
	
	//Fortune 1000 Ranking
	
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Fortune_1000_Description"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
	NSString *Fortune_Ranking=(element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A";
	
	Fortune_Ranking=([Fortune_Ranking isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
	
	//Legal Status
	
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Legal_Status_Description"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
	NSString *Legal_Status=(element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A";
	
	Legal_Status=([Legal_Status isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
	
	//State of Incorporation
	
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"State_Of_Incorporation_Description"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
	NSString *State_of_Incorporation=(element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A";
	
	State_of_Incorporation=([State_of_Incorporation isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
	
	//Credit Score
    
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Credit_Score_Description"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
	NSString *Credit_Score=(element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A";
	
	Credit_Score=([Credit_Score isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
	
	//Rajeev End
    
    NSString *strHTML = [NSString stringWithFormat:str,Employees,Revenue_Yr,Year_of_Incorporation,Public_Private,Ticker_Symbol,strForStockExchange,Fortune_Ranking,Legal_Status,State_of_Incorporation,Credit_Score];
    [(UIWebView*)[self.vDemoGPrf viewWithTag:1] loadHTMLString:strHTML baseURL:baseURL];
}

#pragma mark - ownership
-(void)setUpOwnerShip:(NSDictionary*)dToSet{
    NSURL *baseURL = [NSURL fileURLWithPath:[[[NSBundle mainBundle] pathForResource:@"overview" ofType:@"html"] stringByDeletingLastPathComponent]];
    NSString *str = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"owner" ofType:@"html"] encoding:NSStringEncodingConversionAllowLossy error:nil];
	
	
	//Rajeev Start
    
	NSArray *searchResultRecord = [dToSet objectForKey:@"searchResultRecord"];
    
    if ([searchResultRecord count] == 0)
        return;
    NSDictionary *resultFields = [searchResultRecord objectAtIndex:0];
    
    if ([resultFields count] == 0)
        return;
    NSArray *resultFieldsChild = [resultFields objectForKey:@"resultFields"];
    
	//Location Type
    
    NSString *element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Location_Level_Description"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
    NSString *Location_Type = (element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A";
    
    Location_Type = ([Location_Type isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
	
	//Subsidiary
    
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Subsidiary_Description"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
	NSString *Subsidiary=( (element && ![element isKindOfClass:[NSNull class]] ) ?[NSString stringWithFormat:@"<strong>%@</strong>",element] : @"N/A");
	
	Subsidiary=([Subsidiary isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
	
	//Women Owned
    
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Women_Owned_Description"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
	NSString *Women_Owned=( (element && ![element isKindOfClass:[NSNull class]] ) ?[NSString stringWithFormat:@"<strong>%@</strong>",element] : @"N/A");
	
	Women_Owned=([Women_Owned isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
	
	
	//Minority Owned & Type
    
    NSMutableDictionary *elementDic = [[NSMutableDictionary alloc] init];
    for (NSDictionary *dic in resultFieldsChild) {
        if ([elementDic count] == 2)
            break;
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Minority_Owned_Description"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Minority_Owned_Description"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Minority_Type_Description"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Minority_Type_Description"];
            }
        }
    }
    
    NSString *minorityStr = [[elementDic objectForKey:@"Minority_Owned_Description"] stringByAppendingFormat:@" - %@", [elementDic objectForKey:@"Minority_Type_Description"]];
    
	NSString *Minority_Owned_Type=( (minorityStr && ![minorityStr isKindOfClass:[NSNull class]] ) ?[NSString stringWithFormat:@"<strong>%@</strong>",minorityStr] : @"N/A");
	
	Minority_Owned_Type=([Minority_Owned_Type isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",minorityStr];
	
	//Own / Rent
    
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Owns_Rents_Description"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
	NSString *Own_Rent=(element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A";
	
	
	Own_Rent=([Own_Rent isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
	
	//Franchise
    
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Franchise_Name"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
	NSString *Franchise=(element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A";
	
	
	Franchise=([Franchise isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
	
	//EIN
    
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"EIN"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
	NSString *EIN=(element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A";
	
	
	EIN=([EIN isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
	
	//Rajeev End
    
    NSString *strHTML = [NSString stringWithFormat:str,Location_Type,Subsidiary,Women_Owned,Minority_Owned_Type,Own_Rent,Franchise,EIN];
    
    [(UIWebView*)[self.vOwnerShip viewWithTag:1] loadHTMLString:strHTML baseURL:baseURL];
}

#pragma mark - corporate        
-(void)setUpCorporate:(NSDictionary*)dToSet{
    
    //Rajeev Start
    
	NSArray *searchResultRecord = [dToSet objectForKey:@"searchResultRecord"];
    
    if ([searchResultRecord count] == 0)
        return;
    NSDictionary *resultFields = [searchResultRecord objectAtIndex:0];
    
    if ([resultFields count] == 0)
        return;
    NSArray *resultFieldsChild = [resultFields objectForKey:@"resultFields"];
    
    NSMutableDictionary *elementDic = [[NSMutableDictionary alloc] init];
    for (NSDictionary *dic in resultFieldsChild) {
        if ([elementDic count] == 9)
            break;
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Legal_Ultimate_Parent_Id"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Legal_Ultimate_Parent_Id"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Legal_Ultimate_Parent_Name"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Legal_Ultimate_Parent_Name"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Legal_Ultimate_Parent_City"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Legal_Ultimate_Parent_City"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Legal_Ultimate_Parent_State"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Legal_Ultimate_Parent_State"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Legal_Immediate_Parent_Id"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Legal_Immediate_Parent_Id"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Legal_Immediate_Parent_Name"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Legal_Immediate_Parent_Name"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Legal_Immediate_Parent_City"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Legal_Immediate_Parent_City"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Legal_Immediate_Parent_State"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Legal_Immediate_Parent_State"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Domestic_Foreign_Description"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Domestic_Foreign_Description"];
            }
        }
    }
    
    //    NSArray *arrLinkage =  ([dToSet valueForKey:@"Linkage"] && ![[dToSet valueForKey:@"Linkage"] isKindOfClass:[NSNull class]] ) ?[dToSet valueForKey:@"Linkage"] : nil;
    
    UIButton *lblUlti = (UIButton*)[self.vCrpLnk viewWithTag:1];
    UIButton *lblImm = (UIButton*)[self.vCrpLnk viewWithTag:3];
    UIButton *lblDom = (UIButton*)[self.vCrpLnk viewWithTag:5];
    
    UIButton *btnUlti = (UIButton*)[self.vCrpLnk viewWithTag:2];
    UIButton *btnImm = (UIButton*)[self.vCrpLnk viewWithTag:4];
    UIButton *btnDom = (UIButton*)[self.vCrpLnk viewWithTag:6];
    
    UIButton *lblNA1 = (UIButton*)[self.vCrpLnk viewWithTag:7];
    UIButton *lblNA2 = (UIButton*)[self.vCrpLnk viewWithTag:8];
    UIButton *lblNA3 = (UIButton*)[self.vCrpLnk viewWithTag:9];
    
    UILabel *lblAdd1 = (UILabel*)[self.vCrpLnk viewWithTag:10];
    UILabel *lblAdd2 = (UILabel*)[self.vCrpLnk viewWithTag:11];
    UILabel *lblAdd3 = (UILabel*)[self.vCrpLnk viewWithTag:12];
    
    //    if([arrLinkage isKindOfClass:[NSString class]]) {
    //        [lblUlti setTitle:@"Corporate Linkage" forState:UIControlStateNormal];
    //        [lblImm setTitle:@"" forState:UIControlStateNormal];
    //        [lblDom setTitle:@"" forState:UIControlStateNormal];
    //
    //        [btnDom setTitle:@"" forState:UIControlStateNormal];
    //        [btnImm setTitle:@"" forState:UIControlStateNormal];
    //        [btnUlti setTitle:@"" forState:UIControlStateNormal];
    //
    //        [lblAdd1 setText:@""];
    //        [lblAdd2 setText:@""];
    //        [lblAdd3 setText:@""];
    //
    //        lblNA1.hidden=NO;
    //        lblNA2.hidden=YES;
    //        lblNA3.hidden=YES;
    //        return;
    //    }
    
    NSString *element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Id"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    if([elementDic count]>0) {
        [lblUlti setTitle:@"Ultimate Parent" forState:UIControlStateNormal];
        [lblImm setTitle:@"Immediate Parent" forState:UIControlStateNormal];
        [lblDom setTitle:@"Domestic/Foreign" forState:UIControlStateNormal];
        //       if(arrLinkage.count==3) {
        
        lblNA1.hidden=YES;
        lblNA2.hidden=YES;
        lblNA3.hidden=YES;
        
        // set up value 1
        //if([[arrLinkage objectAtIndex:0] count]>0) {
        NSString *strid = [elementDic objectForKey:@"Legal_Ultimate_Parent_Id"];
        NSString *strName = [elementDic objectForKey:@"Legal_Ultimate_Parent_Name"];
        NSString *strAddress = [NSString stringWithFormat:@"- %@, %@",[elementDic objectForKey:@"Legal_Ultimate_Parent_City"],[elementDic objectForKey:@"Legal_Ultimate_Parent_State"]];
        if (![strAddress isEqualToString:@"- N/A, N/A"])
            [lblAdd1 setText:strAddress];
        if (![strName isEqualToString:@"N/A"])
            [btnUlti setTitle:strName forState:UIControlStateNormal];
        else {
            btnUlti.hidden = YES;
            lblNA1.hidden=NO;
        }
        if (![strid isEqualToString:@"N/A"])
            [btnUlti setTitle:strid forState:UIControlStateDisabled];
        else {
            btnUlti.hidden = YES;
            lblNA1.hidden=NO;
        }
        
        if([strid isEqualToString:element] ) {
            [btnUlti setTitleColor:[UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1] forState:UIControlStateNormal];
        } else {
            [btnUlti setTitleColor:[UIColor colorWithRed:27/255.0 green:152/255.0 blue:194/255.0 alpha:1] forState:UIControlStateNormal];
        }
        //            } else {
        //                [btnUlti setTitle:@"" forState:UIControlStateNormal];
        //                [lblAdd1 setText:@""];
        //                lblNA1.hidden=NO;
        //            }
        
        // set up value 2
        //if([[arrLinkage objectAtIndex:1] count]>0) {
        NSString *_strid = [elementDic objectForKey:@"Legal_Immediate_Parent_Id"];
        NSString *_strName = [elementDic objectForKey:@"Legal_Immediate_Parent_Name"];
        NSString *_strAddress = [NSString stringWithFormat:@"- %@, %@",[elementDic objectForKey:@"Legal_Immediate_Parent_City"],[elementDic objectForKey:@"Legal_Immediate_Parent_State"]];
        if (![_strAddress isEqualToString:@"- N/A, N/A"])
            [lblAdd2 setText:_strAddress];
        if (![_strName isEqualToString:@"N/A"])
            [btnImm setTitle:_strName forState:UIControlStateNormal];
        else {
            lblNA2.hidden=NO;
            btnImm.hidden = YES;
        }
        if (![_strid isEqualToString:@"N/A"])
            [btnImm setTitle:_strid forState:UIControlStateDisabled];
        else {
            btnImm.hidden = YES;
            lblNA2.hidden=NO;
        }
        
        if([_strid isEqualToString:element] ) {
            [btnImm setTitleColor:[UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1] forState:UIControlStateNormal];
        } else {
            [btnImm setTitleColor:[UIColor colorWithRed:27/255.0 green:152/255.0 blue:194/255.0 alpha:1] forState:UIControlStateNormal];
        }
        //            } else {
        //                [btnImm setTitle:@"" forState:UIControlStateNormal];
        //                [lblAdd2 setText:@""];
        //                lblNA2.hidden=NO;
        //            }
        
        // set up value 3
        //if([[arrLinkage objectAtIndex:2] count]>0) {
        NSString *__strName = [elementDic objectForKey:@"Domestic_Foreign_Description"];
        if (![__strName isEqualToString:@"N/A"])
            [btnDom setTitle:__strName forState:UIControlStateNormal];
        else {
            btnDom.hidden = YES;
            lblNA3.hidden=NO;
        }
        
        //            } else {
        //                [btnDom setTitle:@"" forState:UIControlStateNormal];
        //                lblNA3.hidden=NO;
        //            }
        //        } else if(arrLinkage.count==2) {
        //            // set up value 1
        //            if([[arrLinkage objectAtIndex:0] count]>0) {
        //                NSString *strid = [[arrLinkage objectAtIndex:0] objectAtIndex:0];
        //                NSString *strName = [NSString stringWithFormat:@"%@",[[arrLinkage objectAtIndex:0] objectAtIndex:1]];
        //                NSString *strAddress = [NSString stringWithFormat:@"%@, %@",[[arrLinkage objectAtIndex:0] objectAtIndex:2],[[arrLinkage objectAtIndex:0] objectAtIndex:3]];
        //                [lblAdd1 setText:strAddress];
        //                [btnUlti setTitle:strName forState:UIControlStateNormal];
        //                [btnUlti setTitle:strid forState:UIControlStateDisabled];
        //                lblNA1.hidden=YES;
        //                if([strid intValue]==[[self.dForDtl valueForKey:@"AtoZ ID"] intValue] ) {
        //                    [btnUlti setTitleColor:[UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1] forState:UIControlStateNormal];
        //                } else {
        //                    [btnUlti setTitleColor:[UIColor colorWithRed:27/255.0 green:152/255.0 blue:194/255.0 alpha:1] forState:UIControlStateNormal];
        //                }
        //            } else {
        //                [btnUlti setTitle:@"" forState:UIControlStateNormal];
        //                [lblAdd1 setText:@""];
        //                lblNA1.hidden=NO;
        //            }
        //
        //            // set up value 2
        //            if([[arrLinkage objectAtIndex:1] count]>0) {
        //                NSString *strid = [[arrLinkage objectAtIndex:1] objectAtIndex:0];
        //                NSString *strName = [NSString stringWithFormat:@"%@",[[arrLinkage objectAtIndex:1] objectAtIndex:1]];
        //                NSString *strAddress = [NSString stringWithFormat:@"%@, %@",[[arrLinkage objectAtIndex:1] objectAtIndex:2],[[arrLinkage objectAtIndex:1] objectAtIndex:3]];
        //                [lblAdd2 setText:strAddress];
        //                [btnImm setTitle:strName forState:UIControlStateNormal];
        //                [btnImm setTitle:strid forState:UIControlStateDisabled];
        //                lblNA2.hidden=YES;
        //                if([strid intValue]==[[self.dForDtl valueForKey:@"AtoZ ID"] intValue] ) {
        //                    [btnImm setTitleColor:[UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1] forState:UIControlStateNormal];
        //                } else {
        //                    [btnImm setTitleColor:[UIColor colorWithRed:27/255.0 green:152/255.0 blue:194/255.0 alpha:1] forState:UIControlStateNormal];
        //                }
        //            } else {
        //                [btnImm setTitle:@"" forState:UIControlStateNormal];
        //                [lblAdd2 setText:@""];
        //                lblNA2.hidden=NO;
        //            }
        //        } else if(arrLinkage.count==1) {
        //            // set up value 1
        //            if([[arrLinkage objectAtIndex:0] count]>0) {
        //                NSString *strid = [[arrLinkage objectAtIndex:0] objectAtIndex:0];
        //                NSString *strName = [NSString stringWithFormat:@"%@ - %@, %@",[[arrLinkage objectAtIndex:0] objectAtIndex:1],[[arrLinkage objectAtIndex:0] objectAtIndex:2],[[arrLinkage objectAtIndex:0] objectAtIndex:3]];
        //                [btnUlti setTitle:strName forState:UIControlStateNormal];
        //                [btnUlti setTitle:strid forState:UIControlStateDisabled];
        //                lblNA1.hidden=YES;
        //
        //                if([strid intValue]==[[self.dForDtl valueForKey:@"AtoZ ID"] intValue] ) {
        //                    [btnUlti setTitleColor:[UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1] forState:UIControlStateNormal];
        //                } else {
        //                    [btnUlti setTitleColor:[UIColor colorWithRed:27/255.0 green:152/255.0 blue:194/255.0 alpha:1] forState:UIControlStateNormal];
        //                }
        //
        //            } else {
        //                [btnUlti setTitle:@"" forState:UIControlStateNormal];
        //                lblNA1.hidden=NO;
        //            }
        
        //        } else {
        //            [lblUlti setTitle:@"Corporate Linkage" forState:UIControlStateNormal];
        //            [lblImm setTitle:@"" forState:UIControlStateNormal];
        //            [lblDom setTitle:@"" forState:UIControlStateNormal];
        //            [btnDom setTitle:@"" forState:UIControlStateNormal];
        //            [btnImm setTitle:@"" forState:UIControlStateNormal];
        //            [btnUlti setTitle:@"" forState:UIControlStateNormal];
        //            [lblAdd1 setText:@""];
        //            [lblAdd2 setText:@""];
        //            [lblAdd3 setText:@""];
        //            lblNA1.hidden=NO;
        //            lblNA2.hidden=YES;
        //            lblNA3.hidden=YES;
        //        }
    } else {
        [lblUlti setTitle:@"Corporate Linkage" forState:UIControlStateNormal];
        [lblImm setTitle:@"" forState:UIControlStateNormal];
        [lblDom setTitle:@"" forState:UIControlStateNormal];
        [btnDom setTitle:@"" forState:UIControlStateNormal];
        [btnImm setTitle:@"" forState:UIControlStateNormal];
        [btnUlti setTitle:@"" forState:UIControlStateNormal];
        [lblAdd1 setText:@""];
        [lblAdd2 setText:@""];
        [lblAdd3 setText:@""];
        lblNA1.hidden=NO;
        lblNA2.hidden=YES;
        lblNA3.hidden=YES;
    }
}

#pragma mark - industry 
- (void)setUpIndustry:(NSDictionary*)dToSet{
    NSURL *baseURL = [NSURL fileURLWithPath:[[[NSBundle mainBundle] pathForResource:@"overview" ofType:@"html"] stringByDeletingLastPathComponent]];
    NSString *str = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"indprf" ofType:@"html"] encoding:NSStringEncodingConversionAllowLossy error:nil];
    
    //Rajeev Start
    
	NSArray *searchResultRecord = [dToSet objectForKey:@"searchResultRecord"];
    
    if ([searchResultRecord count] == 0)
        return;
    NSDictionary *resultFields = [searchResultRecord objectAtIndex:0];
    
    if ([resultFields count] == 0)
        return;
    NSArray *resultFieldsChild = [resultFields objectForKey:@"resultFields"];
    
    NSMutableArray *CompArray = [[NSMutableArray alloc] init];
    NSInteger x = 0, y=1;
    for (int i=0; i<10; i++,y++) {
        @autoreleasepool {
            NSMutableArray *infoArray = [NSMutableArray arrayWithObjects:[NSNull null],[NSNull null],nil];
            int track = 0;
            for (NSDictionary *dic in resultFieldsChild) {
                if (track == 9)
                    break;
                @autoreleasepool {
                    if (i == 9) {
                        x = 1;
                        y = 0;
                    }
                    if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"SIC%d%d",x,y]]) {
                        NSString *str = [dic objectForKey:@"fieldValue"];
                        NSString *finalStr = nil;
                        if ([str length] > 5 && ![str isEqualToString:@"0"] && ![str isEqualToString:@"N/A"]) {
                            NSMutableString *mutStr = [str mutableCopy];
                            [mutStr insertString:@"-" atIndex:4];
                            finalStr = mutStr;
                        }
                        else {
                            finalStr = str;
                        }
                        
                        [infoArray replaceObjectAtIndex:0 withObject:finalStr];
                        ++track;
                    } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"SIC%d%d_Description",x,y]]) {
                        [infoArray replaceObjectAtIndex:1 withObject:[dic objectForKey:@"fieldValue"]];
                        ++track;
                    }
                }
            }
            [CompArray addObject:infoArray];
        }
    }
    
    NSMutableString *finalSICstr = [[NSMutableString alloc] init];
    for (NSArray *infoArray in CompArray) {
        if (![infoArray isMemberOfClass:[NSNull class]]) {
            if ([[infoArray objectAtIndex:0] isEqualToString:@"0"] && [[infoArray objectAtIndex:1] isEqualToString:@"N/A"]) {
                continue;
            }
            else {
                [finalSICstr appendFormat:@"%@ - %@<br />",[infoArray objectAtIndex:0],[infoArray objectAtIndex:1]];
            }
        }
    }
    
    NSString *strSicCode = (finalSICstr && ![finalSICstr isKindOfClass:[NSNull class]] ) ?finalSICstr : @"N/A";
    
    strSicCode = ([strSicCode isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",finalSICstr];
    
    
    [CompArray removeAllObjects];
    x = 0, y=1;
    for (int i=0; i<10; i++,y++) {
        @autoreleasepool {
            NSMutableArray *infoArray = [NSMutableArray arrayWithObjects:[NSNull null],[NSNull null],nil];
            int track = 0;
            for (NSDictionary *dic in resultFieldsChild) {
                if (track == 9)
                    break;
                @autoreleasepool {
                    if (i == 9) {
                        x = 1;
                        y = 0;
                    }
                    if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"NAICS%d%d",x,y]]) {
                        [infoArray replaceObjectAtIndex:0 withObject:[dic objectForKey:@"fieldValue"]];
                        ++track;
                    } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"NAICS%d%d_Description",x,y]]) {
                        [infoArray replaceObjectAtIndex:1 withObject:[dic objectForKey:@"fieldValue"]];
                        ++track;
                    }
                }
            }
            [CompArray addObject:infoArray];
        }
    }
    
    [finalSICstr setString:@""];
    for (NSArray *infoArray in CompArray) {
        if (![infoArray isMemberOfClass:[NSNull class]]) {
            if ([[infoArray objectAtIndex:0] isEqualToString:@"0"] && [[infoArray objectAtIndex:1] isEqualToString:@"N/A"]) {
                continue;
            }
            else {
                [finalSICstr appendFormat:@"%@ - %@<br />",[infoArray objectAtIndex:0],[infoArray objectAtIndex:1]];
            }
        }
    }
    
    NSString *strNAICS=( (finalSICstr && ![finalSICstr isKindOfClass:[NSNull class]] ) ?[NSString stringWithFormat:@"<strong>%@</strong>",finalSICstr] : @"N/A");
    
    strNAICS=([strNAICS isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",finalSICstr];
    
    NSString *element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Import_Export_Description"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
    NSString *I_E= ( (element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A");
    
    I_E=([I_E isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
    
    
    //Manufacturing
    
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Manufacturing_Description"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
    NSString *Manufacturing=( (element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A");
    
    Manufacturing=([Manufacturing isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
    
    
    //Small Business
    
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Small_Business_Description"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
    NSString *Small_Business=( (element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A");
    
    Small_Business=([Small_Business isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
    
    //Public Filing
    
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Public_Filing_Description"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
    NSString *Public_Filing=( (element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A");
    
    Public_Filing=([Public_Filing isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
    
    
    //Liens & Judgements
    
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"UCC_Description"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
    NSString *LiensJudgements=( (element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A");
    
    LiensJudgements=([LiensJudgements isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
    
    //Non-Profit
    
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Non_Profit_Description"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
    NSString *Non_Profit=( (element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A");
    
    Non_Profit=([Non_Profit isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
    
    NSString *strHTML = [NSString stringWithFormat:str,strSicCode,strNAICS,I_E,Manufacturing,Small_Business,Public_Filing,LiensJudgements,Non_Profit];
    
    [(UIWebView*)[self.vIndPrfl viewWithTag:1] loadHTMLString:strHTML baseURL:baseURL];
}

#pragma mark - otherImportantInfo   
-(void)setUpOtherImpInfo:(NSDictionary*)dToSet{
    NSURL *baseURL = [NSURL fileURLWithPath:[[[NSBundle mainBundle] pathForResource:@"overview" ofType:@"html"] stringByDeletingLastPathComponent]];
    NSString *str = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"othrimp" ofType:@"html"] encoding:NSStringEncodingConversionAllowLossy error:nil];
    
	
	//Rajeev Start
    
	NSArray *searchResultRecord = [dToSet objectForKey:@"searchResultRecord"];
    
    if ([searchResultRecord count] == 0)
        return;
    NSDictionary *resultFields = [searchResultRecord objectAtIndex:0];
    
    if ([resultFields count] == 0)
        return;
    NSArray *resultFieldsChild = [resultFields objectForKey:@"resultFields"];
    
	//Latitude / Longitude
    
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
	
    NSString *latlogFinalStr = [NSString stringWithFormat:@"%@ / %@", [elementDic objectForKey:@"Latitude"],[elementDic objectForKey:@"Longitude"]];
    
	NSString *latlng= ( (latlogFinalStr && ![latlogFinalStr isKindOfClass:[NSNull class]] ) ?latlogFinalStr : @"N/A");
	
	latlng=([latlng isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",latlogFinalStr];
	
	
	
	//Home Based Business
    
    NSString *element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"SOHO_Indicator"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
	NSString *Home_Based_Business= ( (element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A");
	
	Home_Based_Business=([Home_Based_Business isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
	
	//County Population
    
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"County_Population_Description"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
	NSString *County_Population=( (element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A");
	
	County_Population=([County_Population isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
	
	//Number of PCs
    
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Number_Of_PCs_Description"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
	NSString *Number_of_PCs=( (element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A");
	
	Number_of_PCs=([Number_of_PCs isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
	
	
	//Square Footage
	
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Square_Footage_Description"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
	NSString *Square_Footage=( (element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A");
	
	Square_Footage=([Square_Footage isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
	
	
	//IT Expenditures
    
    //	NSString *IT_Expenditures=( ([dToSet valueForKey:@"IT Expenditures"] && ![[dToSet valueForKey:@"IT Expenditures"] isKindOfClass:[NSNull class]] ) ?[dToSet valueForKey:@"IT Expenditures"] : @"N/A");
    //
    //	IT_Expenditures=([IT_Expenditures isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",[dToSet valueForKey:@"IT Expenditures"]];
	
    NSString *IT_Expenditures = @"N/A";
    
	//AtoZ ID
    
    element = nil;
    for (NSDictionary *dic in resultFieldsChild) {
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Id"]) {
                element = [dic objectForKey:@"fieldValue"];
                break;
            }
        }
    }
    
	NSString *AtoZ_ID=( (element && ![element isKindOfClass:[NSNull class]] ) ?element : @"N/A");
	
	AtoZ_ID=([AtoZ_ID isEqualToString:@"N/A"])?@"N/A":[NSString stringWithFormat:@"<strong>%@</strong>",element];
	
	
    NSString *strHTML = [NSString stringWithFormat:str,latlng,Home_Based_Business,County_Population,Number_of_PCs,Square_Footage,IT_Expenditures,AtoZ_ID];
    
    [(UIWebView*)[self.vOtherImpInfo viewWithTag:1] loadHTMLString:strHTML baseURL:baseURL];
}

#pragma mark - QRCode                   
-(void)setUpQRCode:(NSDictionary*)dToSet{
    NSURL *baseURL = [NSURL fileURLWithPath:[[[NSBundle mainBundle] pathForResource:@"overview" ofType:@"html"] stringByDeletingLastPathComponent]];
    
    //Rajeev Start
    
	NSArray *searchResultRecord = [dToSet objectForKey:@"searchResultRecord"];
    
    if ([searchResultRecord count] == 0)
        return;
    NSDictionary *resultFields = [searchResultRecord objectAtIndex:0];
    
    if ([resultFields count] == 0)
        return;
    NSArray *resultFieldsChild = [resultFields objectForKey:@"resultFields"];
    
	NSMutableDictionary *elementDic = [[NSMutableDictionary alloc] init];
    for (NSDictionary *dic in resultFieldsChild) {
        if ([elementDic count] == 10)
            break;
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Company_Name"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Company_Name"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"First_Name_01"]) {
                [elementDic setObject:[NSString stringWithFormat:@"%@ ",[dic objectForKey:@"fieldValue"]] forKey:@"First_Name_01"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Last_Name_01"]) {
                [elementDic setObject:[NSString stringWithFormat:@"%@ ",[dic objectForKey:@"fieldValue"]] forKey:@"Last_Name_01"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Phone"]) {
                [elementDic setObject:[NSString stringWithFormat:@" %@", [self phoneNumberFormatterWithNum:[dic objectForKey:@"fieldValue"]]] forKey:@"Phone"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Physical_Address"]) {
                [elementDic setObject:[NSString stringWithFormat:@"%@ ",[dic objectForKey:@"fieldValue"]] forKey:@"Physical_Address"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Physical_City"]) {
                [elementDic setObject:[NSString stringWithFormat:@"%@, ",[dic objectForKey:@"fieldValue"]] forKey:@"Physical_City"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"State_Of_Incorporation"]) {
                [elementDic setObject:[NSString stringWithFormat:@"%@ ", [dic objectForKey:@"fieldValue"]] forKey:@"State_Of_Incorporation"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Physical_Zip"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Physical_Zip"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Physical_Zip_Plus_4"]) {
                NSString *str = [dic objectForKey:@"fieldValue"];
                if ([str isEqualToString:@"0"])
                    str = @"0000";
                [elementDic setObject:[NSString stringWithFormat:@"-%@ ",str] forKey:@"Physical_Zip_Plus_4"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"URL"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"URL"];
            }
        }
    }
    
    NSString *url=[NSString stringWithFormat:@"http://chart.apis.google.com/chart?cht=qr&chs=200x200&chl=MECARD:ORG%@CN%@%@CTEL%@CADR%@%@%@%@%@CEMAIL%@",[elementDic objectForKey:@"Company_Name"],[elementDic objectForKey:@"First_Name_01"],[elementDic objectForKey:@"Last_Name_01"],[elementDic objectForKey:@"Phone"],[elementDic objectForKey:@"Physical_Address"],[elementDic objectForKey:@"Physical_City"],[elementDic objectForKey:@"State_Of_Incorporation"],[elementDic objectForKey:@"Physical_Zip"],[elementDic objectForKey:@"Physical_Zip_Plus_4"],[elementDic objectForKey:@"URL"]];
    
    NSString *str = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"qrcode" ofType:@"html"] encoding:NSStringEncodingConversionAllowLossy error:nil];
    
    NSString *strHTML = [NSString stringWithFormat:str,url];
    
    [(UIWebView*)[self.vQRCode viewWithTag:1] loadHTMLString:strHTML baseURL:baseURL];
}

#pragma mark - RevenueTrend 
-(void)setUpRevenueTrend:(NSDictionary*)dToSet{ 
    //Rajeev Start
    
	NSArray *searchResultRecord = [dToSet objectForKey:@"searchResultRecord"];
    
    if ([searchResultRecord count] == 0)
        return;
    NSDictionary *resultFields = [searchResultRecord objectAtIndex:0];
    
    if ([resultFields count] == 0)
        return;
    NSArray *resultFieldsChild = [resultFields objectForKey:@"resultFields"];
    
    NSMutableDictionary *elementDic = [[NSMutableDictionary alloc] init];
    for (NSDictionary *dic in resultFieldsChild) {
        if ([elementDic count] == 2)
            break;
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Five_Year_Sales_Growth"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Five_Year_Sales_Growth"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Three_Year_Sales_Growth"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Three_Year_Sales_Growth"];
            }
        }
    }
    
    NSString* output = nil;
    if ([[elementDic objectForKey:@"Five_Year_Sales_Growth"] isEqualToString:@"0"]) {
        output = @"N/A";
    }
    else {
        output = [NSString stringWithFormat:@"%@%%",[elementDic objectForKey:@"Five_Year_Sales_Growth"]];
    }
    //    if([[dToSet valueForKey:@"5 Year % Sales Growth"] hasPrefix:@"+0"]) {
    //		output = [[dToSet valueForKey:@"5 Year % Sales Growth"] substringFromIndex:2];
    //		output =[output stringByAppendingFormat:@"%%",output];
    //	}
    //    else if([[dToSet valueForKey:@"5 Year % Sales Growth"] hasPrefix:@"+"]) {
    //		output = [[dToSet valueForKey:@"5 Year % Sales Growth"] substringFromIndex:1];
    //		output =[output stringByAppendingFormat:@"%%",output];
    //	}
    //	else if([[dToSet valueForKey:@"5 Year % Sales Growth"] intValue]==0) {
    //		output = @"N/A";
    //	}
    
    NSString* output1 = nil;
    if ([[elementDic objectForKey:@"Three_Year_Sales_Growth"] isEqualToString:@"0"]) {
        output1 = @"N/A";
    }
    else {
        output1 = [NSString stringWithFormat:@"%@%%", [elementDic objectForKey:@"Three_Year_Sales_Growth"]];
    }
    //    if([[dToSet valueForKey:@"3 Year % Sales Growth"] hasPrefix:@"+0"]) {
    //		output1 = [[dToSet valueForKey:@"3 Year % Sales Growth"] substringFromIndex:2];
    //		output1 =[output1 stringByAppendingFormat:@"%%",output1];
    //	}
    //    else if([[dToSet valueForKey:@"3 Year % Sales Growth"] hasPrefix:@"+"]) {
    //		output1 = [[dToSet valueForKey:@"3 Year % Sales Growth"] substringFromIndex:1];
    //		output1 =[output1 stringByAppendingFormat:@"%%",output1];
    //	}
    //    else if([[dToSet valueForKey:@"3 Year % Sales Growth"] intValue]==0) {
    //		output1 = @"N/A";
    //	}
    
    [elementDic removeAllObjects];
    for (NSDictionary *dic in resultFieldsChild) {
        if ([elementDic count] == 3)
            break;
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Five_Year_Sales_Volume"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Five_Year_Sales_Volume"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Three_Year_Sales_Volume"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Three_Year_Sales_Volume"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Base_Year_Sales_Volume"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Base_Year_Sales_Volume"];
            }
        }
    }
    
    //    NSArray *array = [[dToSet valueForKey:@"Sales Growth"] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    NSArray *Year = [[dToSet valueForKey:@"Years"] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *url=nil;
    if([elementDic count]==3 && ([[elementDic objectForKey:@"Five_Year_Sales_Volume"] isEqualToString:@"N/A"] || [[elementDic objectForKey:@"Five_Year_Sales_Volume"] isEqualToString:@"0"]) && ([[elementDic objectForKey:@"Three_Year_Sales_Volume"] isEqualToString:@"N/A"] || [[elementDic objectForKey:@"Three_Year_Sales_Volume"] isEqualToString:@"0"]) && ([[elementDic objectForKey:@"Base_Year_Sales_Volume"] isEqualToString:@"N/A"] || [[elementDic objectForKey:@"Base_Year_Sales_Volume"] isEqualToString:@"0"]) ) {
         
         NSString *str =[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"histoData" ofType:@"html"]
                                           encoding:NSUTF8StringEncoding 
                                           error:nil];
         str = [NSString stringWithFormat:str,@"No Historical data for sales growth."];
         [(UIWebView*)[self.vRevenueTrend viewWithTag:1] loadHTMLString:str baseURL:nil];
        } else {
             
             //2N*sz2*,0000FF
             url=[NSString stringWithFormat:@"http://chart.apis.google.com/chart?cht=bvg&chs=320x250&chd=t:%@,%@,%@&chxs=1N*cUSD&2N*sz2&chxr=a&chds=a&chco=50b1c7,EBB671,DE091A&chbh=25,10,25&chxt=x,y,x,x&chxl=0:|%@|%@|%@|2:||5+Year+%%+Sales+Growth+%@||3:||3+Year %%+Sales+Growth+%@||&chdlp=bv&chdl=Revenue&chtt=Revenue+Trend&chts=000000,12,c",[elementDic objectForKey:@"Five_Year_Sales_Volume"],[elementDic objectForKey:@"Three_Year_Sales_Volume"],[elementDic objectForKey:@"Base_Year_Sales_Volume"],[[self.yearsDic objectForKey:@"lbl_sales_years"] objectAtIndex:0],[[self.yearsDic objectForKey:@"lbl_sales_years"] objectAtIndex:1],[[self.yearsDic objectForKey:@"lbl_sales_years"] objectAtIndex:2],output,output1];
            //NSLog(@"url==%@",url);
            url=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //NSLog(@"url==%@",url);
            
            //Rajeev End
             
             [(UIWebView*)[self.vRevenueTrend viewWithTag:1] loadHTMLString:[NSString stringWithFormat:@"<div align='center'><img src='%@' /></div>",url] baseURL:nil];
            }
}

#pragma mark - EmployeeTrend 
-(void)setUpEmployeeTrend:(NSDictionary*)dToSet{
    //Rajeev Start
    
	NSArray *searchResultRecord = [dToSet objectForKey:@"searchResultRecord"];
    
    if ([searchResultRecord count] == 0)
        return;
    NSDictionary *resultFields = [searchResultRecord objectAtIndex:0];
    
    if ([resultFields count] == 0)
        return;
    NSArray *resultFieldsChild = [resultFields objectForKey:@"resultFields"];
    
    NSMutableDictionary *elementDic = [[NSMutableDictionary alloc] init];
    for (NSDictionary *dic in resultFieldsChild) {
        if ([elementDic count] == 2)
            break;
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Five_Year_Employee_Growth"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Five_Year_Employee_Growth"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Three_Year_Employee_Growth"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Three_Year_Employee_Growth"];
            }
        }
    }
    
    NSString* output = nil;
    if ([[elementDic objectForKey:@"Five_Year_Employee_Growth"] isEqualToString:@"0"]) {
        output = @"N/A";
    }
    else {
        output = [NSString stringWithFormat:@"%@%%",[elementDic objectForKey:@"Five_Year_Employee_Growth"]];
    }
    //    NSString*output = nil;
    //    if([[dToSet valueForKey:@"5 Year % Employee Growth"] hasPrefix:@"+0"]) {
    //		output = [[dToSet valueForKey:@"5 Year % Employee Growth"] substringFromIndex:2];
    //		output =[output stringByAppendingFormat:@"%%",output];
    //	}
    //    else if([[dToSet valueForKey:@"5 Year % Employee Growth"] hasPrefix:@"+"]) {
    //		output = [[dToSet valueForKey:@"5 Year % Employee Growth"] substringFromIndex:1];
    //		output =[output stringByAppendingFormat:@"%%",output];
    //	}
    //    else if([[dToSet valueForKey:@"5 Year % Employee Growth"] intValue]==0) {
    //		output = @"N/A";
    //	}
    
    NSString* output1 = nil;
    if ([[elementDic objectForKey:@"Three_Year_Employee_Growth"] isEqualToString:@"0"]) {
        output1 = @"N/A";
    }
    else {
        output1 = [NSString stringWithFormat:@"%@%%", [elementDic objectForKey:@"Three_Year_Employee_Growth"]];
    }
    //    NSString*output1 = nil;
    //    if([[dToSet valueForKey:@"3 Year % Employee Growth"] hasPrefix:@"+0"]) {
    //		output1 = [[dToSet valueForKey:@"3 Year % Employee Growth"] substringFromIndex:2];
    //		output1 =[output1 stringByAppendingFormat:@"%%",output1];
    //	}
    //    else if([[dToSet valueForKey:@"3 Year % Employee Growth"] hasPrefix:@"+"]) {
    //		output1 = [[dToSet valueForKey:@"3 Year % Employee Growth"] substringFromIndex:1];
    //		output1 =[output1 stringByAppendingFormat:@"%%",output1];
    //	}
    //    else if([[dToSet valueForKey:@"3 Year % Employee Growth"] intValue]==0) {
    //		output1 = @"N/A";
    //	}
    
    [elementDic removeAllObjects];
    for (NSDictionary *dic in resultFieldsChild) {
        if ([elementDic count] == 3)
            break;
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Five_Year_Employee_Size"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Five_Year_Employee_Size"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Three_Year_Employee_Size"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Three_Year_Employee_Size"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Base_Year_Employee_Size"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Base_Year_Employee_Size"];
            }
        }
    }
    
    //    NSArray *array = [[dToSet valueForKey:@"Employees Growth"] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    NSArray *Year = [[dToSet valueForKey:@"Years"] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    NSString *url=nil;
    //    if([array count]==3 && [[array objectAtIndex:0] isEqualToString:@"N/A"] && [[array objectAtIndex:1] isEqualToString:@"N/A"] && [[array objectAtIndex:2] isEqualToString:@"N/A"] ) {
    //
    //		NSString *str =[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"histoData" ofType:@"html"]
    //												 encoding:NSUTF8StringEncoding
    //													error:nil];
    //		str = [NSString stringWithFormat:str,@"No Historical data for Employee Trend."];
    //		[(UIWebView*)[self.vRevenueTrend viewWithTag:88] loadHTMLString:str baseURL:nil];
    //
    //	} else {
    //
    //		//chd=s:Paz9
    //		url=[NSString stringWithFormat:@"http://chart.apis.google.com/chart?cht=bvg&chs=320x250&chd=t:%@,%@,%@&chxr=a&chds=a&chco=e9a502,EBB671,DE091A&chbh=25,10,25&chxt=x,y,x,x&chxl=0:|%@|%@|%@|2:||5+Year+%%+Employee+Growth+%@||3:||3+Year+%%+Employee+Growth+%@||&chdlp=bv&chdl=Employees&chtt=Employee+Trend&chts=000000,12,c",[array objectAtIndex:0],[array objectAtIndex:1],[array objectAtIndex:2],[Year objectAtIndex:0],[Year objectAtIndex:1],[Year objectAtIndex:2],output,output1];
    //
    //		//  url=[NSString stringWithFormat:@"http://chart.apis.google.com/chart?cht=bvg&chs=320x300&chd=t:%@,%@,%@&chxr=a&chds=a&chco=e9a502,EBB671,DE091A&chbh=25,10,25&chxt=x,y,x,x&chxl=0:|%@|%@|%@|2:||5+Year+%%+Employee+Growth+%@||3:||3+Year+%%+Employee+Growth+%@||&chdl=Employees&chtt=Employee+Trend&chts=000000,12,c",[array objectAtIndex:0],[array objectAtIndex:1],[array objectAtIndex:2],[Year objectAtIndex:0],[Year objectAtIndex:1],[Year objectAtIndex:2],output,output1];
    //		url=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //    NSArray *array = [[dToSet valueForKey:@"Sales Growth"] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    NSArray *Year = [[dToSet valueForKey:@"Years"] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *url=nil;
    if([elementDic count]==3 && ([[elementDic objectForKey:@"Five_Year_Employee_Size"] isEqualToString:@"N/A"] || [[elementDic objectForKey:@"Five_Year_Employee_Size"] isEqualToString:@"0"]) && ([[elementDic objectForKey:@"Three_Year_Employee_Size"] isEqualToString:@"N/A"] || [[elementDic objectForKey:@"Three_Year_Employee_Size"] isEqualToString:@"0"]) && ([[elementDic objectForKey:@"Base_Year_Employee_Size"] isEqualToString:@"N/A"] || [[elementDic objectForKey:@"Base_Year_Employee_Size"] isEqualToString:@"0"]) ) {
         
         NSString *str =[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"histoData" ofType:@"html"]
                                           encoding:NSUTF8StringEncoding 
                                           error:nil];
         str = [NSString stringWithFormat:str,@"No Historical data for Employee Trend."];
         [(UIWebView*)[self.vRevenueTrend viewWithTag:88] loadHTMLString:str baseURL:nil];
         
        } else {
             
             //chd=s:Paz9
              url=[NSString stringWithFormat:@"http://chart.apis.google.com/chart?cht=bvg&chs=320x250&chd=t:%@,%@,%@&chxr=a&chds=a&chco=e9a502,EBB671,DE091A&chbh=25,10,25&chxt=x,y,x,x&chxl=0:|%@|%@|%@|2:||5+Year+%%+Employee+Growth+%@||3:||3+Year+%%+Employee+Growth+%@||&chdlp=bv&chdl=Employees&chtt=Employee+Trend&chts=000000,12,c",[elementDic objectForKey:@"Five_Year_Employee_Size"],[elementDic objectForKey:@"Three_Year_Employee_Size"],[elementDic objectForKey:@"Base_Year_Employee_Size"],[[self.yearsDic objectForKey:@"lbl_employee_year"] objectAtIndex:0],[[self.yearsDic objectForKey:@"lbl_employee_year"] objectAtIndex:1],[[self.yearsDic objectForKey:@"lbl_employee_year"] objectAtIndex:2],output,output1];
             
            //  url=[NSString stringWithFormat:@"http://chart.apis.google.com/chart?cht=bvg&chs=320x300&chd=t:%@,%@,%@&chxr=a&chds=a&chco=e9a502,EBB671,DE091A&chbh=25,10,25&chxt=x,y,x,x&chxl=0:|%@|%@|%@|2:||5+Year+%%+Employee+Growth+%@||3:||3+Year+%%+Employee+Growth+%@||&chdl=Employees&chtt=Employee+Trend&chts=000000,12,c",[array objectAtIndex:0],[array objectAtIndex:1],[array objectAtIndex:2],[Year objectAtIndex:0],[Year objectAtIndex:1],[Year objectAtIndex:2],output,output1];
            //Rajeev End
            url=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
             [(UIWebView*)[self.vRevenueTrend viewWithTag:88] loadHTMLString:[NSString stringWithFormat:@"<div align='center'><img src='%@' /></div>",url] baseURL:nil];
            }
}

#pragma mark - parsingFromStringToArray

- (NSArray*)parseDataFromString:(NSString*)string andIndex:(NSUInteger)index {
    NSArray *ar = [string componentsSeparatedByString:@"\t000000000\t000000000\t000000000"];
	NSMutableArray *arTmp=[NSMutableArray array];
	for (NSString *strSlashT in ar) {
		NSArray *arSlash = [strSlashT componentsSeparatedByString:@"\t"];
		if([arSlash count]>=10) {
			NSString *strSpace = [arSlash objectAtIndex:0];
			BOOL isFirstSpace = ([strSpace stringByReplacingOccurrencesOfString:@" " withString:@""].length==0);
			NSMutableDictionary *dForComp = [NSMutableDictionary dictionary];
			[dForComp setValue:[arSlash objectAtIndex:(isFirstSpace)?1:0] forKey:@"id"];
			[dForComp setValue:[arSlash objectAtIndex:(isFirstSpace)?2:1] forKey:@"name"];
			[dForComp setValue:[NSString stringWithFormat:@"%@, %@, %@ %@",[arSlash objectAtIndex:(isFirstSpace)?4:3],[arSlash objectAtIndex:(isFirstSpace)?5:4],[arSlash objectAtIndex:(isFirstSpace)?6:5],[arSlash objectAtIndex:(isFirstSpace)?7:6]] forKey:@"address"];
			[dForComp setValue:[arSlash objectAtIndex:(isFirstSpace)?8:7] forKey:@"phone"];
            
            if(index==2) {
                [dForComp setValue:[arSlash objectAtIndex:(isFirstSpace)?10:9] forKey:@"PhoneLine Of Business"];
            }
            
			[arTmp addObject:dForComp];
		}
	}
    return [NSArray arrayWithArray:arTmp];
}

#pragma mark - IBActions

- (IBAction)btnHelpTapped:(id)sender {
    if(!self.nxtdNewAboutVCtr) {
        self.nxtdNewAboutVCtr = [[dNewAboutVCtr alloc] init];
    }
    [self presentModalViewController:self.nxtdNewAboutVCtr animated:YES];
}

- (IBAction)btnInfoTapped:(id)sender {
    UIButton *btn=(UIButton*)sender;
    UIToolbar *tBar = (UIToolbar*)[[btn superview] viewWithTag:777];
    [self.popVCtr presentPopoverFromBarButtonItem:[[tBar items] objectAtIndex:0] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)justReloadData:(id)sender {
    UIButton *btn=(UIButton*)sender;
    btn.selected=!btn.selected;
    [self.tbl1 reloadData];
    [self.tbl2 reloadData];
}

- (IBAction)btnExpandAll:(id)sender {
    [(UIButton*)[self.vCompetitors viewWithTag:77777] setSelected:NO];
    [(UIButton*)[self.vCrpLnk viewWithTag:77777] setSelected:NO];
    [(UIButton*)[self.vDemoGPrf viewWithTag:77777] setSelected:NO];
    [(UIButton*)[self.vExDir viewWithTag:77777] setSelected:NO];
    [(UIButton*)[self.vIndPrfl viewWithTag:77777] setSelected:NO];
    [(UIButton*)[self.vNearBy viewWithTag:77777] setSelected:NO];
    [(UIButton*)[self.vOtherImpInfo viewWithTag:77777] setSelected:NO];
    [(UIButton*)[self.vOverView viewWithTag:77777] setSelected:NO];
    [(UIButton*)[self.vOwnerShip viewWithTag:77777] setSelected:NO];
    [(UIButton*)[self.vQRCode viewWithTag:77777] setSelected:NO];
    [(UIButton*)[self.vRevenueTrend viewWithTag:77777] setSelected:NO];
    [self.tbl1 reloadData];
    [self.tbl2 reloadData];
}

- (IBAction)btnCollapseAll:(id)sender {
    [(UIButton*)[self.vCompetitors viewWithTag:77777] setSelected:YES];
    [(UIButton*)[self.vCrpLnk viewWithTag:77777] setSelected:YES];
    [(UIButton*)[self.vDemoGPrf viewWithTag:77777] setSelected:YES];
    [(UIButton*)[self.vExDir viewWithTag:77777] setSelected:YES];
    [(UIButton*)[self.vIndPrfl viewWithTag:77777] setSelected:YES];
    [(UIButton*)[self.vNearBy viewWithTag:77777] setSelected:YES];
    [(UIButton*)[self.vOtherImpInfo viewWithTag:77777] setSelected:YES];
    [(UIButton*)[self.vOverView viewWithTag:77777] setSelected:YES];
    [(UIButton*)[self.vOwnerShip viewWithTag:77777] setSelected:YES];
    [(UIButton*)[self.vQRCode viewWithTag:77777] setSelected:YES];
    [(UIButton*)[self.vRevenueTrend viewWithTag:77777] setSelected:YES];
    [self.tbl1 reloadData];
    [self.tbl2 reloadData];
}

- (IBAction)backTapped:(id)sender {
    [iNetMngr setView:self.predRcrdVCtr.navigationController.view];
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)btnPrintTapped:(id)sender {
    if(!self.nxtdPrintVCtr) {
        self.nxtdPrintVCtr = [[dPrintVCtr alloc] initWithNibName:@"dPrintVCtr" bundle:nil];
    }
    [self presentModalViewController:self.nxtdPrintVCtr animated:YES];
    [self.nxtdPrintVCtr.webViewPrint loadHTMLString:[self generateHTMLStringForReport] baseURL:nil];
    //    [data writeToFile:@"foo.png" atomically:YES];
}

- (void)addContactToAddressBook
{
    NSDictionary *dToSet = self.addToContactInfoDic;
    NSString *strBName = ( ([dToSet valueForKey:@"Company_Name"] && ![[dToSet valueForKey:@"Company_Name"] isKindOfClass:[NSNull class]] && ![[dToSet valueForKey:@"Company_Name"] isEqualToString:@"N/A"]) ?[dToSet valueForKey:@"Company_Name"] : @"");
    
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
    CFTypeRef ctr = CFBridgingRetain(strBName);
    ABRecordSetValue(newPerson, kABPersonFirstNameProperty,ctr,&error);
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

- (IBAction)btnAddToContacts:(id)sender  {
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

-(void)printItem :(NSData*)data {
    UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
    if(printController && [UIPrintInteractionController canPrintData:data]) {
        printController.delegate = self;
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = [NSString stringWithFormat:@"AtoZdatabases - %@",[[self.dForDtl valueForKey:@"firstname"] stringByAppendingFormat:@" %@",[self.dForDtl valueForKey:@"lastname"]]/*[self.dForDtl valueForKey:@"fullname"]*/];
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        printController.printInfo = printInfo;
        printController.showsPageRange = YES;
        printController.printingItem = data;
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
            if (!completed && error) {
                //NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
            }
        };
        [printController presentAnimated:YES completionHandler:completionHandler];
    }
}

- (void)viewDidUnload
{
    [self setTbl1:nil];
    [self setTbl2:nil];
    [self setVOverView:nil];
    [self setVOwnerShip:nil];
    [self setVDemoGPrf:nil];
    [self setVIndPrfl:nil];
    [self setVCrpLnk:nil];
    [self setVOtherImpInfo:nil];
    [self setTblMainItems:nil];
    [self setVQRCode:nil];
    [self setVRevenueTrend:nil];
    [self setVCompetitors:nil];
    [self setVExDir:nil];
    [self setVNearBy:nil];
    [self setTableCompetitors:nil];
    [self setTableExDir:nil];
    [self setTableNearBy:nil];
    [self setNxtdDtlHelpPopOverVCtr:nil];
    [self setPopVCtr:nil];
    [self setLblTitle:nil];
	[self setToolbar:nil];
	[self setNearby:nil];
	[self setTemp:nil];
    [self setLblBoldFont:nil];
    [self setLblNormalFont:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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
//	return YES;
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (tableView==self.tbl1)?6:5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView==self.tbl1) {
        if(indexPath.row==0){
            BOOL isExpanded = ![(UIButton*)[self.vOverView viewWithTag:77777] isSelected];
            return isExpanded?295:35;
        } else if(indexPath.row==1) {
            BOOL isExpanded = ![(UIButton*)[self.vIndPrfl viewWithTag:77777] isSelected];
            return isExpanded?245:35;
        } else if (indexPath.row==2) {
            BOOL isExpanded = ![(UIButton*)[self.vOtherImpInfo viewWithTag:77777] isSelected];
            return isExpanded?223:35;
        } else if (indexPath.row==3) {
            BOOL isExpanded = ![(UIButton*)[self.vQRCode viewWithTag:77777] isSelected];
            return isExpanded?278:35;
        } else if (indexPath.row==4) {
            BOOL isExpanded = ![(UIButton*)[self.vCompetitors viewWithTag:77777] isSelected];
            return isExpanded?258:35;
        } else if (indexPath.row==5) {
            BOOL isExpanded = ![(UIButton*)[self.vExDir viewWithTag:77777] isSelected];
            return isExpanded?258:35;
        } else return 0;
    } else {
        if(indexPath.row==0) {
            BOOL isExpanded = ![(UIButton*)[self.vDemoGPrf viewWithTag:77777] isSelected];
            return isExpanded?270:35;
        } else if(indexPath.row==1) {
            BOOL isExpanded = ![(UIButton*)[self.vOwnerShip viewWithTag:77777] isSelected];
            return isExpanded?223:35;
        } else if(indexPath.row==2){
            BOOL isExpanded = ![(UIButton*)[self.vCrpLnk viewWithTag:77777] isSelected];
            return isExpanded?145:35;
        } else if(indexPath.row==3){
            BOOL isExpanded = ![(UIButton*)[self.vRevenueTrend viewWithTag:77777] isSelected];
            return isExpanded?665:35;
        } else if (indexPath.row==4) {
            BOOL isExpanded = ![(UIButton*)[self.vNearBy viewWithTag:77777] isSelected];
            return isExpanded?258:35;
        } else return 0;
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
    
    if(tableView==self.tbl1) {
        if(indexPath.row==0) {
            BOOL isExpanded = ![(UIButton*)[self.vOverView viewWithTag:77777] isSelected];
            self.vOverView.tag=kInnerTag;
            self.vOverView.frame=(isExpanded)?CGRectMake(0, 0, 376, 290):CGRectMake(0, 0, 376, 30);
            [cell addSubview:self.vOverView];
        } else if(indexPath.row==1){
            BOOL isExpanded = ![(UIButton*)[self.vIndPrfl viewWithTag:77777] isSelected];
            self.vIndPrfl.tag=kInnerTag;
            self.vIndPrfl.frame=(isExpanded)?CGRectMake(0, 0, 376, 240):CGRectMake(0, 0, 376, 30);
            [cell addSubview:self.vIndPrfl];
        } else if (indexPath.row==2) {
            BOOL isExpanded = ![(UIButton*)[self.vOtherImpInfo viewWithTag:77777] isSelected];
            self.vOtherImpInfo.tag=kInnerTag;
            self.vOtherImpInfo.frame=(isExpanded)?CGRectMake(0, 0, 376, 218):CGRectMake(0, 0, 376, 30);
            [cell addSubview:self.vOtherImpInfo];
        } else if (indexPath.row==3) {
            BOOL isExpanded = ![(UIButton*)[self.vQRCode viewWithTag:77777] isSelected];
            self.vQRCode.tag=kInnerTag;
            self.vQRCode.frame=(isExpanded)?CGRectMake(0, 0, 376, 273):CGRectMake(0, 0, 376, 30);
            [cell addSubview:self.vQRCode];
        }  else if (indexPath.row==4) {
            BOOL isExpanded = ![(UIButton*)[self.vCompetitors viewWithTag:77777] isSelected];
            self.vCompetitors.tag=kInnerTag;
            self.vCompetitors.frame=(isExpanded)?CGRectMake(0, 0, 376, 253):CGRectMake(0, 0, 376, 30);
            [cell addSubview:self.vCompetitors];
        } else if (indexPath.row==5) {
            BOOL isExpanded = ![(UIButton*)[self.vExDir viewWithTag:77777] isSelected];
            self.vExDir.tag=kInnerTag;
            self.vExDir.frame=(isExpanded)?CGRectMake(0, 0, 376, 253):CGRectMake(0, 0, 376, 30);
            [cell addSubview:self.vExDir];
        }
    } else {
        if(indexPath.row==0) {
            BOOL isExpanded = ![(UIButton*)[self.vDemoGPrf viewWithTag:77777] isSelected];
            self.vDemoGPrf.tag=kInnerTag;
            self.vDemoGPrf.frame=(isExpanded)?CGRectMake(0, 0, 376, 265):CGRectMake(0, 0, 376, 30);
            [cell addSubview:self.vDemoGPrf];
        } else if(indexPath.row==1) {
            BOOL isExpanded = ![(UIButton*)[self.vOwnerShip viewWithTag:77777] isSelected];
            self.vOwnerShip.tag=kInnerTag;
            self.vOwnerShip.frame=(isExpanded)?CGRectMake(0, 0, 376, 218):CGRectMake(0, 0, 376, 30);
            [cell addSubview:self.vOwnerShip];
        } else if(indexPath.row==2){
            BOOL isExpanded = ![(UIButton*)[self.vCrpLnk viewWithTag:77777] isSelected];
            self.vCrpLnk.tag=kInnerTag;
            self.vCrpLnk.frame=(isExpanded)?CGRectMake(0, 0, 376, 140):CGRectMake(0, 0, 376, 30);
            [cell addSubview:self.vCrpLnk];
        } else if(indexPath.row==3){ 
            BOOL isExpanded = ![(UIButton*)[self.vRevenueTrend viewWithTag:77777] isSelected];
            self.vRevenueTrend.tag=kInnerTag;
            self.vRevenueTrend.frame=(isExpanded)?CGRectMake(0, 0, 376, 660):CGRectMake(0, 0, 376, 30);
            [cell addSubview:self.vRevenueTrend];
        } else if (indexPath.row==4) {
            BOOL isExpanded = ![(UIButton*)[self.vNearBy viewWithTag:77777] isSelected];
            self.vNearBy.tag=kInnerTag;
            self.vNearBy.frame=(isExpanded)?CGRectMake(0, 0, 376, 253):CGRectMake(0, 0, 376, 30);
            [cell addSubview:self.vNearBy];
        }
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - web view methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if(navigationType==UIWebViewNavigationTypeLinkClicked || navigationType==UIWebViewNavigationTypeFormSubmitted || navigationType==UIWebViewNavigationTypeFormResubmitted) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    } else return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if(webView==( (UIWebView*)[self.vOverView viewWithTag:1] ) ) {
        //NSLog(@"html is %@",[webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"]);
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

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

- (IBAction)btnUltiTapped:(id)sender {
    UIButton *btn = (UIButton*)sender;
    NSString *strTitle = [btn titleForState:UIControlStateDisabled];
    NSInteger atozID = [strTitle intValue];
    NSUInteger currentID = [[self.dForResult valueForKey:@"id"] intValue];
    if(atozID!=currentID) {
        [self loadByID:strTitle];
    } 
}

- (IBAction)btnImmediateTapped:(id)sender {
    UIButton *btn = (UIButton*)sender;
    NSString *strTitle = [btn titleForState:UIControlStateDisabled];
    NSInteger atozID = [strTitle intValue];
    NSUInteger currentID = [[self.dForResult valueForKey:@"id"] intValue];
    if(atozID!=currentID) {
        [self loadByID:strTitle];
    } 
}


-(void)displayComposerSheet 
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;

	NSString *strBName = ( ([self.addToContactInfoDic valueForKey:@"Company_Name"] && ![[self.addToContactInfoDic valueForKey:@"Company_Name"] isKindOfClass:[NSNull class]] && ![[self.addToContactInfoDic valueForKey:@"Company_Name"] isEqualToString:@"N/A"]) ?[self.addToContactInfoDic valueForKey:@"Company_Name"] : @"");
    
//    NSString *strBName = ([self.dForDtl valueForKey:@"Business Name"] && ![[self.dForDtl valueForKey:@"Business Name"] isKindOfClass:[NSNull class]] ) ?[self.dForDtl valueForKey:@"Business Name"] : @"N/A";
    
	[picker setSubject:[NSString stringWithFormat:@"%@ Details (AtoZdatabases Mobile App)",strBName]];
	
	
	// Set up recipients
	NSArray *toRecipients = nil;
	
	[picker setToRecipients:toRecipients];
	    
	NSString *emailBody = [self generateHTMLStringForReport];
	[picker setMessageBody:emailBody isHTML:YES];
	
	[self presentModalViewController:picker animated:YES];
}

- (NSString*)generateHTMLStringForReport {
    NSString *strCompleteOuter = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"complete" ofType:@"html"]
                                                           encoding:NSUTF8StringEncoding
                                                              error:nil];
    NSString *strOverView = [(UIWebView*)[self.vOverView viewWithTag:1] stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    
    NSString *strDemoGrf = [(UIWebView*)[self.vDemoGPrf viewWithTag:1] stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    
    NSString *strIndPrf = [(UIWebView*)[self.vIndPrfl viewWithTag:1] stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    
    NSString *strOthrImp = [(UIWebView*)[self.vOtherImpInfo viewWithTag:1] stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    
    NSString *strOwner = [(UIWebView*)[self.vOwnerShip viewWithTag:1] stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];

    
    NSString *strQRCode = [(UIWebView*)[self.vQRCode viewWithTag:1] stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    
    NSString *strRevTrnd = [(UIWebView*)[self.vRevenueTrend viewWithTag:1] stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    
    NSString *strEmpTrnd = [(UIWebView*)[self.vRevenueTrend viewWithTag:88] stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    
    
    strCompleteOuter = [NSString stringWithFormat:strCompleteOuter,
                        strOverView,strDemoGrf,
                        strIndPrf,strOwner,
                        strOthrImp,[self generateHTML_For_CrpLnk],
                        strQRCode,[strRevTrnd stringByAppendingFormat:@"<br><br>%@",strEmpTrnd],
                        self.tableCompetitors.strInnerHTML,self.tableNearBy.strInnerHTML,
                        self.tableExDir.strInnerHTML
                        ];
    
    return strCompleteOuter;
}

- (NSString*)generateHTML_For_CrpLnk {
    NSString *strCrpLnkFile = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"crplnk" ofType:@"html"]
                                                           encoding:NSUTF8StringEncoding
                                                              error:nil];
    
    
    
    //Rajeev Start
    
    NSMutableString *strHTML = [NSMutableString string];
    
    NSDictionary *dToSet = self.dForDtl;
    
	NSArray *searchResultRecord = [dToSet objectForKey:@"searchResultRecord"];
    
    if ([searchResultRecord count] == 0) {
        [strHTML appendString:@"<tr><td>Corporate Linkage</td><td>N/A</td></tr>"];
        return @"";
    }
    NSDictionary *resultFields = [searchResultRecord objectAtIndex:0];
    
    if ([resultFields count] == 0) {
        [strHTML appendString:@"<tr><td>Corporate Linkage</td><td>N/A</td></tr>"];
        return @"";
    }
    
    NSArray *resultFieldsChild = [resultFields objectForKey:@"resultFields"];
    
    NSMutableDictionary *elementDic = [[NSMutableDictionary alloc] init];
    for (NSDictionary *dic in resultFieldsChild) {
        if ([elementDic count] == 9)
            break;
        @autoreleasepool {
            if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Legal_Ultimate_Parent_Id"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Legal_Ultimate_Parent_Id"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Legal_Ultimate_Parent_Name"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Legal_Ultimate_Parent_Name"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Legal_Ultimate_Parent_City"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Legal_Ultimate_Parent_City"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Legal_Ultimate_Parent_State"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Legal_Ultimate_Parent_State"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Legal_Immediate_Parent_Id"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Legal_Immediate_Parent_Id"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Legal_Immediate_Parent_Name"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Legal_Immediate_Parent_Name"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Legal_Immediate_Parent_City"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Legal_Immediate_Parent_City"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Legal_Immediate_Parent_State"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Legal_Immediate_Parent_State"];
            } else if ([[dic objectForKey:@"fieldName"] isEqualToString:@"Domestic_Foreign_Description"]) {
                [elementDic setObject:[dic objectForKey:@"fieldValue"] forKey:@"Domestic_Foreign_Description"];
            }
        }
    }
    
    if([elementDic count]>0) {
        NSString *strName = nil;
        NSString *city = nil;
        NSString *state = nil;
        NSString *strAddress = nil;
        
        if ([[elementDic objectForKey:@"Legal_Ultimate_Parent_Name"] isEqualToString:@"N/A"] || [[elementDic objectForKey:@"Legal_Ultimate_Parent_Name"] isMemberOfClass:[NSNull class]]) {
            strName = @"";
        }
        else {
            strName = [elementDic objectForKey:@"Legal_Ultimate_Parent_Name"];
        }
        
        if ([[elementDic objectForKey:@"Legal_Ultimate_Parent_City"] isEqualToString:@"N/A"] || [[elementDic objectForKey:@"Legal_Ultimate_Parent_City"] isMemberOfClass:[NSNull class]]) {
            city = @"";
        }
        else {
            city = [elementDic objectForKey:@"Legal_Ultimate_Parent_City"];
        }
        
        if ([[elementDic objectForKey:@"Legal_Ultimate_Parent_State"] isEqualToString:@"N/A"] || [[elementDic objectForKey:@"Legal_Ultimate_Parent_State"] isMemberOfClass:[NSNull class]]) {
            state = @"";
        }
        else {
            state = [elementDic objectForKey:@"Legal_Ultimate_Parent_State"];
        }
        
        if ([city isEqualToString:@""] && [state isEqualToString:@""]) {
            strAddress = @"";
        } else {
            strAddress = [NSString stringWithFormat:@"- %@, %@",city,state];
        }
        
        NSString *finalStr = nil;
        
        if ([strName isEqualToString:@""]) {
            finalStr = [NSString stringWithFormat:@"%@<br />%@", @"N/A", strAddress];
        } else {
            finalStr = [NSString stringWithFormat:@"%@<br />%@", strName, strAddress];
        }
        
        [strHTML appendFormat:@"<tr><td>Ultimate Parent</td><td><strong>%@</strong></td></tr>",finalStr];
        
        //****************     Immediate Parent      ******************
        
        if ([[elementDic objectForKey:@"Legal_Immediate_Parent_Name"] isEqualToString:@"N/A"] || [[elementDic objectForKey:@"Legal_Immediate_Parent_Name"] isMemberOfClass:[NSNull class]]) {
            strName = @"";
        }
        else {
            strName = [elementDic objectForKey:@"Legal_Immediate_Parent_Name"];
        }
        
        if ([[elementDic objectForKey:@"Legal_Immediate_Parent_City"] isEqualToString:@"N/A"] || [[elementDic objectForKey:@"Legal_Immediate_Parent_City"] isMemberOfClass:[NSNull class]]) {
            city = @"";
        }
        else {
            city = [elementDic objectForKey:@"Legal_Immediate_Parent_City"];
        }
        
        if ([[elementDic objectForKey:@"Legal_Immediate_Parent_State"] isEqualToString:@"N/A"] || [[elementDic objectForKey:@"Legal_Immediate_Parent_State"] isMemberOfClass:[NSNull class]]) {
            state = @"";
        }
        else {
            state = [elementDic objectForKey:@"Legal_Immediate_Parent_State"];
        }
        
        if ([city isEqualToString:@""] && [state isEqualToString:@""]) {
            strAddress = @"";
        } else {
            strAddress = [NSString stringWithFormat:@"- %@, %@",city,state];
        }
        
        finalStr = nil;
        
        if ([strName isEqualToString:@""]) {
            finalStr = [NSString stringWithFormat:@"%@<br />%@", @"N/A", strAddress];
        } else {
            finalStr = [NSString stringWithFormat:@"%@<br />%@", strName, strAddress];
        }
        
        [strHTML appendFormat:@"<tr><td>Immediate Parent</td><td><strong>%@</strong></td></tr>",finalStr];
        
        //****************     Domestic/Foreign      ******************
        
        NSString *domestic = nil;
        
        if ([[elementDic objectForKey:@"Domestic_Foreign_Description"] isEqualToString:@"N/A"] || [[elementDic objectForKey:@"Domestic_Foreign_Description"] isMemberOfClass:[NSNull class]]) {
            domestic = @"N/A";
        } else {
            domestic = [elementDic objectForKey:@"Domestic_Foreign_Description"];
        }
        
        [strHTML appendFormat:@"<tr><td>Domestic/Foreign</td><td><strong>%@</strong></td></tr>",domestic];
        
    } else {
        [strHTML appendString:@"<tr><td>Corporate Linkage</td><td>N/A</td></tr>"];
        return @"";
    }
    
    
    strCrpLnkFile = [NSString stringWithFormat:strCrpLnkFile,strHTML];
    return strCrpLnkFile;
    
    
    
    
    
    
//    NSDictionary *dToSet = self.dForDtl;
//    
//    NSArray *arrLinkage =  ([dToSet valueForKey:@"Linkage"] && ![[dToSet valueForKey:@"Linkage"] isKindOfClass:[NSNull class]] ) ?[dToSet valueForKey:@"Linkage"] : nil;
//    
//    NSMutableString *strHTML = [NSMutableString string];
//    
//    if([arrLinkage isKindOfClass:[NSString class]]) {
//        [strHTML appendString:@"<tr><td>Corporate Linkage</td><td>N/A</td></tr>"];
//        return 0;
//    }
//    
//    if([arrLinkage count]>0) {
////        [lblUlti setTitle:@"Ultimate Parent" forState:UIControlStateNormal];
////        [lblImm setTitle:@"Immediate Parent" forState:UIControlStateNormal];
////        [lblDom setTitle:@"Domestic/Foreign" forState:UIControlStateNormal];
//        if(arrLinkage.count==3) {
//            // set up value 1
//            if([[arrLinkage objectAtIndex:0] count]>0) {
//                NSString *strName = [NSString stringWithFormat:@"%@ - %@, %@",[[arrLinkage objectAtIndex:0] objectAtIndex:1],[[arrLinkage objectAtIndex:0] objectAtIndex:2],[[arrLinkage objectAtIndex:0] objectAtIndex:3]];
//                [strHTML appendFormat:@"<tr><td>Ultimate Parent</td><td><strong>%@</strong></td></tr>",strName];
//            } else {
//                [strHTML appendFormat:@"<tr><td>Ultimate Parent</td><td>N/A</td></tr>"];
//            }
//            
//            // set up value 2
//            if([[arrLinkage objectAtIndex:1] count]>0) {
//                NSString *strName = [NSString stringWithFormat:@"%@ - %@, %@",[[arrLinkage objectAtIndex:1] objectAtIndex:1],[[arrLinkage objectAtIndex:1] objectAtIndex:2],[[arrLinkage objectAtIndex:1] objectAtIndex:3]];
//                [strHTML appendFormat:@"<tr><td>Immediate Parent</td><td><strong>%@</strong></td></tr>",strName];
//            } else {
//                [strHTML appendFormat:@"<tr><td>Immediate Parent</td><td>N/A</td></tr>"];
//            }
//            
//            // set up value 3
//            if([[arrLinkage objectAtIndex:2] count]>0) {
//                NSString *strName = [NSString stringWithFormat:@"%@",[[arrLinkage objectAtIndex:2] objectAtIndex:2]];
//                [strHTML appendFormat:@"<tr><td>Domestic/Foreign</td><td><strong>%@</strong></td></tr>",strName];
//            } else {
//               [strHTML appendFormat:@"<tr><td>Domestic/Foreign</td><td><strong>N/A</strong></td></tr>"];
//            }
//        } else if(arrLinkage.count==2) {
//            // set up value 1
//            if([[arrLinkage objectAtIndex:0] count]>0) {
//                NSString *strName = [NSString stringWithFormat:@"%@ - %@, %@",[[arrLinkage objectAtIndex:0] objectAtIndex:1],[[arrLinkage objectAtIndex:0] objectAtIndex:2],[[arrLinkage objectAtIndex:0] objectAtIndex:3]];
//                [strHTML appendFormat:@"<tr><td>Ultimate Parent</td><td><strong>%@</strong></td></tr>",strName];
//            } else {
//                [strHTML appendFormat:@"<tr><td>Ultimate Parent</td><td>N/A</td></tr>"];
//            }
//            
//            // set up value 2
//            if([[arrLinkage objectAtIndex:1] count]>0) {
//                NSString *strName = [NSString stringWithFormat:@"%@ - %@, %@",[[arrLinkage objectAtIndex:1] objectAtIndex:1],[[arrLinkage objectAtIndex:1] objectAtIndex:2],[[arrLinkage objectAtIndex:1] objectAtIndex:3]];
//                [strHTML appendFormat:@"<tr><td>Immediate Parent</td><td><strong>%@</strong></td></tr>",strName];
//            } else {
//                [strHTML appendFormat:@"<tr><td>Immediate Parent</td><td>N/A</td></tr>"];
//            }
//        } else if(arrLinkage.count==1) {
//            // set up value 1
//            if([[arrLinkage objectAtIndex:0] count]>0) {
//                NSString *strName = [NSString stringWithFormat:@"%@ - %@, %@",[[arrLinkage objectAtIndex:0] objectAtIndex:1],[[arrLinkage objectAtIndex:0] objectAtIndex:2],[[arrLinkage objectAtIndex:0] objectAtIndex:3]];
//                [strHTML appendFormat:@"<tr><td>Ultimate Parent</td><td><strong>%@</strong></td></tr>",strName];
//            } else {
//                [strHTML appendFormat:@"<tr><td>Ultimate Parent</td><td>N/A</td></tr>"];
//            }
//        } else {
//            [strHTML appendString:@"<tr><td>Corporate Linkage</td><td>N/A</td></tr>"];
//        }
//    } else {
//        [strHTML appendString:@"<tr><td>Corporate Linkage</td><td>N/A</td></tr>"];
//    }
//    strCrpLnkFile = [NSString stringWithFormat:strCrpLnkFile,strHTML];
//    return strCrpLnkFile;
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
#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
	NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=Hello from California!";
	NSString *body = @"";
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
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

-(NSString *)currencyNumberFormatterWithNum:(NSString *) number
{
    NSLog(@"BEFORE FORMAT = %@", number);
    if ([number isEqualToString:@"N/A"] || [number isEqualToString:@"0"]) {
        number = @"N/A";
        return number;
    }
    
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    [numFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numFormatter setCurrencySymbol:@"$"];
    [numFormatter setMinimumFractionDigits:0];
    NSNumber *lnumber = [NSNumber numberWithLongLong:[number longLongValue]];
    
    NSString *numStr = [numFormatter stringFromNumber:lnumber];
    
    NSLog(@"AFTER FORMAT = %@", numStr);
    return numStr;
}

#pragma mark startFeedDataToDetailsScreen

//Rajeev Start
- (void)startFeedDataToDetailsScreen
{
    NSDictionary *dToSet = self.dForDtl;
    
    [self setUpOverView:dToSet]; //Completed
    [self setUpDemoGraphic:dToSet]; //Completed
    [self setUpOwnerShip:dToSet]; //Completed
    [self setUpCorporate:dToSet];   //Completed
    [self setUpIndustry:dToSet]; //Completed
    [self setUpOtherImpInfo:dToSet]; //Completed
    [self setUpQRCode:dToSet]; //Completed
    [self setUpRevenueTrend:dToSet]; //Completed
    [self setUpEmployeeTrend:dToSet];//Completed
 
    //Rajeev Start
    
	NSArray *searchResultRecord = [dToSet objectForKey:@"searchResultRecord"];
    
    if ([searchResultRecord count] == 0)
        return;
    NSDictionary *resultFields = [searchResultRecord objectAtIndex:0];
    
    if ([resultFields count] == 0)
        return;
    NSArray *resultFieldsChild = [resultFields objectForKey:@"resultFields"];
    
    NSMutableArray *CompArray = [[NSMutableArray alloc] init];
    for (int i=1; i<=10; i++) {
        @autoreleasepool {
            NSMutableArray *infoArray = [NSMutableArray arrayWithObjects:[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],nil];
            int track = 0;
            for (NSDictionary *dic in resultFieldsChild) {
                if (track == 9)
                    break;
                @autoreleasepool {
                    if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Competitor_Id_%d",i]]) {
                        //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                        [infoArray replaceObjectAtIndex:0 withObject:[dic objectForKey:@"fieldValue"]];
                        ++track;
                    } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Competitor_Company_Name_%d",i]]) {
                        //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                        [infoArray replaceObjectAtIndex:1 withObject:[dic objectForKey:@"fieldValue"]];
                        ++track;
                    } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Competitor_Address_%d",i]]) {
                        //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                        [infoArray replaceObjectAtIndex:2 withObject:[dic objectForKey:@"fieldValue"]];
                        ++track;
                    } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Competitor_City_%d",i]]) {
                        //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                        [infoArray replaceObjectAtIndex:3 withObject:[dic objectForKey:@"fieldValue"]];
                        ++track;
                    } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Competitor_State_%d",i]]) {
                        //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                        [infoArray replaceObjectAtIndex:4 withObject:[dic objectForKey:@"fieldValue"]];
                        ++track;
                    } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Competitor_Zip_%d",i]]) {
                        //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                        [infoArray replaceObjectAtIndex:5 withObject:[dic objectForKey:@"fieldValue"]];
                        ++track;
                    } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Competitor_Phone_%d",i]]) {
                        //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                        [infoArray replaceObjectAtIndex:6 withObject:[dic objectForKey:@"fieldValue"]];
                        ++track;
                    } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Competitor_SIC01_%d",i]]) {
                        //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                        [infoArray replaceObjectAtIndex:7 withObject:[dic objectForKey:@"fieldValue"]];
                        ++track;
                    } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Competitor_Distance_%d",i]]) {
                        //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                        [infoArray replaceObjectAtIndex:8 withObject:[dic objectForKey:@"fieldValue"]];
                        ++track;
                    }
                }
            }
            [CompArray addObject:infoArray];
        }
    }
    
    //NSArray *ar=[dToSet valueForKey:@"Competitors"]; //Completed
    self.tableCompetitors.arForTable=CompArray;
    [self.tableCompetitors shouldReloadThings];
    
   
    [CompArray removeAllObjects];
    for (int i=1; i<=100; i++) {
        @autoreleasepool {
            NSMutableArray *infoArray = [NSMutableArray arrayWithObjects:[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],nil];
            int track = 0;
            for (NSDictionary *dic in resultFieldsChild) {
                if (track == 8)
                    break;
                @autoreleasepool {
                    if (i <= 9) {
                        if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"First_Name_0%d",i]]) {
                            //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                            [infoArray replaceObjectAtIndex:0 withObject:[dic objectForKey:@"fieldValue"]];
                            ++track;
                        } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Middle_Initial_0%d",i]]) {
                            //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                            [infoArray replaceObjectAtIndex:1 withObject:[dic objectForKey:@"fieldValue"]];
                            ++track;
                        } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Last_Name_0%d",i]]) {
                            //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                            [infoArray replaceObjectAtIndex:2 withObject:[dic objectForKey:@"fieldValue"]];
                            ++track;
                        } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Executive_Gender_0%d",i]]) {
                            //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                            [infoArray replaceObjectAtIndex:3 withObject:[dic objectForKey:@"fieldValue"]];
                            ++track;
                        } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Executive_Title_0%d",i]]) {
                            //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                            [infoArray replaceObjectAtIndex:4 withObject:[dic objectForKey:@"fieldValue"]];
                            ++track;
                        } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Prefix_0%d",i]]) {
                            //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                            [infoArray replaceObjectAtIndex:5 withObject:[dic objectForKey:@"fieldValue"]];
                            ++track;
                        } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Suffix_0%d",i]]) {
                            //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                            [infoArray replaceObjectAtIndex:6 withObject:[dic objectForKey:@"fieldValue"]];
                            ++track;
                        } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Executive_Email_0%d",i]]) {
                            //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                            [infoArray replaceObjectAtIndex:7 withObject:[dic objectForKey:@"fieldValue"]];
                            ++track;
                        }
                    }
                    else {
                        if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"First_Name_%d",i]]) {
                            //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                            [infoArray replaceObjectAtIndex:0 withObject:[dic objectForKey:@"fieldValue"]];
                            ++track;
                        } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Middle_Initial_%d",i]]) {
                            //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                            [infoArray replaceObjectAtIndex:1 withObject:[dic objectForKey:@"fieldValue"]];
                            ++track;
                        } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Last_Name_%d",i]]) {
                            //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                            [infoArray replaceObjectAtIndex:2 withObject:[dic objectForKey:@"fieldValue"]];
                            ++track;
                        } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Executive_Gender_%d",i]]) {
                            //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                            [infoArray replaceObjectAtIndex:3 withObject:[dic objectForKey:@"fieldValue"]];
                            ++track;
                        } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Executive_Title_%d",i]]) {
                            //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                            [infoArray replaceObjectAtIndex:4 withObject:[dic objectForKey:@"fieldValue"]];
                            ++track;
                        } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Prefix_%d",i]]) {
                            //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                            [infoArray replaceObjectAtIndex:5 withObject:[dic objectForKey:@"fieldValue"]];
                            ++track;
                        } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Suffix_%d",i]]) {
                            //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                            [infoArray replaceObjectAtIndex:6 withObject:[dic objectForKey:@"fieldValue"]];
                            ++track;
                        } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Executive_Email_%d",i]]) {
                            //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                            [infoArray replaceObjectAtIndex:7 withObject:[dic objectForKey:@"fieldValue"]];
                            ++track;
                        }
                    }
                }
            }
            [CompArray addObject:infoArray];
        }
    }
    
    //ar=[dToSet valueForKey:@"Executive Directory"]; //Completed
    self.tableExDir.arForTable=CompArray;
    [self.tableExDir shouldReloadThings];
 
    [CompArray removeAllObjects];
    for (int i=1; i<=10; i++) {
        @autoreleasepool {
            NSMutableArray *infoArray = [NSMutableArray arrayWithObjects:[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],nil];
            int track = 0;
            for (NSDictionary *dic in resultFieldsChild) {
                if (track == 9)
                    break;
                @autoreleasepool {
                    if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Nearby_Id_%d",i]]) {
                        //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                        [infoArray replaceObjectAtIndex:0 withObject:[dic objectForKey:@"fieldValue"]];
                        ++track;
                    } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Nearby_Company_Name_%d",i]]) {
                        //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                        [infoArray replaceObjectAtIndex:1 withObject:[dic objectForKey:@"fieldValue"]];
                        ++track;
                    } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Nearby_Address_%d",i]]) {
                        //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                        [infoArray replaceObjectAtIndex:2 withObject:[dic objectForKey:@"fieldValue"]];
                        ++track;
                    } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Nearby_City_%d",i]]) {
                        //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                        [infoArray replaceObjectAtIndex:3 withObject:[dic objectForKey:@"fieldValue"]];
                        ++track;
                    } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Nearby_State_%d",i]]) {
                        //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                        [infoArray replaceObjectAtIndex:4 withObject:[dic objectForKey:@"fieldValue"]];
                        ++track;
                    } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Nearby_Zip_%d",i]]) {
                        //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                        [infoArray replaceObjectAtIndex:5 withObject:[dic objectForKey:@"fieldValue"]];
                        ++track;
                    } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Nearby_Phone_%d",i]]) {
                        //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                        [infoArray replaceObjectAtIndex:6 withObject:[dic objectForKey:@"fieldValue"]];
                        ++track;
                    } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Nearby_Distance_%d",i]]) {
                        //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                        [infoArray replaceObjectAtIndex:7 withObject:[dic objectForKey:@"fieldValue"]];
                        ++track;
                    } else if ([[dic objectForKey:@"fieldName"] isEqualToString:[NSString stringWithFormat:@"Nearby_SIC01_%d",i]]) {
                        //[infoArray addObject:[dic objectForKey:@"fieldValue"]];
                        [infoArray replaceObjectAtIndex:8 withObject:[dic objectForKey:@"fieldValue"]];
                        ++track;
                    }
                }
            }
            [CompArray addObject:infoArray];
        }
    }
    
    //ar=[dToSet valueForKey:@"Nearby Businesses"]; //Completed
    self.tableNearBy.arForTable=CompArray;
    [self.tableNearBy shouldReloadThings];
}
//Rajeev End

#pragma mark getYearsListRelatedToRevenueTrend

//Rajeev Start
- (void)getYearsListRelatedToRevenueTrend
{
    [iNetMngr createYearsListRelatedToRevenueTrend:self];
}
//Rajeev End

- (void)loadByID :(NSString*)idValue {
    //Rajeev Start
//    NSString *str = [NSString stringWithFormat:WEB_RCRD_DTL,@"Business",idValue];
//    [iNetMngr startLoadingRestValue:str vCtr:self title:@"Loading" message:@"Please wait..."];
    
    NSString *str = [WEB_SERVICE_URL stringByAppendingFormat:WEB_RCRD_DTL,[[self.dForResult valueForKey:@"Database Type"] lowercaseString],idValue];
    [iNetMngr getDetails:self withAPI:str];
    //Rajeev End
}

@end
