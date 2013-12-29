//
//  SRAppDelegate.h
//  Sorty
//
//  Created by Julian Weiss on 12/26/13.
//  Copyright (c) 2013 insanj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRMasterViewController.h"
#define isiOS7 [[UIDevice currentDevice].systemVersion floatValue]>=7.0

@interface SRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

@end