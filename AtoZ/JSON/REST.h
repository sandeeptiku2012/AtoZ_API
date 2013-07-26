//
//  REST.h
//  For Sale
//
//  Created by digicorp on 14/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"

@interface REST : NSObject {
	NSMutableData *responseData;
	NSURL *theUrl;	
}
-(void)getCurrentIssue:(SEL)selector andHandler:(NSObject*)handler;

@end
