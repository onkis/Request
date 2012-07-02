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
-(NSMutableDictionary *)dictonaryForConnection:(NSURLConnection *)connection{
    NSString *key = [NSString stringWithFormat:@"%u", [connection hash]];
    NSLog(@"attempting to access key %@", key);
    return [self.requests objectForKey:key];
}


//***********************************************************************
//Instance Methods
//***********************************************************************
-(void) get:(NSString *)url withBlock:(RequestResponseBlock)block{
    
    NSURL *urlObj = [NSURL URLWithString:url];
    
    NSMutableURLRequest *request = [NSURLRequest requestWithURL:urlObj];
    
    NSURLConnection *connectionForGet = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    
    NSString *key = [NSString stringWithFormat:@"%u", [connectionForGet hash]];
    NSDictionary *responseDict = @{ @"connection" : connectionForGet, @"response": [NSNull null],
                                    @"responseData": [NSNull null], @"responseCode": [NSNull null],
                                    @"block":block};
    NSMutableDictionary *mutResponseDict = [NSMutableDictionary dictionaryWithDictionary:responseDict];
    
    [self.requests setObject:mutResponseDict forKey:key];
    
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
        requestClientManager.requests = [[NSMutableDictionary alloc]init];
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
    NSLog(@"so atempting to send authentication challenge");
}



-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSMutableDictionary* responceDict = [self dictonaryForConnection:connection];
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    NSNumber *responseCode = [NSNumber numberWithInt:[httpResponse statusCode]];
    
    [responceDict setObject:httpResponse forKey:@"response"];
    [responceDict setObject:responseCode forKey:@"responseCode"];
    [responceDict setObject:[NSMutableData data] forKey:@"responseData"];
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
    
    RequestResponseBlock Block = (RequestResponseBlock)[responceDict objectForKey:@"block"];
    Block(responceDict);
}

@end
