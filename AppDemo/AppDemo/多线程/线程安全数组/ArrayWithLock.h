//
//  ArrayWithLock.h
//  ArrayTest
//
//  Created by lwg on 2024/2/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArrayWithLock : NSObject

- (void)addItem:(id)item;

- (void)removeItem:(id)item;

- (id)getLastItem;
 
@end

NS_ASSUME_NONNULL_END
