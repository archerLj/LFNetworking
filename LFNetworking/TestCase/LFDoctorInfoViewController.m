//
//  LFDoctorInfoViewController.m
//  LFADNetworking
//
//  Created by archerLj on 16/3/24.
//  Copyright © 2016年 archerLj. All rights reserved.
//

#import "LFDoctorInfoViewController.h"
#import "LFGetDoctorInfoManager.h"
#import "LFDoctorInfoReformer.h"
#import "LFGetInfoCenterManager.h"
#import "LFUpdateImageManager.h"
#import "LFUpdateFileParams.h"
#import <UIImageView+WebCache.h>

@interface LFDoctorInfoViewController ()
@property (strong, nonatomic) LFGetDoctorInfoManager *doctorInfoManager;
@property (strong, nonatomic) LFDoctorInfoReformer *reformer;
@property (strong, nonatomic) LFGetInfoCenterManager *infoCenterManager;
@property (strong, nonatomic) LFUpdateImageManager *updateImageManager;
@property (strong, nonatomic) NSMutableDictionary *params;
@end

@implementation LFDoctorInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.doctorInfoManager.paramSource = self;
    self.doctorInfoManager.callBackDelegate = self;
    self.infoCenterManager.paramSource = self;
    self.infoCenterManager.callBackDelegate = self;
    self.updateImageManager.paramSource = self;
    self.updateImageManager.callBackDelegate = self;
    UIButton *postData = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    [postData setBackgroundColor:[UIColor redColor]];
    [postData setTitle:@"Post" forState:UIControlStateNormal];
    [postData addTarget:self action:@selector(postDataToServer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:postData];
    
    UIButton *cancelTask = [[UIButton alloc] initWithFrame:CGRectMake(100, 160, 100, 50)];
    [cancelTask setBackgroundColor:[UIColor redColor]];
    [cancelTask setTitle:@"取消所有请求" forState:UIControlStateNormal];
    [cancelTask addTarget:self action:@selector(cancelTask) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelTask];
    
    UIButton *getData = [[UIButton alloc] initWithFrame:CGRectMake(100, 220, 100, 50)];
    [getData setBackgroundColor:[UIColor redColor]];
    [getData setTitle:@"Get" forState:UIControlStateNormal];
    [getData addTarget:self action:@selector(getDataFromServer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getData];
    
    UIButton *updateData = [[UIButton alloc] initWithFrame:CGRectMake(100, 280, 100, 50)];
    [updateData setBackgroundColor:[UIColor redColor]];
    [updateData setTitle:@"Update" forState:UIControlStateNormal];
    [updateData addTarget:self action:@selector(updateDataToServer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:updateData];
}

-(void)cancelTask {
    [self.doctorInfoManager cancelAllRequests];
}

-(void)postDataToServer {
    [self.doctorInfoManager loadData];
}

-(void)getDataFromServer {
    [self.infoCenterManager loadData];
}

-(void)updateDataToServer {
    [self.updateImageManager loadData];
}

-(NSDictionary *)paramsForManager:(LFBaseAPIManager *)manager {
    [self.params removeAllObjects];
    if (manager == self.doctorInfoManager) {
        self.params[@"doctorid"] = @(4462);
    } else if (manager == self.infoCenterManager) {
        self.params[@"userid"] = @(4462);
        self.params[@"patientdoctorTag"] = @1;
        self.params[@"offset"] = @0;
        self.params[@"limit"] = @10;
    } else if(manager == self.updateImageManager) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"useImage" ofType:@"png"];
        UIImage *image = [UIImage imageNamed:@"useImage"];
        NSData *data = UIImagePNGRepresentation(image);
        LFUpdateFileParams *updateParams = [[LFUpdateFileParams alloc] initWithFileData:data name:@"file" fileName:filePath mimeType:@"image/png"];
        self.params[LFUpdateRequestParamParams] = updateParams;
    }
    return self.params;
}

-(void)managerCallApiDidSuccess:(LFBaseAPIManager *)manager {
    id dataGet = nil;
    if (manager == self.doctorInfoManager) {
        dataGet = [self.doctorInfoManager fetchDataWithReformer:self.reformer];
    } else if (manager == self.infoCenterManager) {
        dataGet = [self.infoCenterManager fetchDataWithReformer:self.reformer];
    } else if (manager == self.updateImageManager) {
        dataGet = [self.updateImageManager fetchDataWithReformer:self.reformer];
    }
    NSLog(@"-----%@",dataGet);
}

-(void)managerCallAPiDidFailed:(LFBaseAPIManager *)manager {
    NSLog(@"网络请求失败");
}

-(NSMutableDictionary *)params {
    if (!_params) {
        _params = [[NSMutableDictionary alloc] init];
    }
    return _params;
}

-(LFGetDoctorInfoManager *)doctorInfoManager {
    if (!_doctorInfoManager) {
        _doctorInfoManager = [[LFGetDoctorInfoManager alloc] init];
    }
    return _doctorInfoManager;
}

-(LFDoctorInfoReformer *)reformer {
    if (!_reformer) {
        _reformer = [[LFDoctorInfoReformer alloc] init];
    }
    return _reformer;
}

-(LFGetInfoCenterManager *)infoCenterManager {
    if (!_infoCenterManager) {
        _infoCenterManager = [[LFGetInfoCenterManager alloc] init];
    }
    return _infoCenterManager;
}

-(LFUpdateImageManager *)updateImageManager {
    if (!_updateImageManager) {
        _updateImageManager = [[LFUpdateImageManager alloc] init];
    }
    return _updateImageManager;
}
@end
