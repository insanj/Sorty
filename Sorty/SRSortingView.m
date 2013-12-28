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
    if((self = [super initWithFrame:frame])){
		towerColor = [UIColor blackColor];
		soundsEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"SRSounds"];
		[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
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
	
	array = [[NSMutableArray alloc] initWithArray:given];
	towers = [[NSMutableArray alloc] init];
	for(int i = 0; i < given.count; i++){
		NSInteger height = ceilf(2 + ((((NSNumber *)given[i]).intValue - minVal) * ((self.frame.size.height - 2)/(maxVal - minVal))));
		UIView *tower = [[UIView alloc] initWithFrame:CGRectMake(ceilf(i * (self.frame.size.width / array.count)), self.frame.size.height - height, ceilf(self.frame.size.width / array.count), height)];
		tower.backgroundColor = towerColor;
		tower.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		[towers addObject:tower];
		[self addSubview:towers[i]];
	}
	
	if([name isEqualToString:@"Bubble Sort"]){
		sortThread = [[NSThread alloc] initWithTarget:self selector:@selector(bubbleSort) object:nil];
		[sortThread start];
	}
	
	else if([name isEqualToString:@"Bogo Sort"]){
		sortThread = [[NSThread alloc] initWithTarget:self selector:@selector(bogoSort) object:nil];
		[sortThread start];
	}


}//end if

-(void)bubbleSort{
	BOOL swapped = YES;
	while(swapped){
		swapped = NO;

		for(int i = 1; i < array.count; i++){
			UIView *firstTower = towers[i-1];
			UIView *secondTower = towers[i];
					
			[NSThread sleepForTimeInterval:delay];
			dispatch_sync(dispatch_get_main_queue(), ^{
				[firstTower setBackgroundColor:[UIColor greenColor]];
				[secondTower setBackgroundColor:[UIColor greenColor]];
			});
			

			if([array[i-1] intValue] > [array[i] intValue]){
				swapped = YES;
				
				[NSThread sleepForTimeInterval:delay];
				dispatch_sync(dispatch_get_main_queue(), ^{
					[firstTower setBackgroundColor:[UIColor redColor]];
					[secondTower setBackgroundColor:[UIColor redColor]];
					
					[towers setObject:firstTower atIndexedSubscript:i];
					[towers setObject:secondTower atIndexedSubscript:i-1];
				});
				
				[array exchangeObjectAtIndex:i-1 withObjectAtIndex:i];
				[self playSum:([array[i-1] intValue] + [array[i] intValue])];
				
				[NSThread sleepForTimeInterval:delay];
				dispatch_sync(dispatch_get_main_queue(), ^{
					[firstTower setBackgroundColor:towerColor];
					[secondTower setBackgroundColor:towerColor];
					[self updateTowers];

				});

			}//end if
		}//end for
	}//end while
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


-(void)playSum:(CGFloat)freq{
	if(soundsEnabled){
		TGSineWaveToneGenerator __block *gen = [[TGSineWaveToneGenerator alloc] initWithFrequency:(freq * 10) amplitude:2];
		[gen playForDuration:delay>0.f?delay*10:.0005];
	
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
			gen = nil;
		});
	}
}

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

}

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
}

-(void)deviceOrientationDidChange:(NSNotification *)notification{
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	NSLog(@"rotated to: %d", orientation);
}

-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

@end