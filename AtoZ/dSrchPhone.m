//
//  dSrchPhone.m
//  AtoZ
//
//  Created by Valtech on 12/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "dSrchPhone.h"
#import "dRcrdVCtr.h"

@implementation dSrchPhone
@synthesize predRcrdVCtr = _predRcrdVCtr;
@synthesize txtMobile = _txtMobile;

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
    self.title=@"Search by Phone";
    self.navigationItem.title=@"Search by Phone";
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchTapped:)];
    [item setStyle:UIBarButtonItemStyleDone];
    self.navigationItem.rightBarButtonItem=item;
    
    item=[[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearAll)];
    [item setStyle:UIBarButtonItemStylePlain];
    self.navigationItem.leftBarButtonItem = item;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSError *error = nil;
    [[GANTracker sharedTracker] trackPageview:@"iPad Phone Search Page" withError:&error];
    
    self.trackedViewName=@"iPad Phone Search Page";
}

- (void)viewDidUnload
{
    [self setTxtMobile:nil];
    [super viewDidUnload];
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
        [self searchTapped:nil];
        return YES;
    }
    return NO;
}


-(void)searchTapped:(id)sender {
    NSError *error = nil;
    if (![[GANTracker sharedTracker] trackEvent:@"Person Search Tapped"action:@"TrackEvent" label:self.txtMobile.text value:-1 withError:&error]) {
        NSLog(@"Error Occured ==>%@",error);
    }
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
            [self.predRcrdVCtr.pVCtr dismissPopoverAnimated:YES];
        }
    } 
}

- (void)clearAll {  
    self.txtMobile.text=@"";
}

@end
