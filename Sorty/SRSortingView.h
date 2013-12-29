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
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

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
-(void)die;
@end