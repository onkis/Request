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
//***********************************************************************
//Instance Methods
//***********************************************************************
-(void) get:(NSString *)url withBlock:(RequestResponseBlock)block{
    
    NSURL *urlObj = [NSURL URLWithString:url];
    
    NSMutableURLRequest *request = [NSURLRequest requestWithURL:urlObj];
    
    NSURLConnection *connectionForGet = [NSURLConnection connectionWithRequest:request delegate:self];
    
    NSString *key = [NSString stringWithFormat:@"%@",connectionForGet.hash];
    
    self.requests[key] = connectionForGet;
    [connectionForGet start];
    //[request hash]
    
}
//***********************************************************************
//Class Methods
//***********************************************************************

+ (void) get:(NSString *)url withBlock:(RequestResponseBlock)block{
    Request *client = [Request client];
    
    [client get:url withBlock:block];
}


+ (Request*) client {
    if (requestClientManager == nil) {
        requestClientManager = [[super allocWithZone:NULL] init];
    }
    return requestClientManager;
}

+ (id)allocWithZone:(NSZone *)zone{
    return [self client];
}

- (id)copyWithZone:(NSZone *)zone{
    return self;
}
//***********************************************************************
//Delegate Methods
//***********************************************************************



@end
