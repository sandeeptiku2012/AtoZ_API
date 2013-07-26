//
//  CommonParser.m
//  AtoZ
//
//  Created by Valtech on 11/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CommonParser.h"

@interface CommonParser ()

@end

@implementation CommonParser

static CommonParser *commonparserObj;
@synthesize dStatus = _dStatus;
@synthesize dSession = _dSession;
@synthesize dToken = _dToken;
@synthesize responseDetails = _responseDetails;

@synthesize strActiveToken = _strActiveToken;
@synthesize strUserName = _strUserName;
@synthesize strUserIP = _strUserIP;
@synthesize strActiveCriteria = _strActiveCriteria;

@synthesize jsonReponse = _jsonReponse;

+(void)initialize {
    commonparserObj = [[CommonParser alloc] init];
}

+(CommonParser*)commonParser{
    return commonparserObj;
}

- (void)parseData:(NSData*)data{
    self.dStatus=nil;
    self.dToken=nil;
    self.dSession=nil;
    self.jsonReponse=nil;
    
    if(!data) return;
    
    // log response
    NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    //NSLog(@"response is %@",str);
    
    // set jsonResponse
    self.jsonReponse=[str JSONValue];

}

@end


//    // create document
//    CXMLDocument *doc=[[CXMLDocument alloc] initWithData:data options:0 error:nil];
//    
//    // get status details
//    NSArray *nodes=nil;
//	nodes=[doc nodesForXPath:[NSString stringWithFormat:@"//status/*"] error:nil];
//	NSString *strValue;
//	NSString *strName;
//    NSMutableDictionary *dForStatus=[NSMutableDictionary dictionary];
//    for (CXMLElement *node in nodes) {
//        if([node stringValue] && [[node stringValue] length]>0 && [node name] && [[node name] length]>0) {
//            strName=[node name];
//            strValue=[node stringValue];
//            [dForStatus setValue:strValue forKey:strName];
//        }
//    }
//    self.dStatus=dForStatus;
//    
//    // get token details
//    nodes=[doc nodesForXPath:[NSString stringWithFormat:@"//token/*"] error:nil];
//    NSMutableDictionary *dForToken=[NSMutableDictionary dictionary];
//    for (CXMLElement *node in nodes) {
//        if([node stringValue] && [[node stringValue] length]>0 && [node name] && [[node name] length]>0) {
//            strName=[node name];
//            strValue=[node stringValue];
//            [dForToken setValue:strValue forKey:strName];
//        }
//    }
//    self.dToken=dForToken;