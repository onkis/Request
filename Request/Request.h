//
//  Request.h
//  Request
//
//  Created by Mike Ball on 6/29/12.
//  Copyright (c) 2012 Mike Ball. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface RequestResponse : NSObject
@end
typedef void (^RequestResponseBlock)(RequestResponse* RequestResponse);

@interface RequestResponse()

@property NSURLConnection *connection;
@property NSHTTPURLResponse *response;
@property NSNumber *responseCode;
@property NSMutableData *responseData;
@property RequestResponseBlock block;
-(NSString *) responseDataToString;
@end




@interface Request : NSObject<NSURLConnectionDelegate>
//instance stuff
@property NSMutableDictionary *requests;
-(void) get:(NSString *)url withBlock:(RequestResponseBlock)block;




//static stuff
+(Request *) client;
+(void) get:(NSString *)url withBlock:(RequestResponseBlock)block;

@end