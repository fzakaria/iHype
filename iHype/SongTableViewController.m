//
//  SongTableViewController.m
//  iHype
//
//  Created by Farid Zakaria on 11-04-16.
//  Copyright 2011 Setheron Media. All rights reserved.
//

#import "SongTableViewController.h"
#import "SongTableDataSource.h"
#import "Song.h"
#import "SongModel.h"
#import "AudioController.h"

@implementation SongTableViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.title = @"Hype Machine";
        self.variableHeightRows = YES;
    }
    
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    Song * currentSong = [[AudioController sharedAudioController] currentSongPlaying];
    if (currentSong && currentSong.isPlaying)
    {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Now Playing" style:UIBarButtonItemStylePlain target:self action:@selector(nowPlaying)] autorelease];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;  
    }
}

-(void) modelDidFinishLoad:(id<TTModel>)model
{
    Song * currentSong = [[AudioController sharedAudioController] currentSongPlaying];
    if (currentSong)
        [[AudioController sharedAudioController] pause];

    self.navigationItem.rightBarButtonItem = nil; 
    [super modelDidFinishLoad:model];
}


- (void)nowPlaying {
    TTNavigator* navigator = [TTNavigator navigator];

    Song * currentSong = [[AudioController sharedAudioController] currentSongPlaying];
    int indexOfcurrentSong = [[SongModel sharedSongModel] findIndexOfSong:currentSong];
    //sanity
    if (indexOfcurrentSong == -1)
        return;
    
    NSString * urlAsString = [NSString stringWithFormat:@"tt://root/%d", indexOfcurrentSong];
    TTURLAction * action = [TTURLAction actionWithURLPath:urlAsString];
    action.animated = YES;
    [navigator openURLAction:action];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
    self.dataSource = [[[SongTableDataSource alloc] init] autorelease];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
    return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

-(void) refresh
{
    Song * currentSong = [[AudioController sharedAudioController] currentSongPlaying];
    if (currentSong)
    {
        [[AudioController sharedAudioController] stop]; 
    }
    [super refresh];
}

@end
