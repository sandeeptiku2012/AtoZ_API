//
//  pAboutDtlVctr.h
//  AtoZdatabases
//
//  Created by Ankit Vyas on 12/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface pAboutDtlVctr : UIViewController  
@property (nonatomic,strong) NSString *strTitle;
@property (nonatomic,strong) NSString *strUrl;
@property (nonatomic,strong) IBOutlet UILabel *lblTitle;
@property (nonatomic,strong) IBOutlet UIWebView *webView;
-(IBAction)backTapped:(id)sender;

@end
