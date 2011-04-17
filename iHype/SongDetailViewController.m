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
        
        self.tableViewStyle = UITableViewStylePlain;
        
        TTListDataSource *dataSource = [[[TTListDataSource alloc] init] autorelease];
        
        SongTableViewController * songTable = (SongTableViewController *) [[TTNavigator globalNavigator] viewControllerForURL:kAppRootURLPath];
    
        NSMutableArray * songs = ((SongModel *)songTable.model).songs;
        
        Song *song = (Song *) [songs objectAtIndex:songIndex];
        
        self.title = @"Song Details";
        
        [dataSource.items addObject:[TTTableCaptionItem 
                                     itemWithText:@"asdas"
                                     caption:@"Title"
                                     URL:@""]];
        
        [dataSource.items addObject:[TTTableCaptionItem 
                                     itemWithText:song.link
                                     caption:@"Link"
                                     URL:@""]];  
    
        
        
        self.dataSource = dataSource;
        
    }
    return self;
    
}

@end
