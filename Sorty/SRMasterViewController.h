//
//  SRMasterViewController.h
//  Sorty
//
//  Created by Julian Weiss on 12/26/13.
//  Copyright (c) 2013 insanj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRDetailViewController.h"

@class SRDetailViewController;
@interface SRMasterViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>{
	NSMutableArray *objects;
	NSString *aboutText;
}

@property (strong, nonatomic) SRDetailViewController *detailViewController;
@end