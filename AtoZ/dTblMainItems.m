//
//  dTblMainItems.m
//  AtoZ
//
//  Created by Valtech on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "dTblMainItems.h"

#import "dResultDtlVCtr.h"

@implementation dTblMainItems
@synthesize arForTable = _arForTable;
@synthesize predResultDtlVCtr = _predResultDtlVCtr;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.arForTable = [NSArray arrayWithObjects:@"Overview",@"Demographic Profile",@"Industry Profile",@"Ownership",@"Other Important Information",@"Corporate Linkage",@"QR Code", @"Historical Data", @"Competitors",@"Nearby Businesses",@"Executive Directory",nil];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NewArrowForQL.png"]];
        [imgV setFrame:CGRectMake(2, 0, 22, 22)];
        [imgV setContentMode:UIViewContentModeScaleToFill];
        [cell addSubview:imgV];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setFont:[UIFont fontWithName:@"Trebuchet MS" size:13]];
        [cell.textLabel setTextColor:[UIColor colorWithRed:27/255.0 green:152/255.0 blue:194/255.0 alpha:1]];
    }
    cell.textLabel.text=[NSString stringWithFormat:@"     %@",[self.arForTable objectAtIndex:indexPath.row]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

//
//// Override to support rearranging the table view.
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
//{
//}
//

//
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [(UIButton*)[self.predResultDtlVCtr.vOverView viewWithTag:77777] setSelected:NO];
            [self.predResultDtlVCtr.tbl1 reloadData];
            [self.predResultDtlVCtr.tbl2 reloadData];
            [self.predResultDtlVCtr.tbl1 scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            break;
        case 1:
            [(UIButton*)[self.predResultDtlVCtr.vDemoGPrf viewWithTag:77777] setSelected:NO];
            [self.predResultDtlVCtr.tbl1 reloadData];
            [self.predResultDtlVCtr.tbl2 reloadData];
            [self.predResultDtlVCtr.tbl2 scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            break;
        case 2:
            [(UIButton*)[self.predResultDtlVCtr.vIndPrfl viewWithTag:77777] setSelected:NO];
            [self.predResultDtlVCtr.tbl1 reloadData];
            [self.predResultDtlVCtr.tbl2 reloadData];
            [self.predResultDtlVCtr.tbl1 scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            break;
        case 3:
            [(UIButton*)[self.predResultDtlVCtr.vOwnerShip viewWithTag:77777] setSelected:NO];
            [self.predResultDtlVCtr.tbl1 reloadData];
            [self.predResultDtlVCtr.tbl2 reloadData];
            [self.predResultDtlVCtr.tbl2 scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            break;
        case 4:
            [(UIButton*)[self.predResultDtlVCtr.vOtherImpInfo viewWithTag:77777] setSelected:NO];
            [self.predResultDtlVCtr.tbl1 reloadData];
            [self.predResultDtlVCtr.tbl2 reloadData];
            [self.predResultDtlVCtr.tbl1 scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            break;
        case 5:
            [(UIButton*)[self.predResultDtlVCtr.vCrpLnk viewWithTag:77777] setSelected:NO];
            [self.predResultDtlVCtr.tbl1 reloadData];
            [self.predResultDtlVCtr.tbl2 reloadData];
            [self.predResultDtlVCtr.tbl2 scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            break;
        case 6:
            [(UIButton*)[self.predResultDtlVCtr.vQRCode viewWithTag:77777] setSelected:NO];
            [self.predResultDtlVCtr.tbl1 reloadData];
            [self.predResultDtlVCtr.tbl2 reloadData];
            [self.predResultDtlVCtr.tbl1 scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            break;
        case 7:
            [(UIButton*)[self.predResultDtlVCtr.vRevenueTrend viewWithTag:77777] setSelected:NO];
            [self.predResultDtlVCtr.tbl1 reloadData];
            [self.predResultDtlVCtr.tbl2 reloadData];
            [self.predResultDtlVCtr.tbl2 scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            break;
        case 8:
            [(UIButton*)[self.predResultDtlVCtr.vCompetitors viewWithTag:77777] setSelected:NO];
            [self.predResultDtlVCtr.tbl1 reloadData];
            [self.predResultDtlVCtr.tbl2 reloadData];
            [self.predResultDtlVCtr.tbl1 scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            break;
        case 9:
            [(UIButton*)[self.predResultDtlVCtr.vNearBy viewWithTag:77777] setSelected:NO];
            [self.predResultDtlVCtr.tbl1 reloadData];
            [self.predResultDtlVCtr.tbl2 reloadData];
            [self.predResultDtlVCtr.tbl2 scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            break;
        case 10:
            [(UIButton*)[self.predResultDtlVCtr.vExDir viewWithTag:77777] setSelected:NO];
            [self.predResultDtlVCtr.tbl1 reloadData];
            [self.predResultDtlVCtr.tbl2 reloadData];
            [self.predResultDtlVCtr.tbl1 scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            break;
        default:
            break;
    }
}

@end
