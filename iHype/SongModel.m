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
#import "HypeMachineURLRequest.h"
@implementation SongModel

@synthesize songs = _songs;
@synthesize cookie = _cookie;

-(id)init
{
    if ((self = [super init])) {
        _songs = [[NSMutableArray array] retain];
        _type =  DefaultSongs;
        _page = 1;
    }
    
    return self;
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
    if (!self.isLoading)
    {
      if (more)
      {
          _page++; 
      }
      else
        {
             _page = 1;
            [_songs removeAllObjects]; // Clear out data from previous request.
        }
    }
    
    // Construct the request.
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *host = @"http://hypem.com";
    NSString *path = @"/latest";
    NSString *url = [host stringByAppendingFormat:@"%@/%d?ax=1&ts=%1.2f", path, _page, time];
    
    TTURLRequest* request = [TTURLRequest
                             requestWithURL: url
                             delegate: self];
    
    request.shouldHandleCookies = NO;
    
    request.cachePolicy = cachePolicy;
    request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
    
    HypeMachineURLRequest * response = [[HypeMachineURLRequest alloc] init];
    request.response = response;
    TT_RELEASE_SAFELY(response);
    
    [request send];
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
    HypeMachineURLRequest* response = request.response;
    NSHTTPURLResponse  * httpResponse = [response httpResponse];
    NSDictionary *dict = [httpResponse allHeaderFields];
    self.cookie = [dict objectForKey:@"Set-Cookie"];
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
    
    
    regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=\ttime:\').*(?=\')"
                                                      options:NSRegularExpressionCaseInsensitive
                                                        error:nil];
    
    NSArray *timeMatches = [regex matchesInString:htmlString options:0 range:NSMakeRange(0, [htmlString length])];
    
    
    regex = [NSRegularExpression regularExpressionWithPattern:@"!-- section(-|\\s)player"
                                                      options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                                        error:nil];
    
    NSArray *sectionMatches = [regex matchesInString:htmlString options:0 range:NSMakeRange(0, [htmlString length])];
    
    
    
    NSNumberFormatter * format = [[NSNumberFormatter alloc] init];
	[format setNumberStyle:NSNumberFormatterDecimalStyle];;
	[format setMaximumFractionDigits:2];
    
    NSMutableArray* newSongs = [NSMutableArray arrayWithCapacity:[titleMatches count]];
    NSString * albumThumbnail = nil;
    for (int i = 0 ; i < [titleMatches count] ; ++i) 
    {
        NSTextCheckingResult * titleMatch = [titleMatches objectAtIndex:i];
        NSTextCheckingResult * artistMatch = [artistMatches objectAtIndex:i];
        NSTextCheckingResult * idMatch = [idMatches objectAtIndex:i];
        NSTextCheckingResult * keyMatch = [keyMatches objectAtIndex:i];
        NSTextCheckingResult * timeMatch = [timeMatches objectAtIndex:i];
        NSTextCheckingResult * sectionMatch = [sectionMatches objectAtIndex:i];

        NSString * songTitle = [htmlString substringWithRange:titleMatch.range];
        NSString * songArtist = [htmlString substringWithRange:artistMatch.range];
        NSString * songID = [htmlString substringWithRange:idMatch.range];
        NSString * songKey = [htmlString substringWithRange:keyMatch.range];
        NSString * timeString = [htmlString substringWithRange:timeMatch.range];
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
        newSong.link = [NSString stringWithFormat:@"http://hypem.com/item/%@", songID];
        newSong.description = @"Base Description";
        
        NSNumber * timeAsNumber = [format numberFromString:timeString];
        newSong.length = [timeAsNumber doubleValue];
        
        [newSongs addObject:newSong];
        TT_RELEASE_SAFELY(newSong);
    }
    
    [format release];
    [htmlString release];
    [_songs addObjectsFromArray:newSongs];
    
    [super requestDidFinishLoad:request];
}

#pragma mark Singleton

static SongModel *sharedSongModel = nil;

+ (SongModel *) sharedSongModel
{
    @synchronized(self)
	{
        if (sharedSongModel == nil)
		{
            sharedSongModel = [[self alloc] init];
        }
    }
	
    return sharedSongModel;
}

- (void)dealloc
{
    TT_RELEASE_SAFELY(_songs);
    TT_RELEASE_SAFELY(_cookie);
    [super dealloc];
}


@end

