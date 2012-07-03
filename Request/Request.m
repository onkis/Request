//
//  Request.m
//  Request
//
//  Created by Mike Ball on 6/29/12.
//  Copyright (c) 2012 Mike Ball. All rights reserved.
//
#import "Request.h"
@implementation RequestResponse
-(NSString *) responseDataToString{
    return [NSString stringWithUTF8String:[_responseData bytes]];
}
@end


static Request *requestClientManager = nil;
@implementation Request
-(id) init{
    self = [super init];
    if(self){
        _requests = [[NSMutableDictionary alloc] init];
    }
    return self;
}
//***********************************************************************
//Instance Methods
//***********************************************************************
-(RequestResponse *)responseObjectFor:(NSURLConnection *)connection{
    NSString *key = [NSString stringWithFormat:@"%u", [connection hash]];
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
    RequestResponse * responseObject = [[RequestResponse alloc] init];
        
    responseObject.connection = connectionForGet;
    responseObject.block = block;
    
    [self.requests setObject:responseObject forKey:key];
    
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
    NSLog(@"so atempting to send authentication challenge");
}



-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    RequestResponse* responseObj = [self responseObjectFor:connection];
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    NSNumber *responseCode = [NSNumber numberWithInt:[httpResponse statusCode]];
    responseObj.responseCode = responseCode;
    responseObj.responseData = [NSMutableData data];
    responseObj.response = httpResponse;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    RequestResponse* responceObj = [self responseObjectFor:connection];
    [responceObj.responseData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //NSLog(@"CONNECTION FAILED WITH ERROR: %@", [error description]);
    
    
    RequestResponse* responceObj = [self responseObjectFor:connection];
    responceObj.error = error;
    //TODO: do I need to call the callback here?
    RequestResponseBlock Block = responceObj.block;
    Block(responceObj);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    RequestResponse* responceObj = [self responseObjectFor:connection];
    
    RequestResponseBlock Block = responceObj.block;
    Block(responceObj);
}

@end
