//
//  JSONParser.m
//  ProfilingApp
//
//  Created by digicorp on 11/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "JSONParser.h"
#import "SBJSON.h"
@interface JSONParser()
@property(nonatomic) SEL targetSelector;
@property(nonatomic,assign) NSObject *MainHandler;

@end

@implementation JSONParser

@synthesize targetSelector;
@synthesize MainHandler;


-(id)initWithRequest:(NSDictionary*)object sel:(SEL)seletor andHandler:(NSObject*)handler{
	
	self.MainHandler=handler;
	self.targetSelector=seletor;

	if((self = [super init]))
	{
		SBJSON *json = [[[SBJSON alloc] init] autorelease];
		NSString *strValue = [json stringWithObject:object];
		
		NSMutableURLRequest *theReq=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:WEB_SERVICE_URL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
		[theReq addValue: @"text/xml; charset=ISO-8859-1" forHTTPHeaderField:@"Content-Type"];
		[theReq setHTTPMethod:@"POST"];
		[theReq addValue:[NSString stringWithFormat:@"%i",[strValue length]] forHTTPHeaderField:@"Content-Length"];
		[theReq setHTTPBody:[strValue dataUsingEncoding:NSUTF8StringEncoding]];
		
		
		self.MainHandler=handler;
		self.targetSelector=seletor;
		con=[NSURLConnection connectionWithRequest:theReq delegate:self];
		if(con){
			myWebData=[[NSMutableData data] retain];
		} else {
			[MainHandler performSelector:targetSelector withObject:nil];
		}		
	}
	return self;	
}

-(id)initWithRequestString:(NSString*)object sel:(SEL)seletor andHandler:(NSObject*)handler{
	
	self.MainHandler=handler;
	self.targetSelector=seletor;
	
	if((self = [super init]))
	{
		
		NSMutableURLRequest *theReq=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:WEB_SERVICE_URL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
		[theReq addValue: @"text/xml; charset=ISO-8859-1" forHTTPHeaderField:@"Content-Type"];
		[theReq setHTTPMethod:@"POST"];
		[theReq addValue:[NSString stringWithFormat:@"%i",[object length]] forHTTPHeaderField:@"Content-Length"];
		[theReq setHTTPBody:[object dataUsingEncoding:NSUTF8StringEncoding]];
		
		
		self.MainHandler=handler;
		self.targetSelector=seletor;
		con=[NSURLConnection connectionWithRequest:theReq delegate:self];
		if(con){
			myWebData=[[NSMutableData data] retain];
		} else {
			[MainHandler performSelector:targetSelector withObject:nil];
		}		
	}
	return self;	
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[myWebData setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[myWebData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	//	[connection release];
	[MainHandler performSelector:targetSelector withObject:nil]; 
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString *responseString =[[NSString alloc] initWithData:myWebData encoding:NSUTF8StringEncoding];
	[myWebData release];
	NSError *error;
	SBJSON *json = [[SBJSON new] autorelease];
	id obj = [json objectWithString:responseString error:&error];
	[MainHandler performSelector:targetSelector withObject:obj];
	[responseString release];
}
@end
