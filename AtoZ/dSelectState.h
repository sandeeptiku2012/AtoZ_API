//
//  dSelectState.h
//  AtoZ
//
//  Created by Valtech on 12/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class dRcrdVCtr;

@interface dSelectState : UIViewController

@property (nonatomic,assign) UIViewController *preVCtr;
@property (nonatomic,strong) NSArray *arForStates;
@property (nonatomic, assign) dRcrdVCtr *predRcrdVCtr;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
