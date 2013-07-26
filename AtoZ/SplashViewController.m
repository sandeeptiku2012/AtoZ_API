//
//  SplashViewController.m
//  AtoZdatabases
//
//  Created by Ankit Vyas on 14/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SplashViewController.h"

@implementation SplashViewController

@synthesize location = _location;
@synthesize imgV = _imgV;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *arOfImages = [NSArray arrayWithObjects:
                  [UIImage imageNamed:@"ipAtoZ Splash-RedBox_1.png.png"], 
                  [UIImage imageNamed:@"ipAtoZ Splash-RedBox_2.png.png"], 
                  [UIImage imageNamed:@"ipAtoZ Splash-RedBox_3.png.png"], 
                  [UIImage imageNamed:@"ipAtoZ Splash-RedBox_4.png.png"], 
                  [UIImage imageNamed:@"ipAtoZ Splash-RedBox_5.png.png"], 
                  [UIImage imageNamed:@"ipAtoZ Splash-RedBox_6.png.png"], 
                  [UIImage imageNamed:@"ipAtoZ Splash-RedBox_7.png.png"], 
                  [UIImage imageNamed:@"ipAtoZ Splash-RedBox_8.png.png"], 
                  [UIImage imageNamed:@"ipAtoZ Splash-RedBox_9.png.png"], 
                  [UIImage imageNamed:@"ipAtoZ Splash-RedBox_10.png.png"],
                  nil];
    
    self.imgV.animationImages=arOfImages;
    self.imgV.animationDuration = 2.6;
    [self.imgV startAnimating];
    [self performSelector:@selector(startLocation) withObject:nil afterDelay:5];
}

- (void)startLocation {
    if([ [[UIDevice currentDevice] systemVersion] hasPrefix:@"5" ] ) {
        self.location = [[CLLocationManager alloc] init];
        self.location.delegate = self;
        [self.location startUpdatingLocation];
    } else {
        [APP_DEL SplashScreenCompleted];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    [APP_DEL SplashScreenCompleted];
    self.location.delegate=nil;
    self.location=nil;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    ALERT(@"Message", @"To access AtoZdatabases through this Application, enable Location Services in your settings on your iPad", @"OK", self, nil);
}

@end
