//
//  RequestTests.m
//  RequestTests
//
//  Created by Mike Ball on 6/29/12.
//  Copyright (c) 2012 Mike Ball. All rights reserved.
//

#import "RequestTests.h"

@implementation RequestTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    Request *client = [Request client];
    Request *anotherClient = [Request client];
    NSLog(@"this is the client %@", client);
    NSLog(@"this is the client %@", anotherClient);
 //STFail(@"Unit tests are not implemented yet in RequestTests");
}

- (void)testGetRequests
{
    
    [Request get:@"http://www.google.com" withBlock:^(RequestResponse* response){
        NSLog(@"you are a dork");
        NSLog(@"%@",[response responseDataToString]);
    }];
    [[NSRunLoop currentRunLoop] run];
    //STFail(@"Unit tests are not implemented yet in RequestTests");
}

@end
