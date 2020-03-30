//
//  LockDemo.h
//  GCDDemo
//
//  Created by 安宁 on 2020/3/29.
//  Copyright © 2020 安宁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,TestLockType){
    TestLockSynchronized = 1 ,
    TestLockNSLock = 2 ,

} ;

@interface LockDemo : NSObject

-(void)test:(TestLockType)type;

@end

NS_ASSUME_NONNULL_END
