//
//  LFAppContext.h
//  LFADNetworking
//
//  Created by archerLj on 16/3/23.
//  Copyright © 2016年 archerLj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFNetworkingConfiguration.h"

@interface LFAppContext : NSObject
@property (nonatomic, readonly) BOOL isReachable;

+ (instancetype)sharedInstance;
@end
