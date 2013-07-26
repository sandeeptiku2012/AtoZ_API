//
//  CommonParser.h
//  AtoZ
//
//  Created by Valtech on 11/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJSON.h"

@interface CommonParser : NSObject

@property (nonatomic, strong) NSDictionary *dStatus;
@property (nonatomic, strong) NSDictionary *dSession;
@property (nonatomic, strong) NSDictionary *dToken;
//Rajeev Start
@property (nonatomic, strong) NSDictionary *responseDetails;
//Rajeev End

@property (nonatomic, strong) NSString *strActiveToken;
@property (nonatomic, strong) NSString *strUserName;
@property (nonatomic, strong) NSString *strUserIP;
@property (nonatomic, strong) NSString *strActiveCriteria;

@property (nonatomic, strong) NSDictionary *jsonReponse;

+ (CommonParser*)commonParser;
- (void)parseData:(NSData*)data;

@end
