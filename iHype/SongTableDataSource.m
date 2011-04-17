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
@implementation SongTableDataSource

-(id)init
{
    if ((self = [super init])) {
        _songModel = [[SongModel alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_songModel);
    
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
        TTTableImageItem* tii = [TTTableImageItem itemWithText:song.title
                                                      imageURL:@""
                                                  defaultImage:[UIImage imageNamed:@"photo_placeholder.png"]
                                                           URL:[NSString stringWithFormat:@"tt://root/%d", i]];
        
        // There is a bug in Three20's table cell image logic w.r.t.
        // Three20's image cache. By applying this TTImageStyle, we can
        // override the layout logic to force the image to always be a fixed size.
        // (thanks RoBak42 for the workaround!)
        tii.imageStyle = [TTImageStyle styleWithImage:nil
                                         defaultImage:[UIImage imageNamed:@"photo_placeholder.png"]
                                          contentMode:UIViewContentModeScaleAspectFill
                                                 size:CGSizeMake(75.f, 75.f)
                                                 next:nil];
        [songItems addObject:tii];
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

@end
