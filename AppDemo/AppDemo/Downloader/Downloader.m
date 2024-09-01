//
//  Downloader.m
//  AppDemo
//
//  Created by lwg on 2024/7/2.
//


/**
 边下载边写入的情况，由于断网或关机导致停止
 */

#import <Foundation/Foundation.h>

@interface Downloader : NSObject <NSURLSessionDataDelegate>
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSOutputStream *outputStream;
@property (nonatomic, assign) long long downloadedBytes;
@property (nonatomic, assign) long long totalBytes;
@property (nonatomic, copy) NSString *downloadURL;
@property (nonatomic, copy) NSString *destinationPath;
@end

@implementation Downloader

- (instancetype)initWithURL:(NSString *)url destinationPath:(NSString *)destinationPath {
    self = [super init];
    if (self) {
        _downloadURL = url;
        _destinationPath = [self getDownloadPath:destinationPath];
        _downloadedBytes = 0;
        _totalBytes = 0;
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    }
    return self;
}

- (void)startDownload {
    [self setupOutputStream];
    [self resumeDownload];
}

- (void)setupOutputStream {
    self.outputStream = [NSOutputStream outputStreamToFileAtPath:self.destinationPath append:YES];
    [self.outputStream open];
    NSLog(@"self.destinationPath:%@",self.destinationPath);
    // 获取已下载的字节数
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:self.destinationPath error:nil];
    if (fileAttributes) {
        self.downloadedBytes = [fileAttributes[NSFileSize] longLongValue];
    }
}

- (void)resumeDownload {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.downloadURL]];
    if (self.downloadedBytes > 0) {
        NSString *range = [NSString stringWithFormat:@"bytes=%lld-", self.downloadedBytes];
        [request setValue:range forHTTPHeaderField:@"Range"];
    }
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request];
    [dataTask resume];
}

// NSURLSessionDataDelegate methods
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if (httpResponse.statusCode == 200) {
        self.totalBytes = response.expectedContentLength;
    } else if (httpResponse.statusCode == 206) {
        /**
         HTTP状态码206（Partial Content）表示客户端进行了范围请求，并且服务器成功执行了这部分的GET请求。这是HTTP协议中的一种机制，允许客户端只获取资源的一部分，而不是整个资源。这通常用于支持断点续传或将大型文件分割成多个小部分同时下载。
         */
        NSString *contentRange = httpResponse.allHeaderFields[@"Content-Range"];
        NSArray *components = [contentRange componentsSeparatedByString:@"/"];
        self.totalBytes = [components.lastObject longLongValue];
    }
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.outputStream write:data.bytes maxLength:data.length];
    self.downloadedBytes += data.length;
    NSLog(@"Downloaded %lld/%lld bytes", self.downloadedBytes, self.totalBytes);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    [self.outputStream close];
    if (error) {
        NSLog(@"Download failed with error: %@", error);
    } else {
        NSLog(@"Download completed successfully");
    }
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


