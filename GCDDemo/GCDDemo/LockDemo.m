//
//  LockDemo.m
//  GCDDemo
//
//  Created by 安宁 on 2020/3/29.
//  Copyright © 2020 安宁. All rights reserved.
//

#import "LockDemo.h"

typedef NS_ENUM(NSInteger, ResultStatus) {
    ResultStatusDefault = 0 ,
    ResultStatus1 = 1,
    ResultStatus2 = 2,
    ResultStatus3 = 3
};
struct Result{
    BOOL success ;
    ResultStatus rs;
    NSInteger count ;
};
@interface LockDemo()
{
    ResultStatus _rs ;
    NSInteger _count ;
    NSInteger _circleCount ;

    NSLock * _lock ;
}
@end

@implementation LockDemo

#pragma mark 封装测试锁类型
//封装测试锁类型
-(void)test:(TestLockType)type{
    
    _rs = ResultStatusDefault ;
    _count = 0 ;
    
    if (type == TestLockNSLock) {
        if (!_lock) {
            _lock = [[NSLock alloc]init];
        }
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"current third:%@",[NSThread currentThread]) ;
        sleep(2);
        struct Result result = [self test:type resultStatus:ResultStatus1];
        if (result.success == YES) {
            NSLog(@"%@:%@:  其他都未执行 ，现在执行1",@(type),@(result.count));
        }else{
            NSLog(@"%@:%@:  %@已执行 ，1不执行",@(type),@(result.count),@(result.rs));
        }
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"current third:%@",[NSThread currentThread]) ;
        sleep(2);
        struct Result result = [self test:type resultStatus:ResultStatus2];
        if (result.success == YES) {
            NSLog(@"%@:%@:  其他都未执行 ，现在执行2",@(type),@(result.count));
        }else{
            NSLog(@"%@:%@:  %@已执行 ，2不执行",@(type),@(result.count),@(result.rs));
        }
    });
//    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//    dispatch_async(dispatch_queue_create("ab", DISPATCH_QUEUE_CONCURRENT), ^{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSLog(@"current third:%@",[NSThread currentThread]) ;
        sleep(2);
        struct Result result = [self test:type resultStatus:ResultStatus3];
        if (result.success == YES) {
            NSLog(@"%@:%@:  其他都未执行 ，现在执行3",@(type),@(result.count));
        }else{
            NSLog(@"%@:%@:  %@已执行 ，3不执行",@(type),@(result.count),@(result.rs));
        }
    });
}
#pragma mark 封装执行锁方法
-(struct Result)test:(TestLockType)type resultStatus:(ResultStatus)status{
    struct Result result ;
    result.success = NO ;
    result.rs = ResultStatusDefault ;
    
    if (type == TestLockSynchronized) {
        result = [self setStatusWithSynchronized:status];
    }else if (type == TestLockNSLock){
        result = [self setStatusWithLock:status];
    }
    
    return result ;
}
#pragma mark Synchronized加锁
-(struct Result)setStatusWithSynchronized:(ResultStatus)t{
    
    for (int i = 0; i < 100; i++) {
        @synchronized (self) {
            [self setCircleCount:t];
        }
    }
    @synchronized (self) {
        return [self setStatus:t];
    }
    
}
#pragma mark NSLock加锁
-(struct Result)setStatusWithLock:(ResultStatus)t{
    
    for (int i = 0; i < 100; i++) {
        [_lock lock];
        [self setCircleCount:t];
        [_lock unlock];

    }
    [_lock lock];
    struct Result result = [self setStatus:t] ;
    [_lock unlock];
    return result;
    
}

#pragma mark 加锁代码
-(struct Result)setStatus:(ResultStatus)t{
    
    struct Result result  ;
    _count++;
    
    if (_rs == ResultStatusDefault) {
        _rs = t ;
        result.success = YES ;
    }else{
        result.success = NO ;
        result.rs = _rs ;
    }
    result.count = _count ;
    return result ;
}

-(void)setCircleCount:(NSInteger)type{
    _circleCount++;
    NSLog(@"circle:%@ %@",@(type),@(_circleCount));
}

@end
