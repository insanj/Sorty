//
//  SRSortingView.h
//  Sorty
//
//  Created by Julian Weiss on 12/27/13.
//  Copyright (c) 2013 insanj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TGSineWaveToneGenerator.h"

@interface SRSortingView : UIView {
	NSMutableArray *array, *towers;
	NSInteger minVal, maxVal;
	CGFloat soundDelay, freqCoeff;
}

@property (nonatomic, retain) UIColor *towerColor;
@property (nonatomic, readwrite) NSTimeInterval delay;
@property (nonatomic, readwrite) BOOL soundsEnabled;

@property (nonatomic, retain) NSThread *sortThread;

-(void)sort:(NSArray *)given kind:(NSString *)kind;
@end