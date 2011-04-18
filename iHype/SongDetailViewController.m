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

@implementation SongDetailViewController

@synthesize song = _song;

-(void) dealloc
{
    [_song release];
    [super dealloc];
}

- (id)initWithSongIndex:(int)songIndex {
    
    if (self = [super init]) {
        
        self.tableViewStyle = UITableViewStyleGrouped;
        
        //TTListDataSource *dataSource = [[[TTSectionedDataSource alloc] init] autorelease];
        
    
        NSMutableArray * songs = [SongModel sharedSongModel].songs;
        
        self.song  = (Song *) [songs objectAtIndex:songIndex];
        
        self.title = @"Song Details";
        /*[dataSource.items addObject:@"Song Details"];
        [dataSource.items addObject:[TTTableCaptionItem itemWithText:song.title caption:@"Title"]];
        [dataSource.items addObject:[TTTableCaptionItem itemWithText:song.artist caption:@"Artist"]];
        [dataSource.items addObject:[TTTableCaptionItem itemWithText:song.link caption:@"Link"]];
        [dataSource.items addObject:[TTTableCaptionItem itemWithText:song.id caption:@"ID"]];
        
        [dataSource.items addObject:@"Song Controls"];
        */
        
        CGRect frame = CGRectMake(0.0, 0.0, 200.0, 10.0);
        UISlider *slider = [[UISlider alloc] initWithFrame:frame];
        [slider addTarget:self action:@selector(sliderMoved:) forControlEvents:UIControlEventValueChanged];
        [slider setBackgroundColor:[UIColor clearColor]];
        slider.minimumValue = 0.0;
        slider.maximumValue = 100.0;
        slider.continuous = YES;
        slider.value = 0.0;
        
        self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
                           @"Song Details",
                           [TTTableCaptionItem itemWithText:self.song.title caption:@"Title"],
                           [TTTableCaptionItem itemWithText:self.song.artist caption:@"Artist"],
                           [TTTableCaptionItem itemWithText:self.song.link caption:@"Link"],
                           [TTTableCaptionItem itemWithText:self.song.id caption:@"ID"],
                           @"Song Controls",
                           [TTTableControlItem itemWithCaption:nil control:slider],
                           [PlayPauseTableButton itemWithText:@"Play" delegate:self selector:@selector(playButtonPressed:)],
                           nil];
        
        [slider release];
                           

        
    }
    return self;
    
}

-(IBAction)sliderMoved:(UISlider *)aSlider
{
    NSLog(@"Slider Moved");
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
        [[AudioController sharedAudioController] stop];
    }
    [self refresh];
     NSLog(@"Button Pressed");
}

@end
