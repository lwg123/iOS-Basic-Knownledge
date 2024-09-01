//
//  DownloaderTwo.m
//  AppDemo
//
//  Created by lwg on 2024/7/3.
//

/**
 下载完成后一次性move到location，可以手动开启或暂停
 */

#import "DownloaderTwo.h"

#import <Foundation/Foundation.h>

@interface DownloaderTwo() <NSURLSessionDownloadDelegate>
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSData *resumeData;
@property (nonatomic, copy) NSString *downloadURL;
@property (nonatomic, copy) NSString *destinationPath;
@end

@implementation DownloaderTwo

- (instancetype)initWithURL:(NSString *)url destinationPath:(NSString *)destinationPath {
    self = [super init];
    if (self) {
        _downloadURL = url;
        _destinationPath = [self getDownloadPath:destinationPath];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    }
    return self;
}

- (void)startDownload {
    if (self.resumeData) {
        [self resumeDownload];
    } else {
        NSURL *url = [NSURL URLWithString:self.downloadURL];
        self.downloadTask = [self.session downloadTaskWithURL:url];
        [self.downloadTask resume];
    }
}

- (void)pauseDownload {
    if (self.downloadTask) {
        __weak typeof(self) weakSelf = self;
        [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            weakSelf.resumeData = resumeData;
            weakSelf.downloadTask = nil;
        }];
    }
}

- (void)resumeDownload {
    if (self.resumeData) {
        self.downloadTask = [self.session downloadTaskWithResumeData:self.resumeData];
        [self.downloadTask resume];
        self.resumeData = nil;
    }
}

// NSURLSessionDownloadDelegate methods
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"self.destinationPath:%@",self.destinationPath);
    NSError *error;
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:self.destinationPath] error:&error];
    if (error) {
        NSLog(@"File move error: %@", error);
    } else {
        NSLog(@"Download completed successfully");
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        if ([error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData]) {
            self.resumeData = [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
        } else {
            NSLog(@"Download failed with error: %@", error);
        }
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    CGFloat progress = (CGFloat)totalBytesWritten / totalBytesExpectedToWrite;
    NSLog(@"Download progress: %.2f%%", progress * 100);
}


// 获取文件下载路径
- (NSString *)getDownloadPath:(NSString *)pathStr {
    // 获取应用程序的Documents目录路径, NSDocumentDirectory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // 如果需要指定下载文件的名称，可以在路径后添加文件名
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:pathStr];
    return filePath;
}
@end

