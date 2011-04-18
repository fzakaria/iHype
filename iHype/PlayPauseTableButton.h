//
//  PlayPauseTableButton.h
//  iHype
//
//  Created by Farid Zakaria on 11-04-17.
//  Copyright 2011 Setheron Media. All rights reserved.
//

#import "Three20UI/TTTableTextItem.h"


@interface PlayPauseTableButton : TTTableButton {
    BOOL _isPlaying;
}

-(void) setIsPlaying:(BOOL)isPlaying;

-(void) toggleButton;

-(BOOL) isPlaying;


@end
