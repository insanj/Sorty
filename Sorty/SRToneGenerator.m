//
//  SRToneGenerator
//  Sorty
//
//  Created by Julian Weiss on 12/27/13.
//  Copyright (c) 2013 insanj. All rights reserved.
//
//  Based upon work by Matt Gallagher on 2010/10/20.
//  Copyright 2010 Matt Gallagher. All rights reserved.
//

#import "SRToneGenerator.h"
#import <AudioToolbox/AudioToolbox.h>

OSStatus RenderTone(void *inRefCon, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames, AudioBufferList *ioData){

	SRToneGenerator *toneGenerator = (__bridge SRToneGenerator *)inRefCon;
	double theta = toneGenerator->theta;
	double amplitude = toneGenerator->amplitude;
	double theta_increment = 2.0 * M_PI * toneGenerator->frequency / toneGenerator->sampleRate;
    
	const int channel = 0;
	Float32 *buffer = (Float32 *)ioData->mBuffers[channel].mData;
	
	for(UInt32 frame = 0; frame < inNumberFrames; frame++){
		buffer[frame] = sin(theta) * amplitude;
	
		theta += theta_increment;
		if (theta >= (2 * M_PI))
			theta -= (2 * M_PI);
	}//end for
	
	toneGenerator->theta = theta;
	return noErr;
}//end func

void ToneInterruptionListener(void *inClientData, UInt32 inInterruptionState){
	SRToneGenerator *toneGenerator = (__bridge SRToneGenerator *)inClientData;
	[toneGenerator stop];
}

@implementation SRToneGenerator

#pragma mark - initializations
-(SRToneGenerator *)init{
	if((self = [super init]))
		units = [[NSMutableArray alloc] init];
    return [self initWithFrequency:44100.0f amplitude:1.0];
}

-(id)initWithFrequency:(double)hertz amplitude:(double)volume{
    if((self = [super init])){
		frequency = 440.f;
        amplitude = volume;
        sampleRate = 44100.0f;
		theta = 0;
	}//end if
    
    return self;
}//end init

#pragma mark - tone unit creation
-(AudioComponentInstance)createToneUnitWithFreq:(float)freq{
	AudioComponentInstance toneUnit;
	AudioComponentDescription defaultOutputDescription;
	defaultOutputDescription.componentType = kAudioUnitType_Output;
	defaultOutputDescription.componentSubType = kAudioUnitSubType_RemoteIO;
	defaultOutputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
	defaultOutputDescription.componentFlags = 0;
	defaultOutputDescription.componentFlagsMask = 0;
	
	AudioComponent defaultOutput = AudioComponentFindNext(NULL, &defaultOutputDescription);
	OSErr err = AudioComponentInstanceNew(defaultOutput, &toneUnit);
	
	AURenderCallbackStruct input;
	input.inputProc = RenderTone;
	input.inputProcRefCon = (__bridge void *)(self);
	err = AudioUnitSetProperty(toneUnit, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, 0, &input, sizeof(input));
	
	const int four_bytes_per_float = 4;
	const int eight_bits_per_byte = 8;
	AudioStreamBasicDescription streamFormat;
	streamFormat.mSampleRate = sampleRate;
	streamFormat.mFormatID = kAudioFormatLinearPCM;
	streamFormat.mFormatFlags = kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved;
	streamFormat.mBytesPerPacket = four_bytes_per_float;
	streamFormat.mFramesPerPacket = 1;
	streamFormat.mBytesPerFrame = four_bytes_per_float;
	streamFormat.mChannelsPerFrame = 1;
	streamFormat.mBitsPerChannel = four_bytes_per_float * eight_bits_per_byte;
	err = AudioUnitSetProperty(toneUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, &streamFormat, sizeof(AudioStreamBasicDescription));
	
	return toneUnit;
}//end method

#pragma mark - playing and stopping
-(void)play:(float)freq{
	frequency = freq;
	AudioComponentInstance toneUnit = [self createToneUnitWithFreq:freq];
	AudioUnitInitialize(toneUnit);
	AudioOutputUnitStart(toneUnit);
}//end method

-(void)play:(float)freq length:(float)time{
	frequency = freq;
	AudioComponentInstance toneUnit = [self createToneUnitWithFreq:freq];
	AudioUnitInitialize(toneUnit);
	AudioOutputUnitStart(toneUnit);
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
		AudioOutputUnitStop(toneUnit);
		AudioUnitUninitialize(toneUnit);
		AudioComponentInstanceDispose(toneUnit);
	});
}//end method

-(void)stop{
	NSLog(@"wants to stop!");
}

@end