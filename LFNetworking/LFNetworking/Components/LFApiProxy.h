//
//  LFApiProxy.h
//  LFADNetworking
//
//  Created by archerLj on 16/3/23.
//  Copyright © 2016年 archerLj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFURLResponse.h"

typedef void(^LFCallback)(LFURLResponse *response);

@interface LFApiProxy : NSObject

+ (instancetype)sharedInstance;

- (NSInteger)callGETWithParams:(NSDictionary *)params methodName:(NSString *)methodName success:(LFCallback)success fail:(LFCallback)fail;
- (NSInteger)callPOSTWithParams:(NSDictionary *)params methodName:(NSString *)methodName success:(LFCallback)success fail:(LFCallback)fail;
- (NSInteger)callUPDATEWithParams:(NSDictionary *)params methodName:(NSString *)methodName success:(LFCallback)success fail:(LFCallback)fail;

- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;

@end
