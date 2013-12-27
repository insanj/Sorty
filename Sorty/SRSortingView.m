//
//  SRSortingView.m
//  Sorty
//
//  Created by Julian Weiss on 12/27/13.
//  Copyright (c) 2013 insanj. All rights reserved.
//

#import "SRSortingView.h"

@implementation SRSortingView
@synthesize towerColor, delay;

-(SRSortingView *)initWithFrame:(CGRect)frame{
    if((self = [super initWithFrame:frame])){
		towerColor = [UIColor blackColor];
		[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
	}
	
    return self;
}//end method

-(void)sort:(NSArray *)given kind:(NSString *)name{
	
	int maxVal = -MAXFLOAT, minVal = MAXFLOAT;
	for(NSNumber *n in given){
		if(n.intValue > maxVal)
			maxVal = n.intValue;
		if(n.intValue < minVal)
			minVal = n.intValue;
	}
	
	array = [[NSMutableArray alloc] initWithArray:given];
	towers = [[NSMutableArray alloc] init];
	for(int i = 0; i < given.count; i++){
		float height = ceilf(2 + ((((NSNumber *)given[i]).intValue - minVal) * ((self.frame.size.height - 2)/(maxVal - minVal))));
		UIView *tower = [[UIView alloc] initWithFrame:CGRectMake(ceilf(i * (self.frame.size.width / array.count)), self.frame.size.height - height, ceilf(self.frame.size.width / array.count), height)];
		tower.backgroundColor = towerColor;
		tower.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		[towers addObject:tower];
		[self addSubview:towers[i]];
	}
	
	//below might work, irrelevant, however, when the towers do not show
	if([name isEqualToString:@"Bubble Sort"])
		[NSThread detachNewThreadSelector:@selector(bubbleSort) toTarget:self withObject:nil];
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

			if(array[i-1] > array[i]){
				[NSThread sleepForTimeInterval:delay];
				dispatch_sync(dispatch_get_main_queue(), ^{
					[firstTower setBackgroundColor:[UIColor redColor]];
					[secondTower setBackgroundColor:[UIColor redColor]];
					
					CGRect firstFrame = firstTower.frame;
					[firstTower setFrame:secondTower.frame];
					[secondTower setFrame:firstFrame];
					
					[towers setObject:firstTower atIndexedSubscript:i];
					[towers setObject:secondTower atIndexedSubscript:i-1];
				});

				NSObject *first = array[i];
				[array setObject:array[i-1] atIndexedSubscript:i];
				[array setObject:first atIndexedSubscript:(i-1)];
				swapped = YES;
				
				[NSThread sleepForTimeInterval:delay];
				dispatch_sync(dispatch_get_main_queue(), ^{
					[firstTower setBackgroundColor:towerColor];
					[secondTower setBackgroundColor:towerColor];
				});
			}//end if
		}//end for
	}//end while
}//end method


-(void)deviceOrientationDidChange:(NSNotification *)notification{
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	NSLog(@"rotated to: %d", orientation);
}

-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

@end