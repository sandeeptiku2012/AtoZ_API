//
//  PhoneViewController.h
//  AtoZdatabases
//
//  Created by Ankit Vyas on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ResultViewController;
#import "GAITrackedViewController.h"
@interface PhoneViewController : GAITrackedViewController{
	BOOL isBackFromSearchPage;
}

@property (nonatomic, strong) ResultViewController *predRcrdVCtr;
@property (assign, nonatomic) IBOutlet TabBarCtr *preTabBarCtr;
@property (strong, nonatomic) IBOutlet UITextField *txtMobile;
@property (nonatomic,strong) ResultViewController *nxtResultViewController;

-(IBAction)searchTapped:(id)sender;
- (void)searchByText:(NSString*)sender;
@end
