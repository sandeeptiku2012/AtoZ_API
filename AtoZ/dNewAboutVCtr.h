//
//  dNewAboutVCtr.h
//  AtoZdatabases
//
//  Created by Valtech on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface dNewAboutVCtr : UIViewController <UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>
{
	int indexrecord;
}
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnBack;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnForward;

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,strong) NSArray *arrMenu;
@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIToolbar *First;

- (IBAction)btnDoneTapped:(id)sender;
- (IBAction)MailTapped:(id)sender;
-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;
- (IBAction)PreviousTapped:(id)sender;
- (IBAction)NextTapped:(id)sender;
- (IBAction)RefreshTapped:(id)sender;
- (IBAction)openinsafari:(id)sender;
@end
