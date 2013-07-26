//
//  dLogInVCtr.m
//  AtoZ
//
//  Created by Valtech on 11/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "dLogInVCtr.h"
#import "dLibVCtr.h"

@implementation dLogInVCtr

@synthesize location = _location;
@synthesize imgV = _imgV;
@synthesize imgVPortrait = _imgVPortrait;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *arOfImages = [NSArray arrayWithObjects:
                           [UIImage imageNamed:@"AtoZ Splash-RedBox_1.png"],
                           [UIImage imageNamed:@"AtoZ Splash-RedBox_2.png"],
                           [UIImage imageNamed:@"AtoZ Splash-RedBox_3.png"],
                           [UIImage imageNamed:@"AtoZ Splash-RedBox_4.png"],
                           [UIImage imageNamed:@"AtoZ Splash-RedBox_5.png"],
                           [UIImage imageNamed:@"AtoZ Splash-RedBox_6.png"],
                           [UIImage imageNamed:@"AtoZ Splash-RedBox_7.png"],
                           [UIImage imageNamed:@"AtoZ Splash-RedBox_8.png"],
                           [UIImage imageNamed:@"AtoZ Splash-RedBox_9.png"],
                           [UIImage imageNamed:@"AtoZ Splash-RedBox_10.png"]
                           ,nil];
    
    self.imgV.animationImages=arOfImages;
    self.imgV.animationDuration = 2.6;
    [self.imgV startAnimating];
    
    arOfImages = [NSArray arrayWithObjects:
                  [UIImage imageNamed:@"pAtoZ Splash-RedBox_1.png.png"], 
                  [UIImage imageNamed:@"pAtoZ Splash-RedBox_2.png.png"], 
                  [UIImage imageNamed:@"pAtoZ Splash-RedBox_3.png.png"], 
                  [UIImage imageNamed:@"pAtoZ Splash-RedBox_4.png.png"], 
                  [UIImage imageNamed:@"pAtoZ Splash-RedBox_5.png.png"], 
                  [UIImage imageNamed:@"pAtoZ Splash-RedBox_6.png.png"], 
                  [UIImage imageNamed:@"pAtoZ Splash-RedBox_7.png.png"], 
                  [UIImage imageNamed:@"pAtoZ Splash-RedBox_8.png.png"], 
                  [UIImage imageNamed:@"pAtoZ Splash-RedBox_9.png.png"], 
                  [UIImage imageNamed:@"pAtoZ Splash-RedBox_10.png.png"],
                  nil];
    
    self.imgVPortrait.animationImages=arOfImages;
    self.imgVPortrait.animationDuration = 2.6;
    [self.imgVPortrait startAnimating];
    
    [self performSelector:@selector(startLocation) withObject:nil afterDelay:5];
}

- (void)startLocation {
    if([ [[UIDevice currentDevice] systemVersion] hasPrefix:@"5" ] ) {
        self.location = [[CLLocationManager alloc] init];
        self.location.delegate = self;
        [self.location startUpdatingLocation];
    } else {
        [APP_DEL removeLogInScreen_AddSplitView];
    }
}

- (void)viewDidUnload {
    [self setImgVPortrait:nil];
    [super viewDidUnload];
}

#ifdef IOS_OLDER_THAN__IPHONE_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation)toInterfaceOrientation
{
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        self.imgVPortrait.hidden=YES;
    } else {
        self.imgVPortrait.hidden=NO;
    }
    return YES;
}
#endif

#ifdef IOS_NEWER_OR_EQUAL_TO__IPHONE_6_0
-(BOOL)shouldAutorotate
{
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        self.imgVPortrait.hidden=YES;
    } else {
        self.imgVPortrait.hidden=NO;
    }
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskAll);
}
#endif

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    if(UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
//        self.imgVPortrait.hidden=YES;
//    } else {
//        self.imgVPortrait.hidden=NO;
//    }
//    return YES;
//}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if(UIInterfaceOrientationIsLandscape([self interfaceOrientation])) {  
        self.imgVPortrait.hidden=YES;
    } else {
        self.imgVPortrait.hidden=NO;
    }
}



- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    [APP_DEL removeLogInScreen_AddSplitView];
    self.location.delegate=nil;
    self.location=nil;
}

-(void)getAdrressFromLatLong : (CGFloat)lat lon:(CGFloat)lon{
    NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=false",lat,lon];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    NSURLResponse *response = nil;
    NSError *requestError = nil;    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    NSString *responseString = [[NSString alloc] initWithData: responseData encoding:NSUTF8StringEncoding];
    
    if ([responseString length]>0) {
        
        if ([[[responseString JSONValue] valueForKey:@"status"] isEqualToString:@"OK"] ) {
            NSArray *resultsArray = [[responseString JSONValue] valueForKey:@"results"];
            NSString *zip = nil;
            
            if ([resultsArray count]>0) {
                NSArray *resultComponents = [[resultsArray objectAtIndex:0] valueForKey:@"address_components"];
                for (NSDictionary *dForComponents in resultComponents) {
                    if([[dForComponents valueForKey:@"types"] containsObject:@"postal_code"]) {
                        zip = [dForComponents valueForKey:@"long_name"];
                    }
                }
            }
            if(zip && zip.length>0){
                [(dLibVCtr*)[APP_DEL vCtrLib] setStrZip:zip];
                [APP_DEL removeLogInScreen_AddSplitView];
            } else {
                // 46923
                [(dLibVCtr*)[APP_DEL vCtrLib] setStrZip:@"46923"];
                [APP_DEL removeLogInScreen_AddSplitView];
            }
            
        } else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle: @"Message"
                                                               message: @"Unknown Location."
                                                              delegate:nil
                                                     cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
            [alertView show];
        }
    }
}

// 34.0506927, -118.2594762

- (void)pushNextView:(NSString*)usingZipCode {
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    ALERT(@"Message", @"To access AtoZdatabases through this Application, enable Location Services in your settings on your iPad", @"OK", self, nil);
}

@end
