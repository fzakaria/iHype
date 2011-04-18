//
//  SongDetailViewController.h
//  iHype
//
//  Created by Farid Zakaria on 11-04-16.
//  Copyright 2011 Setheron Media. All rights reserved.
//

#import <Three20/Three20.h>

@class Song;

@interface SongDetailViewController :  TTTableViewController {
    Song * _song;
}
- (id)initWithSongIndex:(int)songIndex;

@property (nonatomic, retain) Song * song;

@end
