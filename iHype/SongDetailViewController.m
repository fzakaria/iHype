//
//  SongDetailViewController.m
//  iHype
//
//  Created by Farid Zakaria on 11-04-16.
//  Copyright 2011 Setheron Media. All rights reserved.
//

#import "SongDetailViewController.h"
#import "Song.h"
#import "SongModel.h"
#import "SongTableViewController.h"
#import "PlayPauseTableButton.h"
#import "AudioController.h"
#import <Foundation/Foundation.h>
#import "AudioStreamer.h"

@implementation SongDetailViewController

@synthesize song = _song;
@synthesize nextSong = _nextSong;
@synthesize spinner = _spinner;
@synthesize slider = _slider;

-(void) dealloc
{    
    [self.spinner release];
    [self.slider release];
    [_song release];
    [_nextSong release];
    [super dealloc];
}

-(UISlider *)initSlider
{
    CGRect frame = CGRectMake(0.0, 0.0, 200.0, 10.0);
    UISlider * slider = [[UISlider alloc] initWithFrame:frame];
    [slider addTarget:self action:@selector(sliderMoved:) forControlEvents:UIControlEventValueChanged];
    [slider setBackgroundColor:[UIColor clearColor]];
    slider.minimumValue = 0.0;
    slider.maximumValue = 100.0;
    slider.continuous = YES;
    slider.value = 100 * ( self.song.played / self.song.length);
    return slider;
}

-(void)setupUI
{
    //choose whether the button should be Pause or Play
    NSString * playButtonText = self.song.isPlaying ? @"Pause" : @"Play";
    
    self.slider = [self initSlider];
    
    //add spinner
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.center = CGPointMake(110, 380);
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    
    //setup datasource
    self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
                       @"Song Details",
                       [TTTableCaptionItem itemWithText:self.song.title caption:@"Title"],
                       [TTTableCaptionItem itemWithText:self.song.artist caption:@"Artist"],
                       [TTTableCaptionItem itemWithText:[self.song lengthAsString] caption:@"Length"],
                       [TTTableCaptionItem itemWithText:self.song.link caption:@"Link"],
                       [TTTableCaptionItem itemWithText:self.song.id caption:@"ID"],
                       @"Song Controls",
                       [TTTableControlItem itemWithCaption:nil control:self.slider],
                       [PlayPauseTableButton itemWithText:playButtonText delegate:self selector:@selector(playButtonPressed:)],
                       nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupUI];
    
    //subscribe to notifications if we are currently being playing
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playbackStateChanged:)
     name:ASStatusChangedNotification
     object:nil];
    
    //notification to last played song
    _progressSliderTimer =
    [NSTimer
     scheduledTimerWithTimeInterval:0.1
     target:self
     selector:@selector(updateSlider:)
     userInfo:nil
     repeats:YES];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:ASStatusChangedNotification
     object:nil];
    
    if (_progressSliderTimer)
    {
        [_progressSliderTimer invalidate];
        _progressSliderTimer = nil;
    }
    
}

- (id)initWithSongIndex:(int)songIndex {
    
    if ((self = [super init])) {
        self.title = @"Song Details";
        
        //lets grab the song for this detailView
        NSMutableArray * songs = [SongModel sharedSongModel].songs;
        self.song  = (Song *) [songs objectAtIndex:songIndex];
        
        
        self.tableViewStyle = UITableViewStyleGrouped;
                
        [self setupUI];
    }
    return self;
    
}

//
// playbackStateChanged:
//
// Invoked when the AudioStreamer
// reports that its playback status has changed.
//
- (void)playbackStateChanged:(NSNotification *)aNotification
{
	if ([[AudioController sharedAudioController] isWaiting])
	{
        [self.spinner startAnimating];
	}
    else
    {
        [self.spinner stopAnimating];
    }
    
    if ([[AudioController sharedAudioController] isIdle])
	{
        //We are only idle when we finish a song so we need to refresh to refresh the play button
        [self refresh];
	}
}

-(IBAction)sliderMoved:(UISlider *)aSlider
{
    double sliderValue = [aSlider value];
    [[AudioController sharedAudioController] seekToTime:sliderValue];
}

-(IBAction) playButtonPressed:(id) sender
{
    PlayPauseTableButton * tableButton = (PlayPauseTableButton*) sender;
    [tableButton toggleButton];
    if ([tableButton isPlaying])
    {
        [[AudioController sharedAudioController] play:self.song withCookie:[SongModel sharedSongModel].cookie];
    }
    else
    {
        [[AudioController sharedAudioController] pause];
    }
    [self refresh];
     NSLog(@"Button Pressed");
}

-(void) updateSlider:(NSTimer *)aNotification
{
    double length = [self.song length];
    double timePlayed = [self.song played];
    [self.slider setValue: 100*(timePlayed/length)];
}

@end
