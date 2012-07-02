//
//  Request.h
//  Request
//
//  Created by Mike Ball on 6/29/12.
//  Copyright (c) 2012 Mike Ball. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^RequestResponseBlock)(NSObject* body);


@interface Request : NSObject<NSURLConnectionDelegate>
//instance stuff
@property NSMutableDictionary *requests;
-(void) get:(NSString *)url withBlock:(RequestResponseBlock)block;




//static stuff
+(Request *) client;
+(void) get:(NSString *)url swithBlock:(RequestResponseBlock)block;

@end