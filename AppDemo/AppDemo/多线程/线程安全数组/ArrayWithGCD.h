//
//  ArrayWithGCD.h
//  ArrayTest
//
//  Created by lwg on 2024/2/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArrayWithGCD : NSObject

- (void)addItem:(id)item;

- (void)removeItem:(id)item;

- (id)getLastItemSync;

@end

NS_ASSUME_NONNULL_END
