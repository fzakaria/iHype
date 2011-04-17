//
//  SongTableViewController.m
//  iHype
//
//  Created by Farid Zakaria on 11-04-16.
//  Copyright 2011 Setheron Media. All rights reserved.
//

#import "SongTableViewController.h"
#import "SongTableDataSource.h"

@implementation SongTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.title = @"Hype Machine";
        self.variableHeightRows = YES;
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
    self.dataSource = [[[SongTableDataSource alloc] init] autorelease];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
    return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

@end
