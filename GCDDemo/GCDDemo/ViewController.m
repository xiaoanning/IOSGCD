//
//  ViewController.m
//  GCDDemo
//
//  Created by 安宁 on 2020/3/29.
//  Copyright © 2020 安宁. All rights reserved.
//

#import "ViewController.h"

#import "LockDemo.h"
#import "ThreadDemo.h"

@interface ViewController ()
{
    LockDemo * _lockDemo ;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self lockTest];
    [self threadTest];
}

-(void)threadTest{
//    [ThreadDemo multiRequestOneByOneEnd];
    [ThreadDemo asyncMultiRequestEnd];
}

-(void)lockTest{
    _lockDemo = [[LockDemo alloc]init];
    [_lockDemo test:(TestLockSynchronized)];
    [_lockDemo test:(TestLockNSLock)];

}


@end
