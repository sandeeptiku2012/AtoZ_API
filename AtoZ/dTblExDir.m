//
//  dTblExDir.m
//  AtoZdatabases
//
//  Created by Valtech on 1/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "dTblExDir.h"
#import "dResultDtlVCtr.h"
#import "pRcrdDtls.h"

@implementation dTblExDir

@synthesize arForTable = _arForTable;
@synthesize arForTable2 = _arForTable2;
@synthesize strInnerHTML = _strInnerHTML;
@synthesize vHeader = _vHeader;
@synthesize predResultDtlVCtr = _predResultDtlVCtr;
@synthesize prepRcrdDtls = _prepRcrdDtls;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)noData {
    [(UIButton*)[self.vHeader viewWithTag:1] setTitle:@"Executive Directory" forState:UIControlStateNormal];
    [(UILabel*)[self.vHeader viewWithTag:3] setText:@"N/A"];
    [(UILabel*)[self.vHeader viewWithTag:9999] setHidden:YES];
    [(UILabel*)[self.vHeader viewWithTag:8888] setHidden:YES];
    if(UI_USER_INTERFACE_IDIOM())
		[(UILabel*)[self.vHeader viewWithTag:3] setFont:self.predResultDtlVCtr.lblNormalFont.font];
	else
		[(UILabel*)[self.vHeader viewWithTag:3] setFont:self.prepRcrdDtls.lblNormalFont.font];
}

- (void)shouldReloadThings {
    
    if(![self.arForTable isKindOfClass:[NSString class]]) {
        NSMutableArray *arDummy = [NSMutableArray array];
        //NSLog(@"array is %@",self.arForTable);
        NSMutableString *strHTML = [NSMutableString string];
        [(UILabel*)[self.vHeader viewWithTag:9999] setHidden:NO];
        [(UILabel*)[self.vHeader viewWithTag:8888] setHidden:NO];
		if(UI_USER_INTERFACE_IDIOM())
			[(UILabel*)[self.vHeader viewWithTag:3] setFont:self.predResultDtlVCtr.lblBoldFont.font];
		else
			[(UILabel*)[self.vHeader viewWithTag:3] setFont:self.prepRcrdDtls.lblBoldFont.font];
		
        for (NSArray *arToAccess in self.arForTable) {
            NSMutableDictionary *dForCompetitors = [NSMutableDictionary dictionary];
 
            NSString *strName1 = nil;
            if ([[arToAccess objectAtIndex:5] isKindOfClass:[NSNull class]]) {
               strName1 = @"";
            } else {
                strName1 = ([arToAccess objectAtIndex:5] && [[arToAccess objectAtIndex:5] length]>0 && ![[arToAccess objectAtIndex:5] isEqualToString:@"N/A"])?[arToAccess objectAtIndex:5]:@"";
            }
            
            NSString *strName2 = nil;
            if ([[arToAccess objectAtIndex:0] isKindOfClass:[NSNull class]]) {
                strName2 = @"";
            } else {
                strName2 = ([arToAccess objectAtIndex:0] && [[arToAccess objectAtIndex:0] length]>0 && ![[arToAccess objectAtIndex:0] isEqualToString:@"N/A"])?[arToAccess objectAtIndex:0]:@"";
            }
            
            NSString *strName3 = nil;
            if ([[arToAccess objectAtIndex:2] isKindOfClass:[NSNull class]]) {
                strName3 = @"";
            } else {
                strName3 = ([arToAccess objectAtIndex:2] && [[arToAccess objectAtIndex:2] length]>0 && ![[arToAccess objectAtIndex:2] isEqualToString:@"N/A"])?[arToAccess objectAtIndex:2]:@"";
            }
            
            NSString *strName4 = nil;
            if ([[arToAccess objectAtIndex:6] isKindOfClass:[NSNull class]]) {
                strName4 = @"";
            } else {
                strName4 = ([arToAccess objectAtIndex:6] && [[arToAccess objectAtIndex:6] length]>0 && ![[arToAccess objectAtIndex:6] isEqualToString:@"N/A"])?[arToAccess objectAtIndex:6]:@"";
            }
            
            NSString *strEmail = nil;
            if ([[arToAccess objectAtIndex:7] isKindOfClass:[NSNull class]]) {
                strEmail = @"";
            } else {
                strEmail = ([arToAccess objectAtIndex:7] && [[arToAccess objectAtIndex:7] length]>0 && ![[arToAccess objectAtIndex:7] isEqualToString:@"N/A"])?[arToAccess objectAtIndex:7]:@"";
            }
            
            NSString *strPosition = nil;
            if ([[arToAccess objectAtIndex:4] isKindOfClass:[NSNull class]]) {
                strPosition = @"";
            } else {
                strPosition = ([arToAccess objectAtIndex:4] && [[arToAccess objectAtIndex:4] length]>0 && ![[arToAccess objectAtIndex:4] isEqualToString:@"N/A"])?[arToAccess objectAtIndex:4]:@"";
            }
        
            strPosition = [strPosition stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSString *strName = nil;
            if (([strName1 isEqualToString:@""] && [strName2 isEqualToString:@""] && [strName3 isEqualToString:@""] && [strName4 isEqualToString:@""]) || [strPosition isEqualToString:@""]) {
                strName = nil;
            } else {
                strName = [NSString stringWithFormat:@"%@ %@ %@ %@",strName1,strName2, strName3, strName4];
            }
            
            strName = [strName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if (strName == nil) {
                strPosition = @"";
            }
            
            strEmail = [strEmail stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if (strName == nil) {
                strEmail = @"";
            }
            
            if (strName == nil && [strPosition isEqualToString:@""] && [strEmail isEqualToString:@""])
                continue;
            
            [dForCompetitors setValue:strPosition forKey:@"title"];
            [dForCompetitors setValue:strName forKey:@"name"];
            [dForCompetitors setValue:strEmail forKey:@"email"];
            [arDummy addObject:dForCompetitors];
            
            // for HTML Work border-left: none
            [strHTML appendFormat:@"<tr border-left='none' border-right='none' border-top='none' border-bottom='solid 1px black'><td>%@</td><td>%@</td></tr>",
             [NSString stringWithFormat:@"%@\n%@",strName,strEmail],strPosition
             ];
        }
        self.arForTable2=[NSArray arrayWithArray:arDummy];
        [self.tableView reloadData];
        
        NSString *str=[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"exdir" ofType:@"html"]
                                                encoding:NSUTF8StringEncoding
                                                   error:nil];
        str = [NSString stringWithFormat:str,strHTML];
        self.strInnerHTML=str;
        if(self.arForTable2.count>0) {
            [(UIButton*)[self.vHeader viewWithTag:1] setTitle:@"Name" forState:UIControlStateNormal];
            [(UILabel*)[self.vHeader viewWithTag:3] setText:@"Title"];
        } else {
            [self noData];
        }
    } else {
        [self noData];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    return (self.interfaceOrientation == UIInterfaceOrientationPortrait);
}
#endif

#ifdef IOS_NEWER_OR_EQUAL_TO__IPHONE_6_0
-(BOOL)shouldAutorotate
{
    if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        return YES;
    } else {
        return NO;
    }
}
- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait);
}
#endif

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arForTable2.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CCell" owner:self options:nil] objectAtIndex:(UI_USER_INTERFACE_IDIOM())?3:7];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    [(UILabel*)[cell viewWithTag:1] setText:[[self.arForTable2 objectAtIndex:indexPath.row] valueForKey:@"name"]];
    [(UIButton*)[cell viewWithTag:2] setTitle:[[self.arForTable2 objectAtIndex:indexPath.row] valueForKey:@"title"]
                                     forState:UIControlStateNormal];
    [(UILabel*)[cell viewWithTag:3] setText:[[self.arForTable2 objectAtIndex:indexPath.row] valueForKey:@"email"]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

