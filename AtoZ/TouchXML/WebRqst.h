//
//  WebRqst.h
//  DigiCamp
//
//  Created by digicorp on 15/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface UIViewController(WebRqst)
-(void)webRequestReceivedData:(NSData*)data;
@end


@class AppDelegate;
@interface WebRqst : NSObject <MBProgressHUDDelegate> 
@property (nonatomic,strong) MBProgressHUD *mbProcess;
@property (nonatomic,assign) UIViewController *vCtrWhileParsing;
@property (nonatomic,assign) AppDelegate *del;
@property (nonatomic,strong) NSMutableData *myWebData;
@property (nonatomic,strong) NSURLConnection *con;
@property (nonatomic,strong) UIAlertView *av;
@property (nonatomic,strong) NSString *restValue;
@property (nonatomic,strong) UIActivityIndicatorView *actV;
@property (nonatomic,strong) UIView *vIhoneLoadingScreen;
//Rajeev Start
@property (nonatomic, assign) enum SERVICE_TYPE eService_type;
//Rajeev End

-(void)showProgressHUD:(NSString*)message title:(NSString*)title;
-(void)hideProgressHUD;

//-(void)startLoading:(NSMutableURLRequest*)urlRequest vCtr:(UIViewController*)vCtrRef message:(NSString*)message;

-(void)startLoadingRestValue:(NSString*)restValue vCtr:(UIViewController*)vCtrRef title:(NSString*)title message:(NSString*)message;

@end
