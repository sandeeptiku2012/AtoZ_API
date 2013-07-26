//
//  pPrintVctr.m
//  AtoZdatabases
//
//  Created by Ankit Vyas on 16/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "pPrintVctr.h"

@implementation pPrintVctr
@synthesize printButton;
@synthesize webViewPrint;
@synthesize isLoading = _isLoading;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
   // [self.webViewPrint setScalesPageToFit:YES];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarOrientation:(UIInterfaceOrientationLandscapeRight) animated:YES];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarOrientation:(UIDeviceOrientationPortrait) animated:YES];
}

- (void)viewDidUnload
{
    [self setWebViewPrint:nil];
	
	[self setPrintButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#ifdef IOS_NEWER_OR_EQUAL_TO__IPHONE_6_0
-(BOOL)shouldAutorotate
{
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        return YES;
    } else {
        return NO;
    }
}
- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight);
}
#endif

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request {
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	self.isLoading = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
   	self.isLoading = NO;

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	self.isLoading = NO;
    
}

#pragma mark - Event Methods
- (IBAction)printButtonTapped:(id)sender {
    
    if(!self.isLoading) {
        
        NSData *imageData = [self getImageFromView:self.webViewPrint];
        [self printItem:imageData];
        
       // NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"/myImage.png"];
       // [imageData writeToFile:imagePath atomically:YES];
        
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
//            UIImageView *imageView = [[UIImageView alloc] initWithImage:viewImage];
//            imageView.frame = CGRectMake(10, 10, 600, 400);
//            [self.view addSubview:imageView];
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
   // if( max > 960 )
      //  scale = 960/max;
    
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
		[printController presentAnimated:YES completionHandler:completionHandler];
	}
}

@end
