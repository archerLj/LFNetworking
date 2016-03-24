//
//  LFRequestGenerator.m
//  LFADNetworking
//
//  Created by archerLj on 16/3/23.
//  Copyright © 2016年 archerLj. All rights reserved.
//

#import "LFRequestGenerator.h"
#import "NSDictionary+LFNetworkingMethods.h"
#import "LFNetworkingConfiguration.h"
#import "NSObject+LFNetworkingMethods.h"
#import <AFNetworking/AFNetworking.h>
#import "NSObject+LFNetworkingMethods.h"
#import "NSURLRequest+LFNetworkingMethods.h"
#import "LFUpdateFileParams.h"


NSString *const ServerAddress = @"http://ibaby-plan.org:8280/IbabyWebService/3";
NSString *const PhotoServerAddress = @"http://ibaby-plan.org:8280/IbabyWebService/File/Upload";
@interface LFRequestGenerator ()
@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;
@end


@implementation LFRequestGenerator

#pragma mark - public methods
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LFRequestGenerator *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LFRequestGenerator alloc] init];
    });
    return sharedInstance;
}

- (NSURLRequest *)generateGETRequestWithRequestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@?%@",ServerAddress,methodName,[requestParams LF_urlParamsString]];
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:nil error:NULL];
    request.requestParams = nil;
    return request;
}

- (NSURLRequest *)generatePOSTRequestWithRequestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",ServerAddress,methodName];
    NSURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:urlString parameters:requestParams error:NULL];
    request.requestParams = requestParams;
    return request;
}

- (NSURLRequest *)generateUPDATERequestWithRequestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName {
    
    NSString *urlString = [NSString stringWithFormat:@"%@",PhotoServerAddress];
    LFUpdateFileParams *fileParams = requestParams[LFUpdateRequestParamParams];
    NSMutableDictionary *otherParams = [requestParams mutableCopy];
    [otherParams removeObjectForKey:LFUpdateRequestParamParams];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.httpRequestSerializer multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:otherParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fileParams.fileData name:fileParams.name  fileName:fileParams.fileName mimeType:fileParams.mimeType];
    } error:&serializationError];
    return request;
}

#pragma mark - getters and setters
- (AFHTTPRequestSerializer *)httpRequestSerializer {
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = kLFNetworkingTimeoutSeconds;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpRequestSerializer;
}
@end
