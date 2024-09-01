//
//  DownloaderTwo.h
//  AppDemo
//
//  Created by lwg on 2024/7/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DownloaderTwo : NSObject
- (instancetype)initWithURL:(NSString *)url destinationPath:(NSString *)destinationPath;
- (void)startDownload;
- (void)pauseDownload;
@end

NS_ASSUME_NONNULL_END
