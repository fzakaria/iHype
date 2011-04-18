//
//  PlayPauseTableButton.m
//  iHype
//
//  Created by Farid Zakaria on 11-04-17.
//  Copyright 2011 Setheron Media. All rights reserved.
//

#import "PlayPauseTableButton.h"


@implementation PlayPauseTableButton

-(id)init
{
    if ((self = [super init]))
    {
        _isPlaying = FALSE;   
    }
    return self; 
}

-(void) setIsPlaying:(BOOL)isPlaying
{
    if (_isPlaying == isPlaying)
    {
        return;
    }
    if (isPlaying)
    {
        self.text = @"Pause";
    }
    else
    {
        self.text  = @"Play";
    }
    _isPlaying = isPlaying;
}

-(void) toggleButton
{
    [self setIsPlaying:!_isPlaying];
}

-(BOOL) isPlaying
{
    return _isPlaying;
}

@end
