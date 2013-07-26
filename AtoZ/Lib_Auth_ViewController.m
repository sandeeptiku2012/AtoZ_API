//
//  Lib_Auth_ViewController.m
//  AtoZdatabases
//
//  Created by Ankit Vyas on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Lib_Auth_ViewController.h"

@implementation Lib_Auth_ViewController
@synthesize Vauth;
@synthesize txtLCard = _txtLCard;
@synthesize lblAlert = _lblAlert;
@synthesize lblAlertMsg = _lblAlertMsg;
@synthesize nxtTabBarCtr = _nxtTabBarCtr;

@synthesize strName = _strName;
@synthesize strAddress = _strAddress;
@synthesize strPhone = _strPhone;
@synthesize strID = _strID;
@synthesize dforLibrary = _dforLibrary;
@synthesize lblAddress = _lblAddress;
@synthesize lblName = _lblName;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.lblAlert.hidden=self.lblAlertMsg.hidden=YES;
	[self.Vauth.layer setCornerRadius:5.0];
	self.Vauth.layer.borderWidth = 1;
	self.Vauth.layer.borderColor = [[UIColor colorWithRed:27/255.0 green:152/255.0 blue:194/255.0 alpha:1] CGColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSError *error = nil;
    [[GANTracker sharedTracker] trackPageview:@"Library Card Authentication Page" withError:&error];
    self.trackedViewName=@"Library Card Authentication Page";
    
    self.txtLCard.text=@"";
    self.lblAddress.text = [NSString stringWithFormat:@"%@\n%@",self.strAddress,self.strPhone];
    self.lblName.text = self.strName;
    self.lblAlert.hidden=self.lblAlertMsg.hidden=YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
	[self setVauth:nil];
    [self setTxtLCard:nil];
    [self setLblAlert:nil];
    [self setLblAlertMsg:nil];
    [self setStrName:nil];
    [self setStrAddress:nil];
    [self setStrPhone:nil];
    [self setStrID:nil];
    [self setDforLibrary:nil];
    [self setNxtTabBarCtr:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)blinkError {
    self.lblAlert.hidden=self.lblAlertMsg.hidden=NO;
}

- (void)stopAnimationOfAlertLbls {
    [self.lblAlert.layer removeAllAnimations];
    [self.lblAlertMsg.layer removeAllAnimations];
    self.lblAlert.hidden=self.lblAlertMsg.hidden=YES;
}


- (IBAction)saveTapped:(id)sender {
   	NSString *libraryAccountNo = self.strID;
    
    NSString *strCard = [self.txtLCard.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(strCard.length>0) {
        NSError *error = nil;
        if (![[GANTracker sharedTracker] trackEvent:@"LibraryAccountNo"
            action:@"TrackEvent"
            label:libraryAccountNo
            value:-1
            withError:&error]) {
            NSLog(@"Error Occured ==>%@",error);
        }
        [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:@"LibraryAccountNo" withAction:@"TrackEvent" withLabel:libraryAccountNo withValue:[NSNumber numberWithInt:3]];
        
        [self.txtLCard resignFirstResponder];
        [iNetMngr authenticateCard:strCard libraryAccountNo:libraryAccountNo vCtrRef:self];
    } else {
        [self blinkError];
    }
	
}

- (IBAction)btnBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)infobuttonTapped:(id)sender {
	AboutVctr *abt=[[AboutVctr alloc] initWithNibName:@"AboutVctr" bundle:nil];
	UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:abt];
	nav.navigationBarHidden=YES;
	[self.navigationController presentModalViewController:nav animated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self saveTapped:textField.text];
    [textField resignFirstResponder];
    return YES;
}

// 22991

- (void)webRequestReceivedData:(NSData *)data {
    [COMMON_PARSER parseData:data];
    NSLog(@"data is %@",COMMON_PARSER.jsonReponse);
    COMMON_PARSER.dStatus = [[COMMON_PARSER jsonReponse] valueForKey:@"status"];
    
    if( [[COMMON_PARSER.dStatus valueForKey:@"message"] isEqualToString:@"Success"] && [[[COMMON_PARSER jsonReponse] valueForKey:@"valid"] boolValue] ) {
        
        NSUserDefaults *sDef = [NSUserDefaults standardUserDefaults];
        NSDictionary *d = self.dforLibrary;
        if(![[d valueForKey:@"name"] isKindOfClass:[NSNull class]] ) [sDef setValue:[d valueForKey:@"name"] forKey:@"library"];
        
        //NSLog(@"value is %@",self.txtLCard.text);
        
        [sDef setValue:self.txtLCard.text forKey:@"card"];
        
        if(![[d valueForKey:@"name"] isKindOfClass:[NSNull class]] ) [sDef setValue:[d valueForKey:@"name"] forKey:@"lname"];
        if(![[d valueForKey:@"address"] isKindOfClass:[NSNull class]] ) [sDef setValue:[d valueForKey:@"address"] forKey:@"laddress"];
        if(![[d valueForKey:@"phoneNumber"] isKindOfClass:[NSNull class]] ) [sDef setValue:[d valueForKey:@"phoneNumber"] forKey:@"lphone"];
        if(![[d valueForKey:@"logoPath"] isKindOfClass:[NSNull class]] ) { 
            [sDef setValue:[d valueForKey:@"logoPath"] forKey:@"llogo"];
        }
        if(![[d valueForKey:@"id"] isKindOfClass:[NSNull class]] ) { 
            [sDef setValue:[d valueForKey:@"id"] forKey:@"id"];
        }
        
        [sDef synchronize];
        
        // go to search screen
        [self.navigationController pushViewController:[APP_DEL nxtTabBarCtr] animated:YES];
    } else {
        [self blinkError];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.txtLCard becomeFirstResponder];
}

@end
