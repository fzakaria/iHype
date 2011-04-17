//
//  SongTableCell.h
//  iHype
//
//  Created by Farid Zakaria on 11-04-17.
//  Copyright 2011 Setheron Media. All rights reserved.
//

#import "Three20UI/TTTableLinkedItemCell.h"

@class TTImageView;
@interface SongTableCell : TTTableLinkedItemCell {
    UILabel*      _titleLabel;
    TTImageView*  _imageView2;
}


@property (nonatomic, readonly, retain) UILabel*      titleLabel;
@property (nonatomic, readonly, retain) TTImageView*  imageView2;

@end
