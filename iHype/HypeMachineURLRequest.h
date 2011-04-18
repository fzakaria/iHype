//
//  HypeMachineURLRequest.h
//  iHype
//
//  Created by Farid Zakaria on 11-04-17.
//  Copyright 2011 Setheron Media. All rights reserved.
//

#import "Three20/Three20.h"
#import <Foundation/Foundation.h>


@interface HypeMachineURLRequest : TTURLDataResponse<TTURLResponse> {
    NSHTTPURLResponse * _response;
}

@property (nonatomic, retain) NSHTTPURLResponse * httpResponse;

- (NSError*)request:(TTURLRequest*)request processResponse:(NSHTTPURLResponse*)response data:(id)data;


@end
