//
//  LFURLResponse.h
//  LFADNetworking
//
//  Created by archerLj on 16/3/23.
//  Copyright © 2016年 archerLj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFNetworkingConfiguration.h"

@interface LFURLResponse : NSObject
@property (nonatomic, assign, readonly) LFURLResponseStatus status;
@property (nonatomic, assign, readonly) NSInteger requestId;
@property (nonatomic, copy, readonly) NSURLRequest *request;
/** 包含返回码等信息*/
@property (nonatomic, strong, readonly) NSURLResponse *response;
@property (nonatomic, copy) NSDictionary *requestParams;
/** 服务器返回的响应数据*/
@property (nonatomic, strong, readonly) NSData *responseData;
@property (nonatomic, strong, readonly) id content;


- (instancetype)initWithData:(NSData *)data;
- (instancetype)initWithResponse:(NSURLResponse *)response responseData:(NSData *)responseData requestId:(NSNumber *)requestId request:(NSURLRequest *)request status:(LFURLResponseStatus)status;
- (instancetype)initWithResponse:(NSURLResponse *)response responseData:(NSData *)responseData requestId:(NSNumber *)requestId request:(NSURLRequest *)request error:(NSError *)error;

@end
