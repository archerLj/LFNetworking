//
//  LFAppContext.m
//  LFADNetworking
//
//  Created by archerLj on 16/3/23.
//  Copyright © 2016年 archerLj. All rights reserved.
//

#import "LFAppContext.h"
#import "AFNetworkReachabilityManager.h"

@implementation LFAppContext

- (BOOL)isReachable {
    
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    } else {
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}

#pragma mark - public methods
+ (instancetype)sharedInstance {
    
    static LFAppContext *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LFAppContext alloc] init];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    });
    return sharedInstance;
}

@end
