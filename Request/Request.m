//
//  Request.m
//  Request
//
//  Created by Mike Ball on 6/29/12.
//  Copyright (c) 2012 Mike Ball. All rights reserved.
//

#import "Request.h"
static Request *requestClientManager = nil;
@implementation Request

+ (Request*) client {
    if (requestClientManager == nil) {
        requestClientManager = [[super allocWithZone:NULL] init];
    }
    return requestClientManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self client];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end
