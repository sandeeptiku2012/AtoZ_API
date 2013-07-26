//
//  dNewAboutVCtr.m
//  AtoZdatabases
//
//  Created by Valtech on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "dNewAboutVCtr.h"

@implementation dNewAboutVCtr

@synthesize lblTitle = _lblTitle;
@synthesize toolbar = _toolbar;
@synthesize First = _First;
@synthesize btnBack = _btnBack;
@synthesize btnForward = _btnForward;
@synthesize webView = _webView;
@synthesize  arrMenu = _arrMenu;
@synthesize tblView  = _tblView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{

	
		
	self.tblView.layer.shadowOffset=CGSizeMake(2, 2);
	self.tblView.layer.shadowColor=[[UIColor grayColor] CGColor];
	self.tblView.layer.shadowOpacity=0.85;
	
	indexrecord=1;
    [super viewDidLoad];
    self.arrMenu=[NSArray arrayWithObjects:@" Terms & Conditions",@" Privacy Policy", nil];
	
	self.lblTitle.text=@"Terms & Conditions";
	NSString *urlAddress =@"http://www.atozdatabases.com/termsandconditions";
	
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:urlAddress];
	
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	//Load the request in the UIWebView.
	[self.webView loadRequest:requestObj];
	[self performSelector:@selector(dummyCaller) withObject:nil afterDelay:1.0];
}
-(void)dummyCaller
{
  [self.tblView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
}
- (void)webViewDidStartLoad:(UIWebView *)mwebView {
    self.btnBack.enabled = (self.webView .canGoBack);
    self.btnForward.enabled = (self.webView .canGoForward);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.btnBack.enabled = (webView.canGoBack);
    self.btnForward.enabled = (webView.canGoForward);
}
- (void)viewDidUnload
{
	[self setBtnBack:nil];
	[self setBtnForward:nil];
	[self setToolbar:nil];
	[self setFirst:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
//    // Return YES for supported orientations
//	return YES;
//}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrMenu count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
		
		UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 50)];
		[cell addSubview:v];
		UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 320, 50)];
		[lbl setBackgroundColor:[UIColor colorWithRed:0.9098 green:0.9098 blue:0.9020 alpha:1]];
		[lbl setText:[self.arrMenu objectAtIndex:indexPath.row]];
		[lbl setFont:[UIFont fontWithName:@"Trebuchet MS" size:15]];
		[lbl setTextAlignment:UITextAlignmentLeft];
		if(indexPath.row==0)
		{
			[lbl setTextColor:[UIColor whiteColor]];
		}
		else
			[lbl setTextColor:[UIColor blackColor]];
			
		lbl.tag = 111;
		[cell addSubview:lbl];		
    }
	
	
	 [(UILabel*)[cell viewWithTag:111] setText:[self.arrMenu objectAtIndex:indexPath.row]];
	
	// Configure the cell.
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        indexrecord=1;
        self.lblTitle.text=@"Terms & Conditions";
        NSString *urlAddress =@"http://www.atozdatabases.com/termsandconditions";
        
        //Create a URL object.
        NSURL *url = [NSURL URLWithString:urlAddress];
        
        //URL Requst Object
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        
        //Load the request in the UIWebView.
        [self.webView loadRequest:requestObj];  
    }
	else if(indexPath.row==1)
	{
		indexrecord=2;
		self.lblTitle.text=@"Privacy Policy";
		NSString *urlAddress =@"http://www.atozdatabases.com/privacypolicy";
		
		//Create a URL object.
		NSURL *url = [NSURL URLWithString:urlAddress];
		
		//URL Requst Object
		NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
		
		//Load the request in the UIWebView.
		[self.webView loadRequest:requestObj];
	}
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	[(UILabel*)[cell viewWithTag:111] setTextColor:[UIColor whiteColor]];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	[(UILabel*)[cell viewWithTag:111] setTextColor:[UIColor blackColor]];
}

- (IBAction)MailTapped:(id)sender {
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			[self displayComposerSheet];
		}
		else
		{
			[self launchMailAppOnDevice];
		}
	}
	else
	{
		[self launchMailAppOnDevice];
	}
    
}
#pragma mark Compose Mail

// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet 
{
	//MFMailComposeViewControllerDelegate
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@"Mobile User Experience"];
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:@"contactus@atozdatabases.com"]; 
	[picker setToRecipients:toRecipients];
	[self presentModalViewController:picker animated:YES];
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog( @"Result: canceled");
			break;
		case MFMailComposeResultSaved:
			NSLog( @"Result: saved");
			break;
		case MFMailComposeResultSent:
			NSLog( @"Result: sent");
			break;
		case MFMailComposeResultFailed:
			NSLog( @"Result: failed");
			break;
		default:
			NSLog( @"Result: not sent");
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
	NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=Hello from California!";
	NSString *body = @"";
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}


- (IBAction)btnDoneTapped:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)PreviousTapped:(id)sender {
	[self.webView  goBack];
}

- (IBAction)NextTapped:(id)sender {
	[self.webView  goForward];
}

- (IBAction)RefreshTapped:(id)sender {
	[self.webView  reload];
}

- (IBAction)openinsafari:(id)sender {
	if(indexrecord==1){
		NSURL *url = [NSURL URLWithString:@"http://www.atozdatabases.com/termsandconditions"];
		
		if (![[UIApplication sharedApplication] openURL:url])
			
			NSLog(@"%@%@",@"Failed to open url:",[url description]);
		
	}
	if(indexrecord==2){
		NSURL *url = [NSURL URLWithString:@"http://www.atozdatabases.com/privacypolicy"];
		
		if (![[UIApplication sharedApplication] openURL:url])
			
			NSLog(@"%@%@",@"Failed to open url:",[url description]);
		
	}
}
@end
