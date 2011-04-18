//
//  AudioController.m
//  HypeIphone
//
//  Created by Farid Zakaria on 11-04-05.
//  Copyright 2011 Setheron Media. All rights reserved.
//

#import "AudioController.h"
#import "AudioStreamer.h"
#import "Song.h"

static AudioController * sharedAudioController = nil;

@implementation AudioController

@synthesize audioStreamer, currentSongPlaying;

+(id) sharedAudioController
{
    @synchronized(self)
    {
        if (sharedAudioController == nil)
        {
            sharedAudioController = [[self alloc] init];
        }
        return sharedAudioController;
    }
}


- (void)dealloc {
    // Should never be called, but just here for clarity really.
    currentSongPlaying = nil;
    audioStreamer = nil;
    [super dealloc];
}


//
// createStreamer
//
// Creates or recreates the AudioStreamer object.
//
- (void)createStreamerWithUrl:(NSURL*)aUrl andCookie:(NSString*)aCookie
{
    if (audioStreamer)
    {
        [self destroyStreamer];
    }
    audioStreamer = [ [AudioStreamer alloc] initWithURL:aUrl];
    audioStreamer.cookie = aCookie;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playbackStateChanged:)
     name:ASStatusChangedNotification
     object:audioStreamer];
    
    //[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

//
// destroyStreamer
//
// Removes the streamer, the UI update timer and the change notification
//
- (void)destroyStreamer
{
	if (audioStreamer)
	{   
        //[[UIApplication sharedApplication] endReceivingRemoteControlEvents];
        
        [[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:ASStatusChangedNotification
         object:audioStreamer];
        
		[audioStreamer stop];
		[audioStreamer release];
         audioStreamer = nil;
	}
}

-(void) play:(Song *)newSong withCookie:(NSString *)aCookie
{
    currentSongPlaying = newSong;
    [self createStreamerWithUrl:[NSURL URLWithString:[currentSongPlaying downloadUrlAsString]] andCookie:aCookie];
    [audioStreamer start];
}

-(void) pause
{
    [audioStreamer pause];
}

-(void) stop
{
    [audioStreamer stop];
}

- (void)seekToTime:(double)newSeekTime
{
    [audioStreamer seekToTime:newSeekTime];
}

- (BOOL)isPlaying
{
    return [audioStreamer isPlaying];
}

- (BOOL)isPaused
{
    return [audioStreamer isPaused];
}

- (BOOL)isWaiting
{
    return [audioStreamer isWaiting];
}

- (BOOL)isIdle
{
    return [audioStreamer isIdle];
}

-(double) durationPlayed
{
    return [audioStreamer duration];
}

// playbackStateChanged:
//
// Invoked when the AudioStreamer
// reports that its playback status has changed.
//
- (void)playbackStateChanged:(NSNotification *)aNotification
{
	if ([audioStreamer isWaiting])
	{
        NSLog(@"Streaming is waiting...");
	}
	else if ([audioStreamer isPlaying])
	{
		NSLog(@"Streaming is playing...");
	}
	else if ([audioStreamer isIdle])
	{
        NSLog(@"Streaming is idle...");
	}
    else if ([audioStreamer isPaused])
	{
        NSLog(@"Streaming is paused...");
	}
}

@end
