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
-(void)viewDidLoad{
	objects = @[@"Bubble Sort", @"Insertion Sort", @"Selection Sort"].mutableCopy;
	if([[NSUserDefaults standardUserDefaults] floatForKey:@"SRItems"] == 0.f)
		[[NSUserDefaults standardUserDefaults] setFloat:50 forKey:@"SRItems"];

	if([[NSUserDefaults standardUserDefaults] floatForKey:@"SRDelay"] == 0.f)
		[[NSUserDefaults standardUserDefaults] setFloat:1/[[NSUserDefaults standardUserDefaults] floatForKey:@"SRItems"] forKey:@"SRDelay"];
		
    [super viewDidLoad];
	CGRect titleBarFrame = [@"Sorty" boundingRectWithSize:self.navigationController.navigationBar.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Arial-BoldMT" size:18.f]} context:nil];
	UIButton *title = [[UIButton alloc] initWithFrame:titleBarFrame];
	title.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:18.f];
	[title setTitle:@"Sorty" forState:UIControlStateNormal];
	[title setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	self.navigationItem.titleView = title;
	self.title = @"";

	self.detailViewController = (SRDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
	self.tableView.backgroundColor = [UIColor colorWithRed:239/255.f green:239/255.f blue:239/255.f alpha:1.0];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;

	self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:237/255.f green:243/255.f blue:254/255.f alpha:1.0];
	self.clearsSelectionOnViewWillAppear = YES;
}//end method

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - options config
-(void)switchSounds:(UISwitch *)sender{
	[[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:@"SRSounds"];
	[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].detailTextLabel.text = sender.isOn?@"ON":@"OFF";
}

-(void)changedDelay:(UISlider *)sender{
	[[NSUserDefaults standardUserDefaults] setFloat:sender.value forKey:@"SRDelay"];
	[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].detailTextLabel.text = @(sender.value).stringValue;
}

-(void)changedItems:(UISlider *)sender{
	[[NSUserDefaults standardUserDefaults] setFloat:sender.value forKey:@"SRItems"];
	[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]].detailTextLabel.text = @(sender.value).stringValue;
}

#pragma mark - table view
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if(section==0)
		return @"Options";
	return @"Algorithms";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if(section==0)
		return objects.count;
	return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 50.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *identifier = @"SRCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	
	if(!cell){
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
			
		if(indexPath.section == 0){
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			
			if(indexPath.row == 0){
				cell.textLabel.text = @"Sounds";
				UISwitch *sounds = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
				sounds.center =  CGPointMake(cell.frame.size.width - sounds.frame.size.width*2.25, cell.center.y);
				[sounds addTarget:self action:@selector(switchSounds:) forControlEvents:UIControlEventValueChanged];
				[sounds setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"SRSounds"]];
				sounds.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
				[cell addSubview:sounds];
				
				cell.detailTextLabel.text = sounds.isOn?@"ON":@"OFF";
			}
			
			else if(indexPath.row == 1){
				cell.textLabel.text = @"Delay";
				UISlider *delay = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width/3, 50)];
				delay.center =  CGPointMake(cell.frame.size.width - delay.frame.size.width, cell.center.y);
				delay.minimumValue = 0.f;
				delay.maximumValue = 1.f;
				[delay addTarget:self action:@selector(changedDelay:) forControlEvents:UIControlEventValueChanged];
				[delay setValue:[[NSUserDefaults standardUserDefaults] floatForKey:@"SRDelay"]];
				delay.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
				[cell addSubview:delay];
				
				cell.detailTextLabel.text = @(delay.value).stringValue;
			}
			
			else if(indexPath.row == 2){
				cell.textLabel.text = @"Items";
				UISlider *items = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width/3, 50)];
				items.center =  CGPointMake(cell.frame.size.width - items.frame.size.width, cell.center.y);
				items.minimumValue = 10;
				items.maximumValue = 500;
				[items addTarget:self action:@selector(changedItems:) forControlEvents:UIControlEventValueChanged];
				[items setValue:[[NSUserDefaults standardUserDefaults] floatForKey:@"SRItems"]];
				items.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
				[cell addSubview:items];
				
				cell.detailTextLabel.text = @(items.value).stringValue;
			}
			
		}//end if
	}//end if
	
	if(indexPath.section == 1){
		cell.textLabel.text = objects[indexPath.row];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:18.f];
		cell.textLabel.highlightedTextColor = [UIColor darkGrayColor];
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
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
	if(indexPath.section==1){
		SRDetailViewController *detail = [[SRDetailViewController alloc] init];
		detail.detailItem = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
		[self.navigationController pushViewController:detail animated:YES];
	}
	
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        NSString *name = objects[indexPath.row];
        self.detailViewController.detailItem = name;
    }
}//end method

@end