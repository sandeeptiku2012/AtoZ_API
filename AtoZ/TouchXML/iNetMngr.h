//
//  Global.h
//  DigiCamp
//
//  Created by digicorp on 15/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class WebRqst;
@interface iNetMngr : NSObject {

}
+(WebRqst*)requestObject;
+(UIView*)view;
+(void)setView:(UIView*)setV;

+(void)startLoadingRestValue:(NSString*)restValue vCtr:(UIViewController*)vCtrRef title:(NSString*)title message:(NSString*)message;
+ (void)getNearByLibraries:(UIViewController*)vCtr zipCode:(NSString*)zipCode ;
+ (void)authenticateCard:(NSString*)cardNo libraryAccountNo:(NSString*)accountNo vCtrRef:(UIViewController*)vCtr;

+ (void)setRqstUserName:(UIViewController*)vCtrRef userName:(NSString*)userName;
+ (void)setRqstIP:(UIViewController*)vCtrRef ip:(NSString*)ip;
+ (void)setRqstDBToCombine:(UIViewController*)vCtrRef;
+ (void)setRqstCriteria:(UIViewController*)vCtrRef criteriaField:(NSString*)criteriaField criteriaValue:(NSString*)criteriaValue;
+ (void)getRecords:(UIViewController*)vCtrRef pageNumber:(NSString*)pageNumber numberOfRecords:(NSString*)numberOfRecords;

+ (void)getStates:(UIViewController*)vCtrRef;

+ (void)createToken:(UIViewController*)vCtrRef;
+ (void)createYearsListRelatedToRevenueTrend:(UIViewController*)vCtrRef;
+ (void)createSession:(UIViewController*)vCtrRef;
+ (void)setRqstUserName:(UIViewController*)vCtrRef userName:(NSString*)userName;
//Rajeev Start
+ (void)getDetails:(UIViewController*)vCtrRef withAPI:(NSString *) serverAPI;
//Rajeev End

+(NSMutableURLRequest*)urlRequestAction:(NSString*)sa_Name message:(NSString*)sm_msg;
+(NSString*)SA_synchronise;
+(NSString*)SM_synchronise;

+(NSString*)SA_SearchAction;
+(NSString*)SM_Search_BrandID:(NSString*)brandID modelID:(NSString*)modelID From:(NSString*)from to:(NSString*)to countryID:(NSString*)countryID;

+(NSString*)SA_ModelImages;
+(NSString*)SM_ModelImages:(NSString*)modelID;
+(NSMutableArray*)arrayOfImages;

+(NSString*)SA_FavouriteRefresh;
+(NSString*)SM_FavouriteRefreshModelIDs:(NSString*)modelIDs;
void ALERT(NSString *title, NSString *message,NSString *canceBtnTitle,id delegate,NSString *otherButtonTitles, ... );

+ (CLLocationCoordinate2D) geoCodeUsingAddress: (NSString *) address;
@end
