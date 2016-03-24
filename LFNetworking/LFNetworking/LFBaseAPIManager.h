//
//  LFBaseAPIManager.h
//  LFADNetworking
//
//  Created by archerLj on 16/3/23.
//  Copyright © 2016年 archerLj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFURLResponse.h"
@class LFBaseAPIManager;


static NSString *const kLFBaseAPIManagerRequestID = @"kLFBaseAPIManagerRequestID";

/**- network error -*/
typedef NS_ENUM(NSUInteger, LFAPIManagerErrorType) {
    LFAPIManagerErrorTypeDefault, // 没有产生过api请求，这个是manager的默认状态
    LFAPIManagerErrorTypeSuccess, // api请求成功并且返回数据正确，此时manager的数据是可以直接拿来使用的。
    LFAPIManagerErrorTypeNoContent, // api请求成功但是返回数据不正确，回调数据验证函数返回NO就会导致这个状态
    LFAPIManagerErrorTypeParamsError, // 参数错误，不会调用api, 是在参数验证函数里面做的（api调用之前）
    LFAPIManagerErrorTypeTimeOut, // 请求超时，超时时间是可以自己设定的。
    LFAPIManagerErrorTypeNoNetwork // 网络不通，这个也是在调用api之前判断的，不会产生api调用。
};

/**- network request type -*/
typedef NS_ENUM(NSUInteger, LFAPIManagerRequestType) {
    LFAPIManagerRequestTypeGet,
    LFAPIManagerRequestTypePost,
    LFAPIManagerRequestTypeUpdate
};


/********************************************************************************/
/*                                       LFAPIManagerApiCallBackDelegate                   */
/********************************************************************************/
@protocol LFAPIManagerApiCallBackDelegate <NSObject>
@required
-(void)managerCallApiDidSuccess:(LFBaseAPIManager *)manager;
-(void)managerCallAPiDidFailed:(LFBaseAPIManager *)manager;
@end


/********************************************************************************/
/*                                       LFAPIManagerApiCallBackDataReformer            */
/********************************************************************************/
@protocol LFAPIManagerApiCallBackDataReformer <NSObject>
@required
-(id)manager:(LFBaseAPIManager *)manager reformData:(NSDictionary *)data;
@end


/********************************************************************************/
/*                                       LFAPIManagerValidator                                   */
/********************************************************************************/
@protocol LFAPIManagerValidator <NSObject>
@required
-(BOOL)manager:(LFBaseAPIManager *)manager isCorrectWithCallBackData:(NSDictionary *)data;
-(BOOL)manager:(LFBaseAPIManager *)manager isCorrectWithParamsData:(NSDictionary *)data;
@end


/********************************************************************************/
/*                                       LFAPIManagerParamSourceDelegate                   */
/********************************************************************************/
@protocol LFAPIManagerParamSourceDelegate <NSObject>
@required
-(NSDictionary *)paramsForManager:(LFBaseAPIManager *)manager;
@end


/********************************************************************************/
/*                                       LFAPIManagerDelegate                                    */
/********************************************************************************/
@protocol LFAPIManagerDelegate <NSObject>
@required
-(NSString *)methodName;
-(LFAPIManagerRequestType)requestType;

@optional
-(void)cleanData;
-(NSDictionary *)reformParams:(NSDictionary *)params;
@end


/********************************************************************************/
/*                                       LFAPIMangerInterceptor                                  */
/********************************************************************************/
@protocol LFAPIManagerInterceptor <NSObject>
@optional
-(BOOL)manager:(LFBaseAPIManager *)manager shouldCallApiWithParams:(NSDictionary *)params;
-(void)manager:(LFBaseAPIManager *)manager afterCallApiWithParams:(NSDictionary *)params;

-(void)manager:(LFBaseAPIManager *)manager beforePerformSuccessWithResponse:(LFURLResponse *)response;
-(void)manager:(LFBaseAPIManager *)manager afterPerformSuccessWithResponse:(LFURLResponse *)response;

-(void)manager:(LFBaseAPIManager *)manager beforePerformFailedWithResponse:(LFURLResponse *)response;
-(void)manager:(LFBaseAPIManager *)manager afterPerformFailedWithResponse:(LFURLResponse *)response;
@end


/********************************************************************************/
/*                                       LFAPIBaseManager                                        */
/********************************************************************************/
@interface LFBaseAPIManager : NSObject
@property (nonatomic, weak) id<LFAPIManagerApiCallBackDelegate> callBackDelegate;
@property (nonatomic, weak) id<LFAPIManagerParamSourceDelegate> paramSource;
@property (nonatomic, weak) id<LFAPIManagerValidator> validator;
@property (nonatomic, weak) NSObject<LFAPIManagerDelegate> *child;
@property (nonatomic, weak) id<LFAPIManagerInterceptor> interceptor;

@property (nonatomic, copy, readonly) NSString *errorMessage;
@property (nonatomic, readonly) LFAPIManagerErrorType errorType;

@property (nonatomic, assign, readonly) BOOL isReachable;
@property (nonatomic, assign, readonly) BOOL isLoading;


-(NSInteger)loadData;
-(id)fetchDataWithReformer:(id<LFAPIManagerApiCallBackDataReformer>)reformer;

-(void)cancelAllRequests;
-(void)cancelRequestWithRequestId:(NSInteger)requestId;

-(BOOL)shouldCallAPIWithParams:(NSDictionary *)params;
-(void)afterCallingAPIWithParams:(NSDictionary *)params;

-(void)beforePerformSuccessWithResponse:(LFURLResponse *)response;
-(void)afterPerformSuccessWithResponse:(LFURLResponse *)response;

-(void)beforePerformFailWithResponse:(LFURLResponse *)response;
-(void)afterPerformFailWithResponse:(LFURLResponse *)response;


-(NSDictionary *)reformParams:(NSDictionary *)params;
-(void)cleanData;
@end
