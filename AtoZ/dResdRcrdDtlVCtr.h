//
//  dResdRcrdDtlVCtr.h
//  AtoZdatabases
//
//  Created by Valtech on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dDtlHelpPopOverVCtr.h"
#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>

@class dRcrdVCtr;
@class dNewAboutVCtr;
@class dPrintVCtr;

@interface dResdRcrdDtlVCtr : UIViewController <UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UIPopoverControllerDelegate,UIPrintInteractionControllerDelegate,MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UITableView *tblQL;
@property (strong, nonatomic) IBOutlet UITableView *tbl1;
@property (strong, nonatomic) IBOutlet UITableView *tbl2;

@property (strong, nonatomic) UIPopoverController *popVCtr;

@property (strong, nonatomic) IBOutlet UIView *vMainTableItems;
@property (strong, nonatomic) IBOutlet UIView *vOverView;
@property (strong, nonatomic) IBOutlet UIView *vNHInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;


@property(strong,nonatomic) IBOutlet UILabel *temp;

@property (strong, nonatomic) NSDictionary *dForDtl;
@property (strong, nonatomic) NSDictionary *dForResult;
@property (nonatomic, assign) dRcrdVCtr *predRcrdVCtr;
@property (strong, nonatomic) dDtlHelpPopOverVCtr *nxtdDtlHelpPopOverVCtr;
@property (strong, nonatomic) dNewAboutVCtr *nxtdNewAboutVCtr;
@property (strong, nonatomic) dPrintVCtr *nxtdPrintVCtr;
@property (strong, nonatomic) NSMutableDictionary *addToContactInfoDic;

@property (strong, nonatomic) NSArray *arForQuickLinks;

-(void)setUpOverView:(NSDictionary*)dToSet;
-(void)setUpNHInfo:(NSDictionary*)dToSet;

- (IBAction)backTapped:(id)sender;
- (IBAction)btnCollapseAll:(id)sender;
- (IBAction)btnExpandAll:(id)sender ;
- (IBAction)justReloadData:(id)sender ;
- (IBAction)btnPrintTapped:(id)sender ;
- (IBAction)btnInfoTapped:(id)sender ;
- (IBAction)btnHelpTapped:(id)sender ;
-(IBAction)btnAddToContacts:(id)sender;

-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;
-(void)launchMailAppOnDevice;

- (IBAction)MailTapped:(id)sender;
- (NSString*)generateHTMLStringForReport ;
//Rajeev Start
- (void)createToken;
- (void)loadByID :(NSString*)idValue;
-(NSString *) phoneNumberFormatterWithNum:(NSString *) number;
- (void)addContactToAddressBook;
//Rajeev End
@end
