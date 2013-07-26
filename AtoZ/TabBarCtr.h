//
//  TabBarCtr.h
//  AtoZdatabases
//
//  Created by Spark on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BusinessViewController;
@class PersonViewController;
@class CategoryViewController;
@class PhoneViewController;
@class MasterViewController;

@interface TabBarCtr : UIViewController <UITabBarDelegate,UIActionSheetDelegate>{
	int selectedTabIndex;
}
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITabBar *tabBar;
@property (nonatomic, strong) MasterViewController *pLibVctr;
@property (strong, nonatomic) IBOutlet BusinessViewController *nxtBusinessViewController;
@property (strong, nonatomic) IBOutlet PersonViewController *nxtPersonViewController;
@property (strong, nonatomic) IBOutlet CategoryViewController *nxtCategoryViewController;
@property (strong, nonatomic) IBOutlet PhoneViewController *nxtPhoneViewController;
@property (strong, nonatomic) IBOutlet UIImageView *imgVHShadow;
@property (nonatomic,strong) NSArray *arForStates;
-(IBAction)btnBacktapped:(id)sender;
- (IBAction)infobuttonTapped:(id)sender;
- (IBAction)btnSettingsTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnSetting;
@end
