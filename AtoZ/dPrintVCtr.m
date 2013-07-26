//
//  dPrintVCtr.m
//  AtoZdatabases
//
//  Created by Valtech on 1/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "dPrintVCtr.h"

@implementation dPrintVCtr
@synthesize barBtnPrint = _barBtnPrint;
@synthesize webViewPrint;
@synthesize isLoading = _isLoading;
@synthesize strString = _strString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setWebViewPrint:nil];
    [self setBarBtnPrint:nil];
    [super viewDidUnload];
}

#ifdef IOS_OLDER_THAN__IPHONE_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}
#endif

#ifdef IOS_NEWER_OR_EQUAL_TO__IPHONE_6_0
-(BOOL)shouldAutorotate
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskAll);
}
#endif

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//	return YES;
//}

- (IBAction)btnPrintTapped:(id)sender {
    if(!self.isLoading) {
        
        NSData *imageData = [self getImageFromView:self.webViewPrint];
        [self printItem:imageData];
        
        //NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"/myImage.png"];
        //[imageData writeToFile:imagePath atomically:YES];

        
//        NSString *str=[self.webViewPrint stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
//        //NSLog(@"height is %@",str);
//        if( [str intValue]>0) {
//            CGSize sixzevid=CGSizeMake(768,[str intValue]);
//            UIGraphicsBeginImageContext(sixzevid);
//
//            [self.webViewPrint.layer renderInContext:UIGraphicsGetCurrentContext()];
//            UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//            
//            NSData *imageData = UIImagePNGRepresentation(viewImage);
//            [self printItem:imageData];
//        }
    }
}

-(NSData *)getImageFromView:(UIView *)view  // Mine is UIWebView but should work for any
{
    webViewRect = view.frame;
    
    NSData *pngImg;
    CGFloat max, scale = 1.0;
    CGSize viewSize = [view bounds].size;
    
    // Get the size of the the FULL Content, not just the bit that is visible
    CGSize size = [view sizeThatFits:CGSizeZero];
    
    // Scale down if on iPad to something more reasonable
    max = (viewSize.width > viewSize.height) ? viewSize.width : viewSize.height;
    if( max > 960 )
        scale = 960/max;
    
    UIGraphicsBeginImageContextWithOptions( size, YES, scale );
    
    // Set the view to the FULL size of the content.
    [view setFrame: CGRectMake(0, 0, size.width, size.height)];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];    
    pngImg = UIImagePNGRepresentation( UIGraphicsGetImageFromCurrentImageContext() );
    
    UIGraphicsEndImageContext();
    
    [view setFrame:webViewRect];
    
    return pngImg;    // Voila an image of the ENTIRE CONTENT, not just visible bit
}


- (IBAction)btnCloseTapped:(id)sender {
    [printController dismissAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if(navigationType==UIWebViewNavigationTypeLinkClicked || navigationType==UIWebViewNavigationTypeFormSubmitted || navigationType==UIWebViewNavigationTypeFormResubmitted) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    } else return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.isLoading = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.isLoading = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    self.isLoading=NO;
}


- (IBAction)backButtonTapped:(id)sender {
	
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Print Methods

-(void)printItem :(NSData*)data {
    printController = [UIPrintInteractionController sharedPrintController];
    if(printController && [UIPrintInteractionController canPrintData:data]) {
        printController.delegate = self;
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = [NSString stringWithFormat:@"AtoZdatabases"];
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        printController.printInfo = printInfo;
        printController.showsPageRange = YES;
        printController.printingItem = data;
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
            if (!completed && error) {
                //NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
            }
        };
        [printController presentFromBarButtonItem:self.barBtnPrint animated:YES completionHandler:completionHandler];
    }
}

- (BOOL)presentFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated completionHandler:(UIPrintInteractionCompletionHandler)completion {
    return YES;
}

- (BOOL)presentFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated completionHandler:(UIPrintInteractionCompletionHandler)completion {
    return YES;
}
@end
