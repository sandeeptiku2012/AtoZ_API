//
//  pRcdtVctr.h
//  AtoZdatabases
//
//  Created by Ankit Vyas on 13/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>
#import "pPrintVctr.h"

@interface pRcdtVctr : UIViewController <UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UIPrintInteractionControllerDelegate,MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITableView *tbl1;
@property (strong, nonatomic) IBOutlet UIView *vOverView;
@property (strong, nonatomic) IBOutlet UIView *vNHInfo;
@property (strong, nonatomic) NSArray *arForQuickLinks;
@property (strong, nonatomic) NSDictionary *dForDtl;
@property (strong, nonatomic) NSDictionary *dForResult;
@property (strong, nonatomic) pPrintVctr *nxtpPrintVCtr;
@property (strong, nonatomic) NSMutableDictionary *addToContactInfoDic;


- (IBAction)btnBackTapped:(id)sender;


-(void)setUpOverView:(NSDictionary*)dToSet;
-(void)setUpNHInfo:(NSDictionary*)dToSet;
- (IBAction)justReloadData:(id)sender ;
- (IBAction)btnPrintTapped:(id)sender ;
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
