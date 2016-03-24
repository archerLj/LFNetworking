//
//  NSDictionary+LFNetworkingMethods.m
//  LFADNetworking
//
//  Created by archerLj on 16/3/23.
//  Copyright © 2016年 archerLj. All rights reserved.
//

#import "NSDictionary+LFNetworkingMethods.h"
#import "NSArray+LFNetworkingMethods.h"

@implementation NSDictionary (LFNetworkingMethods)

- (NSString *)LF_urlParamsString {
    
    NSMutableString *paramString = [[NSMutableString alloc] init];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) {
            [paramString appendString:[NSString stringWithFormat:@"%@=%@&",key,obj]];
        }
    }];
    paramString = [[paramString substringToIndex:paramString.length-1] mutableCopy];
    return paramString;
}

/** 字典变json */
- (NSString *)LF_jsonString {
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
