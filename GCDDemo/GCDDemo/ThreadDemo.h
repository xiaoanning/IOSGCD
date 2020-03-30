//
//  ThreadDemo.h
//  GCDDemo
//
//  Created by 安宁 on 2020/3/30.
//  Copyright © 2020 安宁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThreadDemo : NSObject

//多个网络请求 顺序执行后 如何执行下一步
+(void)multiRequestOneByOneEnd;
//多个网络请求完成后如何执行下一步
+(void)asyncMultiRequestEnd;

@end

NS_ASSUME_NONNULL_END
