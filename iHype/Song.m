//
//  Song.m
//  iHype
//
//  Created by Farid Zakaria on 11-04-15.
//  Copyright 2011 Setheron Media. All rights reserved.
//

#import "Song.h"


@implementation Song

@synthesize id = _id;
@synthesize key = _key;
@synthesize title = _title;
@synthesize description = _description;
@synthesize link = _link;
@synthesize artist = _artist;
@synthesize albumUrl = _albumUrl;


- (void) dealloc {
    TT_RELEASE_SAFELY(_id);
    TT_RELEASE_SAFELY(_key);
    TT_RELEASE_SAFELY(_title);
    TT_RELEASE_SAFELY(_description);
    TT_RELEASE_SAFELY(_albumUrl);
    TT_RELEASE_SAFELY(_link);
    TT_RELEASE_SAFELY(_artist);
    [super dealloc];
}

@end
