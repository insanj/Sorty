//
//  SRSortingView.h
//  Sorty
//
//  Created by Julian Weiss on 12/27/13.
//  Copyright (c) 2013 insanj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRSortingView : UIView {
	NSMutableArray *array, *towers;
	NSThread *sortThread;
	NSInteger minVal, maxVal;
}

@property (nonatomic, retain) UIColor *towerColor;
@property (nonatomic, readwrite) NSTimeInterval delay;

-(void)sort:(NSArray *)given kind:(NSString *)kind;
@end