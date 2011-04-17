//
//  SongTableDataSource.m
//  iHype
//
//  Created by Farid Zakaria on 11-04-16.
//  Copyright 2011 Setheron Media. All rights reserved.
//

#import "SongTableDataSource.h"
#import "Song.h"
#import "SongModel.h"
#import "SongTableItem.h"
#import "SongTableCell.h"
@implementation SongTableDataSource

-(id)init
{
    if ((self = [super init])) {
        _songModel = [SongModel sharedSongModel];
    }
    
    return self;
}

- (void)dealloc {    
    [super dealloc];
}

- (id<TTModel>)model {
    return _songModel;
}


- (void)tableViewDidLoadModel:(UITableView *)tableView
{
    NSMutableArray* songItems = [[NSMutableArray alloc] init];    
    // Construct an object that is suitable for the table view system
    // from each SearchResult domain object that we retrieve from the TTModel.
    for (int i = 0 ; i < [_songModel.songs count]; ++i)
    {
        Song * song = (Song *) [_songModel.songs objectAtIndex:i];

        
        [songItems addObject:[SongTableItem itemWithTitle:song.title
                                                      artist: song.artist
                                                      imageURL:song.albumUrl
                                                       URL: [NSString stringWithFormat:@"tt://root/%d", i]]];
        
        // There is a bug in Three20's table cell image logic w.r.t.
        // Three20's image cache. By applying this TTImageStyle, we can
        // override the layout logic to force the image to always be a fixed size.
        // (thanks RoBak42 for the workaround!)
       /*tii.imageStyle = [TTImageStyle styleWithImage:nil
                                         defaultImage:[UIImage imageNamed:@"photo_placeholder.png"]
                                          contentMode:UIViewContentModeScaleAspectFill
                                                 size:CGSizeMake(50.f, 50.f)
                                                 next:nil];
        */
       
         //[songItems addObject:tii];
    }
    [songItems addObject:[TTTableMoreButton itemWithText:@"more…"]];
    self.items = songItems;
    TT_RELEASE_SAFELY(songItems);

}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForLoading:(BOOL)reloading {
    if (reloading) {
        return NSLocalizedString(@"Updating HypeMachine feed...", @"HypeMachine feed updating text");
    } else {
        return NSLocalizedString(@"Loading HypeMachine feed...", @"HypeMachine feed loading text");
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForEmpty {
    return NSLocalizedString(@"No songs found.", @"HypeMachine feed no results");
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)subtitleForError:(NSError*)error {
    return NSLocalizedString(@"Sorry, there was an error loading the HypeMachine stream.", @"");
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id) object {   
    
    if ([object isKindOfClass:[SongTableItem class]]) {  
        return [SongTableCell class];  
    } else {  
        return [super tableView:tableView cellClassForObject:object];  
    }  
} 

@end
