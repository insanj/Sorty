//
//  SRSortingView.m
//  Sorty
//
//  Created by Julian Weiss on 12/27/13.
//  Copyright (c) 2013 insanj. All rights reserved.
//

#import "SRSortingView.h"

@implementation SRSortingView
@synthesize delay, sortThread, soundsEnabled;

#pragma mark - initializations

-(instancetype)initWithFrame:(CGRect)frame{
    if((self = [super initWithFrame:frame])){
		gen = [[SRToneGenerator alloc] init];
	}
	
    return self;
}//end method

-(void)sort:(NSArray *)given kind:(NSString *)name{
	minVal = NSIntegerMax, maxVal = NSIntegerMin;
	for(NSNumber *n in given){
		if(n.intValue > maxVal)
			maxVal = n.intValue;
		if(n.intValue < minVal)
			minVal = n.intValue;
	}
	
	items = [[SRSortingArray alloc] initWithArray:given];
	items.towerColor = [UIColor purpleColor];
	[items generateTowersInto:self];
	
	soundsEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"SRSounds"];
	soundDelay = delay>0?delay:.01;
	freqCoeff = [[NSUserDefaults standardUserDefaults] floatForKey:@"SRFreq"];
	
	if([name isEqualToString:@"Bubble Sort"]){
		sortThread = [[NSThread alloc] initWithTarget:self selector:@selector(bubbleSort) object:nil];
		[sortThread start];
	}
	
	else if([name isEqualToString:@"Quick Sort"]){
		sortThread = [[NSThread alloc] initWithTarget:self selector:@selector(quickSort) object:nil];
		[sortThread start];
	}
}//end if

#pragma mark - sorts

/*-(void)bogoSort{
	 BOOL unsorted = YES;
	 while(unsorted){
		 unsorted = NO;
		 
		 for(int i = 1; i < array.count; i++){
			 UIView *firstTower = towers[i-1];
			 UIView *secondTower = towers[i];
			 
			 [NSThread sleepForTimeInterval:delay];
			 dispatch_sync(dispatch_get_main_queue(), ^{
			 [firstTower setBackgroundColor:[UIColor greenColor]];
			 [secondTower setBackgroundColor:[UIColor greenColor]];
			 });
			 
			 if([array[i-1] intValue] > [array[i] intValue]){
				 [self playSum:([array[i-1] intValue] + [array[i] intValue])];
				 unsorted = YES;
				 
				 NSMutableArray *repl = [[NSMutableArray alloc] init];
				 for(int i = 0; i < array.count; i++){
					 int randEle = (arc4random() % (array.count-1));
					 if(repl.count > randEle && repl[randEle] == nil)
						 [repl insertObject:repl[i] atIndex:randEle];
						 else if(repl.count < randEle)
						 [repl insertObject:repl[i] atIndex:randEle];
						 else
						 i--;
					 }
					 
					 [NSThread sleepForTimeInterval:delay];
					 [self genTowers];
					 break;
			 }//end if
		 }//end for
	 }//end while
 }//end method*/

-(void)bubbleSort{
	BOOL sorted = NO;
	while(!sorted){
		sorted = YES;

		for(int i = 1; i < items.count; i++){
			[NSThread sleepForTimeInterval:delay];
			dispatch_sync(dispatch_get_main_queue(), ^{
				[items setColorOfTower:i-1 to:[UIColor greenColor]];
				[items setColorOfTower:i to:[UIColor greenColor]];
			});
			
			if([items compare:i-1 to:i] > 0){
				sorted = NO;
				
				[NSThread sleepForTimeInterval:delay];
				dispatch_sync(dispatch_get_main_queue(), ^{
					[items setColorOfTower:i-1 to:[UIColor redColor]];
					[items setColorOfTower:i to:[UIColor redColor]];
				});
				
				[self playSum:[items sumOf:i-1 and:i]];
				[items exchangeObjectAtIndex:i-1 withObjectAtIndex:i];

				[NSThread sleepForTimeInterval:delay];
				dispatch_sync(dispatch_get_main_queue(), ^{
					[items resetColorOfTower:i-1];
					[items resetColorOfTower:i];
					[items regenerateTowersInto:self];

				});
				
			}//end if
		}//end for
	}//end while
}//end method

-(void)quickSort{
	[self quickSort:items low:0 high:(int)items.count-1];
}

-(void)quickSort:(SRSortingArray *)a low:(int)low high:(int)high{
	[NSThread sleepForTimeInterval:delay];
	int piv = [a objectAtIndex:(arc4random() % (high-low))+low].intValue;
	dispatch_sync(dispatch_get_main_queue(), ^{[a setColorOfTower:piv to:[UIColor redColor]];});
				
	int firstPos = low;
	int lastPos = high;
	
	while(firstPos < lastPos){
		dispatch_sync(dispatch_get_main_queue(), ^{[a setColorOfTower:firstPos to:[UIColor redColor]];});

		while([a compare:firstPos to:piv] < 0){
			firstPos++;
			if(firstPos > lastPos)
				break;
		}//end while
		
		while([a compare:firstPos to:piv] > 0){
			lastPos--;
			if(lastPos < firstPos)
				break;
		}//end while
		
		if(firstPos <= lastPos){
			dispatch_sync(dispatch_get_main_queue(), ^{
				[a setColorOfTower:firstPos to:[UIColor greenColor]];
				[a setColorOfTower:lastPos to:[UIColor greenColor]];
			});
			
			[self playSum:[a sumOf:firstPos and:lastPos]];
			[a exchangeObjectAtIndex:firstPos withObjectAtIndex:lastPos];

			dispatch_sync(dispatch_get_main_queue(), ^{
				[items resetColorOfTower:firstPos];
				[items resetColorOfTower:lastPos];
				[items regenerateTowersInto:self];
			});
			
			firstPos++;
			lastPos--;
				
			if(firstPos > lastPos)
				break;
		}//end if
		
		if(low < lastPos)
			[self quickSort:a low:low high:lastPos];
		if(firstPos < high)
			[self quickSort:a low:firstPos high:high];
	}//end while
}//end method

#pragma mark - sounds and towers

-(void)playSum:(CGFloat)freq{
	if(soundsEnabled)
		[gen play:(freq * freqCoeff) length:soundDelay];
}//end method

@end