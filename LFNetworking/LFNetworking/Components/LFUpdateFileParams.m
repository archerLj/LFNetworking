//
//  LFUpdateFileParams.m
//  LFADNetworking
//
//  Created by archerLj on 16/3/24.
//  Copyright © 2016年 archerLj. All rights reserved.
//

#import "LFUpdateFileParams.h"

@implementation LFUpdateFileParams
-(instancetype)initWithFileData:(NSData *)data
                           name:(NSString *)name
                       fileName:(NSString *)fileName
                       mimeType:(NSString *)mimeType {
    self = [super init];
    if (self) {
        _fileData = data;
        _name = name;
        _fileName = fileName;
        _mimeType = mimeType;
    }
    return self;
}
@end
