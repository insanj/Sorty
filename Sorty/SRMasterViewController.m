//
//  SRMasterViewController.m
//  Sorty
//
//  Created by Julian Weiss on 12/26/13.
//  Copyright (c) 2013 insanj. All rights reserved.
//

#import "SRMasterViewController.h"

@implementation SRMasterViewController

#pragma mark - view cycle
-(void)awakeFromNib{
	if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
	    self.clearsSelectionOnViewWillAppear = NO;
	    self.preferredContentSize = CGSizeMake(320.0, 600.0);
	}
	
    [super awakeFromNib];
}//end method

-(void)viewDidLoad{
	objects = @[@"Bubble Sort", @"Insertion Sort", @"Selection Sort"].mutableCopy;
	
    [super viewDidLoad];
	
	self.navigationItem.title = @"Sorty";
	self.detailViewController = (SRDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
	self.tableView.backgroundColor = [UIColor colorWithRed:239/255.f green:239/255.f blue:239/255.f alpha:1.0];
}//end method

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - table view
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return objects.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 50.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SRCell" forIndexPath:indexPath];
	cell.textLabel.text = objects[indexPath.row];
	cell.textLabel.highlightedTextColor = [UIColor darkGrayColor];
    return cell;
}//end method

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
	cell.backgroundColor = [UIColor colorWithRed:239/255.f green:239/255.f blue:239/255.f alpha:0.5];
	
	UIView *back = [[UIView alloc] initWithFrame:cell.frame];
    back.backgroundColor = [UIColor colorWithRed:225/255.f green:225/255.f blue:225/255.f alpha:1.0];
    cell.selectedBackgroundView = back;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
	return UITableViewCellEditingStyleNone;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
	NSString *stringToMove = [objects objectAtIndex:fromIndexPath.row];
    [objects removeObjectAtIndex:fromIndexPath.row];
    [objects insertObject:stringToMove atIndex:toIndexPath.row];
}//end method

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        NSString *name = objects[indexPath.row];
        self.detailViewController.detailItem = name;
    }
}//end method

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *object = objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}//end method

@end