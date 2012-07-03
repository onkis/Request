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
//should these all be (weak)?
@property (strong) NSURLConnection *connection;
@property (strong) NSHTTPURLResponse *response;
@property (strong) NSNumber *responseCode;
@property (strong) NSMutableData *responseData;
@property (strong) RequestResponseBlock block;
@property (strong) NSError *error;
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