//
//  SRSortingView.h
//  Sorty
//
//  Created by Julian Weiss on 12/27/13.
//  Copyright (c) 2013 insanj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRToneGenerator.h"
#import "SRSortingArray.h"

@interface SRSortingView : UIView {
	SRSortingArray *items;
	NSInteger minVal, maxVal;
	CGFloat soundDelay, freqCoeff;
	SRToneGenerator *gen;
}

@property (nonatomic, readwrite) NSTimeInterval delay;
@property (nonatomic, readwrite) BOOL soundsEnabled;
@property (nonatomic, retain) NSThread *sortThread;

-(void)sort:(NSArray *)given kind:(NSString *)kind;
@end