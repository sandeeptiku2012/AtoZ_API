//
//  AboutVctr.h
//  AtoZdatabases
//
//  Created by Ankit Vyas on 05/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
@class pAboutDtlVctr;

@interface AboutVctr : UIViewController <MFMessageComposeViewControllerDelegate>
@property(strong,nonatomic)pAboutDtlVctr *nxtpAboutDtlVctr;
@property(strong,nonatomic) MFMailComposeViewController *picker;
@property (nonatomic,strong)IBOutlet UITableView *tblView;
@property (nonatomic,strong) NSArray *arrMenu;
@property (nonatomic,readwrite)int indexrecord;

- (IBAction)btnDoneTapped:(id)sender;
- (IBAction)MailTapped:(id)sender;
-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;

@end
