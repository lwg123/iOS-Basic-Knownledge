//
//  ViewController.m
//  Interview03-定时器
//
//  Created by MJ Lee on 2018/6/19.
//  Copyright © 2018年 MJ Lee. All rights reserved.
//

#import "TimerViewController.h"
#import "MJProxy.h"
#import "MJProxy1.h"
#import "MJTimer.h"

@interface TimerViewController ()
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) dispatch_source_t timer2;
@property (copy, nonatomic) NSString *task;
@end

@implementation TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:[MJProxy proxyWithTarget:self] selector:@selector(timerTest) userInfo:nil repeats:YES];
    
    // 接口设计
    self.task = [MJTimer execTask:self
                         selector:@selector(doTask)
                            start:2.0
                         interval:1.0
                          repeats:YES
                            async:NO];
    
//    self.task = [MJTimer execTask:^{
//        NSLog(@"111111 - %@", [NSThread currentThread]);
//    } start:2.0 interval:-10 repeats:NO async:NO];
}

- (void)timerTest
{
    NSLog(@"%s", __func__);
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
    [self.timer invalidate];
}

- (void)doTask
{
    NSLog(@"doTask - %@", [NSThread currentThread]);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [MJTimer cancelTask:self.task];
}

- (void)test
{
    
    // 队列
    //    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_queue_t queue = dispatch_queue_create("timer", DISPATCH_QUEUE_SERIAL);
    
    // 创建定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 设置时间
    uint64_t start = 2.0; // 2秒后开始执行
    uint64_t interval = 1.0; // 每隔1秒执行
    dispatch_source_set_timer(timer,
                              dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC),
                              interval * NSEC_PER_SEC, 0);
    
    // 设置回调
    //    dispatch_source_set_event_handler(timer, ^{
    //        NSLog(@"1111");
    //    });
    dispatch_source_set_event_handler_f(timer, timerFire);
    
    // 启动定时器
    dispatch_resume(timer);
    
    self.timer2 = timer;
}

void timerFire(void *param)
{
    NSLog(@"2222 - %@", [NSThread currentThread]);
}


@end
