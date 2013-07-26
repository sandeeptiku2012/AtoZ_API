//
//  AppDelegate.h
//  AtoZ
//
//  Created by Valtech on 11/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "HJObjManager.h"
#import "GAI.h"

// iPhone Imports
#import "SplashViewController.h"
#import "MasterViewController.h"
#import "TabBarCtr.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property BOOL isBackFromSearch;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UISplitViewController *splitViewController;
@property (strong, nonatomic) UIViewController *vCtr;
@property (strong, nonatomic) UIViewController *vCtrLib;
@property (strong, nonatomic) NSString *strToken;
@property (nonatomic, strong) HJObjManager* objMan;
@property (nonatomic, readwrite) float clatitude,clongitude;
@property (strong, nonatomic) NSDictionary *tokenParamsDic;
- (void)removeLogInScreen_AddSplitView;

// common variables for iPhone & ipad
@property (strong, nonatomic) UINavigationController *navigationController;

// iphone variables
@property (strong, nonatomic) SplashViewController *viewController;
@property (strong, nonatomic) TabBarCtr *nxtTabBarCtr;
//@property (strong, nonatomic) UITabBarController *tCtr;
@property(nonatomic, retain) id<GAITracker> tracker;
-(void)SplashScreenCompleted;
@end
