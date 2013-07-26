//
//  WebRqst.m
//  DigiCamp
//
//  Created by digicorp on 15/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WebRqst.h"
#import "iNetMngr.h"
#import <QuartzCore/QuartzCore.h>

//Rajeev Start
@interface WebRqst (Private_Methods)
-(void) createTokenRequest;
-(void) createRequestWithTokenID:(NSString *) tokenID;
@end
//Rajeev End

@implementation WebRqst

@synthesize restValue = _restValue;
@synthesize mbProcess = _mbProcess;
@synthesize vCtrWhileParsing = _vCtrWhileParsing;
@synthesize del = _del;
@synthesize myWebData = _myWebData;
@synthesize con = _con;
@synthesize vIhoneLoadingScreen = _vIhoneLoadingScreen;

@synthesize av = _av;
@synthesize actV = _actV;
//Rajeev Start
@synthesize eService_type = _eService_type;
//Rajeev End

-(id)init{
	if(self=[super init]){
        //Rajeev Start
        self.eService_type = NON;
        //Rajeev End
		self.del=(AppDelegate*)[[UIApplication sharedApplication] delegate];
		self.vIhoneLoadingScreen = [[[NSBundle mainBundle] loadNibNamed:@"LoadingScreen" owner:self options:nil] objectAtIndex:0];
		[self.vIhoneLoadingScreen viewWithTag:3].layer.cornerRadius=10;
	} 
	return self;
}

-(void)showProgressHUD:(NSString*)message title:(NSString*)title{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//		
//		if(self.av!=nil) {  self.av=nil; }
//		self.av=[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
//		[self.av show];
//		self.actV=[[UIActivityIndicatorView alloc] init];
//		[self.actV startAnimating];
//		[self.actV setFrame:CGRectMake(125, 75, 37, 37)];
//		[self.av addSubview:self.actV];
		[[iNetMngr view] addSubview:self.vIhoneLoadingScreen];
	}else{
		if(self.mbProcess!=nil){ [self.mbProcess removeFromSuperview]; self.mbProcess=nil;}
		self.mbProcess=[[MBProgressHUD alloc] initWithView:[iNetMngr view]];
		self.mbProcess.labelText=title;
		self.mbProcess.detailsLabelText=message;
		[[iNetMngr view] addSubview:self.mbProcess];
		[self.mbProcess setDelegate:self];
		[self.mbProcess show:NO];
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	}
	
}

-(void)hideProgressHUD {
	[self.av dismissWithClickedButtonIndex:0 animated:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[self.vIhoneLoadingScreen removeFromSuperview];
	[self.mbProcess hide:NO];
	if(self.mbProcess!=nil){ [self.mbProcess removeFromSuperview]; self.mbProcess=nil;}
}

//- (void)applicationDidEnterBackground:(NSNotification *) notification
//{
//    if (self.con) {
//        NSLog(@"HELLO");
//        [self.con cancel];
//        self.con = nil;
//    }
//    [self hideProgressHUD];
//}

- (void)startDownloadingData:(NSURLRequest*)request{
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:@"Application_Enter_BG" object:nil];
    
    self.con=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(self.con){
		self.myWebData=[NSMutableData data];
	} else {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}
}

-(void)startLoadingRestValue:(NSString*)restValue vCtr:(UIViewController*)vCtrRef title:(NSString*)title message:(NSString*)message{
    self.restValue = restValue;
	self.vCtrWhileParsing=vCtrRef;
	[self showProgressHUD:message title:title];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//	[self performSelector:@selector(startDownloadingData:) withObject:[NSURLRequest requestWithURL:[NSURL URLWithString:restValue]] afterDelay:0.75];
    if (self.eService_type == TOKEN_CREATE) {
        self.eService_type = NON;
        [self createTokenRequest];
    }
    else if (self.eService_type == PHYSICAL_STATE) {
        self.eService_type = NON;
        [self createRequestWithTokenID:[APP_DEL strToken]];
    }
    else if (self.eService_type == GET_RESULTS) {
        self.eService_type = NON;
        [self createRequestWithTokenID:[APP_DEL strToken]];
    }
    else if (self.eService_type == GET_DETAILS) {
        self.eService_type = NON;
        [self createRequestWithTokenID:[APP_DEL strToken]];
    }
    else if (self.eService_type == GET_YEARS_LIST_REVENUE) {
        self.eService_type = NON;
        [self createRequestWithTokenID:[APP_DEL strToken]];
    }
    else {
        [self performSelector:@selector(startDownloadingData:)
			   withObject:[NSURLRequest requestWithURL:[NSURL URLWithString:self.restValue]]];
    }
}

#pragma mark - Private_Methods
//Rajeev Start
-(void) createTokenRequest
{
    NSDictionary *tokenParamsDic = [APP_DEL tokenParamsDic];
    NSURL *url = [[NSURL alloc] initWithString:self.restValue];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    [urlRequest setValue:[[tokenParamsDic objectForKey:@"SubscriberID"] stringValue] forHTTPHeaderField:@"SubscriberID"];
    [urlRequest setValue:[tokenParamsDic objectForKey:@"SubscriberPassword"] forHTTPHeaderField:@"SubscriberPassword"];
    [urlRequest setValue:[tokenParamsDic objectForKey:@"SubscriberUsername"] forHTTPHeaderField:@"SubscriberUsername"];
    [urlRequest setValue:[tokenParamsDic objectForKey:@"AccountUsername"] forHTTPHeaderField:@"AccountUsername"];
    [urlRequest setValue:[tokenParamsDic objectForKey:@"AccountPassword"] forHTTPHeaderField:@"AccountPassword"];
    [urlRequest setValue:[tokenParamsDic objectForKey:@"AccountDetailsRequired"] forHTTPHeaderField:@"AccountDetailsRequired"];
    [urlRequest setURL:url];
    [urlRequest setHTTPMethod:@"GET"];
    [self performSelector:@selector(startDownloadingData:)
			   withObject:urlRequest];
}

-(void) createRequestWithTokenID:(NSString *) tokenID
{
    NSURL *url = [[NSURL alloc] initWithString:self.restValue];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    [urlRequest setValue:tokenID forHTTPHeaderField:@"TokenID"];
    [urlRequest setURL:url];
    [urlRequest setHTTPMethod:@"GET"];
    [self performSelector:@selector(startDownloadingData:)
			   withObject:urlRequest];
}
//Rajeev End
//-(void)startLoading:(NSMutableURLRequest*)urlRequest vCtr:(UIViewController*)vCtrRef message:(NSString*)message{
//	vCtrWhileParsing=vCtrRef;
//	[self showProgressHUD:message];
//	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//	NSURLConnection *con=[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
//	if(con){
//		myWebData=[[NSMutableData data] retain];
//	} else {
//		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//	}
//}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[self.myWebData setLength: 0];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.myWebData appendData:data];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	self.con=nil;
	[self hideProgressHUD];
//	[vCtrWhileParsing performSelector:@selector(webRequestReceivedData:) withObject:nil afterDelay:0.75];
    [self.vCtrWhileParsing webRequestReceivedData:nil];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
	self.con=nil;
    [self hideProgressHUD];
    
    [self.vCtrWhileParsing webRequestReceivedData:self.myWebData];
}

//-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//	if ([challenge previousFailureCount] == 0) {
//		NSURLCredential *cred = [[[NSURLCredential alloc] initWithUser:del.strUserName password:del.strPassword
//														   persistence:NSURLCredentialPersistenceForSession] autorelease];
//		[[challenge sender] useCredential:cred forAuthenticationChallenge:challenge];
//	} else {
//		[[challenge sender] cancelAuthenticationChallenge:challenge]; 
//	}
//}


- (void)hudWasHidden{
}

@end
