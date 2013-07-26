//
//  dTblNearBy.h
//  AtoZdatabases
//
//  Created by Valtech on 1/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class dResultDtlVCtr;
@class pRcrdDtls;

@interface dTblNearBy : UITableViewController

@property (nonatomic, strong) NSArray *arForTable;
@property (nonatomic, strong) NSArray *arForTable2;
@property (nonatomic, assign) dResultDtlVCtr *predResultDtlVCtr;
- (void)shouldReloadThings;
@property (nonatomic, strong) NSString *strInnerHTML;
@property (nonatomic, strong) IBOutlet UIView *vHeader;
- (NSString *)append:(NSString *)Phone ;

@property (nonatomic, assign) IBOutlet pRcrdDtls *prepRcrdDtls;
@end
