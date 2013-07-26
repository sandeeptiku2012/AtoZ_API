//
//  AboutVctr.m
//  AtoZdatabases
//
//  Created by Ankit Vyas on 05/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AboutVctr.h"
#import "pAboutDtlVctr.h"

@implementation AboutVctr
@synthesize picker = _picker;
@synthesize tblView = _tblView;
@synthesize indexrecord = _indexrecord;
@synthesize arrMenu = _arrMenu;
@synthesize nxtpAboutDtlVctr = _nxtpAboutDtlVctr;


- (void)viewDidUnload
{
    [super viewDidUnload];
	[self setArrMenu:nil];
	[self setPicker:nil];
	[self setTblView:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSError *error = nil;
    [[GANTracker sharedTracker] trackPageview:@"About Page" withError:&error];
	self.tblView.layer.shadowOffset=CGSizeMake(2, 2);
	self.tblView.layer.shadowColor=[[UIColor grayColor] CGColor];
	self.tblView.layer.shadowOpacity=0.85;
	self.arrMenu=[NSArray arrayWithObjects:@" Terms & Conditions",@" Privacy Policy", nil];
	
    // Do any additional setup after loading the view from its nib.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
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
		[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
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
			[lbl setTextColor:[UIColor blackColor]];
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
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	[tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	[(UILabel*)[cell viewWithTag:111] setTextColor:[UIColor whiteColor]];
	self.nxtpAboutDtlVctr=[[pAboutDtlVctr alloc] initWithNibName:@"pAboutDtlVctr" bundle:nil];
	
    if(indexPath.row==0){
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath1];
        [(UILabel*)[cell viewWithTag:111] setTextColor:[UIColor blackColor]];
        
		self.nxtpAboutDtlVctr.strTitle=@"Terms & Conditions";	
		self.nxtpAboutDtlVctr.strUrl=@"http://www.atozdatabases.com/termsandconditions";	
	} else if(indexPath.row==1){
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:0 inSection:indexPath.section ];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath1];
        [(UILabel*)[cell viewWithTag:111] setTextColor:[UIColor blackColor]];
        
		self.nxtpAboutDtlVctr.strTitle=@"Privacy Policy";
		self.nxtpAboutDtlVctr.strUrl=@"http://www.atozdatabases.com/privacypolicy";
	}
	
	[self.navigationController pushViewController:self.nxtpAboutDtlVctr animated:YES];
	
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	[(UILabel*)[cell viewWithTag:111] setTextColor:[UIColor whiteColor]];
	self.nxtpAboutDtlVctr=[[pAboutDtlVctr alloc] initWithNibName:@"pAboutDtlVctr" bundle:nil];

    if(indexPath.row==0){
    self.nxtpAboutDtlVctr.strTitle=@"Terms & Conditions";	
	self.nxtpAboutDtlVctr.strUrl=@"http://www.atozdatabases.com/termsandconditions";	
	} else if(indexPath.row==1){
		self.nxtpAboutDtlVctr.strTitle=@"Privacy Policy";
		self.nxtpAboutDtlVctr.strUrl=@"http://www.atozdatabases.com/privacypolicy";
	}
	
	[self.navigationController pushViewController:self.nxtpAboutDtlVctr animated:YES];
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
	self.picker = [[MFMailComposeViewController alloc] init];
	self.picker.mailComposeDelegate = self;
	
	[self.picker setSubject:@"Mobile User Experience"];
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:@"contactus@atozdatabases.com"]; 
	[self.picker setToRecipients:toRecipients];
	[self presentModalViewController:self.picker animated:YES];
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
@end
