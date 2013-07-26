//
//  TabBarCtr.m
//  AtoZdatabases
//
//  Created by Spark on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TabBarCtr.h"
#import "BusinessViewController.h"
#import "PersonViewController.h"
#import "CategoryViewController.h"
#import "PhoneViewController.h"
#import "SettingsVctr.h"

@implementation TabBarCtr
@synthesize lblTitle;
@synthesize arForStates = _arForStates;
@synthesize tabBar = _tabBar;
@synthesize nxtBusinessViewController = _nxtBusinessViewController;
@synthesize nxtPersonViewController = _nxtPersonViewController;
@synthesize nxtCategoryViewController = _nxtCategoryViewController;
@synthesize nxtPhoneViewController = _nxtPhoneViewController;
@synthesize imgVHShadow = _imgVHShadow;
@synthesize pLibVctr = _pLibVctr;
@synthesize btnSetting = _btnSetting;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBar.selectedItem=[[self.tabBar items] objectAtIndex:0];
	
	[self.tabBar selectedItem];
    [self.view bringSubviewToFront:self.imgVHShadow];
    self.lblTitle.text = @"Find a Business";
	
}
-(void)viewWillAppear:(BOOL)animated{
	NSUserDefaults *sDef = [NSUserDefaults standardUserDefaults];
    if([sDef valueForKey:@"id"] && [sDef valueForKey:@"card"]) {
		self.btnSetting.hidden=NO;
	}else
		self.btnSetting.hidden=YES;
	self.tabBar.selectedItem=[[self.tabBar items] objectAtIndex:selectedTabIndex];
	AppDelegate *appdel=[[UIApplication sharedApplication] delegate];
	if ([appdel isBackFromSearch]==YES) {
		appdel.isBackFromSearch = NO;
		switch (selectedTabIndex) {
				
			case 0:
				
				[self.tabBar selectedItem];
				self.nxtBusinessViewController.view.frame=CGRectMake(0, 44, 320, 367);
				[self.view addSubview:self.nxtBusinessViewController.view];
				self.lblTitle.text = @"Find a Business";
				[self.nxtBusinessViewController viewWillAppear:YES];
				break;
			case 1:
				
				self.nxtPersonViewController.view.frame=CGRectMake(0, 44, 320, 367);
				[self.view addSubview:self.nxtPersonViewController.view];
				self.lblTitle.text = @"Find a Person";
				[self.nxtPersonViewController viewWillAppear:YES];
				break;
				
			case 2:
				
				self.nxtCategoryViewController.view.frame=CGRectMake(0, 44, 320, 367);
				[self.view addSubview:self.nxtCategoryViewController.view];
				self.lblTitle.text = @"Search by Category";
				[self.nxtPersonViewController viewWillAppear:YES];
				break;	
				
			case 3:
				
				self.nxtPhoneViewController.view.frame=CGRectMake(0, 44, 320, 367);
				[self.view addSubview:self.nxtPhoneViewController.view];
				self.lblTitle.text = @"Search by Phone";
				[self.nxtPhoneViewController viewWillAppear:YES];
				break;	
				
			default:
				break;
		}

	}else{
		self.tabBar.selectedItem=[[self.tabBar items] objectAtIndex:0];
		[self.tabBar selectedItem];
		self.nxtBusinessViewController.view.frame=CGRectMake(0, 44, 320, 367);
       
		[self.view addSubview:self.nxtBusinessViewController.view];
        [self.nxtBusinessViewController.txtBName resignFirstResponder];
        [self.nxtBusinessViewController.txtState resignFirstResponder];
        [self.nxtBusinessViewController.txtCity resignFirstResponder];
		self.lblTitle.text = @"Find a Business";
		[self.nxtBusinessViewController viewWillAppear:YES];
	}


		
	[super viewWillAppear:animated];
}
- (IBAction)btnSettingsTapped:(id)sender {
	NSUserDefaults *sDef = [NSUserDefaults standardUserDefaults];
    if([sDef valueForKey:@"id"] && [sDef valueForKey:@"card"]) {
        UIActionSheet *act = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to remove your library card & navigate to a list of AtoZdatabases subscriber near you?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"YES" otherButtonTitles:@"NO",nil];
		[act showFromTabBar:self.tabBar];
    } else {
        ALERT(@"Message", @"No library card details stored.", @"OK", self, nil);
    }
}

-(IBAction)btnBacktapped:(id)sender{	
	MasterViewController *mVCtr =[[self.navigationController viewControllers] objectAtIndex:0];
	[mVCtr getNearByLibraries];
	[self.navigationController popToViewController:mVCtr animated:YES];
}
- (IBAction)infobuttonTapped:(id)sender {
	AboutVctr *abt=[[AboutVctr alloc] initWithNibName:@"AboutVctr" bundle:nil];
	UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:abt];
	nav.navigationBarHidden=YES;
	[self.navigationController presentModalViewController:nav animated:YES];
}
- (void)viewDidUnload
{
	[self setBtnSetting:nil];
	[self setPLibVctr:nil];
    [self setLblTitle:nil];
    [self setTabBar:nil];
    [self setNxtBusinessViewController:nil];
    [self setNxtPersonViewController:nil];
    [self setNxtCategoryViewController:nil];
    [self setNxtPhoneViewController:nil];
    [self setArForStates:nil];
    [self setImgVHShadow:nil];
    [super viewDidUnload];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSUInteger index = [[tabBar items] indexOfObject:item];
    [self.nxtBusinessViewController.view removeFromSuperview];
    [self.nxtCategoryViewController.view removeFromSuperview];
    [self.nxtPersonViewController.view removeFromSuperview];
    [self.nxtPhoneViewController.view removeFromSuperview];
	selectedTabIndex = index;
    switch (index) {
        case 0:
            // Find a business
            self.nxtBusinessViewController.view.frame=CGRectMake(0, 44, 320, 367);
            [self.view addSubview:self.nxtBusinessViewController.view];
            self.lblTitle.text = @"Find a Business";
			[self.nxtBusinessViewController viewWillAppear:YES];
            break;
        case 1:
            // Find a person
            self.nxtPersonViewController.view.frame=CGRectMake(0, 44, 320, 367);
            [self.view addSubview:self.nxtPersonViewController.view];
            self.lblTitle.text = @"Find a Person";
			[self.nxtPersonViewController viewWillAppear:YES];
            break;
        case 2:
            // Search by category
            self.nxtCategoryViewController.view.frame=CGRectMake(0, 44, 320, 367);
            [self.view addSubview:self.nxtCategoryViewController.view];
            self.lblTitle.text = @"Search by Category";
			[self.nxtCategoryViewController viewWillAppear:YES];
            break;
        case 3:
            // Search by phone
            self.nxtPhoneViewController.view.frame=CGRectMake(0, 44, 320, 367);
            [self.view addSubview:self.nxtPhoneViewController.view];
            self.lblTitle.text = @"Search by Phone";
            break;
//		case 4:
//			//settings
//			self.nxtSettingsVctr.view.frame=CGRectMake(0, 44, 320, 367);
//			[self.view ad+dSubview:self.nxtSettingsVctr.view];
//			self.lblTitle.text=@"Settings";
//			[self.nxtSettingsVctr viewDidLoad];
//			[self performSelector:@selector(checkSetting)];
//			break;
        default:
            break;
    }
    [self.view bringSubviewToFront:self.imgVHShadow];
}

- (void)checkSetting
{
	NSUserDefaults *sDef = [NSUserDefaults standardUserDefaults];
    if([sDef valueForKey:@"id"] && [sDef valueForKey:@"card"]) {
        UIActionSheet *act = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to remove your library card & navigate to a list of AtoZdatabases subscriber near you?" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"YES" otherButtonTitles:@"NO",nil];
		[act showFromTabBar:self.tabBar];
    } else {
        ALERT(@"Message", @"No library card details stored.", @"OK", self, nil);
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	self.tabBar.selectedItem=[[self.tabBar items] objectAtIndex:0];
	[self.tabBar selectedItem];
	self.nxtBusinessViewController.view.frame=CGRectMake(0, 44, 320, 367);
	[self.view addSubview:self.nxtBusinessViewController.view];
	self.lblTitle.text = @"Find a Business";

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
		[self btnBacktapped:nil];
	}else if (buttonIndex==1){
		
		self.tabBar.selectedItem=[[self.tabBar items] objectAtIndex:0];
		[self.tabBar selectedItem];
		self.nxtBusinessViewController.view.frame=CGRectMake(0, 44, 320, 367);
		[self.view addSubview:self.nxtBusinessViewController.view];
		self.lblTitle.text = @"Find a Business";

		
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

@end
