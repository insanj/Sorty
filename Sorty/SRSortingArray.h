//
//  SRSortingArray.h
//  Sorty
//
//  Created by Julian Weiss on 12/28/13.
//  Copyright (c) 2013 insanj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRSortingArray : NSObject {
	NSInteger minVal, maxVal;
	NSMutableArray *numbers, *towers;
}

@property (nonatomic, retain) UIColor *plain, *compared, *sorted;

//Augmented creation/management methods
-(instancetype)initWithArray:(NSArray *)array;
-(NSUInteger)count;
-(NSNumber *)objectAtIndex:(NSUInteger)index;
-(NSInteger)compare:(NSUInteger)idx1 to:(NSUInteger)idx2;
-(void)replaceObjectAtIndex:(NSUInteger)index withObject:(NSNumber *)num;
-(void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;
-(NSInteger)sumOf:(NSUInteger)idx1 and:(NSUInteger)idx2;

//Tower management methods
-(void)resetColorOfTower:(NSInteger)index;
-(void)colorComparedTower:(NSInteger)index;
-(void)colorSortedTower:(NSInteger)index;
-(void)generateTowersInFrame:(CGRect)frame;
-(void)generateTowersInto:(UIView *)view;
-(void)resetTowersIntoView:(UIView *)view;
-(void)regenerateTowersInto:(UIView *)view;
-(NSArray *)towersArray;
@end