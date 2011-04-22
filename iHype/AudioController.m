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
#import "SongModel.h"

static AudioController * sharedAudioController = nil;

@implementation AudioController

@synthesize audioStreamer = _audioStreamer;
@synthesize cookie = _cookie;
@synthesize currentSongPlaying = _currentSongPlaying;

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
    self.currentSongPlaying = nil;
    self.audioStreamer = nil;
    self.cookie = nil;
    
    if (_progressUpdateTimer)
	{
		[_progressUpdateTimer invalidate];
		_progressUpdateTimer = nil;
	}
    
    [super dealloc];
}


//
// createStreamer
//
// Creates or recreates the AudioStreamer object.
//
- (void)createStreamerWithUrl:(NSURL*)aUrl andCookie:(NSString*)aCookie
{
    if (self.audioStreamer)
    {
        [self destroyStreamer];
    }
    self.audioStreamer = [ [AudioStreamer alloc] initWithURL:aUrl];
    self.cookie = aCookie;
    self.audioStreamer.cookie = aCookie;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playbackStateChanged:)
     name:ASStatusChangedNotification
     object:self.audioStreamer];
    
    _progressUpdateTimer =
    [NSTimer
     scheduledTimerWithTimeInterval:0.1
     target:self
     selector:@selector(updateSongProgress:)
     userInfo:nil
     repeats:YES];
    
    //[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

//
// destroyStreamer
//
// Removes the streamer, the UI update timer and the change notification
//
- (void)destroyStreamer
{
	if (self.audioStreamer)
	{   
        //[[UIApplication sharedApplication] endReceivingRemoteControlEvents];
        
        [[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:ASStatusChangedNotification
         object:self.audioStreamer];
        
        [_progressUpdateTimer invalidate];
		 _progressUpdateTimer = nil;
        
		[self.audioStreamer stop];
		[self.audioStreamer release];
         self.audioStreamer = nil;
	}
}

//
// updateProgress:
//
// Invoked when the AudioStreamer
// reports that its playback progress has changed.
//
- (void)updateSongProgress:(NSTimer *)updatedTimer
{
	if (self.audioStreamer.bitRate != 0.0)
	{
		double progress = self.audioStreamer.progress;
		double duration = self.audioStreamer.duration;
		
		if (duration > 0)
		{
            self.currentSongPlaying.played = progress;
		}
	}
}

-(void) play:(Song *)newSong withCookie:(NSString *)aCookie
{
    if (self.currentSongPlaying != newSong)
    {
        if (self.currentSongPlaying)
            [self pause];
        [self createStreamerWithUrl:[NSURL URLWithString:[newSong downloadUrlAsString]] andCookie:aCookie];
    }
    self.currentSongPlaying = newSong;
    self.currentSongPlaying.isPlaying = YES;
    [self.audioStreamer start];
}

-(void) pause
{
    self.currentSongPlaying.isPlaying = NO;
    [self.audioStreamer pause];
}

-(void) stop
{
    self.currentSongPlaying.isPlaying = NO;
    [self.audioStreamer stop];
}

- (void)seekToTime:(double)newSeekTime
{
    [self.audioStreamer seekToTime:newSeekTime];
}

- (BOOL)isPlaying
{
    return [self.audioStreamer isPlaying];
}

- (BOOL)isPaused
{
    return [self.audioStreamer isPaused];
}

- (BOOL)isWaiting
{
    return [self.audioStreamer isWaiting];
}

- (BOOL)isIdle
{
    return [self.audioStreamer isIdle];
}

-(double) durationPlayed
{
    return [self.audioStreamer duration];
}

// playbackStateChanged:
//
// Invoked when the AudioStreamer
// reports that its playback status has changed.
//
- (void)playbackStateChanged:(NSNotification *)aNotification
{
	if ([self.audioStreamer isWaiting])
	{
        NSLog(@"Streaming is waiting...");
	}
	else if ([self.audioStreamer isPlaying])
	{
		NSLog(@"Streaming is playing...");
	}
	else if ([self.audioStreamer isIdle])
	{
        NSLog(@"Streaming is idle...");
        //lets play the next song
        NSMutableArray * songs = [[SongModel sharedSongModel] songs];
        int index = [[SongModel sharedSongModel] findIndexOfSong:self.currentSongPlaying];
        self.currentSongPlaying.played = 0;
        Song * nextSong = [songs objectAtIndex:index+1];
        if (nextSong)
            [self play:nextSong withCookie:self.cookie];
	}
    else if ([self.audioStreamer isPaused])
	{
        NSLog(@"Streaming is paused...");
	}
}

@end
