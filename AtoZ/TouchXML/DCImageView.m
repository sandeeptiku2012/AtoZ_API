//
//  DCImageView.m
//  asyTblDemo
//
//  Created by digicorp on 12/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DCImageView.h"
#import <MobileCoreServices/MobileCoreServices.h>
BOOL isA3GSorHigher;

@implementation DCImageView

@synthesize dRef;
@synthesize ip;
@synthesize tableRef;
@synthesize strURL;
@synthesize myWebData;
@synthesize imgV;
@synthesize strURL2;

#define SOURCETYPE UIImagePickerControllerSourceTypeCamera

+(void)initialize{
	Class aMsgClass = NSClassFromString(@"MFMessageComposeViewController");
	if(aMsgClass && [UIImagePickerController isSourceTypeAvailable:SOURCETYPE]){
		NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:SOURCETYPE];
		bool isA3GS = [mediaTypes containsObject:kUTTypeMovie];
		isA3GSorHigher=isA3GS;
	}
}


+(void)loadURLImage:(NSString*)urlStringValue dictionaryRef:(NSMutableDictionary*)dRef indexPath:(NSIndexPath*)indexPath tableViewRef:(UITableView*)tableViewRef{
	
	NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
	if([defaults stringForKey:urlStringValue]){
		NSString *str=[defaults stringForKey:urlStringValue];
		NSData *data=[NSData dataWithContentsOfFile:str];
		[dRef setObject:@"localLoading" forKey:@"cell"];
		[dRef setObject:[UIImage imageWithData:data] forKey:@"mywebdata"];
		
		if(isA3GSorHigher){
			[tableViewRef reloadData];
		} else {
			[tableViewRef performSelector:@selector(reloadRowsAtIndexPaths:withRowAnimation:) withObject:[NSArray arrayWithObject:indexPath] afterDelay:0.5];
		}
	} else {
		DCImageView *dc=[[DCImageView alloc] init];
		dc.dRef=dRef;
		dc.ip=indexPath;
		dc.tableRef=tableViewRef;
		dc.strURL2=urlStringValue;
		dc.strURL=urlStringValue;
		dc.imgV=nil;
		[dRef setObject:dc forKey:@"cell"];
		[dc release]; dc=nil;
	}
}

+(void)loadURLImage:(NSString*)urlStringValue dictionaryRef:(NSMutableDictionary*)dRef imgVRef:(UIImageView*)imgVRef{
	NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
	if([defaults stringForKey:urlStringValue]){
		NSString *str=[defaults stringForKey:urlStringValue];
		NSData *data=[NSData dataWithContentsOfFile:str];
		[dRef setObject:@"localLoading" forKey:@"cell"];
		[dRef setObject:[UIImage imageWithData:data] forKey:@"mywebdata"];
		[imgVRef setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:str]]];
	} else {
		DCImageView *dc=[[DCImageView alloc] init];
		dc.dRef=dRef;
		dc.ip=nil;
		dc.tableRef=nil;
		dc.strURL2=urlStringValue;
		dc.strURL=urlStringValue;
		dc.imgV=imgVRef;
		[dRef setObject:dc forKey:@"cell"];
		[dc release]; dc=nil;
	}
}

-(void)setStrURL:(NSString *)urlInStringFormat{
	NSURLConnection *con=[[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlInStringFormat]] delegate:self];
	if(con){
		myWebData=[[NSMutableData data] retain];
	} else {
	}	
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[myWebData setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[myWebData appendData:data];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[connection release];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
	[dRef setObject:[UIImage imageWithData:myWebData] forKey:@"mywebdata"];
	if(tableRef &&[tableRef canPerformAction:@selector(reloadRowsAtIndexPaths:withRowAnimation:) withSender:[NSArray arrayWithObject:ip]] && ip){
		(isA3GSorHigher)?[tableRef reloadRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationBottom]:[tableRef performSelector:@selector(reloadRowsAtIndexPaths:withRowAnimation:) withObject:[NSArray arrayWithObject:ip] afterDelay:0.5];
		
	} else if(imgV && [imgV canPerformAction:@selector(setImage:) withSender:[UIImage imageWithData:myWebData]])
		[imgV setImage:[UIImage imageWithData:myWebData]];
	
	NSString *fileName=[[strURL2 componentsSeparatedByString:@"/"] lastObject];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	NSString *path=[basePath stringByAppendingPathComponent:fileName];
	
	[myWebData writeToFile:path atomically:YES];
	
	NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
	[defaults setValue:path forKey:strURL2];
	[defaults synchronize];
	
//	HTTP:__WWW.MYGULFCAR.COM_USERFILES_PRODUCT_LARGE_6471_100_2403.jpg
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


-(void)dealloc{
	if(tableRef!=nil && [tableRef retainCount]>0) { [tableRef release]; tableRef=nil; }
	if(imgV!=nil && [imgV retainCount]>0) { [imgV release]; imgV=nil; }
	if(dRef!=nil && [dRef retainCount]>0) { [dRef release]; dRef=nil; }
	if(ip!=nil && [ip retainCount]>0) { [ip release]; ip=nil; }
	[super dealloc];
}

@end


