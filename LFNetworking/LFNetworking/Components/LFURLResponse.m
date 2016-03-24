//
//  LFURLResponse.m
//  LFADNetworking
//
//  Created by archerLj on 16/3/23.
//  Copyright © 2016年 archerLj. All rights reserved.
//

#import "LFURLResponse.h"
#import "NSObject+LFNetworkingMethods.h"
#import "NSURLRequest+LFNetworkingMethods.h"

@interface LFURLResponse()
@property (nonatomic, assign, readwrite) LFURLResponseStatus status;
@property (nonatomic, copy, readwrite) NSURLRequest *request;
@property (nonatomic, assign, readwrite) NSInteger requestId;
@property (nonatomic, strong, readwrite) NSURLResponse *response;
@property (nonatomic, strong, readwrite) NSData *responseData;
@property (nonatomic, strong, readwrite) id content;
@end

@implementation LFURLResponse
#pragma mark - life cycle
- (instancetype)initWithResponse:(NSURLResponse *)response responseData:(NSData *)responseData requestId:(NSNumber *)requestId request:(NSURLRequest *)request status:(LFURLResponseStatus)status {
    
    self = [super init];
    if (self) {
        self.status = status;
        self.requestId = [requestId integerValue];
        self.request = request;
        self.requestParams = request.requestParams;
        self.response = response;
        self.content = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
    }
    return self;
}

- (instancetype)initWithResponse:(NSURLResponse *)response responseData:(NSData *)responseData requestId:(NSNumber *)requestId request:(NSURLRequest *)request error:(NSError *)error {
    
    self = [super init];
    if (self) {
        self.status = [self responseStatusWithError:error];
        self.requestId = [requestId integerValue];
        self.request = request;
        self.requestParams = request.requestParams;
        self.response = response;
        if (responseData) {
            self.content = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
        }else {
            self.content = nil;
        }
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data {
    
    self = [super init];
    if (self) {
        self.status = [self responseStatusWithError:nil];
        self.requestId = 0;
        self.request = nil;
        self.response = nil;
        self.responseData = [data copy];
    }
    return self;
}

#pragma mark - private methods
- (LFURLResponseStatus)responseStatusWithError:(NSError *)error {
    
    if (error) {
        LFURLResponseStatus result = LFURLResponseStatusErrorNoNetwork;
        
        // 除了超时以外，所有错误都当成是无网络
        if (error.code == NSURLErrorTimedOut) {
            result = LFURLResponseStatusErrorNoNetwork;
        }
        return result;
    } else {
        return LFURLResponseStatusSuccess;
    }
}

@end
