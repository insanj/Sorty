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
	CGFloat theta = toneGenerator->theta;
	CGFloat theta_increment = 2 * M_PI * toneGenerator->frequency / toneGenerator->sampleRate;
    
	const int channel = 0;
	Float32 *buffer = (Float32 *)ioData->mBuffers[channel].mData;
	
	CGFloat amp = 0.f;
	for(UInt32 frame = 0; frame < inNumberFrames; frame++){
		if(frame < inNumberFrames/2)
			amp += 0.008;
		else
			amp -= 0.008;
		
		buffer[frame] = sinf(theta) * amp;
	
		theta += theta_increment;
		if(theta >= (2 * M_PI))
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

-(instancetype)initWithFrequency:(CGFloat)freq{
    if((self = [super init])){
		frequency = freq;
        amplitude = 1.f;
        sampleRate = 44100.f;
		theta = 0.f;
		
		toneUnit = [self createToneUnitWithFreq:freq];
	}//end if
    
    return self;
}//end init

#pragma mark - tone unit creation
-(AudioComponentInstance)createToneUnitWithFreq:(CGFloat)freq{
	AudioComponentInstance audioInstance;
	AudioComponentDescription defaultOutputDescription;
	defaultOutputDescription.componentType = kAudioUnitType_Output;
	defaultOutputDescription.componentSubType = kAudioUnitSubType_RemoteIO;
	defaultOutputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
	defaultOutputDescription.componentFlags = 0;
	defaultOutputDescription.componentFlagsMask = 0;
	
	AudioComponent defaultOutput = AudioComponentFindNext(NULL, &defaultOutputDescription);
	OSErr err = AudioComponentInstanceNew(defaultOutput, &audioInstance);
	
	AURenderCallbackStruct input;
	input.inputProc = RenderTone;
	input.inputProcRefCon = (__bridge void *)(self);
	err = AudioUnitSetProperty(audioInstance, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, 0, &input, sizeof(input));
	
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
	err = AudioUnitSetProperty(audioInstance, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, &streamFormat, sizeof(AudioStreamBasicDescription));

	AudioUnitInitialize(audioInstance);
	return audioInstance;
}//end method

#pragma mark - playing and stopping

-(void)playForLength:(CGFloat)time{
	AudioOutputUnitStart(toneUnit);

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
		[self stop];
	});
}//end method

-(void)stop{
	AudioOutputUnitStop(toneUnit);
}

-(void)dealloc{
	AudioUnitUninitialize(toneUnit);
	AudioComponentInstanceDispose(toneUnit);
}

@end