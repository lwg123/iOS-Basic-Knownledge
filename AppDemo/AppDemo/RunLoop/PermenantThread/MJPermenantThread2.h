//
//  MJPermenantThread2.h
//  AppDemo
//
//  Created by lwg on 2024/8/15.
//

#import <Foundation/Foundation.h>

typedef void (^MJPermenantThreadTask)(void);

@interface MJPermenantThread2 : NSObject

/**
 开启线程
 */
//- (void)run;

/**
 在当前子线程执行一个任务
 */
- (void)executeTask:(MJPermenantThreadTask)task;

/**
 结束线程
 */
- (void)stop;

@end


