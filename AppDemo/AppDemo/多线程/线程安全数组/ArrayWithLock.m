//
//  ArrayWithLock.m
//  ArrayTest
//
//  Created by lwg on 2024/2/5.
//

#import "ArrayWithLock.h"

@interface ArrayWithLock()

@property (nonatomic) NSMutableArray *array;
@property (nonatomic) NSLock *lock;

@end

@implementation ArrayWithLock

- (instancetype)init {
    if (self = [super init]) {
        _array = [NSMutableArray new];
        _lock = [NSLock new];
    }
    return self;
}

- (void)addItem:(id)item {
    [self.lock lock];
    [self.array addObject:item];
    [self.lock unlock];
    
}

- (void)removeItem:(id)item {
    [self.lock lock];
    [self.array removeObject:item];
    [self.lock unlock];
}

- (id)getLastItem {
    [self.lock lock];
    id item = nil;
    NSUInteger count = self.array.count;
    if (count > 0) {
        item = self.array[count - 1];
    }
    [self.lock unlock];
    return item;
}

- (NSUInteger)count {
    [self.lock lock];
    NSUInteger count = self.array.count;
    [self.lock unlock];
    return count;
    
}

@end
