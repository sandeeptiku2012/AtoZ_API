//
//  SplashViewController.h
//  AtoZdatabases
//
//  Created by Ankit Vyas on 14/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SplashViewController : UIViewController <UIAlertViewDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *location;
@property (strong, nonatomic) IBOutlet UIImageView *imgV;

@end
