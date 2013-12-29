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
    if((self = [super initWithFrame:frame]))
		gen = [[SRToneGenerator alloc] initWithAmplitude:1];
	
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
	items.plain = UIColorFromRGB(0x8180ef);
	items.compared = UIColorFromRGB(0xf1787d);
	items.sorted = UIColorFromRGB(0x97fba7);
	[items generateTowersInto:self];
	
	soundsEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"SRSounds"];
	soundDelay = delay>0.05f?delay:0.05f;
	freqCoeff = [[NSUserDefaults standardUserDefaults] floatForKey:@"SRFreq"];
	
	if([name isEqualToString:@"Bubble Sort"]){
		sortThread = [[NSThread alloc] initWithTarget:self selector:@selector(bubbleSort) object:nil];
		[sortThread start];
	}
	
	else if([name isEqualToString:@"Cocktail Shaker Sort"]){
		sortThread = [[NSThread alloc] initWithTarget:self selector:@selector(cocktailSort) object:nil];
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
				[items colorSortedTower:i-1];
				[items colorSortedTower:i];
			});
			
			if([items compare:i-1 to:i] > 0){
				sorted = NO;
				
				[NSThread sleepForTimeInterval:delay];
				dispatch_sync(dispatch_get_main_queue(), ^{
					[items colorComparedTower:i-1];
					[items colorComparedTower:i-1];
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
	
	for(int i = 1; i < items.count; i++)
		[self playSum:[items sumOf:i-1 and:i]];
}//end method


-(void)cocktailSort{
	BOOL sorted = NO;
	while(!sorted){
		sorted = YES;
		
		for(int i = 0; i < items.count-2; i++){
			[NSThread sleepForTimeInterval:delay];
			
			dispatch_sync(dispatch_get_main_queue(), ^{
				[items colorSortedTower:i];
				[items colorSortedTower:i+1];
			});
			
			if([items compare:i to:i+1] > 0){
				sorted = NO;
				
				[NSThread sleepForTimeInterval:delay];
				dispatch_sync(dispatch_get_main_queue(), ^{
					[items colorComparedTower:i];
					[items colorComparedTower:i+1];
				});
				
				[self playSum:[items sumOf:i and:i+1]];
				[items exchangeObjectAtIndex:i withObjectAtIndex:i+1];
				
				[NSThread sleepForTimeInterval:delay];
				dispatch_sync(dispatch_get_main_queue(), ^{
					[items resetColorOfTower:i];
					[items resetColorOfTower:i+1];
					[items regenerateTowersInto:self];
					
				});
				
			}//end if
		}//end for
		
		if(sorted){
			[items colorSortedTower:items.count-1];
			break;
		}
		
		for(int i = (int)items.count-2; i > 0; i--){
			[NSThread sleepForTimeInterval:delay];
			
			dispatch_sync(dispatch_get_main_queue(), ^{
				[items colorSortedTower:i];
				[items colorSortedTower:i+1];
			});
			
			if([items compare:i to:i+1] > 0){
				sorted = NO;
				
				[NSThread sleepForTimeInterval:delay];
				dispatch_sync(dispatch_get_main_queue(), ^{
					[items colorComparedTower:i];
					[items colorComparedTower:i+1];
				});
				
				[self playSum:[items sumOf:i and:i+1]];
				[items exchangeObjectAtIndex:i withObjectAtIndex:i+1];
				
				[NSThread sleepForTimeInterval:delay];
				dispatch_sync(dispatch_get_main_queue(), ^{
					[items resetColorOfTower:i];
					[items resetColorOfTower:i+1];
					[items regenerateTowersInto:self];
				});
				
			}//end if
		}//end for
	}//end while
	
	for(int i = 0; i < items.count-1; i++)
		[self playSum:[items sumOf:i and:i+1]];
}//end method

-(void)quickSort{
	[self quickSort:items low:0 high:(NSInteger)items.count-1];
}

-(void)quickSort:(SRSortingArray *)a low:(NSInteger)low high:(NSInteger)high{
	[NSThread sleepForTimeInterval:delay];

	if(low < high){
		NSInteger pivot = (arc4random() % (high-low)) + low;
		NSInteger left = low;
		NSInteger right = high;
		dispatch_sync(dispatch_get_main_queue(), ^{
			[items colorSortedTower:pivot];
		});

		while(left <= right){
			dispatch_sync(dispatch_get_main_queue(), ^{
				[items colorComparedTower:left];
				[items colorComparedTower:right];
			});

			while([a compare:left to:pivot] < 0)
				left++;
			while([a compare:right to:pivot] > 0)
				right--;
			
			if(left <= right){
				dispatch_sync(dispatch_get_main_queue(), ^{
					[items colorSortedTower:left];
					[items colorSortedTower:right];
				});
				
				[self playSum:[items sumOf:left and:right]];
				[a exchangeObjectAtIndex:left withObjectAtIndex:right];

				left++;
				right--;
			}
		}
		
		[self quickSort:a low:low high:right];
		[self quickSort:a low:left high:high];
	}
}//end method

#pragma mark - sounds and towers

-(void)playSum:(CGFloat)freq{
	if(soundsEnabled)
		[gen play:(freq * freqCoeff) length:soundDelay];
}//end method

@end