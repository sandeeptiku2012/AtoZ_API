//
//  pPrintVctr.h
//  AtoZdatabases
//
//  Created by Ankit Vyas on 16/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pPrintVctr : UIViewController<UIWebViewDelegate,UIPrintInteractionControllerDelegate,UIWebViewDelegate>{
    UIPrintInteractionController *printController;
    CGRect webViewRect; 
}
@property (strong, nonatomic) IBOutlet UIWebView *webViewPrint;
@property (nonatomic,readwrite) BOOL isLoading;
@property (strong, nonatomic) IBOutlet UIButton *printButton;

- (IBAction)printButtonTapped:(id)sender;
- (IBAction)backButtonTapped:(id)sender;
-(void)printItem :(NSData*)data ;
-(NSData *)getImageFromView:(UIView *)view;

@end
