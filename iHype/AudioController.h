//
//  AudioController.h
//  HypeIphone
//
//  Created by Farid Zakaria on 11-04-05.
//  Copyright 2011 Setheron Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Song;
@class AudioStreamer;

@interface AudioController : NSObject {
    Song * _currentSongPlaying;
    AudioStreamer * _audioStreamer;
    NSTimer * _progressUpdateTimer;
    NSString * _cookie;
}

@property (nonatomic, retain) AudioStreamer * audioStreamer;
@property (nonatomic, retain) Song * currentSongPlaying;
@property (nonatomic, copy) NSString * cookie;

+(id) sharedAudioController; //grab singleton

//audioStreamer methods
-(void) play:(Song*)newSong withCookie:(NSString*)aCookie;
-(void) pause;
-(void) stop;
- (BOOL)isPlaying;
- (BOOL)isPaused;
- (BOOL)isWaiting;
- (BOOL)isIdle;
-(double) durationPlayed;
- (void)seekToTime:(double)newSeekTime;
- (void)createStreamerWithUrl:(NSURL*)aUrl andCookie:(NSString*)aCookie;
- (void)destroyStreamer;
- (void)updateSongProgress:(NSTimer *)updatedTimer;




@end
