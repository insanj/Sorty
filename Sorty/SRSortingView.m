//
//  SRSortingView.m
//  Sorty
//
//  Created by Julian Weiss on 12/27/13.
//  Copyright (c) 2013 insanj. All rights reserved.
//

#import "SRSortingView.h"

@implementation SRSortingView
@synthesize towerColor, delay, sortThread, soundsEnabled;

-(SRSortingView *)initWithFrame:(CGRect)frame{
    if((self = [super initWithFrame:frame]))
		towerColor = [UIColor blackColor];
	
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
	
	array = [[NSMutableArray alloc] initWithArray:given];
	towers = [[NSMutableArray alloc] init];
	for(int i = 0; i < given.count; i++){
		NSInteger height = ceilf(2 + ((((NSNumber *)given[i]).intValue - minVal) * ((self.frame.size.height - 2)/(maxVal - minVal))));
		UIView *tower = [[UIView alloc] initWithFrame:CGRectMake(ceilf(i * (self.frame.size.width / array.count)), self.frame.size.height - height, ceilf(self.frame.size.width / array.count), height)];
		tower.backgroundColor = towerColor;
		tower.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		[towers addObject:tower];
		[self addSubview:towers[i]];
	}//end for
	
	soundsEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"SRSounds"];
	soundDelay = delay>0.f?delay:.01;
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

-(void)bubbleSort{
	BOOL sorted = NO;
	while(!sorted){
		sorted = YES;

		for(int i = 1; i < array.count; i++){
			UIView *firstTower = towers[i-1];
			UIView *secondTower = towers[i];
					
			[NSThread sleepForTimeInterval:delay];
			dispatch_sync(dispatch_get_main_queue(), ^{
				[firstTower setBackgroundColor:[UIColor greenColor]];
				[secondTower setBackgroundColor:[UIColor greenColor]];
			});
			

			if([array[i-1] intValue] > [array[i] intValue]){
				sorted = NO;
				
				[NSThread sleepForTimeInterval:delay];
				dispatch_sync(dispatch_get_main_queue(), ^{
					[firstTower setBackgroundColor:[UIColor redColor]];
					[secondTower setBackgroundColor:[UIColor redColor]];
		
					[towers setObject:firstTower atIndexedSubscript:i];
					[towers setObject:secondTower atIndexedSubscript:i-1];
					
					[self playSum:([array[i-1] intValue] + [array[i] intValue])];
				});
				
				[array exchangeObjectAtIndex:i-1 withObjectAtIndex:i];
				
				[NSThread sleepForTimeInterval:delay];
				dispatch_sync(dispatch_get_main_queue(), ^{
					[firstTower setBackgroundColor:towerColor];
					[secondTower setBackgroundColor:towerColor];
					
					[self updateTowers];
				});
			}//end if
		}//end for
	}//end while
	
	if(soundsEnabled){
		TGSineWaveToneGenerator __block *gen = [[TGSineWaveToneGenerator alloc] initWithFrequency:500 amplitude:2.5];
		[gen playForDuration:0.25];
	}//end if
}//end method

-(void)bogoSort{
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
}//end method

-(void)quickSort{
	[self quickSort:array low:0 high:(int)array.count-1];
}

-(void)quickSort:(NSMutableArray*)a low:(int)low high:(int)high{
	if([sortThread isCancelled])
		return;
		
	[NSThread sleepForTimeInterval:delay];
	int piv = [a[(arc4random() % (high-low))+low] intValue];
	dispatch_sync(dispatch_get_main_queue(), ^{[towers[piv] setBackgroundColor:[UIColor redColor]];});
				  
	int firstPos = low;
	int lastPos = high;
	
	while(firstPos < lastPos){
		while([a[firstPos] intValue] < piv){
			firstPos++;
			if(firstPos > lastPos)
				break;
		}//end while
		
		while([a[firstPos] intValue] > piv){
			lastPos--;
			if(lastPos < firstPos)
				break;
		}//end while
		
		if(firstPos <= lastPos){
			[a exchangeObjectAtIndex:firstPos withObjectAtIndex:lastPos];
			
			dispatch_sync(dispatch_get_main_queue(), ^{
				[towers[firstPos] setBackgroundColor:[UIColor greenColor]];
				[towers[lastPos] setBackgroundColor:[UIColor greenColor]];
				[self playSum:([a[firstPos] intValue] + [array[lastPos] intValue])];
				[self updateTowers];

			});
			
			[towers exchangeObjectAtIndex:firstPos withObjectAtIndex:lastPos];
			firstPos++;
			lastPos--;
				
			if(firstPos>lastPos)
				break;
		}//end if
		
		if(low < lastPos)
			[self quickSort:array low:low high:lastPos];
		if(firstPos < high)
			[self quickSort:array low:firstPos high:high];
	}//end while
}//end method

-(void)playSum:(CGFloat)freq{
	if(soundsEnabled){
		TGSineWaveToneGenerator __block *gen = [[TGSineWaveToneGenerator alloc] initWithFrequency:(freq * freqCoeff) amplitude:2];
		[gen playForDuration:soundDelay];
	}//end if
}//end method

-(void)genTowers{
	for(UIView *t in towers)
		[t removeFromSuperview];
	
	[towers removeAllObjects];
	for(int i = 0; i < array.count; i++){
		NSInteger height = ceilf(2 + ((((NSNumber *)array[i]).intValue - minVal) * ((self.frame.size.height - 2)/(maxVal - minVal))));
		UIView *tower = [[UIView alloc] initWithFrame:CGRectMake(ceilf(i * (self.frame.size.width / array.count)), self.frame.size.height - height, ceilf(self.frame.size.width / array.count), height)];
		tower.backgroundColor = towerColor;
		tower.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		[towers addObject:tower];
		[self addSubview:towers[i]];
	}
}//end method

-(void)updateTowers{
	for(int i = 0; i < array.count; i++){
		UIView *lastTower = towers[i];
		[lastTower removeFromSuperview];
		NSInteger height = ceilf(2 + ((((NSNumber *)array[i]).intValue - minVal) * ((self.frame.size.height - 2)/(maxVal - minVal))));
		UIView *tower = [[UIView alloc] initWithFrame:CGRectMake(ceilf(i * (self.frame.size.width / array.count)), self.frame.size.height - height, ceilf(self.frame.size.width / array.count), height)];
		tower.backgroundColor = lastTower.backgroundColor;
		tower.autoresizingMask = lastTower.autoresizingMask;
		[towers setObject:tower atIndexedSubscript:i];
		[self addSubview:towers[i]];
	}
}//end method

@end