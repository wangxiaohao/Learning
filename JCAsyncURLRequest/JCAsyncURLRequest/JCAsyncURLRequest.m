//
//  JCAsyncURLRequest.m
//  JCAsyncURLRequest
//
//  Created by CXY on 16/11/11.
//  Copyright © 2016年 CXY. All rights reserved.
//

#import "JCAsyncURLRequest.h"

@interface JCAsyncURLRequest ()<NSURLConnectionDelegate, NSURLSessionDelegate, NSURLConnectionDataDelegate>
{
    NSMutableData *_recData;
    SuccessBlock _successBlock;
    FailureBlock _failureBlock;
}

@end

@implementation JCAsyncURLRequest

- (instancetype)initWithURL:(NSURL *)URL {
    if (self = [super initWithURL:URL]) {
        _recData = [NSMutableData data];
    }
    return self;
}

- (void)requestWithURL:(NSURL *)url success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock {
    _successBlock = successBlock;
    _failureBlock = failureBlock;
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    [connection start];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_recData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *err = nil;
    id ret = [NSJSONSerialization JSONObjectWithData:_recData options:NSJSONReadingAllowFragments error:&err];
    if (err) {
        if (_failureBlock) {
            _failureBlock([err localizedDescription]);
        }
    } else {
        if (_successBlock) {
            _successBlock(ret);
        }
    }
}
@end
