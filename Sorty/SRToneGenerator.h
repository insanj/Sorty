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
	double frequency;
    double amplitude;
    double sampleRate;
    double theta;
}

-(id)initWithFrequency:(double)hertz amplitude:(double)volume;
-(AudioComponentInstance)createToneUnitWithFreq:(float)freq;
-(void)play:(float)freq;
-(void)play:(float)freq length:(float)time;
-(void)stop;

@end