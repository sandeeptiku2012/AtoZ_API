//
//  AppDelegate.m
//  AtoZ
//
//  Created by Valtech on 11/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "dLogInVCtr.h"
#import "dLibVCtr.h"
#include "EasyTracker.h"

/******* Set your tracking ID here *******/
static NSString *const kTrackingId = @"UA-19718876-1";
static NSString *const kTrackingId1 = @"UA-19718876-1";
//UA-19718876-1
@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize splitViewController = _splitViewController;
@synthesize vCtr = _vCtr;
@synthesize vCtrLib = _vCtrLib;
@synthesize strToken = _strToken;
@synthesize objMan = _objMan;
@synthesize nxtTabBarCtr = _nxtTabBarCtr;
@synthesize clatitude = _clatitude;
@synthesize clongitude = _clongitude;
@synthesize isBackFromSearch;
@synthesize tracker = tracker_;
@synthesize viewController = _viewController;
@synthesize tokenParamsDic = _tokenParamsDic;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //New Google Analytics
    [GAI sharedInstance].debug = YES;
    [GAI sharedInstance].dispatchInterval = 20;
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:kTrackingId1];

    //Token Params
    self.tokenParamsDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TokenParams" ofType:@"plist"]];
    
    
    //Universal Google Analytics
    [EasyTracker launchWithOptions:launchOptions withParameters:nil withError:nil];
    self.objMan = [[HJObjManager alloc] initWithLoadingBufferSize:6 memCacheSize:20];
    NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/imgcache/ImageGrid/"] ;
    HJMOFileCache* fileCache = [[HJMOFileCache alloc] initWithRootPath:cacheDirectory] ;
    self.objMan.fileCache = fileCache;
    
    // Have the file cache trim itself down to a size & age limit, so it doesn't grow forever
    fileCache.fileCountLimit = 100;
    fileCache.fileAgeLimit = 60*60*24*7; //1 week
    [fileCache trimCacheUsingBackgroundThread];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[SplashViewController alloc] initWithNibName:@"SplashViewController" bundle:nil];
        self.nxtTabBarCtr = [[TabBarCtr alloc] initWithNibName:@"TabBarCtr" bundle:nil];
		self.viewController.view.frame=CGRectMake(0, 20, 320, 460);
        [self.window addSubview:self.viewController.view];
    } else {
        self.vCtr = [[dLogInVCtr alloc] initWithNibName:@"dLogInVCtr" bundle:nil];
        self.vCtrLib = [[dLibVCtr alloc] initWithNibName:@"dLibVCtr" bundle:nil];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.vCtrLib];
        //Rajeev Start
        self.window.rootViewController = self.vCtr;
        //Rajeev End
        [self.window addSubview:self.vCtr.view];
        [iNetMngr setView:self.vCtr.view];
    }
    [self.window makeKeyAndVisible];
    return YES;
}

#ifdef IOS_NEWER_OR_EQUAL_TO__IPHONE_6_0
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskAll;
}
#endif

// portrait 1, pud 2, ll 3,lr 4
- (void)removeLogInScreen_AddSplitView {
    CATransition *tr=[CATransition animation];
    tr.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    tr.type=kCATransitionFade;
    tr.delegate=self;
    tr.duration=0.85;
    [iNetMngr setView:self.navigationController.view];
    [self.vCtr.view addSubview:self.navigationController.view];
    [self performSelector:@selector(removeFromLogIn) withObject:nil afterDelay:0.85];
    
    [self.window.layer addAnimation:tr forKey:nil];
}
- (void)removeFromLogIn {
    [self.splitViewController.view removeFromSuperview];
    [self.vCtr.view removeFromSuperview];
    [self.navigationController.view removeFromSuperview];
    
    //Rajeev Start
    self.window.rootViewController = self.navigationController;
    //Rajeev End
    [self.window addSubview:self.navigationController.view];
    [iNetMngr setView:self.navigationController.view];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)applicationWillResignActive:(UIApplication *)application {
//    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"Application_Enter_BG" object:nil]];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
//    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"Application_Enter_BG" object:nil]];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

// iphone methods
-(void)SplashScreenCompleted
{
	[self.viewController.view removeFromSuperview];
	MasterViewController *masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
	self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    [self.navigationController setNavigationBarHidden:YES];
	[self.window addSubview:self.navigationController.view];
    [iNetMngr setView:self.navigationController.view];
}

@end
