//
//  ViewController.m
//  UploadDemo
//
//  Created by 洪锐丹 on 2018/6/18.
//  Copyright © 2018年 Amani. All rights reserved.
//

#import "ViewController.h"
#import "NetworkManager.h"

NSString const *HTTP_BIN_POST_URL_STRING = @"https://www.httpbin.org/post";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)httpUploadTouchInside:(id)sender {
    NetworkManagerUploadObject *file = [[NetworkManagerUploadObject alloc] init];
    file.file = [[NSBundle mainBundle] pathForResource:@"UploadDemo" ofType:@"zip"];
    [[NetworkManager shareInstance] httpPostFileToUrl:[HTTP_BIN_POST_URL_STRING copy] files:@[file] handle:^(BOOL isSuccess, NSError *error) {
    }];
}

- (IBAction)urlUploadTouchInside:(id)sender {
    NSString *file = [[NSBundle mainBundle] pathForResource:@"UploadDemo" ofType:@"zip"];
    [[NetworkManager shareInstance] urlUploadFileToUrl:[HTTP_BIN_POST_URL_STRING copy] file:file handle:^(BOOL isSuccess, NSError *error) {
        
    }];
}

- (IBAction)urlUploadDataTouchInside:(id)sender {
    [[NetworkManager shareInstance] urlUploadDataToUrl:[HTTP_BIN_POST_URL_STRING copy] data:[HTTP_BIN_POST_URL_STRING dataUsingEncoding:NSUTF8StringEncoding] handle:^(BOOL isSuccess, NSError *error) {
        NSLog(@"url upload string result : %d", isSuccess);
    }];
    NSString *file = [[NSBundle mainBundle] pathForResource:@"UploadDemo" ofType:@"zip"];
    [[NetworkManager shareInstance] urlUploadDataToUrl:[HTTP_BIN_POST_URL_STRING copy] data:[NSData dataWithContentsOfFile:file] handle:^(BOOL isSuccess, NSError *error) {
        NSLog(@"url upload file result : %d", isSuccess);
    }];
}
@end
