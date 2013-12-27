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
	
	NSLog(@"%i %i", minVal, maxVal);
	array = [[NSMutableArray alloc] initWithArray:given];
	towers = [[NSMutableArray alloc] init];
	for(int i = 0; i < given.count; i++){
		float height = ceilf(2 + ((((NSNumber *)given[i]).intValue - minVal) * ((self.frame.size.height - 2)/(maxVal - minVal))));
		UIView *tower = [[UIView alloc] initWithFrame:CGRectMake(ceilf(i * (self.frame.size.width / array.count)), self.frame.size.height - height, ceilf(self.frame.size.width / array.count), height)];
		tower.backgroundColor = towerColor;
		tower.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		
		NSLog(@"%i: %@", i, tower);
		[self addSubview:tower]; //<-- DOESN'T WORK
		[towers addObject:tower];
	}
	
	//below might work, irrelevant, however, when the towers do not show
	//if([name isEqualToString:@"Bubble Sort"])
	//	[NSThread detachNewThreadSelector:@selector(bubbleSort) toTarget:self withObject:nil];
}//end if

-(void)bubbleSort{
	[NSThread sleepForTimeInterval:delay];

	BOOL swapped = NO;
	while(!swapped){
		for(int i = 1; i < array.count; i++){
			[[towers objectAtIndex:i-1] setBackgroundColor:[UIColor redColor]];
			[[towers objectAtIndex:i] setBackgroundColor:[UIColor redColor]];
			[NSThread sleepForTimeInterval:delay];

			if(array[i-1] > array[i]){
				[[towers objectAtIndex:i-1] setBackgroundColor:[UIColor greenColor]];
				[[towers objectAtIndex:i] setBackgroundColor:[UIColor greenColor]];
				[NSThread sleepForTimeInterval:delay];

				NSObject *first = array[i];
				[array setObject:array[i-1] atIndexedSubscript:i];
				[array setObject:first atIndexedSubscript:i-1];
				swapped = YES;
			}
			
			[[towers objectAtIndex:i-1] setBackgroundColor:towerColor];
			[[towers objectAtIndex:i] setBackgroundColor:towerColor];
			[NSThread sleepForTimeInterval:delay];
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