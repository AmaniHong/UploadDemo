//
//  NetworkManager.m
//  UploadDemo
//
//  Created by 洪锐丹 on 2018/6/18.
//  Copyright © 2018年 Amani. All rights reserved.
//

#import "NetworkManager.h"
@import AFNetworking;

@interface NetworkManager ()

@property (nonatomic, strong) AFURLSessionManager *urlManager;
@property (nonatomic, strong) AFHTTPSessionManager *httpManager;

@end

@implementation NetworkManagerUploadObject

@end

@implementation NetworkManager

static NetworkManager *_shareInstance = nil;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[NetworkManager alloc] init];
    });
    return _shareInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        dispatch_queue_t queue = dispatch_queue_create("UPLOAD_DEMO_QUEUE", NULL);
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.urlManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        self.urlManager.responseSerializer = [AFJSONResponseSerializer serializer];
        [self.urlManager setCompletionQueue:queue];
        
        self.httpManager = [AFHTTPSessionManager manager];
        self.httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.httpManager setCompletionQueue:queue];
    }
    return self;
}

- (void)urlUploadFileToUrl:(NSString *)url file:(NSString *)file handle:(NetworkHandle)handle {
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];

    NSURL *filePath = [NSURL fileURLWithPath:file];
    
    NSURLSessionUploadTask *uploadTask = [self.urlManager uploadTaskWithRequest:request fromFile:filePath progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSLog(@"response %@", response);
        NSLog(@"error %@", error);

        if (error) {
            handle(NO, error);
            return ;
        }
        if (response) {
            handle(YES, nil);
            return ;
        }
    }];
    [uploadTask resume];
}

- (void)urlUploadDataToUrl:(NSString *)url data:(NSData *)data handle:(NetworkHandle)handle {
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];

    NSURLSessionUploadTask *uploadTask = [self.urlManager uploadTaskWithRequest:request fromData:data progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress %@", uploadProgress);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"response %@", response);
        NSLog(@"error %@", error);
        if (handle) {
            handle(!error, error);
        }
    }];
    
    [uploadTask resume];
}

- (void)httpPostFileToUrl:( NSString * )url files:(NSArray<NetworkManagerUploadObject*> *)files handle:(NetworkHandle)handle {
    
    NSURLSessionDataTask *dataTask = [self.httpManager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NetworkManagerUploadObject *file in files) {
            NSString *name = file.name ? file.name : @"file";
            NSString *mimeType = file.mimeType ? file.mimeType : @"application/octet-stream";
            [formData appendPartWithFileData:[NSData dataWithContentsOfFile:file.file] name:name fileName:[file.file lastPathComponent] mimeType:mimeType];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"progress : %@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject : %@", responseObject);
        if (handle) {
            handle(YES, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error : %@", error);
        if (handle) {
            handle(!error, error);
        }
    }];
    
    [dataTask resume];
    
}
@end


