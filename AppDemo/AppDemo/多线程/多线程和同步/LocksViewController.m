//
//  LocksViewController.m
//  AppDemo
//
//  Created by lwg on 2024/8/24.
//

#import "LocksViewController.h"
#import "MJBaseDemo.h"
#import "OSSpinLockDemo.h"
#import "OSSpinLockDemo2.h"
#import "OSUnfairLockDemo.h"
#import "MutexDemo.h"
#import "MutexDemo2.h"
#import "MutexDemo3.h"
#import "NSLockDemo.h"
#import "NSConditionDemo.h"
#import "NSConditionLockDemo.h"
#import "SerialQueueDemo.h"
#import "SemaphoreDemo.h"
#import "SynchronizedDemo.h"
#import <pthread.h>

#define SemaphoreBegin \
static dispatch_semaphore_t semaphore; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
    semaphore = dispatch_semaphore_create(1); \
}); \
dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

#define SemaphoreEnd \
dispatch_semaphore_signal(semaphore);


@interface LocksViewController ()
@property (strong, nonatomic) MJBaseDemo *demo;
@property (strong, nonatomic) dispatch_queue_t queue;
@property (assign, nonatomic) pthread_rwlock_t lock;
@end

@implementation LocksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    MJBaseDemo *demo = [[NSConditionDemo alloc] init];
//    [demo ticketTest];
//    [demo moneyTest];
    [demo otherTest];
}

- (void)test
{
    NSLog(@"2");
}

- (void)test1
{
    SemaphoreBegin;
    
    // .....
    
    SemaphoreEnd;
}

- (void)test2
{
    SemaphoreBegin;
    
    // .....
    
    SemaphoreEnd;
}

- (void)test3
{
    SemaphoreBegin;
    
    // .....
    
    SemaphoreEnd;
}

#pragma 读写线程安全方案2
/**
 使用dispatch_barrier_async，实现读取时可以多个线程同时读取，写入时只有一个线程写入
 */
- (void)readWrite {
    self.queue = dispatch_queue_create("rw_queue", DISPATCH_QUEUE_CONCURRENT);
    
    for (int i = 0; i < 10; i++) {
        dispatch_async(self.queue, ^{
            [self read];
        });
        
        dispatch_async(self.queue, ^{
            [self read];
        });
        
        dispatch_async(self.queue, ^{
            [self read];
        });
        
        dispatch_barrier_async(self.queue, ^{
            [self write];
        });
    }
}

- (void)read {
    sleep(1);
    NSLog(@"read");
}

- (void)write
{
    sleep(1);
    NSLog(@"write");
}


#pragma 读写线程安全方案2
/**
 使用读写锁，实现读取时可以多个线程同时读取，写入时只有一个线程写入
 */
- (void)readWrite2 {
    // 初始化锁
    pthread_rwlock_init(&_lock, NULL);
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    for (int i = 0; i < 10; i++) {
        dispatch_async(queue, ^{
            [self read2];
        });
        dispatch_async(queue, ^{
            [self write2];
        });
    }
}

- (void)read2 {
    pthread_rwlock_rdlock(&_lock);
    
    sleep(1);
    NSLog(@"%s", __func__);
    
    pthread_rwlock_unlock(&_lock);
}

- (void)write2
{
    pthread_rwlock_wrlock(&_lock);
    
    sleep(1);
    NSLog(@"%s", __func__);
    
    pthread_rwlock_unlock(&_lock);
}

- (void)dealloc
{
    pthread_rwlock_destroy(&_lock);
}
@end
