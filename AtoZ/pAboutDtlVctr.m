//
//  pAboutDtlVctr.m
//  AtoZdatabases
//
//  Created by Ankit Vyas on 12/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "pAboutDtlVctr.h"

@implementation pAboutDtlVctr
@synthesize strTitle = _strTitle;
@synthesize strUrl = _strUrl;
@synthesize lblTitle = _lblTitle;
@synthesize webView = _webView;

- (void)viewDidUnload
{
	[self setWebView:nil];
	[self setLblTitle:nil];
	[self setStrUrl:nil];
	[self setStrTitle:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
	self.lblTitle.text=self.strTitle;
	
	        //Create a URL object.
	        NSURL *url = [NSURL URLWithString:self.strUrl];
	        
	        //URL Requst Object
	        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	        
	        //Load the request in the UIWebView.
	        [self.webView loadRequest:requestObj];  
	
	[super viewWillAppear:animated];
}

-(IBAction)backTapped:(id)sender{
	[self.navigationController popViewControllerAnimated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {     
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];   
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

@end
