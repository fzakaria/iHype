//
//  PopularSongModel.h
//  iHype
//
//  Created by Farid Zakaria on 11-04-15.
//  Copyright 2011 Setheron Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"

typedef enum {
    NewSongs,
    PopularSongs,
    DefaultSongs = NewSongs
} SongType;

@class Song;
@interface SongModel  : TTURLRequestModel {
    NSMutableArray*  _songs;
    SongType _type;
    NSUInteger _page;
    NSString * _cookie;
}

+ (SongModel *) sharedSongModel;
-(int) findIndexOfSong:(Song*)song;

@property (nonatomic, readonly) NSMutableArray* songs;
@property (nonatomic, copy) NSString* cookie;

@end
