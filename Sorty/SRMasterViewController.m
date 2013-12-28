//
//  SRMasterViewController.m
//  Sorty
//
//  Created by Julian Weiss on 12/26/13.
//  Copyright (c) 2013 insanj. All rights reserved.
//

#import "SRMasterViewController.h"

@implementation SRMasterViewController
static NSString *aboutText = @"Created with love by Julian (insanj) Weiss. Source available online. Special thanks to thekirbylover and the TGSineWaveToneGenerator project. Tap here to see what I'm up to (and, if you like it, follow me on twitter).";

#pragma mark - view cycle
-(void)viewDidLoad{
	objects = @[@"Bitonic Sort", @"Bogo Sort", @"Bubble Sort", @"Bucket Sort", @"Cocktail Shaker Sort", @"Heap Sort", @"Insertion Sort", @"Merge Sort", @"Quick Sort", @"Radix Sort", @"Selection Sort"].mutableCopy;
	if([[NSUserDefaults standardUserDefaults] floatForKey:@"SRItems"] == 0.f)
		[[NSUserDefaults standardUserDefaults] setFloat:50.f forKey:@"SRItems"];

	if([[NSUserDefaults standardUserDefaults] floatForKey:@"SRDelay"] == 0.f)
		[[NSUserDefaults standardUserDefaults] setFloat:1/[[NSUserDefaults standardUserDefaults] floatForKey:@"SRItems"] forKey:@"SRDelay"];
	
	if([[NSUserDefaults standardUserDefaults] floatForKey:@"SRFreq"] == 0.f)
		[[NSUserDefaults standardUserDefaults] setFloat:10.f forKey:@"SRFreq"];
		
    [super viewDidLoad];
	NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	NSString *name = [build isEqualToString:@"1"]?@"Sorty":[NSString stringWithFormat:@"Sorty (%@)", build];
	
	CGRect titleBarFrame = [name boundingRectWithSize:self.navigationController.navigationBar.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Arial-BoldMT" size:18.f]} context:nil];
	UIButton *title = [[UIButton alloc] initWithFrame:titleBarFrame];
	title.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:18.f];
	[title setTitle:name forState:UIControlStateNormal];
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
	[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]].detailTextLabel.text = @((int)sender.value).stringValue;
}

-(void)changedFreq:(UISlider *)sender{
	[[NSUserDefaults standardUserDefaults] setFloat:sender.value forKey:@"SRFreq"];
	[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]].detailTextLabel.text = @(sender.value).stringValue;
}



#pragma mark - table view
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 3;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if(section==0)
		return @"Options";
	else if(section==1)
		return @"Algorithms";
	return @"About";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if(section==0)
		return 4;
	else if(section==1)
		return objects.count;
	return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return indexPath.section==2?[aboutText boundingRectWithSize:CGSizeMake(self.view.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.f]} context:nil].size.height:50.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSString *identifier = @"SRCell";
	if(indexPath.section == 0)
		identifier = @"SROptionCell";
	else if(indexPath.section == 2)
		identifier = @"SRAboutCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if(!cell){
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
		
		if(indexPath.section == 0){
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.textLabel.font = [UIFont systemFontOfSize:18.f];
			cell.textLabel.textColor = [UIColor blackColor];
			cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
			cell.detailTextLabel.textColor = [UIColor blackColor];
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
		
		else if(indexPath.section == 1){
			cell.textLabel.text = objects[indexPath.row];
			cell.textLabel.font = [UIFont boldSystemFontOfSize:18.f];
			cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
			cell.detailTextLabel.text = nil;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		
		else{
			cell.textLabel.text = aboutText;
			cell.textLabel.textAlignment = NSTextAlignmentNatural;
			cell.textLabel.numberOfLines = 0;
			cell.textLabel.font = [UIFont systemFontOfSize:14.f];
			cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
			cell.detailTextLabel.text = nil;
		}
	}//end nil
	
	if(indexPath.section == 0){
		CGFloat width = cell.frame.size.width/3;

		if(indexPath.row == 0){
			UISwitch *sounds = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
			sounds.center =  CGPointMake(cell.frame.size.width - sounds.frame.size.width, cell.center.y + 2);
			[sounds addTarget:self action:@selector(switchSounds:) forControlEvents:UIControlEventValueChanged];
			[sounds setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"SRSounds"]];
			sounds.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
			sounds.tag = 1;
			
			if(![cell viewWithTag:1])
				[cell addSubview:sounds];
			
			cell.textLabel.text = @"Sounds";
			cell.detailTextLabel.text = sounds.isOn?@"ON":@"OFF";
		}
		
		else if(indexPath.row == 1){
			UISlider *delay = [[UISlider alloc] initWithFrame:CGRectMake(cell.frame.size.width - width - 25, 0, width, 50)];
			delay.center =  CGPointMake(delay.center.x, cell.center.y + 2);
			delay.minimumValue = 0.f;
			delay.maximumValue = 1.f;
			[delay addTarget:self action:@selector(changedDelay:) forControlEvents:UIControlEventValueChanged];
			[delay setValue:[[NSUserDefaults standardUserDefaults] floatForKey:@"SRDelay"]];
			delay.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
			delay.tag = 2;
			
			if(![cell viewWithTag:2])
				[cell addSubview:delay];
			
			cell.textLabel.text = @"Delay";
			cell.detailTextLabel.text = @(delay.value).stringValue;
		}
		
		else if(indexPath.row == 2){
			UISlider *items = [[UISlider alloc] initWithFrame:CGRectMake(cell.frame.size.width - width - 25, 0, cell.frame.size.width/3, 50)];
			items.center =  CGPointMake(items.center.x, cell.center.y + 2);
			items.minimumValue = 10;
			items.maximumValue = 250;
			[items addTarget:self action:@selector(changedItems:) forControlEvents:UIControlEventValueChanged];
			[items setValue:[[NSUserDefaults standardUserDefaults] floatForKey:@"SRItems"]];
			items.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
			items.tag = 3;
			
			if(![cell viewWithTag:3])
				[cell addSubview:items];
			
			cell.textLabel.text = @"Items";
			cell.detailTextLabel.text = @((int)items.value).stringValue;
		}
		
		else if(indexPath.row == 3){
			UISlider *freq = [[UISlider alloc] initWithFrame:CGRectMake(cell.frame.size.width - width - 25, 0, cell.frame.size.width/3, 50)];
			freq.center =  CGPointMake(freq.center.x, cell.center.y + 2);
			freq.minimumValue = 1;
			freq.maximumValue = 100;
			[freq addTarget:self action:@selector(changedFreq:) forControlEvents:UIControlEventValueChanged];
			[freq setValue:[[NSUserDefaults standardUserDefaults] floatForKey:@"SRFreq"]];
			freq.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
			freq.tag = 4;
			
			if(![cell viewWithTag:4])
				[cell addSubview:freq];
			
			cell.textLabel.text = @"Frequency Coeff";
			cell.detailTextLabel.text = @(freq.value).stringValue;
		}
	}//end == 0
	
    return cell;
}//end method

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
	cell.backgroundColor = [UIColor colorWithRed:239/255.f green:239/255.f blue:239/255.f alpha:0.5];
	
	UIView *back = [[UIView alloc] initWithFrame:cell.frame];
    back.backgroundColor = [UIColor colorWithRed:225/255.f green:225/255.f blue:225/255.f alpha:1.0];
    cell.selectedBackgroundView = back;
	
	if(indexPath.section ==1){
		if([@[@"Bubble Sort", @"Quick Sort"] containsObject:cell.textLabel.text])
			cell.textLabel.textColor = [UIColor blackColor];
		
		else{
			cell.textLabel.textColor = [UIColor lightGrayColor];
			[cell setUserInteractionEnabled:NO];
		}
	}//end if
}//end method

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
	return UITableViewCellEditingStyleNone;
}


-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
	NSString *stringToMove = [objects objectAtIndex:fromIndexPath.row];
    [objects removeObjectAtIndex:fromIndexPath.row];
    [objects insertObject:stringToMove atIndex:toIndexPath.row];
}//end method

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if(indexPath.section==1){
		SRDetailViewController *detail = [[SRDetailViewController alloc] init];
		detail.detailItem = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
		[self.navigationController pushViewController:detail animated:YES];
	}
	
	else if(indexPath.section==2){
		NSString *me = @"insanj";
		if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:me]]];
		
		else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]])
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitterrific:///profile?screen_name=" stringByAppendingString:me]]];
		
		else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]])
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:me]]];
		
		else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]])
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:me]]];
		
		else
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:me]]];
	}//end else if
	
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        NSString *name = objects[indexPath.row];
        self.detailViewController.detailItem = name;
    }
}//end method

@end