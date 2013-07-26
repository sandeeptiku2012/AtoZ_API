//
//  JSONParser.h
//  ProfilingApp
//
//  Created by digicorp on 11/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JSONParser : NSObject {
	NSURLConnection *con;
	NSMutableData *myWebData;
	SEL targetSelector;
	NSObject *MainHandler;
}
-(id)initWithRequest:(NSDictionary*)object sel:(SEL)seletor andHandler:(NSObject*)handler;
-(id)initWithRequestString:(NSString*)object sel:(SEL)seletor andHandler:(NSObject*)handler;
@end
