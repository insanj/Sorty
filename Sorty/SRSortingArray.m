//
//  SRSortingArray.m
//  Sorty
//
//  Created by Julian Weiss on 12/28/13.
//  Copyright (c) 2013 insanj. All rights reserved.
//

#import "SRSortingArray.h"

@implementation SRSortingArray
@synthesize plain, compared, sorted, grey;

#pragma mark - augmented creation/management methods
-(instancetype)initWithArray:(NSArray *)array{
	if((self = [super init])){
		numbers = [[NSMutableArray alloc] initWithArray:array];
		towers = [[NSMutableArray alloc] initWithCapacity:numbers.count];

		minVal = NSIntegerMax, maxVal = NSIntegerMin;
		for(NSNumber *n in array){
			if(n.intValue > maxVal)
				maxVal = n.intValue;
			if(n.intValue < minVal)
				minVal = n.intValue;
		}
	}//end if
	
	return self;
}//end init

-(NSUInteger)count{
	return numbers.count;
}

-(NSNumber *)objectAtIndex:(NSUInteger)index{
	return [numbers objectAtIndex:index];
}

-(void)addObject:(NSNumber *)num consideringMin:(NSInteger)min max:(NSInteger)max andFinalCount:(NSUInteger)count inView:(UIView *)view{
	[numbers addObject:num];
	
	NSInteger height = ceilf(2 + ((num.intValue - min) * ((view.frame.size.height - 2)/(max - min))));
	UIView *tower = [[UIView alloc] initWithFrame:CGRectMake((numbers.count-1) * (view.frame.size.width / count), view.frame.size.height - height, ceilf(view.frame.size.width / count), height)];
	tower.backgroundColor = grey;
	tower.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	[towers addObject:tower];
	
	dispatch_sync(dispatch_get_main_queue(), ^{
		[view addSubview:[towers lastObject]];
	});
	
	//NSLog(@"tower: %@ index: %lu count of view: %lu count of towers: %lu", [towers lastObject], [[view subviews] indexOfObject:[towers lastObject]], view.subviews.count, towers.count);
}

-(NSNumber *)removeObjectAtIndex:(NSUInteger)index{
	NSNumber *prev = numbers[index];
	[numbers removeObjectAtIndex:index];
	
	[towers[index] removeFromSuperview];
	[towers removeObjectAtIndex:index];
	
	return prev;
}

-(NSInteger)compare:(NSUInteger)idx1 to:(NSUInteger)idx2{
	return [[numbers objectAtIndex:idx1] compare:[numbers objectAtIndex:idx2]];
}

-(NSInteger)sumOf:(NSUInteger)idx1 and:(NSUInteger)idx2{
	return [[numbers objectAtIndex:idx1] intValue] + [[numbers objectAtIndex:idx2] intValue];
}

//requires regeneration
-(void)changeValueOfIndex:(NSInteger)index toNewValue:(NSNumber *)num{
	[numbers replaceObjectAtIndex:index withObject:num];
}

-(void)replaceObjectAtIndex:(NSUInteger)index withObject:(NSNumber *)num{
	[numbers replaceObjectAtIndex:index withObject:num];
	[towers replaceObjectAtIndex:index withObject:towers[[numbers indexOfObject:num]]];
}

-(void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2{
	[numbers exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
	[towers exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

-(NSArray *)numbersArray{
	return numbers.copy;
}

#pragma mark - tower management methods
-(void)removeTowerFromSuperview:(NSUInteger)index{
	[numbers removeObjectAtIndex:index];
	[towers[index] removeFromSuperview];
}

-(void)resetColorOfTower:(NSInteger)index{
	[towers[index] setBackgroundColor:plain];
}

-(void)colorComparedTower:(NSInteger)index{
	[towers[index] setBackgroundColor:compared];
}

-(void)colorSortedTower:(NSInteger)index{
	[towers[index] setBackgroundColor:sorted];
}

-(void)colorGreyedTower:(NSInteger)index{
	[towers[index] setBackgroundColor:grey];
}

-(void)generateTowersInFrame:(CGRect)frame{
	for(int i = 0; i < numbers.count; i++){
		NSInteger height = ceilf(2 + ((((NSNumber *)numbers[i]).intValue - minVal) * ((frame.size.height - 2)/(maxVal - minVal))));
		UIView *tower = [[UIView alloc] initWithFrame:CGRectMake(ceilf(i * (frame.size.width / numbers.count)), frame.size.height - height, ceilf(frame.size.width / numbers.count), height)];
		tower.backgroundColor = plain;
		tower.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		[towers addObject:tower];
	}//end for
}//end method

-(void)generateTowersInto:(UIView *)view{
	for(int i = 0; i < numbers.count; i++){
		NSInteger height = ceilf(2 + ((((NSNumber *)numbers[i]).intValue - minVal) * ((view.frame.size.height - 2)/(maxVal - minVal))));
		UIView *tower = [[UIView alloc] initWithFrame:CGRectMake(ceilf(i * (view.frame.size.width / numbers.count)), view.frame.size.height - height, ceilf(view.frame.size.width / numbers.count), height)];
		tower.backgroundColor = plain;
		tower.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		[towers addObject:tower];
		[view addSubview:tower];
	}//end for
}//end method

-(void)resetTowersIntoView:(UIView *)view{
	for(UIView *tower in towers){
		[tower removeFromSuperview];
		[view addSubview:tower];
	}
}//end method

-(void)regenerateTowersInto:(UIView *)view{
	for(int i = 0; i < numbers.count; i++){
		[towers[i] removeFromSuperview];
		
		NSInteger height = ceilf(2 + ((((NSNumber *)numbers[i]).intValue - minVal) * ((view.frame.size.height - 2)/(maxVal - minVal))));
		UIView *tower = [[UIView alloc] initWithFrame:CGRectMake(ceilf(i * (view.frame.size.width / numbers.count)), view.frame.size.height - height, ceilf(view.frame.size.width / numbers.count), height)];
		tower.backgroundColor = plain;
		tower.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		[towers replaceObjectAtIndex:i withObject:tower];
		
		[view addSubview:towers[i]];
	}//end for
}

-(NSArray *)towersArray{
	return towers.copy;
}

@end