//
//  REST.m
//  For Sale
//
//  Created by digicorp on 14/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "REST.h"
#import "JSONParser.h"


@implementation REST

-(void)getCurrentIssue:(SEL)selector andHandler:(NSObject*)handler{
	
//	NSString *str=[NSString stringWithFormat:@"{\"request\":\"%@\",\"para\":{\"username\":\"%@\",\"password\":\"%@\",\"magazine_id\":\"%@\"}}",@"content/get_content_data",USERNAME,PASSWORD,@"53"];
//	//NSLog(@"request is %@",str);
//	[[[JSONParser alloc] initWithRequestString:str sel:selector andHandler:handler] autorelease];
}
// {\"request\":\"content/get_content_data\",\"para\":{\"username\":\"t\",\"password\":\"t\",\"magazine_id\":\"60\"}}
@end
