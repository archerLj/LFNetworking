//
//  NSString+LFNetworkingMethods.m
//  LFADNetworking
//
//  Created by archerLj on 16/3/23.
//  Copyright © 2016年 archerLj. All rights reserved.
//

#import "NSString+LFNetworkingMethods.h"
#include <CommonCrypto/CommonDigest.h>
#import "NSObject+LFNetworkingMethods.h"

@implementation NSString (LFNetworkingMethods)

- (NSString *)LF_md5 {
    
    NSData* inputData = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char outputData[CC_MD5_DIGEST_LENGTH];
    CC_MD5([inputData bytes], (unsigned int)[inputData length], outputData);
    
    NSMutableString* hashStr = [NSMutableString string];
    int i = 0;
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; ++i)
        [hashStr appendFormat:@"%02x", outputData[i]];
    
    return hashStr;
}

@end
