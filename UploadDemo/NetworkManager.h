//
//  NetworkManager.h
//  UploadDemo
//
//  Created by 洪锐丹 on 2018/6/18.
//  Copyright © 2018年 Amani. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NetworkManagerUploadObject;

typedef void(^NetworkHandle)(BOOL isSuccess,  NSError * error);
@interface NetworkManager : NSObject

+ (instancetype)shareInstance;

- (void)urlUploadFileToUrl:(NSString *)url file:(NSString *)file handle:(NetworkHandle)handle;
- (void)urlUploadDataToUrl:(NSString *)url data:(NSData *)data handle:(NetworkHandle)handle;
- (void)httpPostFileToUrl:(NSString *)url files:(NSArray<NetworkManagerUploadObject*> *)files handle:( NetworkHandle)handle;

@end

@interface NetworkManagerUploadObject : NSObject

@property (nonatomic, copy) NSString *file;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *mimeType;

@end
