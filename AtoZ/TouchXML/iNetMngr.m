//
//  Global.m
//  DigiCamp
//
//  Created by digicorp on 15/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "iNetMngr.h"
#import "WebRqst.h"


static WebRqst *rqstObj;
static UIView *gView;
static NSString *domainURL;
static NSMutableArray *arForImages;

#define kImageArray [Global arrayOfImages]

@implementation iNetMngr

void ALERT(NSString *title, NSString *message,NSString *canceBtnTitle,id delegate,NSString *otherButtonTitles, ... )
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:title 
                                                      message:message 
                                                     delegate:delegate 
                                            cancelButtonTitle:canceBtnTitle 
                                            otherButtonTitles:nil
                            ];
    
    va_list args;
    va_start(args, otherButtonTitles);
    NSString *obj;
    for (obj = otherButtonTitles; obj != nil; obj = va_arg(args, NSString*))
        [alertView addButtonWithTitle:obj];
    va_end(args);
    
    [alertView show];
}

+(void)initialize{
	rqstObj=[[WebRqst alloc] init];
	NSDictionary *d=[[NSDictionary alloc] initWithContentsOfFile:
					 [[NSBundle mainBundle] pathForResource:@"DomainDetails" ofType:@"plist"]];
	domainURL=[[d valueForKey:@"DomainURL"] retain];
	
	//[[NSString alloc] initWithString:[d valueForKey:@"domainURL"]];
	[d release]; d=nil;
	
	arForImages=[[NSMutableArray alloc] init];
}

+(WebRqst*)requestObject {
    return rqstObj;
}

+(NSString*)domainURL{
	return domainURL;
}

+(NSMutableArray*)arrayOfImages{
	return arForImages;
}

+(void)setView:(UIView*)setV{
    if(gView && [gView retainCount]>1) {
        [gView release]; gView=nil; 
    }
	gView=[setV retain];
}

+(UIView*)view{
	return gView;
}

+(void)startLoadingRestValue:(NSString*)restValue vCtr:(UIViewController*)vCtrRef title:(NSString*)title message:(NSString*)message {
    restValue=[restValue stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation];
    NSLog(@"API hit -> %@",restValue);
    [rqstObj startLoadingRestValue:restValue vCtr:vCtrRef title:title message:message];
}

+ (void)getNearByLibraries:(UIViewController*)vCtr zipCode:(NSString*)zipCode {
    [iNetMngr startLoadingRestValue:[NSString stringWithFormat:@"%@%@/page/0",WEB_LIB_REST_URL,zipCode] 
                               vCtr:vCtr 
                              title:@"Loading" message:@"Please wait..."];
}

+ (void)authenticateCard:(NSString*)cardNo libraryAccountNo:(NSString*)accountNo vCtrRef:(UIViewController*)vCtr {
    [iNetMngr startLoadingRestValue:[NSString stringWithFormat:WEB_AUTH_URL,accountNo,cardNo]
                               vCtr:vCtr
                              title:@"Loading"
                            message:@"Please wait..."];
}

//Rajeev Start
+ (void)getDetails:(UIViewController*)vCtrRef withAPI:(NSString *) serverAPI
{
    rqstObj.eService_type = GET_DETAILS;
    [iNetMngr startLoadingRestValue:serverAPI vCtr:vCtrRef title:@"Loading" message:@"Please wait..."];
}
//Rajeev End
+ (void)createToken:(UIViewController*)vCtrRef {
//Rajeev Start
//    [iNetMngr startLoadingRestValue:[NSString stringWithFormat:@"%@%@",WEB_SERVICE_URL,WEB_TOKEN_RQST]
//                               vCtr:vCtrRef 
//                              title:@"Loading"
//                            message:@"Please wait..."];
      rqstObj.eService_type = TOKEN_CREATE;
      [iNetMngr startLoadingRestValue:[WEB_SERVICE_URL stringByAppendingString:WEB_TOKEN_RQST]
                                   vCtr:vCtrRef
                                  title:@"Loading"
                                message:@"Please wait..."];
//Rajeev End
}

//Rajeev Start

+ (void)createYearsListRelatedToRevenueTrend:(UIViewController*)vCtrRef
{
    rqstObj.eService_type = GET_YEARS_LIST_REVENUE;
    [iNetMngr startLoadingRestValue:[WEB_SERVICE_URL stringByAppendingString:WEB_YEARS_LIST_REVENUE]
                               vCtr:vCtrRef
                              title:@"Loading"
                            message:@"Please wait..."];
}

//Rajeev End

+ (void)createSession:(UIViewController*)vCtrRef {
    [iNetMngr startLoadingRestValue:[WEB_SERVICE_URL stringByAppendingFormat:WEB_CREATE_SESSION,COMMON_PARSER.strActiveToken] 
                               vCtr:vCtrRef 
                              title:@"Loading"
                            message:@"Please wait..."];
}

+ (void)setRqstUserName:(UIViewController*)vCtrRef userName:(NSString*)userName{
    [iNetMngr startLoadingRestValue:[WEB_SERVICE_URL stringByAppendingFormat:WEB_SET_UNAME,userName,COMMON_PARSER.strActiveToken] 
                               vCtr:vCtrRef 
                              title:@"Loading"
                            message:@"Please wait..."];
}

+ (void)setRqstIP:(UIViewController*)vCtrRef ip:(NSString*)ip{
    [iNetMngr startLoadingRestValue:[WEB_SERVICE_URL stringByAppendingFormat:WEB_SET_IP,ip,COMMON_PARSER.strActiveToken] 
                               vCtr:vCtrRef 
                              title:@"Loading"
                            message:@"Please wait..."];
}

+ (void)setRqstDBToCombine:(UIViewController*)vCtrRef{
    [iNetMngr startLoadingRestValue:[WEB_SERVICE_URL stringByAppendingFormat:WEB_SET_DBXES,COMMON_PARSER.strActiveToken] 
                               vCtr:vCtrRef 
                              title:@"Loading"
                            message:@"Please wait..."];
}

+ (void)setRqstCriteria:(UIViewController*)vCtrRef criteriaField:(NSString*)criteriaField criteriaValue:(NSString*)criteriaValue{
    [iNetMngr startLoadingRestValue:[WEB_SERVICE_URL stringByAppendingFormat:WEB_SET_CRITERIA,criteriaField,criteriaValue,COMMON_PARSER.strActiveToken] 
                               vCtr:vCtrRef 
                              title:@"Loading"
                            message:@"Please wait..."];
}

+ (void)getRecords:(UIViewController*)vCtrRef pageNumber:(NSString*)pageNumber numberOfRecords:(NSString*)numberOfRecords{
    //Rajeev Start
    
//    [iNetMngr startLoadingRestValue:[WEB_SERVICE_URL stringByAppendingFormat:WEB_GET_RESULTS,pageNumber,numberOfRecords,COMMON_PARSER.strActiveToken] 
//                               vCtr:vCtrRef 
//                              title:@"Loading"
//                            message:@"Please wait..."];
    rqstObj.eService_type = GET_RESULTS;
    [iNetMngr startLoadingRestValue:[WEB_SERVICE_URL stringByAppendingFormat:WEB_GET_RESULTS,pageNumber,numberOfRecords]
                               vCtr:vCtrRef
                              title:@"Loading"
                            message:@"Please wait..."];
    
    //Rajeev End
}

+ (void)getStates:(UIViewController*)vCtrRef {
   // WEB_GET_STATES
    //Rajeev Start
//    [iNetMngr startLoadingRestValue:[WEB_SERVICE_URL stringByAppendingFormat:WEB_GET_STATES,COMMON_PARSER.strActiveToken]
//                               vCtr:vCtrRef 
//                              title:@"Loading" 
//                            message:@"Please wait..."];
    rqstObj.eService_type = PHYSICAL_STATE;
    [iNetMngr startLoadingRestValue:[WEB_SERVICE_URL stringByAppendingFormat:WEB_GET_STATES,@"Physical_State"]
                                    vCtr:vCtrRef
                                   title:@"Loading"
                                 message:@"Please wait..."];
    //Rajeev End
}

+(void)startLoading:(NSMutableURLRequest*)urlRequest vCtr:(UIViewController*)vCtrRef message:(NSString*)message{

//	[rqstObj startLoading:urlRequest vCtr:vCtrRef message:message];
}

+(NSMutableURLRequest*)urlRequestAction:(NSString*)sa_Name message:(NSString*)sm_msg{
	NSMutableURLRequest *urlReq=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:domainURL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
	[urlReq addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[urlReq addValue:sa_Name forHTTPHeaderField:@"SOAPAction"];
	[urlReq setHTTPMethod:@"POST"];
	[urlReq setHTTPBody: [sm_msg dataUsingEncoding:NSUTF8StringEncoding]];
	return urlReq;	
}


+(NSString*)SA_synchronise{
	return @"http://tempuri.org/SyncronizeData";
}

+(NSString*)SM_synchronise{
	return @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><SyncronizeData xmlns=\"http://tempuri.org/\" /></soap:Body></soap:Envelope>";
}


+(NSString*)SA_SearchAction{
	return @"http://tempuri.org/GetSearchResults";
}

+(NSString*)SM_Search_BrandID:(NSString*)brandID modelID:(NSString*)modelID From:(NSString*)from to:(NSString*)to countryID:(NSString*)countryID{
	return [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><GetSearchResults xmlns=\"http://tempuri.org/\"><pBrandId>%@</pBrandId><pModelId>%@</pModelId><pFrom>%@</pFrom><pTo>%@</pTo><pCountryID>%@</pCountryID></GetSearchResults></soap:Body></soap:Envelope>",brandID,modelID,from,to,countryID];
}

+(NSString*)SA_ModelImages{
	return @"http://tempuri.org/GetImages";
}

+(NSString*)SM_ModelImages:(NSString*)modelID{
	return [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><GetImages xmlns=\"http://tempuri.org/\"><Pid>%@</Pid></GetImages></soap:Body></soap:Envelope>",modelID];
	
}

+(NSString*)SA_FavouriteRefresh{
	return @"http://tempuri.org/GetFavoriteDetails";
}

+(NSString*)SM_FavouriteRefreshModelIDs:(NSString*)modelIDs{
	return [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><GetFavoriteDetails xmlns=\"http://tempuri.org/\"><pProductIds>%@</pProductIds></GetFavoriteDetails></soap:Body></soap:Envelope>",modelIDs];
}

+ (CLLocationCoordinate2D) geoCodeUsingAddress: (NSString *) address
{
    CLLocationCoordinate2D myLocation; 
    
    // -- modified from the stackoverflow page - we use the SBJson parser instead of the string scanner --
    
    NSString       *esc_addr = [address stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSString            *req = [NSString stringWithFormat: @"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSDictionary *googleResponse = [[NSString stringWithContentsOfURL: [NSURL URLWithString: req] encoding: NSUTF8StringEncoding error: NULL] JSONValue];
    
    NSDictionary    *resultsDict = [googleResponse valueForKey:  @"results"];   // get the results dictionary
    NSDictionary   *geometryDict = [   resultsDict valueForKey: @"geometry"];   // geometry dictionary within the  results dictionary
    NSDictionary   *locationDict = [  geometryDict valueForKey: @"location"];   // location dictionary within the geometry dictionary
    
    // -- you should be able to strip the latitude & longitude from google's location information (while understanding what the json parser returns) --
    
    NSArray *latArray = [locationDict valueForKey: @"lat"]; NSString *latString = [latArray lastObject];     // (one element) array entries provided by the json parser
    NSArray *lngArray = [locationDict valueForKey: @"lng"]; NSString *lngString = [lngArray lastObject];     // (one element) array entries provided by the json parser
    
    myLocation.latitude = [latString doubleValue];     // the json parser uses NSArrays which don't support "doubleValue"
    myLocation.longitude = [lngString doubleValue];
    
    return myLocation;
}

@end


