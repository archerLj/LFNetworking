//
//  LFGetDoctorInfoManager.m
//  LFADNetworking
//
//  Created by archerLj on 16/3/24.
//  Copyright © 2016年 archerLj. All rights reserved.
//

#import "LFGetDoctorInfoManager.h"

@implementation LFGetDoctorInfoManager
-(instancetype)init {
    self = [super init];
    if (self) {
        self.validator = self;
    }
    return self;
}

-(NSString *)methodName {
    return @"Doctor/Info";
}

-(LFAPIManagerRequestType)requestType{
    return LFAPIManagerRequestTypePost;
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
