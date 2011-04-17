//
//  PopularSongModel.m
//  iHype
//
//  Created by Farid Zakaria on 11-04-15.
//  Copyright 2011 Setheron Media. All rights reserved.
//

#import "SongModel.h"
#import "extXML/extXML.h"
#import "Song.h"

@implementation SongModel

@synthesize songs = _songs;

-(id)init
{
    if ((self = [super init])) {
        _songs = [[NSMutableArray array] retain];
        _type =  DefaultSongs;
    }
    
    return self;
}
/*
- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
    
    //if we do pageing this should have an if check around it
    [_songs removeAllObjects]; // Clear out data from previous request.
    
    // Construct the request.
    NSString *host = @"http://hypem.com";
    NSString *path = @"/feed/popular/now/1/feed.xml";
    NSString *url = [host stringByAppendingFormat:@"%@", path];

    TTURLRequest* request = [TTURLRequest
                             requestWithURL: url
                             delegate: self];
    
    request.cachePolicy = cachePolicy;
    request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
    
    TTURLXMLResponse* response = [[TTURLXMLResponse alloc] init];
    response.isRssFeed = YES;
    request.response = response;
    TT_RELEASE_SAFELY(response);
    
    [request send];
}
*/
- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
    
    //if we do pageing this should have an if check around it
    [_songs removeAllObjects]; // Clear out data from previous request.
    
    // Construct the request.
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *host = @"http://hypem.com";
    NSString *path = @"/latest";
    int pageNumber = 1;
    NSString *url = [host stringByAppendingFormat:@"%@/%d?ax=1&ts=%1.2f", path, pageNumber, time];
    
    TTURLRequest* request = [TTURLRequest
                             requestWithURL: url
                             delegate: self];
    
    request.cachePolicy = cachePolicy;
    request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
    
    TTURLDataResponse * response = [[TTURLDataResponse alloc] init];
    request.response = response;
    TT_RELEASE_SAFELY(response);
    
    [request send];
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
    TTURLDataResponse* response = request.response;
    NSData * htmlData = response.data;
    NSString * htmlString = [[NSString alloc] initWithData:htmlData encoding:NSASCIIStringEncoding];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=\tsong:\').*(?=\')"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    
    NSArray *titleMatches = [regex matchesInString:htmlString options:0 range:NSMakeRange(0, [htmlString length])];
    
    regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=\tkey: \')\\w*(?=\')"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSArray *keyMatches = [regex matchesInString:htmlString options:0 range:NSMakeRange(0, [htmlString length])];
    
    regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=\tid:\')\\w*(?=\')"
                                                     options:NSRegularExpressionCaseInsensitive
                                                       error:nil];
    NSArray *idMatches = [regex matchesInString:htmlString options:0 range:NSMakeRange(0, [htmlString length])];
    
    regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=\tartist:\').*(?=\')"
                                                      options:NSRegularExpressionCaseInsensitive
                                                        error:nil];
    NSArray *artistMatches = [regex matchesInString:htmlString options:0 range:NSMakeRange(0, [htmlString length])];
    
    
    regex = [NSRegularExpression regularExpressionWithPattern:@"!-- section(-|\\s)player"
                                                      options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                                        error:nil];
    
    NSArray *sectionMatches = [regex matchesInString:htmlString options:0 range:NSMakeRange(0, [htmlString length])];
    
  
    NSAssert([titleMatches count] != [titleMatches count] != [artistMatches count] != [idMatches count], "Improper parse");
    
    NSMutableArray* newSongs = [NSMutableArray arrayWithCapacity:[titleMatches count]];
    NSString * albumThumbnail = nil;
    for (int i = 0 ; i < [titleMatches count] ; ++i) 
    {
        NSTextCheckingResult * titleMatch = [titleMatches objectAtIndex:i];
        NSTextCheckingResult * artistMatch = [artistMatches objectAtIndex:i];
        NSTextCheckingResult * idMatch = [idMatches objectAtIndex:i];
        NSTextCheckingResult * keyMatch = [keyMatches objectAtIndex:i];
        NSTextCheckingResult * sectionMatch = [sectionMatches objectAtIndex:i];

        NSString * songTitle = [htmlString substringWithRange:titleMatch.range];
        NSString * songArtist = [htmlString substringWithRange:artistMatch.range];
        NSString * songID = [htmlString substringWithRange:idMatch.range];
        NSString * songKey = [htmlString substringWithRange:keyMatch.range];
        NSString * sectionString = [htmlString substringWithRange:sectionMatch.range];
        
        if ([sectionString isEqualToString:@"!-- section player"]) //this means we are not a similar post
        {
            NSRange rangeofSong = NSMakeRange(titleMatch.range.location, sectionMatch.range.location - titleMatch.range.location);
            
            regex = [NSRegularExpression regularExpressionWithPattern:@"http:\\/\\/static-ak.hypem.net\\/.*(gif|png)"
                                                             options:NSRegularExpressionCaseInsensitive
                                                               error:nil];
            NSTextCheckingResult *match = [regex firstMatchInString:htmlString
                                                            options:0
                                                            range:rangeofSong];
            
            if (!match)
            {
                NSLog(@"Couldn't find a thumbnail");
            }
            albumThumbnail = [htmlString substringWithRange:match.range];
            
        }
    
        Song * newSong = [[Song alloc] init];
        newSong.title = songTitle;
        newSong.artist = songArtist;
        newSong.id = songID;
        newSong.key = songKey;
        newSong.albumUrl = albumThumbnail;
        newSong.description = @"Base Description";
        
        [newSongs addObject:newSong];
        TT_RELEASE_SAFELY(newSong);
    }
    
    [htmlString release];
    [_songs addObjectsFromArray:newSongs];
    
    [super requestDidFinishLoad:request];
}
/*
- (void)requestDidFinishLoad:(TTURLRequest*)request {
    TTURLXMLResponse* response = request.response;
    TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
    
    NSDictionary* feed = response.rootObject;
    NSArray * channel = [feed objectForKey:@"channel"]; 
    NSArray * items = [channel objectForKey:@"item"];
    
     NSMutableArray* newSongs = [NSMutableArray arrayWithCapacity:[items count]];
    
    for (NSDictionary * item in items) 
    {
        NSString * title = [[item objectForKey:@"title"] objectForXMLNode];
        NSString * link = [[item objectForKey:@"link"] objectForXMLNode];
        NSString * description = [[item objectForKey:@"description"] objectForXMLNode];

        Song * newSong = [[Song alloc] init];
        newSong.title = title;
        newSong.link = link;
        newSong.description = description;
        
        [newSongs addObject:newSong];
        TT_RELEASE_SAFELY(newSong);
    }
    
    [_songs addObjectsFromArray:newSongs];
    
    [super requestDidFinishLoad:request];
}
*/

- (void)dealloc
{
    TT_RELEASE_SAFELY(_songs);
    [super dealloc];
}


@end

