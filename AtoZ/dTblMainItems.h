//
//  dTblMainItems.h
//  AtoZ
//
//  Created by Valtech on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class dResultDtlVCtr;

@interface dTblMainItems : UITableViewController

@property (nonatomic,strong) NSArray *arForTable;
@property (nonatomic,assign) dResultDtlVCtr *predResultDtlVCtr;

@end
