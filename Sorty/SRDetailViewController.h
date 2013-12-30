//
//  SRDetailViewController.h
//  Sorty
//
//  Created by Julian Weiss on 12/26/13.
//  Copyright (c) 2013 insanj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRSortingView.h"

@interface SRDetailViewController : UIViewController <UISplitViewControllerDelegate>{
	UIButton *reveal;
	SRSortingView *sortingView;
}

@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) NSString *detailItem;
@end