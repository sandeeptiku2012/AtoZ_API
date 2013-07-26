//
//  dLogInVCtr.h
//  AtoZ
//
//  Created by Valtech on 11/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
@interface dLogInVCtr : UIViewController <UITextFieldDelegate,UIAlertViewDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *location;
@property (strong, nonatomic) IBOutlet UIImageView *imgV;
@property (strong, nonatomic) IBOutlet UIImageView *imgVPortrait;

-(void)getAdrressFromLatLong : (CGFloat)lat lon:(CGFloat)lon;

@end
