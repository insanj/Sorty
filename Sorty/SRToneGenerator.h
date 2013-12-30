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
	AudioComponentInstance toneUnit;
	
@public
	CGFloat frequency;
    CGFloat amplitude;
    CGFloat sampleRate;
    CGFloat theta;
}

-(instancetype)initWithFrequency:(CGFloat)freq;
-(AudioComponentInstance)createToneUnitWithFreq:(CGFloat)freq;
-(void)playForLength:(CGFloat)time;
-(void)stop;
@end