//
//  DCImageView.h
//  asyTblDemo
//
//  Created by digicorp on 12/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DCImageView : UIView {
	NSString *strURL;
	NSMutableDictionary *dRef;
	NSIndexPath *ip;
	UITableView *tableRef;	
	NSMutableData *myWebData;
	UIImageView *imgV;
	NSString *strURL2;
}
@property(nonatomic,retain) NSMutableData *myWebData;
@property(nonatomic,retain) NSString *strURL;
@property(nonatomic,retain) NSMutableDictionary *dRef;
@property(nonatomic,retain) NSIndexPath *ip;
@property(nonatomic,retain) UITableView *tableRef;
@property(nonatomic,retain) UIImageView *imgV;
@property(nonatomic,retain) NSString *strURL2;

+(void)loadURLImage:(NSString*)urlStringValue dictionaryRef:(NSMutableDictionary*)dRef indexPath:(NSIndexPath*)indexPath tableViewRef:(UITableView*)tableViewRef;

+(void)loadURLImage:(NSString*)urlStringValue dictionaryRef:(NSMutableDictionary*)dRef imgVRef:(UIImageView*)imgVRef;

@end



//-(void)setStrURL:(NSString *)urlInStringFormat mutableArrayRef{
//	NSURLConnection *con=[[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlInStringFormat]] delegate:self];
//	if(con){
//		myWebData=[[NSMutableData data] retain];
//	} else {
//	}	
//}
//
//-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//	[myWebData setLength: 0];
//}
//
//-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//	[myWebData appendData:data];
//	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//}
//
//-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
//	[connection release];
//	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//}
//
//-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
//	[connection release];
//	self.image=[UIImage imageWithData:myWebData];
//	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//}



