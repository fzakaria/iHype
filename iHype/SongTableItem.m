//
//  SongTableItem.m
//  iHype
//
//  Created by Farid Zakaria on 11-04-17.
//  Copyright 2011 Setheron Media. All rights reserved.
//

#import "SongTableItem.h"
// Core
#import "Three20Core/TTCorePreprocessorMacros.h"

@implementation SongTableItem

@synthesize title     = _title;
@synthesize artist   = _artist;
@synthesize imageURL  = _imageURL;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    TT_RELEASE_SAFELY(_title);
    TT_RELEASE_SAFELY(_artist);
    TT_RELEASE_SAFELY(_imageURL);
    
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class public


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)itemWithTitle:(NSString*)title artist:(NSString *)artist imageURL:(NSString *)imageURL URL:(NSString *)URL{
    SongTableItem* item = [[[self alloc] init] autorelease];
    item.title = title;
    item.artist = artist;
    item.imageURL = imageURL;
    item.URL = URL;
    return item;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSCoding


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithCoder:(NSCoder*)decoder {
    if ((self = [super initWithCoder:decoder])) {
        self.title = [decoder decodeObjectForKey:@"title"];
        self.artist = [decoder decodeObjectForKey:@"artist"];
        self.imageURL = [decoder decodeObjectForKey:@"imageURL"];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)encodeWithCoder:(NSCoder*)encoder {
    [super encodeWithCoder:encoder];
    if (self.title) {
        [encoder encodeObject:self.title forKey:@"title"];
    }
    if (self.artist) {
        [encoder encodeObject:self.artist forKey:@"artist"];
    }
    if (self.imageURL) {
        [encoder encodeObject:self.imageURL forKey:@"imageURL"];
    }
}


@end
