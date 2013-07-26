//
//  dPrintVCtr.h
//  AtoZdatabases
//
//  Created by Valtech on 1/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface dPrintVCtr : UIViewController <UIWebViewDelegate,UIPrintInteractionControllerDelegate> {
    UIPrintInteractionController *printController;
    CGRect webViewRect;
}
- (IBAction)btnPrintTapped:(id)sender;
- (IBAction)btnCloseTapped:(id)sender;

@property (strong, nonatomic) IBOutlet UIWebView *webViewPrint;
@property (nonatomic,readwrite) BOOL isLoading;
@property (strong, nonatomic) NSString *strString;

-(void)printItem :(NSData*)data ;
-(NSData *)getImageFromView:(UIView *)view;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barBtnPrint;

@end
