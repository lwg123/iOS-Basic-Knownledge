//
//  ArrayWithGCD.m
//  ArrayTest
//
//  Created by lwg on 2024/2/5.
//

#import "ArrayWithGCD.h"

@interface ArrayWithGCD()

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) dispatch_queue_t readWriteQueue;
@end

/**
 dispatch_barrier_async 函数传入的并发队列必须是自己创建的，不然没有效果
 */

@implementation ArrayWithGCD

- (instancetype)init {
    if (self = [super init]) {
        _array = [NSMutableArray new];
        _readWriteQueue = dispatch_queue_create("com.geek.queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)addItem:(id)item {
    dispatch_barrier_async(self.readWriteQueue, ^{
        NSLog(@"add item %@", item);
        [self.array addObject:item];
    });
    
    
}

- (void)removeItem:(id)item {
    dispatch_barrier_async(self.readWriteQueue, ^{
        [self.array removeObject:item];
    });
    
}

- (id)getLastItemSync {
    __block id item = nil;
    dispatch_sync(self.readWriteQueue, ^{
        NSLog(@"enter getLastItemSync");
        NSUInteger count = self.array.count;
        if (count > 0) {
            item = self.array[count - 1];
        }
    });
    return item;
}


@end
