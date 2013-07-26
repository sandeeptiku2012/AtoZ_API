//
//  SettingsVctr.m
//  AtoZdatabases
//
//  Created by Ankit Vyas on 10/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsVctr.h"

@implementation SettingsVctr
@synthesize preTabBarCtr = _preTabBarCtr;
@synthesize aSheet = _aSheet;



- (void)viewDidUnload
{
	
	[self setASheet:nil];
	[self setPreTabBarCtr:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
//	NSUserDefaults *sDef = [NSUserDefaults standardUserDefaults];
//    if([sDef valueForKey:@"id"] && [sDef valueForKey:@"card"]) {
//        self.aSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to remove your library card & navigate to a list of AtoZdatabases subscriber near you?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"YES" otherButtonTitles:@"NO",nil];
//		[self.aSheet showFromTabBar:self.preTabBarCtr.tabBar];
//    } else {
//        ALERT(@"Message", @"No library card details stored.", @"OK", self, nil);
//    }

    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
//	NSUserDefaults *sDef = [NSUserDefaults standardUserDefaults];
//    if([sDef valueForKey:@"id"] && [sDef valueForKey:@"card"]) {
//        self.aSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to remove your library card & navigate to a list of AtoZdatabases subscriber near you?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"YES" otherButtonTitles:@"NO",nil];
//		[self.aSheet showFromTabBar:self.preTabBarCtr.tabBar];
//    } else {
//        ALERT(@"Message", @"No library card details stored.", @"OK", self, nil);
//    }

	[super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex==0) {
        NSUserDefaults *sDef = [NSUserDefaults standardUserDefaults];
        [sDef removeObjectForKey:@"library"];
        [sDef removeObjectForKey:@"card"];
        [sDef removeObjectForKey:@"lname"];
        [sDef removeObjectForKey:@"laddress"];
        [sDef removeObjectForKey:@"lphone"];
        [sDef removeObjectForKey:@"llogo"];
        [sDef removeObjectForKey:@"id"];
        [sDef synchronize];
        
        [self.navigationController popViewControllerAnimated:YES];
		[self.preTabBarCtr performSelector:@selector(backToRootViewController) withObject:nil afterDelay:0];

		}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

@end
