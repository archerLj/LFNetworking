//
//  NSURLRequest+LFNetworkingMethods.m
//  LFADNetworking
//
//  Created by archerLj on 16/3/23.
//  Copyright © 2016年 archerLj. All rights reserved.
//

#import "NSURLRequest+LFNetworkingMethods.h"
#import <objc/runtime.h>

static void *AIFNetworkingRequestParams;
@implementation NSURLRequest (LFNetworkingMethods)

- (void)setRequestParams:(NSDictionary *)requestParams{
    objc_setAssociatedObject(self, &AIFNetworkingRequestParams, requestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)requestParams {
    return objc_getAssociatedObject(self, &AIFNetworkingRequestParams);
}

@end
