//
//  dResultDtlVCtr.h
//  AtoZ
//
//  Created by Valtech on 12/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "dDtlHelpPopOverVCtr.h"
#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>

@class dRcrdVCtr;
@class dTblMainItems;
@class dTblCompetitors;
@class dTblExDir;
@class dTblNearBy;
@class dNewAboutVCtr;
@class dPrintVCtr;

@interface dResultDtlVCtr : UIViewController <UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,UIPrintInteractionControllerDelegate,MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *temp;

@property (strong, nonatomic) IBOutlet UILabel *Nearby;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UITableView *tbl1;
@property (strong, nonatomic) IBOutlet UITableView *tbl2;

@property (strong, nonatomic) IBOutlet UIView *vOverView;
@property (strong, nonatomic) IBOutlet UIView *vOwnerShip;
@property (strong, nonatomic) IBOutlet UIView *vDemoGPrf;
@property (strong, nonatomic) IBOutlet UIView *vIndPrfl;
@property (strong, nonatomic) IBOutlet UIView *vCrpLnk;
@property (strong, nonatomic) IBOutlet UIView *vOtherImpInfo;
@property (strong, nonatomic) IBOutlet UIView *vQRCode;
@property (strong, nonatomic) IBOutlet UIView *vRevenueTrend;
@property (strong, nonatomic) IBOutlet UIView *vCompetitors;
@property (strong, nonatomic) IBOutlet UIView *vExDir;
@property (strong, nonatomic) IBOutlet UIView *vNearBy;

@property (strong, nonatomic) UIPopoverController *popVCtr;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) NSDictionary *dForDtl;
@property (strong, nonatomic) NSDictionary *dForResult;
@property (nonatomic, assign) dRcrdVCtr *predRcrdVCtr;
@property (strong, nonatomic) dDtlHelpPopOverVCtr *nxtdDtlHelpPopOverVCtr;
@property (strong, nonatomic) dNewAboutVCtr *nxtdNewAboutVCtr;
@property (strong, nonatomic) IBOutlet dTblMainItems *tblMainItems;
@property (strong, nonatomic) IBOutlet dTblCompetitors *tableCompetitors;
@property (strong, nonatomic) IBOutlet dTblExDir *tableExDir;
@property (strong, nonatomic) IBOutlet dTblNearBy *tableNearBy;
@property (strong, nonatomic) dPrintVCtr *nxtdPrintVCtr;
@property (strong, nonatomic) NSMutableDictionary *yearsDic;
@property (strong, nonatomic) NSMutableDictionary *addToContactInfoDic;

-(void)setUpOverView:(NSDictionary*)dToSet;
-(void)setUpDemoGraphic:(NSDictionary*)dToSet;
-(void)setUpOwnerShip:(NSDictionary*)dToSetup;
-(void)setUpCorporate:(NSDictionary*)dToSet;
-(void)setUpIndustry:(NSDictionary*)dToSet;
-(void)setUpOtherImpInfo:(NSDictionary*)dToSet;
-(void)setUpQRCode:(NSDictionary*)dToSet;
-(void)setUpRevenueTrend:(NSDictionary*)dToSet;
-(void)setUpEmployeeTrend:(NSDictionary*)dToSet;
- (NSArray*)parseDataFromString:(NSString*)string andIndex:(NSUInteger)index ;

- (IBAction)justReloadData:(id)sender;
- (IBAction)btnExpandAll:(id)sender;
- (IBAction)btnCollapseAll:(id)sender;
- (IBAction)btnInfoTapped:(id)sender;

- (IBAction)backTapped:(id)sender ;
- (IBAction)btnPrintTapped:(id)sender ;
- (IBAction)btnAddToContacts:(id)sender;
- (IBAction)btnHelpTapped:(id)sender ;
- (void)printItem :(NSData*)data;

-(void)displayComposerSheet ;
-(void)launchMailAppOnDevice ;

- (void)loadByID :(NSString*)idValue ;
- (IBAction)MailTapped:(id)sender ;
- (IBAction)btnUltiTapped:(id)sender;
- (IBAction)btnImmediateTapped:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblBoldFont;
@property (strong, nonatomic) IBOutlet UILabel *lblNormalFont;

- (NSString*)generateHTMLStringForReport ;
- (NSString*)generateHTML_For_CrpLnk ;
//Rajeev Start
-(NSString *) phoneNumberFormatterWithNum:(NSString *) number;
- (void)createToken;
-(NSString *)currencyNumberFormatterWithNum:(NSString *) number;
- (void)getYearsListRelatedToRevenueTrend;
- (void)startFeedDataToDetailsScreen;
- (void)addContactToAddressBook;
//Rajeev End
@end
