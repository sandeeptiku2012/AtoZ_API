//
//  dTblNearBy.m
//  AtoZdatabases
//
//  Created by Valtech on 1/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "dTblNearBy.h"

#import "dResultDtlVCtr.h"
#import "pRcrdDtls.h"

@implementation dTblNearBy

@synthesize arForTable = _arForTable;
@synthesize arForTable2 = _arForTable2;
@synthesize predResultDtlVCtr = _predResultDtlVCtr;
@synthesize strInnerHTML = _strInnerHTML;
@synthesize vHeader = _vHeader;
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
    [(UIButton*)[self.vHeader viewWithTag:1] setTitle:@"Nearby Businesses" forState:UIControlStateNormal];
    [(UILabel*)[self.vHeader viewWithTag:2] setText:@"N/A"];
    [(UILabel*)[self.vHeader viewWithTag:3] setText:@""];
    [(UILabel*)[self.vHeader viewWithTag:4] setText:@""];
    [(UILabel*)[self.vHeader viewWithTag:9999] setHidden:YES];
    [(UILabel*)[self.vHeader viewWithTag:8888] setHidden:YES];
	if(UI_USER_INTERFACE_IDIOM()) 
		[(UILabel*)[self.vHeader viewWithTag:2] setFont:self.predResultDtlVCtr.lblNormalFont.font];
	else 
		[(UILabel*)[self.vHeader viewWithTag:2] setFont:self.prepRcrdDtls.lblNormalFont.font];
		
	[(UILabel*)[self.vHeader viewWithTag:2] setTextAlignment:UITextAlignmentCenter];
}

- (void)shouldReloadThings {
    
    if(![self.arForTable isKindOfClass:[NSString class]]) {
        NSMutableArray *arDummy = [NSMutableArray array];
        //NSLog(@"array is %@",self.arForTable);
        NSMutableString *strHTML = [NSMutableString string];
        [(UILabel*)[self.vHeader viewWithTag:9999] setHidden:NO];
        [(UILabel*)[self.vHeader viewWithTag:8888] setHidden:NO];
		if(UI_USER_INTERFACE_IDIOM()) 
			[(UILabel*)[self.vHeader viewWithTag:2] setFont:self.predResultDtlVCtr.lblBoldFont.font];
		else
			[(UILabel*)[self.vHeader viewWithTag:2] setFont:self.prepRcrdDtls.lblBoldFont.font];
			
		[(UILabel*)[self.vHeader viewWithTag:2] setTextAlignment:UITextAlignmentLeft];
        for (NSArray *arToAccess in self.arForTable) {
            NSMutableDictionary *dForCompetitors = [NSMutableDictionary dictionary];
            
            NSString *strID = ([arToAccess objectAtIndex:0] && [[arToAccess objectAtIndex:0] length]>0 && ![[arToAccess objectAtIndex:0] isEqualToString:@"N/A"])?[arToAccess objectAtIndex:0]:@"";
            
            NSString *strBName = ([arToAccess objectAtIndex:1] && [[arToAccess objectAtIndex:1] length]>0 && ![[arToAccess objectAtIndex:1] isEqualToString:@"N/A"])?[arToAccess objectAtIndex:1]:@"";
            
            NSString *strAddRessLine1 = ([arToAccess objectAtIndex:2] && [[arToAccess objectAtIndex:2] length]>0 && ![[arToAccess objectAtIndex:2] isEqualToString:@"N/A"])?[arToAccess objectAtIndex:2]:@"";
            NSString *strAddRessLine2 = ([arToAccess objectAtIndex:3] && [[arToAccess objectAtIndex:3] length]>0 && ![[arToAccess objectAtIndex:3] isEqualToString:@"N/A"])?[arToAccess objectAtIndex:3]:@"";
            NSString *strAddRessLine3 = ([arToAccess objectAtIndex:4] && [[arToAccess objectAtIndex:4] length]>0 && ![[arToAccess objectAtIndex:4] isEqualToString:@"N/A"])?[arToAccess objectAtIndex:4]:@"";
            NSString *strAddRessLine4 = ([arToAccess objectAtIndex:5] && [[arToAccess objectAtIndex:5] length]>0 && ![[arToAccess objectAtIndex:5] isEqualToString:@"0"] && ![[arToAccess objectAtIndex:5] isEqualToString:@"N/A"])?[arToAccess objectAtIndex:5]:@"";
            
            NSString *strAddress = nil;
            if ([strAddRessLine1 isEqualToString:@""] && [strAddRessLine2 isEqualToString:@""] && [strAddRessLine3 isEqualToString:@""] && [strAddRessLine4 isEqualToString:@""]) {
                strAddress = nil;
            } else {
                strAddress = [NSString stringWithFormat:@"%@, %@, %@ %@",strAddRessLine1,strAddRessLine2, strAddRessLine3, strAddRessLine4];
            }
            
            NSString *strPhone = ([arToAccess objectAtIndex:6] && [[arToAccess objectAtIndex:6] length]>0 && ![[arToAccess objectAtIndex:6] isEqualToString:@"N/A"] && ![[arToAccess objectAtIndex:6] isEqualToString:@"0"])?[arToAccess objectAtIndex:6]:@"";
            
            NSString *strLOB = ([arToAccess objectAtIndex:8] && [[arToAccess objectAtIndex:8] length]>0 && ![[arToAccess objectAtIndex:8] isEqualToString:@"N/A"])?[arToAccess objectAtIndex:8]:@"";
            
            if (strAddress == nil && [strPhone isEqualToString:@""] && [strID isEqualToString:@""] && [strBName isEqualToString:@""] && [strLOB isEqualToString:@""]) {
                continue;
            }
            
            strPhone = [self append:strPhone];
            
            [dForCompetitors setValue:strAddress forKey:@"address"];
            [dForCompetitors setValue:strPhone forKey:@"phone"];
            [dForCompetitors setValue:strID forKey:@"id"];
            [dForCompetitors setValue:strBName forKey:@"name"];
            [dForCompetitors setValue:strLOB forKey:@"Line Of Business"];
            [arDummy addObject:dForCompetitors];
            // for HTML Work
            [strHTML appendFormat:@"<tr border-left='none' border-right='none' border-top='none' border-bottom='solid 1px black'><td><a id='c_%@'>%@</a></td><td>%@</td><td>%@</td><td>%@</td></tr>",
             strID,strBName,strAddress,strPhone,strLOB
             ];
        }
        self.arForTable2=[NSArray arrayWithArray:arDummy];
        [self.tableView reloadData];
        
        NSString *str=[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nearbybuiz" ofType:@"html"]
                                                encoding:NSUTF8StringEncoding
                                                   error:nil];
        str = [NSString stringWithFormat:str,strHTML];
        self.strInnerHTML=str;
        if(self.arForTable2.count>0) {
            [(UIButton*)[self.vHeader viewWithTag:1] setTitle:@"Name" forState:UIControlStateNormal];
            [(UILabel*)[self.vHeader viewWithTag:2] setText:@"Address"];
            [(UILabel*)[self.vHeader viewWithTag:3] setText:@"Phone"];
            [(UILabel*)[self.vHeader viewWithTag:4] setText:@"Line Of Business"];
        } else {
            [self noData];
        }
    } else {
        [self noData];
    }
}

- (NSString *)append:(NSString *)Phone {
    NSString *result;
    NSString *sub1;
    NSString *sub2;
    NSString *final;
    
    if([Phone isEqualToString:@"N/A"]) 
        return nil;
    if([Phone length]>0 && [Phone length]>9)  {
        result=[NSString stringWithFormat:@"(%@",Phone];
        NSRange range = {0,4};
        NSString *subword = [result substringWithRange:range];
        subword=[NSString stringWithFormat:@"%@)",subword];
        //NSLog(@"%@",subword);
        NSRange range1={4,3};
        sub1=[result substringWithRange:range1];
        //NSLog(@"%@",sub1);
        NSRange range2={7,4};
        sub2=[result substringWithRange:range2];
        //NSLog(@"%@",sub2);
        final=[NSString stringWithFormat:@"%@ %@-%@",subword,sub1,sub2];               
    }
    return final;
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
    return self.arForTable.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CCell" owner:self options:nil] objectAtIndex:
				(UI_USER_INTERFACE_IDIOM())?2:5];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UIButton *btn = (UIButton*)[cell viewWithTag:1];
        [btn addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchDown];
    }
    
    UIButton *btn = (UIButton*)[cell viewWithTag:1];
    UIButton *btnAddress = (UIButton*)[cell viewWithTag:2];
    UIButton *btnPhone = (UIButton*)[cell viewWithTag:3];
    UIButton *btnLine = (UIButton*)[cell viewWithTag:4];
    NSDictionary *dToAccess = [self.arForTable2 objectAtIndex:indexPath.row];
    [(UILabel*)[cell viewWithTag:77] setText:[NSString stringWithFormat:@"%i",indexPath.row]];
    
    [btn setTitle:[dToAccess valueForKey:@"name"] forState:UIControlStateNormal];
    [btnAddress setTitle:[dToAccess valueForKey:@"address"] forState:UIControlStateNormal];
    [btnPhone setTitle:[dToAccess valueForKey:@"phone"] forState:UIControlStateNormal];
    [btnLine setTitle:[dToAccess valueForKey:@"Line Of Business"] forState:UIControlStateNormal];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)btnTapped:(UIButton*)sender {
    NSUInteger index = [[(UILabel*)[[sender superview] viewWithTag:77] text] intValue];
	
	if(UI_USER_INTERFACE_IDIOM()) {
		[self.predResultDtlVCtr loadByID:[[self.arForTable2 objectAtIndex:index] valueForKey:@"id"]];
	} else {
		[self.prepRcrdDtls loadByID:[[self.arForTable2 objectAtIndex:index] valueForKey:@"id"]];
	}
}

@end
