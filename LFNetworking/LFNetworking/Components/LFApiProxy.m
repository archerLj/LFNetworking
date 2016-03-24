//
//  LFApiProxy.m
//  LFADNetworking
//
//  Created by archerLj on 16/3/23.
//  Copyright © 2016年 archerLj. All rights reserved.
//

#import "LFApiProxy.h"
#import "LFRequestGenerator.h"
#import "NSURLRequest+LFNetworkingMethods.h"
#warning 以后要替换AFNetworking，只在这里一个地方改修就可以了。
#import <AFNetworking/AFNetworking.h>

static NSString * const kLFApiProxyDispatchItemKeyCallbackSuccess = @"kLFApiProxyDispatchItemCallbackSuccess";
static NSString * const kLFApiProxyDispatchItemKeyCallbackFail = @"kLFApiProxyDispatchItemCallbackFail";


@interface LFApiProxy ()
@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) NSNumber *recordedRequestId;
#warning 以后要替换AFNetworking，只在这里一个地方改修就可以了。
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end

@implementation LFApiProxy

#pragma mark - life cycle
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LFApiProxy *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LFApiProxy alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods
- (NSInteger)callGETWithParams:(NSDictionary *)params methodName:(NSString *)methodName success:(LFCallback)success fail:(LFCallback)fail {
    
    NSURLRequest *request = [[LFRequestGenerator sharedInstance] generateGETRequestWithRequestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)callPOSTWithParams:(NSDictionary *)params methodName:(NSString *)methodName success:(LFCallback)success fail:(LFCallback)fail {
    
    NSURLRequest *request = [[LFRequestGenerator sharedInstance] generatePOSTRequestWithRequestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (NSInteger)callUPDATEWithParams:(NSDictionary *)params methodName:(NSString *)methodName success:(LFCallback)success fail:(LFCallback)fail {
    
    NSURLRequest *request = [[LFRequestGenerator sharedInstance] generateUPDATERequestWithRequestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (void)cancelRequestWithRequestID:(NSNumber *)requestID {
    
    NSURLSessionTask *task = self.dispatchTable[requestID];
    [task cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList {
    
    for (NSNumber *requestId in requestIDList) {
        [self cancelRequestWithRequestID:requestId];
    }
}

#pragma mark - private methods
#warning 以后要替换AFNetworking，只在这里一个地方改修就可以了。
- (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(LFCallback)success fail:(LFCallback)fail {
    
    __block NSURLSessionTask *task = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        NSURLSessionTask *storedTask = self.dispatchTable[@(task.taskIdentifier)];
        if (storedTask == nil) {
            return;
        }
        
        LFURLResponse *taskResponse = nil;
        if (error == nil) {
            taskResponse = [[LFURLResponse alloc] initWithResponse:response responseData:responseObject requestId:@(task.taskIdentifier) request:task.currentRequest status:LFURLResponseStatusSuccess];
            success?success(taskResponse):nil;
        } else {
            taskResponse = [[LFURLResponse alloc] initWithResponse:response responseData:responseObject requestId:@(task.taskIdentifier) request:task.currentRequest error:error];
            fail?fail(taskResponse):nil;
        }
        
        [self.dispatchTable removeObjectForKey:@(task.taskIdentifier)];
        
    }];
    
    
    [task resume];
    self.dispatchTable[@(task.taskIdentifier)] = task;
    return @(task.taskIdentifier);
}

#pragma mark - getters and setters
- (NSMutableDictionary *)dispatchTable {
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

-(AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _sessionManager;
}
@end
