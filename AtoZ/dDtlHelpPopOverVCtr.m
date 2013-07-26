//
//  dDtlHelpPopOverVCtr.m
//  AtoZdatabases
//
//  Created by sagar kothari on 09/01/12.
//  Copyright 2012 navgujarat. All rights reserved.
//

#import "dDtlHelpPopOverVCtr.h"

@implementation dDtlHelpPopOverVCtr
@synthesize webView = _webView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)setPopOverSize {
    CGSize size = CGSizeMake(382, 400); // size of view in popover
    self.contentSizeForViewInPopover = size;
}

- (void)loadHelp {
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"info" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:strPath];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setPopOverSize];
    [self loadHelp];
    self.navigationItem.title=@"Information";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setPopOverSize];
    [self loadHelp];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setPopOverSize];
    [self loadHelp];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self setPopOverSize];
}

- (void)viewDidUnload
{
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

@end
