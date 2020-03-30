//
//  ThreadDemo.m
//  GCDDemo
//
//  Created by 安宁 on 2020/3/30.
//  Copyright © 2020 安宁. All rights reserved.
//

#import "ThreadDemo.h"

@implementation ThreadDemo

//多个网络请求 顺序执行后 如何执行下一步
+(void)multiRequestOneByOneEnd{
    NSString *str = @"http://www.jianshu.com/p/6930f335adba";
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];

    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    for (int i=0; i<10; i++) {
        
        NSLog(@"%d---",i);

        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSLog(@"%d---%d",i,i);
            dispatch_semaphore_signal(sem);
        }];
        
        [task resume];
        NSLog(@"---%d",i);

        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);//这里一直等待 直到dispatch_semaphore_signal执行
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"end");//这里等待所有请求完毕后执行
    });
}

//多个网络请求完成后如何执行下一步？
+(void)asyncMultiRequestEnd{
    NSString *str = @"http://www.jianshu.com/p/6930f335adba";
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];

    dispatch_group_t downloadGroup = dispatch_group_create();
    for (int i=0; i<100; i++) {
        dispatch_group_enter(downloadGroup);
        NSLog(@"%d---",i);

        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSLog(@"%d---%d",i,i);
            dispatch_group_leave(downloadGroup);
        }];
        [task resume];
        NSLog(@"---%d",i);

    }

    dispatch_group_notify(downloadGroup, dispatch_get_main_queue(), ^{
        NSLog(@"end");
    });
}
@end
