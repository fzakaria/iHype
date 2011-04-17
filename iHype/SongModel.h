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

@interface SongModel  : TTURLRequestModel {
    NSMutableArray*  _songs;
    SongType _type;
}

@property (nonatomic, readonly) NSMutableArray* songs;

@end
