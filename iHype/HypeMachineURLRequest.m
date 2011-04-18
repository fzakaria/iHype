//
//  HypeMachineURLRequest.m
//  iHype
//
//  Created by Farid Zakaria on 11-04-17.
//  Copyright 2011 Setheron Media. All rights reserved.
//

#import "HypeMachineURLRequest.h"


@implementation HypeMachineURLRequest

@synthesize httpResponse = _response;

- (void) dealloc {
    [_response release];
    [super dealloc];
}

- (NSError*)request:(TTURLRequest*)request processResponse:(NSHTTPURLResponse*)response data:(id)data
{
    self.httpResponse = response;
    return [super request:request processResponse:response data:data];
}


@end
