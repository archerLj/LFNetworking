//
//  LFNetworkingConfiguration.h
//  LFADNetworking
//
//  Created by archerLj on 16/3/23.
//  Copyright © 2016年 archerLj. All rights reserved.
//

#ifndef LFNetworkingConfiguration_h
#define LFNetworkingConfiguration_h

typedef NS_ENUM(NSUInteger, LFURLResponseStatus)
{
    LFURLResponseStatusSuccess, //作为底层，请求是否成功只考虑是否成功收到服务器反馈。至于签名是否正确，返回的数据是否完整，由上层的RTApiBaseManager来决定。
    LFURLResponseStatusErrorTimeout,
    LFURLResponseStatusErrorNoNetwork // 默认除了超时以外的错误都是无网络错误。
};

static NSTimeInterval kLFNetworkingTimeoutSeconds = 20.0f;
static NSString *LFUDIDName = @"anjukeAppsUDID";
static NSString *LFKeychainServiceName = @"com.anjukeApps";
static NSString *LFPasteboardType = @"anjukeAppsContent";

static NSString *LFUpdateRequestParamParams = @"updateDataParams";

#endif /* LFNetworkingConfiguration_h */
