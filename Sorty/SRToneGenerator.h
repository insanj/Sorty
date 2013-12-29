//
//  SRToneGenerator.h
//  Sorty
//
//  Created by Julian Weiss on 12/27/13.
//  Copyright (c) 2013 insanj. All rights reserved.
//
//  Based upon work by Matt Gallagher on 2010/10/20.
//  Copyright 2010 Matt Gallagher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>

@interface SRToneGenerator : NSObject{
	NSMutableArray *units;
	
@public
	CGFloat frequency;
    CGFloat amplitude;
    CGFloat sampleRate;
    CGFloat theta;
}

-(id)initWithAmplitude:(CGFloat)volume;
-(AudioComponentInstance)createToneUnitWithFreq:(CGFloat)freq;
-(void)play:(CGFloat)freq;
-(void)play:(CGFloat)freq length:(CGFloat)time;
-(void)stop;
@end