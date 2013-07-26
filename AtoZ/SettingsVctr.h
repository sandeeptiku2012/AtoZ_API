//
//  SettingsVctr.h
//  AtoZdatabases
//
//  Created by Ankit Vyas on 10/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsVctr : UIViewController <UIActionSheetDelegate>
@property (assign, nonatomic) IBOutlet TabBarCtr *preTabBarCtr;

@property (nonatomic,strong)UIActionSheet *aSheet;
@end
