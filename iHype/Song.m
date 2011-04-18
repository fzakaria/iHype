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
@synthesize length = _length;
@synthesize played = _played;
@synthesize isPlaying = _isPlaying;

-(id)init
{
    if ((self = [super init])) {
        self.length = 0;
        self.played = 0;
    }
    
    return self;
}

-(NSString*) downloadUrlAsString
{
    return [NSString stringWithFormat:@"http://hypem.com/serve/play/%@/%@.mp3", self.id, self.key];
}

-(NSString*) lengthAsString
{
    int minutes = floor([self length]/60);
    int seconds = round([self length]- minutes * 60);
    NSString * timeString = [NSString stringWithFormat:@"%d:%d", minutes, seconds];
    return timeString;
}

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
