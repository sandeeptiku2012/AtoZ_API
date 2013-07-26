//
//  ResultViewController.h
//  AtoZdatabases
//
//  Created by Ankit Vyas on 15/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
#import "pRcrdDtls.h"
#import "pRcdtVctr.h"
#import "GAITrackedViewController.h"
@class CategoryViewController;
@interface ResultViewController : GAITrackedViewController <ASIHTTPRequestDelegate>
@property (strong,nonatomic) CategoryViewController *nxtCategoryViewController;
@property (strong, nonatomic) IBOutlet UITabBar *tabbar;
- (IBAction)BackTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *VforMap;
@property (strong, nonatomic) IBOutlet MKMapView *mapViewRecords;
@property (strong, nonatomic) IBOutlet UIView *VforList;
@property (nonatomic , readwrite) int ibutton;
@property (nonatomic, strong) ASINetworkQueue *nQ;
@property (nonatomic,strong) NSDictionary *dForSearch;
@property (readwrite, nonatomic) NSUInteger totalRecords;
@property (nonatomic,strong)IBOutlet UILabel *lblRecordsTitle;
@property (nonatomic,strong)IBOutlet UITableView *tableViewRecords;
@property (nonatomic, strong) NSArray *arOfRecords;
@property (strong, nonatomic) NSIndexPath *selectedIP;
@property (strong, nonatomic) NSNumber *numberFrom;
@property (strong, nonatomic) NSNumber *numberTo;
@property (readwrite, nonatomic) BOOL isSearching;
@property (nonatomic, strong) NSMutableArray *arOfFilteredRcrds;
@property (strong, nonatomic) IBOutlet UIButton *btnNS;
@property (strong, nonatomic) IBOutlet UIButton *btnPS;
@property (nonatomic,readwrite) int SearchIndex;
//Next & Previous Segment
@property (strong, nonatomic) IBOutlet UISegmentedControl *sgNextPrev;
- (IBAction)sgNxtPrePage:(id)sender;


@property(nonatomic,strong) pRcrdDtls *nxtpRcrdDtls;
@property(nonatomic,strong) pRcdtVctr *nxtpRcdtVctr; 

// array for cities
@property (nonatomic, strong) NSArray *arForStates;

@property (nonatomic, readwrite) BOOL isFetchingStates;
@property (nonatomic, readwrite) BOOL isFetchingRecords;
@property (nonatomic, readwrite) BOOL isLoginUsingSession;

@property (strong, nonatomic) IBOutlet UIToolbar *tBarNextPre;

- (void)pushLibDtlVCtrWithDetails:(NSDictionary*)d;
- (void)selectSpecificPin:(NSDictionary *)dToSelect;
- (void)setupRecordsResponse;
- (void)addPins;
-(void) centerMap:(MKMapView*)mapView;
- (NSInteger)indexOfTitle:(NSString*)strTitle;
- (void)resetProcess;
@end
