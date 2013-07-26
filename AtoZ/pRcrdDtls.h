//
//  pRcrdDtls.h
//  AtoZdatabases
//
//  Created by Ankit Vyas on 11/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>
#import "pPrintVctr.h"

@class dTblCompetitors;
@class dTblExDir;
@class dTblNearBy;

@interface pRcrdDtls : UIViewController <MFMailComposeViewControllerDelegate>{
	BOOL isScreenLoadedForFirstTime;
}

@property int quickLinkSelectedIndex;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITableView *tbl1;

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
@property (strong, nonatomic) IBOutlet UILabel *lblBoldFont;
@property (strong, nonatomic) IBOutlet UILabel *lblNormalFont;
@property (strong, nonatomic) NSDictionary *dForDtl;
@property (strong, nonatomic) NSDictionary *dForResult;
@property (strong, nonatomic) NSMutableDictionary *yearsDic;

@property (strong, nonatomic) IBOutlet dTblCompetitors *tableCompetitors;
@property (strong, nonatomic) IBOutlet dTblExDir *tableExDir;
@property (strong, nonatomic) IBOutlet dTblNearBy *tableNearBy;
@property (strong, nonatomic) pPrintVctr *nxtpPrintVCtr;
@property (copy, nonatomic) NSString *phyAdd;
@property (strong, nonatomic) NSMutableDictionary *addToContactInfoDic;

- (IBAction)btnBackTapped:(id)sender;
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
//- (IBAction)btnExpandAll:(id)sender;
//- (IBAction)btnCollapseAll:(id)sender;
//- (IBAction)btnInfoTapped:(id)sender;

- (IBAction)btnPrintTapped:(id)sender ;
- (IBAction)btnAddToContacts:(id)sender;
//- (IBAction)btnHelpTapped:(id)sender ;
//- (void)printItem :(NSData*)data;

-(void)displayComposerSheet ;
-(void)launchMailAppOnDevice ;

- (void)loadByID :(NSString*)idValue ;
- (IBAction)MailTapped:(id)sender ;
- (IBAction)btnUltiTapped:(id)sender;
- (IBAction)btnImmediateTapped:(id)sender;


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
