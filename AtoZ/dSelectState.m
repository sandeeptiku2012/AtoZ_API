//
//  dSelectState.m
//  AtoZ
//
//  Created by Valtech on 12/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "dSelectState.h"
#import "dRcrdVCtr.h"

@implementation dSelectState

@synthesize preVCtr = _preVCtr;
@synthesize arForStates = _arForStates;
@synthesize predRcrdVCtr = _predRcrdVCtr;
@synthesize tableView = _tableView;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Select State";
}

- (void)clearTexts:(id)sender {
    [self.preVCtr performSelector:@selector(setStrState:) withObject:nil];
    [self.preVCtr performSelector:@selector(setStrStateKey:) withObject:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGSize size = CGSizeMake(337, 292); // size of view in popover
    self.contentSizeForViewInPopover = size;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGSize size = CGSizeMake(337, 292); // size of view in popover
    self.contentSizeForViewInPopover = size;
    [self.predRcrdVCtr.pVCtr setPopoverContentSize:CGSizeMake(337, 336) animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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
//    return YES;
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arForStates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        [cell.textLabel setTextColor:[UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    cell.textLabel.text=[[self.arForStates objectAtIndex:indexPath.row] valueForKey:@"displayValue"];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row==0) {
        [self.preVCtr performSelector:@selector(setStrState:) withObject:nil];
        [self.preVCtr performSelector:@selector(setStrStateKey:) withObject:nil];
    } else {
        NSDictionary *dToAccess = [self.arForStates objectAtIndex:indexPath.row];
        [self.preVCtr performSelector:@selector(setStrState:) withObject:[dToAccess valueForKey:@"displayValue"]];
        [self.preVCtr performSelector:@selector(setStrStateKey:) withObject:[dToAccess valueForKey:@"value"]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
