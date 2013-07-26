//
//  DetailViewController.m
//  AtoZdatabases
//
//  Created by Ankit Vyas on 14/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "Lib_Auth_ViewController.h"
#import "GAITracker.h"

@implementation DetailViewController
@synthesize VLibAuthCard = _VLibAuthCard;
@synthesize VGet_Staryted = _VGet_Staryted;

@synthesize lib_Auth_ViewController = _lib_Auth_ViewController;
@synthesize strName = _strName;
@synthesize strAddress = _strAddress;
@synthesize strPhone = _strPhone;
@synthesize lblAddress = _lblAddress;
@synthesize lblName = _lblName;
@synthesize exists = _exists;
@synthesize btnBack = _btnBack;
@synthesize imgVCallOut = _imgVCallOut;
@synthesize fromMap = _fromMap;
@synthesize strID = _strID;
@synthesize dOfLibrary = _dOfLibrary;

#pragma mark - Managing the detail item

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.VLibAuthCard.layer setCornerRadius:5.0];
	self.VLibAuthCard.layer.borderWidth = 1;
	self.VLibAuthCard.layer.borderColor = [[UIColor colorWithRed:27/255.0 green:152/255.0 blue:194/255.0 alpha:1] CGColor];
	
	[self.VGet_Staryted.layer setCornerRadius:5.0];
	self.VGet_Staryted.layer.borderWidth = 1;
	self.VGet_Staryted.layer.borderColor = [[UIColor colorWithRed:27/255.0 green:152/255.0 blue:194/255.0 alpha:1] CGColor];

}

- (void)viewDidUnload
{
	[self setVGet_Staryted:nil];
	[self setVLibAuthCard:nil];
    [self setStrName:nil];
    [self setStrAddress:nil];
    [self setStrPhone:nil];
    [self setLblAddress:nil];
    [self setLblName:nil];
    [self setImgVCallOut:nil];
    [self setBtnBack:nil];
    [self setStrID:nil];
    [self setDOfLibrary:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSError *error = nil;
    [[GANTracker sharedTracker] trackPageview:@"Library Detail Page" withError:&error];
    self.trackedViewName=@"Library Detail Page";
	NSLog(@"%@",self.strPhone);
    self.lblAddress.text = [NSString stringWithFormat:@"%@\n%@",self.strAddress,self.strPhone];
    self.lblName.text = self.strName;
    self.VLibAuthCard.hidden=!(self.exists);
    self.imgVCallOut.hidden=!(self.strPhone && self.strPhone.length>0);
    //[self.btnBack setTitle:(self.fromMap)?@"  Map":@" List" forState:UIControlStateNormal];
}
- (IBAction)infobuttonTapped:(id)sender {
	AboutVctr *abt=[[AboutVctr alloc] initWithNibName:@"AboutVctr" bundle:nil];
	UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:abt];
	nav.navigationBarHidden=YES;
	[self.navigationController presentModalViewController:nav animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return  UIInterfaceOrientationIsPortrait(interfaceOrientation);
}
							
- (IBAction)BackTapped:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)LibAuthTapped:(id)sender {
	self.lib_Auth_ViewController=[[Lib_Auth_ViewController alloc] initWithNibName:@"Lib_Auth_ViewController" bundle:nil];
    self.lib_Auth_ViewController.strAddress = self.strAddress;
    self.lib_Auth_ViewController.strID = self.strID;
    self.lib_Auth_ViewController.strName = self.strName;
    self.lib_Auth_ViewController.strPhone = self.strPhone;
	self.lib_Auth_ViewController.dforLibrary=self.dOfLibrary;
	[self.navigationController pushViewController:self.lib_Auth_ViewController animated:YES];
}

- (IBAction)GetStartedTapped:(id)sender {
    [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:@"Library Detail"
        withAction:@"TrackEvent"
        withLabel:self.strName
        withValue:[NSNumber numberWithInt:2]];
    NSError *error = nil;
    if (![[GANTracker sharedTracker] trackEvent:@"Get Started Tapped"
        action:@"TrackEvent"
        label:self.strName
        value:-1
        withError:&error]) {
        NSLog(@"Error Occured ==>%@",error);
    }
	// go to search screen
    [self.navigationController pushViewController:[APP_DEL nxtTabBarCtr] animated:YES];
	
}

@end
