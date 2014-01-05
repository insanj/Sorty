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
	self = [super initWithFrame:frame];
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
	
	gens = [[NSMutableArray alloc] init];
	
	items = [[SRSortingArray alloc] initWithArray:given];
	items.plain = UIColorFromRGB(0x8180ef);
	items.compared = UIColorFromRGB(0xf1787d);
	items.sorted = UIColorFromRGB(0x97fba7);
	[items generateTowersInto:self];
	
	soundsEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"SRSounds"];
	soundDelay = delay>0.05f?delay:0.05f;
	freqCoeff = [[NSUserDefaults standardUserDefaults] floatForKey:@"SRFreq"];
	
	if([name isEqualToString:@"Bubble Sort"])
		sortThread = [[NSThread alloc] initWithTarget:self selector:@selector(bubbleSort) object:nil];
	
	else if([name isEqualToString:@"Cocktail Shaker Sort"])
		sortThread = [[NSThread alloc] initWithTarget:self selector:@selector(cocktailSort) object:nil];
		
	else if([name isEqualToString:@"Drain Sort"])
		sortThread = [[NSThread alloc] initWithTarget:self selector:@selector(drainSort) object:nil];
	
	else if([name isEqualToString:@"Insertion Sort"])
		sortThread = [[NSThread alloc] initWithTarget:self selector:@selector(insertionSort) object:nil];
	
	else if([name isEqualToString:@"Quicksort"])
		sortThread = [[NSThread alloc] initWithTarget:self selector:@selector(quickSort) object:nil];
		
	else if([name isEqualToString:@"Selection Sort"])
		sortThread = [[NSThread alloc] initWithTarget:self selector:@selector(selectionSort) object:nil];

	else if([name isEqualToString:@"Shell Sort"])
		sortThread = [[NSThread alloc] initWithTarget:self selector:@selector(shellSort) object:nil];
	
	[sortThread start];
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
 }//end bogo*/

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
}//end bubble

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

-(void)drainSort{
	NSInteger maxdex = 0;
	for(int i = 0; i < [items count]; i++)
		if([items compare:i to:maxdex] > 0)
			maxdex = i;
	
	NSArray *orig = [items numbersArray];
	SRSortingArray *sorted = [[SRSortingArray alloc] initWithArray:[[NSArray alloc] init]];
	
	while([sorted count] != orig.count){
		for(int i = 0; i < [items count]; i++){
			[NSThread sleepForTimeInterval:delay];
			dispatch_sync(dispatch_get_main_queue(), ^{
				[items colorComparedTower:i];
			});
			
			if([items objectAtIndex:i].intValue == 0){
				dispatch_async(dispatch_get_main_queue(), ^{
					[sorted addObject:orig[i] consideringMin:minVal max:maxVal andFinalCount:orig.count inView:self];
				});
			}//end if
			
			[self playSum:i];
			[items changeValueOfIndex:i toNewValue:@([items objectAtIndex:i].intValue - 1)];
			
			dispatch_sync(dispatch_get_main_queue(), ^{
				[items regenerateTowersInto:self];
			});
		}//end for
	}//end while
	
	NSArray *finalSorting = [sorted numbersArray];
	[sorted removeAllObjects];
	
	items = [[SRSortingArray alloc] initWithArray:finalSorting];
	items.plain = [UIColor colorWithWhite:0.75 alpha:0.5];
	items.sorted = UIColorFromRGB(0x97fba7);
	
	dispatch_sync(dispatch_get_main_queue(), ^{
		[items generateTowersInto:self];
	});
	
	[self playAscensionOn:items];
}//end drain

-(void)insertionSort{
	for(int i = 0; i < items.count; i++){
		[NSThread sleepForTimeInterval:delay];
		int value = [items objectAtIndex:i].intValue;
		
		int j = i-1;
		for( ; j >= 0 && [items objectAtIndex:j].intValue > value; j--){
			[NSThread sleepForTimeInterval:delay];
			dispatch_sync(dispatch_get_main_queue(), ^{
				[items colorComparedTower:j];
				[items colorComparedTower:j+1];
			});
			
			[self playSum:[items sumOf:j and:j+1]];
			[items exchangeObjectAtIndex:j withObjectAtIndex:j+1];
		}
		
		dispatch_sync(dispatch_get_main_queue(), ^{
			[items regenerateTowersInto:self];
			[items colorSortedTower:j+1];
		});
	}//end for
	
	[self playAscensionOn:items];
}//end cocktail

/*-(void)mergeSort{
	NSLog(@"%@", NSStringFromRange([self mergeSort:NSMakeRange(0, [items count])]));
}

-(NSRange)mergeSort:(NSRange)array{
	if([items count] >= 2){
		int middle = (int)[items count]/2;
		NSRange left = NSMakeRange(0, middle);
		NSRange right = NSMakeRange(middle, ([items count] - middle));
		return [self merge:[self mergeSort:left] andRight:[self mergeSort:right]];
	}
	
	else
		return array;
}//end merge

-(NSRange)merge:(NSRange)leftArray andRight:(NSRange)rightArray{
	NSMutableArray *result = [[NSMutableArray alloc] init];
	NSUInteger right = leftArray.location;
	NSUInteger left = rightArray.location;
	
	while(left < (leftArray.location + leftArray.length) && right < (rightArray.location + rightArray.length)){
		if([items compare:left to:right] < 0)
			[result addObject:[items objectAtIndex:left++]];
		else
			[result addObject:[items objectAtIndex:right++]];
	}//end while

	NSRange leftRange = NSMakeRange(left, leftArray.length - left);
	NSRange rightRange = NSMakeRange(right, rightArray.length - right);
	
	NSArray *newRight = [rightArr subarrayWithRange:rightRange];
	NSArray *newLeft = [leftArr subarrayWithRange:leftRange];
	
	newLeft = [result arrayByAddingObjectsFromArray:newLeft];
	return [newLeft arrayByAddingObjectsFromArray:newRight];
	
	return NSMakeRange(leftArray.location, rightArray.location + rightArray.length);
}*/

-(void)quickSort{
	[self quickSort:items low:0 high:(NSInteger)items.count-1];
	[self playAscensionOn:items];
}//end qs1

-(void)quickSort:(SRSortingArray *)a low:(NSInteger)first high:(NSInteger)last{
	[NSThread sleepForTimeInterval:delay];
	if(first >= last)
		return;
	
	int piv = [a objectAtIndex:(first+last)/2].intValue;
	long left = first;
    long right = last;
	dispatch_sync(dispatch_get_main_queue(), ^{
		[items colorSortedTower:(first+last)/2];
	});
	
    while(left <= right){
		dispatch_sync(dispatch_get_main_queue(), ^{
			[items colorComparedTower:left];
			[items colorComparedTower:right];
		});
		
        while([a objectAtIndex:left].intValue < piv)
            left++;
		
        while([a objectAtIndex:right].intValue > piv)
            right--;
		
        if(left <= right){
			[NSThread sleepForTimeInterval:delay];
			dispatch_sync(dispatch_get_main_queue(), ^{
				[items colorSortedTower:left];
				[items colorSortedTower:right];
			});
			
			[self playSum:[items sumOf:left and:right]];
            [a exchangeObjectAtIndex:left++ withObjectAtIndex:right--];
			
			dispatch_sync(dispatch_get_main_queue(), ^{
				[a resetColorOfTower:left-1];
				[a resetColorOfTower:right+1];
				[a regenerateTowersInto:self];
			});
		}
    }//end while
	
	[self quickSort:a low:first high:right];
	[self quickSort:a low:left high:last];
}//end qs2

-(void)selectionSort{
	for(int i = 0; i < [items count] - 1; i++){
		int min = MAXFLOAT;
		int minindex = i + 1;

		for(int k = i; k < [items count]; k++){
			dispatch_sync(dispatch_get_main_queue(), ^{
				[items colorComparedTower:k];
			});
			
			if([items objectAtIndex:k].intValue < min){
				dispatch_sync(dispatch_get_main_queue(), ^{
					[items colorComparedTower:minindex];
					[items regenerateTowersInto:self];
				});
				
				minindex = k;
				min = [items objectAtIndex:k].intValue;
			}
		}//end for
		
		[self playSum:[items sumOf:i and:minindex]];
		[items exchangeObjectAtIndex:i withObjectAtIndex:minindex];
		
		dispatch_sync(dispatch_get_main_queue(), ^{
			[items regenerateTowersInto:self];
			[items colorSortedTower:minindex];
		});
		
	}//end for
	
	[self playAscensionOn:items];
}//end selection

-(void)shellSort{
	int increment = (int)[items count]/2;
	while(increment > 0){
		[NSThread sleepForTimeInterval:delay];

		for(int i = increment; i < [items count]; i++){
			int j = i;
			int temp = [items objectAtIndex:i].intValue;
			
			while(j >= increment && [items objectAtIndex:j-increment].intValue > temp){
				dispatch_sync(dispatch_get_main_queue(), ^{
					[items colorComparedTower:i];
					[items colorComparedTower:j];
				});
				
				[NSThread sleepForTimeInterval:delay];
				
				[self playSum:[items sumOf:j and:j-increment]];
				[items exchangeObjectAtIndex:j withObjectAtIndex:j-increment];
				j -= increment;
			}//end while
			
			dispatch_sync(dispatch_get_main_queue(), ^{
				[items regenerateTowersInto:self];
				[items colorSortedTower:j];
			});
		}//end for
		
		if (increment == 2)
			increment = 1;
		else
			increment *= (5.0 / 11);
	}//end while
	
	[self playAscensionOn:items];
}//end shell

#pragma mark - sounds and towers

-(void)playSum:(CGFloat)freq{
	if(soundsEnabled){
		SRToneGenerator *gen = [[SRToneGenerator alloc] initWithFrequency:(fmod(350, freq) + 150)*freqCoeff];
		[gens addObject:gen];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[gen playForLength:soundDelay];
		});
		
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(soundDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
			[gens removeObject:gen];
		});
	}
}//end method


-(void)playAscensionOn:(SRSortingArray *)array{
	[array colorSortedTower:0];
	for(int i = 0; i < items.count-1; i++){
		[NSThread sleepForTimeInterval:delay];
		[self playSum:[array sumOf:i and:i+1]];
		dispatch_sync(dispatch_get_main_queue(), ^{
			[array colorSortedTower:i+1];
		});
	}
}//end ascension

#pragma mark - graveyard

-(void)die{
	soundsEnabled = NO;
	soundDelay = 0.0;
	sortThread = nil;
	items = nil;
}

@end