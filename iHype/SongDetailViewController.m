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


@implementation SongDetailViewController

- (id)initWithSongIndex:(int)songIndex {
    
    if (self = [super init]) {
        
        self.tableViewStyle = UITableViewStyleGrouped;
        
        //TTListDataSource *dataSource = [[[TTSectionedDataSource alloc] init] autorelease];
        
    
        NSMutableArray * songs = [SongModel sharedSongModel].songs;
        
        Song *song = (Song *) [songs objectAtIndex:songIndex];
        
        self.title = @"Song Details";
        /*[dataSource.items addObject:@"Song Details"];
        [dataSource.items addObject:[TTTableCaptionItem itemWithText:song.title caption:@"Title"]];
        [dataSource.items addObject:[TTTableCaptionItem itemWithText:song.artist caption:@"Artist"]];
        [dataSource.items addObject:[TTTableCaptionItem itemWithText:song.link caption:@"Link"]];
        [dataSource.items addObject:[TTTableCaptionItem itemWithText:song.id caption:@"ID"]];
        
        [dataSource.items addObject:@"Song Controls"];
        */
        
        self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
                           @"Song Details",
                           [TTTableCaptionItem itemWithText:song.title caption:@"Title"],
                           [TTTableCaptionItem itemWithText:song.artist caption:@"Artist"],
                           [TTTableCaptionItem itemWithText:song.link caption:@"Link"],
                           [TTTableCaptionItem itemWithText:song.id caption:@"ID"],
                           @"Song Controls",
                           [TTTableCaptionItem itemWithText:song.id caption:@"ID"],
                           nil];
                           

        
    }
    return self;
    
}

@end
