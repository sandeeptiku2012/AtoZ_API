//
//  dSrchPhone.h
//  AtoZ
//
//  Created by Valtech on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@class dRcrdVCtr;

@interface dSrchPhone : GAITrackedViewController

@property (nonatomic, assign) dRcrdVCtr *predRcrdVCtr;
@property (strong, nonatomic) IBOutlet UITextField *txtMobile;

-(void)searchTapped:(id)sender;
- (void)searchByText:(NSString*)sender;

@end
