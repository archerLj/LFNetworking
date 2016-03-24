//
//  LFUpdateImageManager.m
//  LFADNetworking
//
//  Created by archerLj on 16/3/24.
//  Copyright © 2016年 archerLj. All rights reserved.
//

#import "LFUpdateImageManager.h"

@implementation LFUpdateImageManager
-(instancetype)init {
    self = [super init];
    if (self) {
        self.validator = self;
    }
    return self;
}

-(NSString *)methodName {
    return nil;
}

-(LFAPIManagerRequestType)requestType{
    return LFAPIManagerRequestTypeUpdate;
}

-(BOOL)manager:(LFBaseAPIManager *)manager isCorrectWithParamsData:(NSDictionary *)data {
    return YES;
}

-(BOOL)manager:(LFBaseAPIManager *)manager isCorrectWithCallBackData:(NSDictionary *)data {
    return YES;
}

-(NSDictionary *)reformParams:(NSDictionary *)params {
    return params;
}

@end
