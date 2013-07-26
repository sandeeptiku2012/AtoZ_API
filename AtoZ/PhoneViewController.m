//
//  PhoneViewController.m
//  AtoZdatabases
//
//  Created by Ankit Vyas on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhoneViewController.h"
#import "ResultViewController.h"


@implementation PhoneViewController
@synthesize predRcrdVCtr = _predRcrdVCtr;
@synthesize txtMobile = _txtMobile;
@synthesize preTabBarCtr = _preTabBarCtr;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle


- (void)viewWillAppear:(BOOL)animated {
	
    NSError *error = nil;
    [[GANTracker sharedTracker] trackPageview:@"Phone Search Page" withError:&error];
    
    self.trackedViewName=@"Phone Search Page";
    
	[self.txtMobile resignFirstResponder];
	if (isBackFromSearchPage==NO) {
		/*self.txtMobile.text = @""*/;
		
		
	}else if(isBackFromSearchPage == YES)
		isBackFromSearchPage = NO;
    
	
	//self.txtMobile.placeholder.text
	

	[super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.txtMobile resignFirstResponder];
    if (isBackFromSearchPage != YES) {
        AppDelegate *appdel=[[UIApplication sharedApplication] delegate];
        appdel.isBackFromSearch = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Search by Phone";;
    self.navigationItem.title=@"Search by Phone";
    
}


- (void)viewDidUnload
{
    [self setTxtMobile:nil];
    [super viewDidUnload];
}


#pragma UITextField delegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    char *x = (char*)[string UTF8String];
    //NSLog(@"char index is %i",x[0]);
    if([string isEqualToString:@"-"] || [string isEqualToString:@"("] || [string isEqualToString:@")"] || [string isEqualToString:@"0"] || [string isEqualToString:@"1"] ||  [string isEqualToString:@"2"] ||  [string isEqualToString:@"3"] ||  [string isEqualToString:@"4"] ||  [string isEqualToString:@"5"] ||  [string isEqualToString:@"6"] ||  [string isEqualToString:@"7"] ||  [string isEqualToString:@"8"] ||  [string isEqualToString:@"9"] || x[0]==0 || [string isEqualToString:@" "]) {
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 14) ? NO : YES;
    } else {
        return NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.txtMobile) {
        [textField resignFirstResponder];
       // [self searchTapped:nil];
        
        isBackFromSearchPage = YES;
        AppDelegate *appdel=[[UIApplication sharedApplication] delegate];
        appdel.isBackFromSearch = YES;
        
        [self.txtMobile resignFirstResponder];
        [self searchByText:self.txtMobile.text];
        return YES;
    }
    return NO;
}


-(IBAction)searchTapped:(id)sender {
	isBackFromSearchPage = YES;
	AppDelegate *appdel=[[UIApplication sharedApplication] delegate];
	appdel.isBackFromSearch = YES;

    
    NSError *error = nil;
    if (![[GANTracker sharedTracker] trackEvent:@"Phone Search Tapped"
        action:@"TrackEvent"
        label:self.txtMobile.text
        value:-1
        withError:&error]) {
        NSLog(@"Error Occured ==>%@",error);
    }
    
    [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:@"Phone Search Tapped" withAction:@"TrackEvent" withLabel:self.txtMobile.text withValue:[NSNumber numberWithInt:7]];
	[self.txtMobile resignFirstResponder];
    [self searchByText:self.txtMobile.text];
}

- (void)searchByText:(NSString*)sender {
    NSString *str = self.txtMobile.text;
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"(" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@")" withString:@""];
    if(str.length==0 || str.length<=6 || str.length>16 )  {
        ALERT(@"Please enter the Phone number in the format 888-888-8888 or (800) 789-9999.", nil, @"OK", self, nil);
    }
    else
    {
        if(str.length>0) {
			if(self.predRcrdVCtr)
				[self setPredRcrdVCtr:nil];
			
			self.predRcrdVCtr=[[ResultViewController alloc] initWithNibName:@"ResultViewController" bundle:nil];
            [self.predRcrdVCtr resetProcess];
            //Rajeev Start
            NSMutableDictionary *dToSearch = [NSMutableDictionary dictionary];
            [dToSearch setValue:@"0" forKey:@"recordtype"];
            [dToSearch setValue:@"1" forKey:@"is_primaryExec"];
            [dToSearch  setValue:str forKey:@"Phone"];
            self.predRcrdVCtr.dForSearch=dToSearch;
            //self.predRcrdVCtr.dForSearch=[NSDictionary dictionaryWithObjectsAndKeys:str,@"Phone", nil];
            //Rajeev End
            [self.predRcrdVCtr performSelector:@selector(createToken) withObject:nil afterDelay:0.2];
			[self.preTabBarCtr.navigationController pushViewController:self.predRcrdVCtr animated:YES];

        }
    } 
}

- (void)clearAll {  
    self.txtMobile.text=@"";
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return  UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

@end
