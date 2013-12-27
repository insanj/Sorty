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
		detailItem = @"Bubble Sort";
	
	if([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad){
		UINavigationBar *navigationBar = self.navigationController.navigationBar;
		CGRect titleBarFrame = [detailItem boundingRectWithSize:navigationBar.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Arial-BoldMT" size:18.f]} context:nil];		
		UIButton *titleButton = [[UIButton alloc] initWithFrame:titleBarFrame];
		titleButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:18.f];
		[titleButton setTitle:detailItem forState:UIControlStateNormal];
		[titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[titleButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
		[titleButton addTarget:self action:@selector(revealBar) forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.titleView = titleButton;
	}
}//end method

-(void)viewWillAppear:(BOOL)animated{
	SRSortingView *sortingView = [[SRSortingView alloc] initWithFrame:self.view.frame];
	sortingView.backgroundColor = [UIColor colorWithRed:239/255.f green:239/255.f blue:239/255.f alpha:1.0];
	sortingView.towerColor = [UIColor purpleColor];
	sortingView.delay = 1;
	sortingView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	[self.view addSubview:sortingView];
	[sortingView sort:@[@5, @1, @7, @9, @1, @3, @2, @10, @11] kind:detailItem];
}

-(void)revealBar{
	if(self.navigationController.navigationBar.hidden){
		reveal = nil;
		self.navigationController.navigationBar.hidden = NO;
		[UIView animateWithDuration:0.75 delay:0.01 usingSpringWithDamping:0.5f initialSpringVelocity:0.1f options:UIViewAnimationOptionCurveEaseOut animations:^{
			CGRect downFrame = self.navigationController.navigationBar.frame;
			downFrame.origin.y = [[UIApplication sharedApplication] statusBarFrame].size.height;
			[self.navigationController.navigationBar setFrame:downFrame];
		} completion:nil];
	}
	
	else{
		CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
		[UIView animateWithDuration:0.75 delay:0.01 usingSpringWithDamping:0.5f initialSpringVelocity:0.1f options:UIViewAnimationOptionCurveEaseOut animations:^{
			CGRect upFrame = navigationBarFrame;
			upFrame.origin.y = -upFrame.size.height;
			[self.navigationController.navigationBar setFrame:upFrame];
		} completion:^(BOOL finished){
			self.navigationController.navigationBar.hidden = YES;
			
			reveal = [[UIButton alloc] initWithFrame:navigationBarFrame];
			[reveal addTarget:self action:@selector(revealBar) forControlEvents:UIControlEventTouchUpInside];
			[self.view addSubview:reveal];
		}];
	}//end else
}//end method

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
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
