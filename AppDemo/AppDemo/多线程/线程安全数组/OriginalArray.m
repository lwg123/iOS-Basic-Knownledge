//
//  OriginalArray.m
//  ArrayTest
//
//  Created by lwg on 2024/2/5.
//

#import "OriginalArray.h"

@interface OriginalArray()

@property (nonatomic) NSMutableArray *array;

@end

@implementation OriginalArray

- (instancetype)init {
    if (self = [super init]) {
        _array = [NSMutableArray new];
    }
    return self;
}

- (void)addItem:(id)item {
    [self.array addObject:item];
    
}

- (void)removeItem:(id)item {
    [self.array removeObject:item];
}

- (id)getLastItem {
    NSUInteger count = self.array.count;
    if (count > 0) {
        return self.array[count - 1];
    }
    return nil;
}

- (NSUInteger)count {
    return self.array.count;
}

@end
