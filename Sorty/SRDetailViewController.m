//
//  SRDetailViewController.m
//  Sorty
//
//  Created by Julian Weiss on 12/26/13.
//  Copyright (c) 2013 insanj. All rights reserved.
//

#import "SRDetailViewController.h"

@implementation SRDetailViewController
@synthesize detailItem;

#pragma mark - managing the detail item
-(void)setDetailItem:(NSString *)newDetailItem{
    if(detailItem != newDetailItem)
        detailItem = newDetailItem;

    if(self.masterPopoverController != nil)
        [self.masterPopoverController dismissPopoverAnimated:YES];
}//end method

-(void)viewDidLoad{
    [super viewDidLoad];

	if(!detailItem)
		detailItem = @"Bogo Sort";
	
	if([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad){
		UINavigationBar *navigationBar = self.navigationController.navigationBar;
		
		if([detailItem respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]){
			CGRect titleBarFrame = [detailItem boundingRectWithSize:navigationBar.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Arial-BoldMT" size:18.f]} context:nil];
			UIButton *titleButton = [[UIButton alloc] initWithFrame:titleBarFrame];
			titleButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:18.f];
			[titleButton setTitle:detailItem forState:UIControlStateNormal];
			[titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			[titleButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
			[titleButton addTarget:self action:@selector(revealBar) forControlEvents:UIControlEventTouchUpInside];
			self.navigationItem.titleView = titleButton;
			sortingView = [[SRSortingView alloc] initWithFrame:self.view.frame];
		}//end if
		
		else{
			self.title = detailItem;
			sortingView = [[SRSortingView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
		}
		
		sortingView.backgroundColor = [UIColor colorWithRed:239/255.f green:239/255.f blue:239/255.f alpha:1.0];
		sortingView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		[self.view addSubview:sortingView];
		
		NSMutableArray *gen = [NSMutableArray new];
		for(int i = 0, imax = [[NSUserDefaults standardUserDefaults] floatForKey:@"SRItems"]; i < imax; i++)
			[gen addObject:@(arc4random() % imax)];
		sortingView.delay = [[NSUserDefaults standardUserDefaults] floatForKey:@"SRDelay"];
		[sortingView sort:gen kind:detailItem];
	}//end if
}//end method

#pragma mark - effects

-(void)revealBar{
	if(self.navigationController.navigationBar.hidden){
		reveal = nil;
		self.navigationController.navigationBar.hidden = NO;
		[UIView animateWithDuration:0.75 delay:0.01 usingSpringWithDamping:0.65f initialSpringVelocity:0.1f options:UIViewAnimationOptionCurveEaseOut animations:^{
			
			CGRect downFrame = self.navigationController.navigationBar.frame;
			downFrame.origin.y = UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])?[[UIApplication sharedApplication] statusBarFrame].size.height:[[UIApplication sharedApplication] statusBarFrame].size.width;
			[self.navigationController.navigationBar setFrame:downFrame];
		} completion:nil];
	}
	
	else{
		CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
		[UIView animateWithDuration:0.75 delay:0.01 usingSpringWithDamping:0.6f initialSpringVelocity:0.1f options:UIViewAnimationOptionCurveEaseOut animations:^{
			CGRect upFrame = navigationBarFrame;
			upFrame.origin.y = -upFrame.size.height;
			[self.navigationController.navigationBar setFrame:upFrame];
		} completion:^(BOOL finished){
			self.navigationController.navigationBar.hidden = YES;
			
			reveal = [[UIButton alloc] initWithFrame:navigationBarFrame];
			[reveal addTarget:self action:@selector(revealBar) forControlEvents:UIControlEventTouchDown];
			[self.view addSubview:reveal];
		}];
	}//end else
}//end method

-(void)viewWillDisappear:(BOOL)animated{
	if(self.navigationController.navigationBar.hidden){
		reveal = nil;
		[UIView animateWithDuration:0.75 delay:0.01 usingSpringWithDamping:0.65f initialSpringVelocity:0.1f options:UIViewAnimationOptionCurveEaseOut animations:^{
			CGRect downFrame = self.navigationController.navigationBar.frame;
			downFrame.origin.y = UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])?[[UIApplication sharedApplication] statusBarFrame].size.height:[[UIApplication sharedApplication] statusBarFrame].size.width;
			[self.navigationController.navigationBar setFrame:downFrame];
		} completion:nil];
		self.navigationController.navigationBar.hidden = NO;
	}//end if
}

-(void)viewDidDisappear:(BOOL)animated{
	[sortingView die];
	
	if(self.navigationController.navigationBar.hidden){
		CGRect downFrame = self.navigationController.navigationBar.frame;
		downFrame.origin.y = UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])?[[UIApplication sharedApplication] statusBarFrame].size.height:[[UIApplication sharedApplication] statusBarFrame].size.width;
		[self.navigationController.navigationBar setFrame:downFrame];
	}
}

#pragma mark - split view

-(void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController{
    barButtonItem.title = NSLocalizedString(@"Sorts", @"Sorts");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

-(void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}
@end