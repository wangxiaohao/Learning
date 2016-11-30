//
//  JCAsyncURLRequest.h
//  JCAsyncURLRequest
//
//  Created by CXY on 16/11/11.
//  Copyright © 2016年 CXY. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^SuccessBlock)(id successInfo);
typedef void(^FailureBlock)(NSString *error);

@interface JCAsyncURLRequest : NSURLRequest

- (void)requestWithURL:(NSURL *)url success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;
@end
