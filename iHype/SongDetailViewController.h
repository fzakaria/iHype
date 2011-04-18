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
    Song * _nextSong;
    UIActivityIndicatorView * _spinner;
    NSTimer * _progressSliderTimer;
    UISlider * _slider;
}
- (id)initWithSongIndex:(int)songIndex;
-(UISlider *)initSlider;
-(void) updateSlider:(NSTimer *)aNotification;

@property (nonatomic, retain) Song * song;
@property (nonatomic, retain) Song * nextSong;
@property (nonatomic, retain) UIActivityIndicatorView * spinner;
@property (nonatomic, retain) UISlider * slider;

@end
