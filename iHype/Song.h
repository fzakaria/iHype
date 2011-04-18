//
//  Song.h
//  iHype
//
//  Created by Farid Zakaria on 11-04-15.
//  Copyright 2011 Setheron Media. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Song : NSObject {
    NSString * _id;
    NSString * _key;
    NSString * _title;
    NSString * _albumUrl;
    NSString * _artist;
    NSString * _description;
    NSString * _link;
    NSTimeInterval _length;
    NSTimeInterval _played;
    BOOL _isPlaying;
}

-(NSString*) downloadUrlAsString;
-(NSString*) lengthAsString;

@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * key;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * description;
@property (nonatomic, copy) NSString * link;
@property (nonatomic, copy) NSString * artist;
@property (nonatomic, copy) NSString * albumUrl;
@property (readwrite,assign) NSTimeInterval length;
@property (readwrite,assign) NSTimeInterval played;
@property (readwrite,assign) BOOL isPlaying;

@end
