//
//  NSObject+LFNetworkingMethods.m
//  LFADNetworking
//
//  Created by archerLj on 16/3/23.
//  Copyright © 2016年 archerLj. All rights reserved.
//

#import "NSObject+LFNetworkingMethods.h"

@implementation NSObject (LFNetworkingMethods)

- (id)LF_defaultValue:(id)defaultData {
    
    if (![defaultData isKindOfClass:[self class]]) {
        return defaultData;
    }
    
    if ([self LF_isEmptyObject]) {
        return defaultData;
    }
    
    return self;
}

- (BOOL)LF_isEmptyObject {
    
    if ([self isEqual:[NSNull null]]) {
        return YES;
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        if ([(NSString *)self length] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSArray class]]) {
        if ([(NSArray *)self count] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSDictionary class]]) {
        if ([(NSDictionary *)self count] == 0) {
            return YES;
        }
    }
    
    return NO;
}


@end
