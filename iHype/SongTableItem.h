//
//  SongTableItem.h
//  iHype
//
//  Created by Farid Zakaria on 11-04-17.
//  Copyright 2011 Setheron Media. All rights reserved.
//

#import "Three20UI/TTTableTextItem.h"


@interface SongTableItem :TTTableTextItem {
    NSString* _title;
    NSString* _artist;
    NSString* _imageURL;
}

@property (nonatomic, copy)   NSString* title;
@property (nonatomic, copy)   NSString* artist;
@property (nonatomic, copy)   NSString* imageURL;

+ (id)itemWithTitle:(NSString*)title artist:(NSString*)artist imageURL:(NSString*)imageURL URL:(NSString*)URL;

@end
