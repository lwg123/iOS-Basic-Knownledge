//
//  Downloader.h
//  AppDemo
//
//  Created by lwg on 2024/7/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Downloader : NSObject

- (instancetype)initWithURL:(NSString *)url destinationPath:(NSString *)destinationPath;
- (void)startDownload;

@end

NS_ASSUME_NONNULL_END
