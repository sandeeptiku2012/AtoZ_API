//
//  dLibCardNo.m
//  AtoZ
//
//  Created by Valtech on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "dLibCardNo.h"
#import "dLibVCtr.h"
#import "iNetMngr.h"


@implementation dLibCardNo
@synthesize txtLCard = _txtLCard;
@synthesize lblAlert = _lblAlert;
@synthesize lblAlertMsg = _lblAlertMsg;
@synthesize predLibVCtr = _predLibVCtr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSError *error = nil;
    [[GANTracker sharedTracker] trackPageview:@"iPad Library Card Authenticaton Page" withError:&error];
    self.lblAlert.hidden=self.lblAlertMsg.hidden=YES;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSError *error = nil;
    [[GANTracker sharedTracker] trackPageview:@"iPad Library Card Authentication Page" withError:&error];
    self.trackedViewName=@"iPad Library Card Authentication Page";
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.txtLCard.text=@"";
    self.lblAlert.hidden=self.lblAlertMsg.hidden=YES;
}

- (void)viewDidUnload
{
    [self setTxtLCard:nil];
    [self setLblAlert:nil];
    [self setLblAlertMsg:nil];
    [super viewDidUnload];
}

- (void)blinkError {
    NSError *error = nil;
    if (![[GANTracker sharedTracker] trackEvent:@"iPad Library Card Error"action:@"TrackEvent" label:self.lblAlertMsg.text value:-1 withError:&error]) {
        NSLog(@"Error Occured ==>%@",error);
    }
    
    [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:@"iPad Library Card Error" withAction:@"TrackEvent" withLabel:self.lblAlertMsg.text withValue:[NSNumber numberWithInt:109]];
    self.lblAlert.hidden=self.lblAlertMsg.hidden=NO;
}

- (void)stopAnimationOfAlertLbls {
    [self.lblAlert.layer removeAllAnimations];
    [self.lblAlertMsg.layer removeAllAnimations];
    self.lblAlert.hidden=self.lblAlertMsg.hidden=YES;
}

#ifdef IOS_OLDER_THAN__IPHONE_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}
#endif

#ifdef IOS_NEWER_OR_EQUAL_TO__IPHONE_6_0
-(BOOL)shouldAutorotate
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskAll);
}
#endif

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return YES;
//}

- (IBAction)saveTapped:(id)sender {
    NSString *libraryAccountNo = [[self.predLibVCtr.arOfLibraries objectAtIndex:[self.predLibVCtr.selectedIP row]] valueForKey:@"id"] ;
    
    NSString *strCard = [self.txtLCard.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(strCard.length>0) {
        [self.txtLCard resignFirstResponder];
        [iNetMngr authenticateCard:strCard libraryAccountNo:libraryAccountNo vCtrRef:self];
        NSError *error = nil;
        if (![[GANTracker sharedTracker] trackEvent:@"iPad Library Card Save Tapped"action:@"TrackEvent" label:libraryAccountNo value:-1 withError:&error]) {
            NSLog(@"Error Occured ==>%@",error);
        }
        
        [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:@"iPad Library Card Save Tapped" withAction:@"TrackEvent" withLabel:libraryAccountNo withValue:[NSNumber numberWithInt:108]];
    } else {
        [self blinkError];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self saveTapped:nil];
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
        NSDictionary *d = [self.predLibVCtr.arOfLibraries objectAtIndex:[self.predLibVCtr.selectedIP row]];
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
        [self.predLibVCtr performSelector:@selector(enterToSearchScreen:) withObject:nil afterDelay:0.25];
    } else {
        [self blinkError];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.txtLCard becomeFirstResponder];
}

@end
