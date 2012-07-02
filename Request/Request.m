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
-(NSDictionary *)dictonaryForConnection:(NSURLConnection *)connection{
    NSString *key = [NSString stringWithFormat:@"%u", connection.hash];
    return self.requests[key];
}


//***********************************************************************
//Instance Methods
//***********************************************************************
-(void) get:(NSString *)url withBlock:(RequestResponseBlock)block{
    
    NSURL *urlObj = [NSURL URLWithString:url];
    
    NSMutableURLRequest *request = [NSURLRequest requestWithURL:urlObj];
    
    NSURLConnection *connectionForGet = [NSURLConnection connectionWithRequest:request delegate:self];
    
    NSString *key = [NSString stringWithFormat:@"%u", connectionForGet.hash];
    NSDictionary *responseDict = @{ @"connection" : connectionForGet, @"response": [NSNull null],
                                    @"responseData": [NSNull null], @"responseCode": [NSNull null],
                                    @"block":block};
    self.requests[key] = responseDict;
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

//not sure I understand this one but I believe I need it...
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSDictionary* responceDict = [self dictonaryForConnection:connection];
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    NSNumber *responseCode = [NSNumber numberWithInt:[httpResponse statusCode]];
    
    [responceDict setValue:httpResponse forKey:@"response"];
    [responceDict setValue:responseCode forKey:@"responseCode"];
    [responceDict setValue:[NSMutableData data] forKey:@"responseData"];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSDictionary* responceDict = [self dictonaryForConnection:connection];
    NSMutableData *responseData = [responceDict objectForKey:@"responseData"];
    [responseData appendData:data];
    [responceDict setValue:responseData forKey:@"responseData"];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"CONNECTION FAILED WITH ERROR: %@", [error description]);
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSDictionary* responceDict = [self dictonaryForConnection:connection];
    
    void (^RequestResponseBlock)(NSDictionary* response) = [responceDict objectForKey:@"block"];
    RequestResponseBlock(responceDict);
}

@end
