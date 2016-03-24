//
//  LFBaseAPIManager.m
//  LFADNetworking
//
//  Created by archerLj on 16/3/23.
//  Copyright © 2016年 archerLj. All rights reserved.
//

#import "LFBaseAPIManager.h"
#import "LFAppContext.h"
#import "LFURLResponse.h"
#import "LFApiProxy.h"

#define LFCallAPI(REQUEST_METHOD, REQUEST_ID)                                                       \
{                                                                                       \
REQUEST_ID = [[LFApiProxy sharedInstance] call##REQUEST_METHOD##WithParams:apiParams methodName:self.child.methodName success:^(LFURLResponse *response) { \
[self successedOnCallingAPI:response];                                          \
} fail:^(LFURLResponse *response) {                                                \
[self failedOnCallingAPI:response withErrorType:LFAPIManagerErrorTypeDefault];  \
}];                                                                                 \
[self.requestIdList addObject:@(REQUEST_ID)];                                          \
}

@interface LFBaseAPIManager ()
@property (nonatomic, strong, readwrite) id fetchedRawData;
@property (nonatomic, copy, readwrite) NSString *errorMessage;
@property (nonatomic, readwrite) LFAPIManagerErrorType errorType;
@property (nonatomic, strong) NSMutableArray *requestIdList;
@end

@implementation LFBaseAPIManager

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        _callBackDelegate = nil;
        _validator = nil;
        _paramSource = nil;
        
        _fetchedRawData = nil;
        
        _errorMessage = nil;
        _errorType = LFAPIManagerErrorTypeDefault;
        
        if ([self conformsToProtocol:@protocol(LFAPIManagerDelegate)]) {
            self.child = (id <LFAPIManagerDelegate>)self;
        }
    }
    return self;
}

- (void)dealloc {
    [self cancelAllRequests];
    self.requestIdList = nil;
}

#pragma mark - public methods
- (void)cancelAllRequests {
    [[LFApiProxy sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestID {
    [self removeRequestIdWithRequestID:requestID];
    [[LFApiProxy sharedInstance] cancelRequestWithRequestID:@(requestID)];
}

- (id)fetchDataWithReformer:(id<LFAPIManagerApiCallBackDataReformer>)reformer {
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(manager:reformData:)]) {
        resultData = [reformer manager:self reformData:self.fetchedRawData];
    } else {
        resultData = [self.fetchedRawData mutableCopy];
    }
    return resultData;
}

#pragma mark - calling api
- (NSInteger)loadData {
    NSDictionary *params = [self.paramSource paramsForManager:self];
    NSInteger requestId = [self loadDataWithParams:params];
    return requestId;
}

- (NSInteger)loadDataWithParams:(NSDictionary *)params {
    NSInteger requestId = 0;
    NSDictionary *apiParams = [self reformParams:params];
    if ([self shouldCallAPIWithParams:apiParams]) {
        if ([self.validator manager:self isCorrectWithParamsData:apiParams]) {
            
            // 实际的网络请求
            if ([self isReachable]) {
                switch (self.child.requestType)
                {
                    case LFAPIManagerRequestTypeGet:
                        LFCallAPI(GET, requestId);
                        break;
                    case LFAPIManagerRequestTypePost:
                        LFCallAPI(POST, requestId);
                        break;
                    case LFAPIManagerRequestTypeUpdate:
                        LFCallAPI(UPDATE, requestId);
                    default:
                        break;
                }
                
                NSMutableDictionary *params = [apiParams mutableCopy];
                params[kLFBaseAPIManagerRequestID] = @(requestId);
                [self afterCallingAPIWithParams:params];
                return requestId;
                
            } else {
                [self failedOnCallingAPI:nil withErrorType:LFAPIManagerErrorTypeNoNetwork];
                return requestId;
            }
        } else {
            [self failedOnCallingAPI:nil withErrorType:LFAPIManagerErrorTypeParamsError];
            return requestId;
        }
    }
    return requestId;
}

#pragma mark - api callbacks
- (void)successedOnCallingAPI:(LFURLResponse *)response {
    
    if (response.content) {
        self.fetchedRawData = [response.content copy];
    } else {
        self.fetchedRawData = [response.responseData copy];
    }
    
    [self removeRequestIdWithRequestID:response.requestId];
    if ([self.validator manager:self isCorrectWithCallBackData:nil]) {
        [self beforePerformSuccessWithResponse:response];
        [self.callBackDelegate managerCallApiDidSuccess:self];
        [self afterPerformSuccessWithResponse:response];
    } else {
        [self failedOnCallingAPI:response withErrorType:LFAPIManagerErrorTypeNoContent];
    }
}

- (void)failedOnCallingAPI:(LFURLResponse *)response withErrorType:(LFAPIManagerErrorType)errorType {
    self.errorType = errorType;
    [self removeRequestIdWithRequestID:response.requestId];
    [self beforePerformFailWithResponse:response];
    [self.callBackDelegate managerCallAPiDidFailed:self];
    [self afterPerformFailWithResponse:response];
}

#pragma mark - method for interceptor
- (void)beforePerformSuccessWithResponse:(LFURLResponse *)response {
    self.errorType = LFAPIManagerErrorTypeSuccess;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:beforePerformSuccessWithResponse:)]) {
        [self.interceptor manager:self beforePerformSuccessWithResponse:response];
    }
}

- (void)afterPerformSuccessWithResponse:(LFURLResponse *)response {
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformSuccessWithResponse:)]) {
        [self.interceptor manager:self afterPerformSuccessWithResponse:response];
    }
}

- (void)beforePerformFailWithResponse:(LFURLResponse *)response {

    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:beforePerformFailedWithResponse:)]) {
        [self.interceptor manager:self beforePerformFailedWithResponse:response];
    }
}

- (void)afterPerformFailWithResponse:(LFURLResponse *)response {
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformFailedWithResponse:)]) {
        [self.interceptor manager:self afterPerformFailedWithResponse:response];
    }
}

//只有返回YES才会继续调用API
- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params {
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:shouldCallApiWithParams:)]) {
        return [self.interceptor manager:self shouldCallApiWithParams:params];
    } else {
        return YES;
    }
}

- (void)afterCallingAPIWithParams:(NSDictionary *)params {
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterCallApiWithParams:)]) {
        [self.interceptor manager:self afterCallApiWithParams:params];
    }
}

#pragma mark - method for child
- (void)cleanData {
    IMP childIMP = [self.child methodForSelector:@selector(cleanData)];
    IMP selfIMP = [self methodForSelector:@selector(cleanData)];
    
    if (childIMP == selfIMP) {
        self.fetchedRawData = nil;
        self.errorMessage = nil;
        self.errorType = LFAPIManagerErrorTypeDefault;
    } else {
        if ([self.child respondsToSelector:@selector(cleanData)]) {
            [self.child cleanData];
        }
    }
}

- (NSDictionary *)reformParams:(NSDictionary *)params {
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];
    
    if (childIMP == selfIMP) {
        return params;
    } else {
        // 如果child是继承得来的，那么这里就不会跑到，会直接跑子类中的IMP。
        // 如果child是另一个对象，就会跑到这里
        NSDictionary *result = nil;
        result = [self.child reformParams:params];
        if (result) {
            return result;
        } else {
            return params;
        }
    }
}

#pragma mark - private methods
- (void)removeRequestIdWithRequestID:(NSInteger)requestId {
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}

#pragma mark - getters and setters
- (NSMutableArray *)requestIdList {
    if (_requestIdList == nil) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}

- (BOOL)isReachable {
    BOOL isReachability = [LFAppContext sharedInstance].isReachable;
    if (!isReachability) {
        self.errorType = LFAPIManagerErrorTypeNoNetwork;
    }
    return isReachability;
}

- (BOOL)isLoading {
    return [self.requestIdList count] > 0;
}
@end
