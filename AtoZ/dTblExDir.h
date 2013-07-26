//
//  dTblExDir.h
//  AtoZdatabases
//
//  Created by Valtech on 1/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class dResultDtlVCtr;
@class pRcrdDtls;

@interface dTblExDir : UITableViewController <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *arForTable;
@property (nonatomic, strong) NSArray *arForTable2;
- (void)shouldReloadThings;
@property (nonatomic, strong) NSString *strInnerHTML;
@property (nonatomic, strong) IBOutlet UIView *vHeader;
@property (nonatomic, assign) IBOutlet dResultDtlVCtr *predResultDtlVCtr;
@property (nonatomic, assign) IBOutlet pRcrdDtls *prepRcrdDtls;

@end
