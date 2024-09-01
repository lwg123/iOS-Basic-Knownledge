//
//  DownloadViewController.m
//  AppDemo
//
//  Created by lwg on 2024/7/3.
//

#import "DownloadViewController.h"
#import "Downloader.h"
#import "DownloaderTwo.h"

NSString *videoUrl = @"https://v3.cdnpk.net/videvo_files/video/free/2014-12/large_preview/Raindrops_Videvo.mp4?token=exp=1720107691~hmac=0aa86c81c7232fd94dc75e10754bdb53afcedadc03849091893e9ae4de590632";

@interface DownloadViewController ()

@property (nonatomic, strong) DownloaderTwo *downloaderTwo;
@property (nonatomic, strong) Downloader *downloader;

@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"断点续传";
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 150, 100, 30)];
    [btn setTitle:@"开始下载" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(startDownload) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(200, 150, 100, 30)];
    [btn2 setTitle:@"停止下载" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(pauseDownload) forControlEvents:UIControlEventTouchUpInside];
    btn2.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn2];
}


- (void)startDownload {
    [self.downloaderTwo startDownload];
    
    //[self.downloader startDownload];
}

- (void)pauseDownload {
    [self.downloaderTwo pauseDownload];
}

- (DownloaderTwo *)downloaderTwo {
    if (!_downloaderTwo) {
        _downloaderTwo = [[DownloaderTwo alloc] initWithURL:videoUrl destinationPath:@"video2.mp4"];
    }
    return _downloaderTwo;
}


- (Downloader *)downloader {
    if (!_downloader) {
        _downloader = [[Downloader alloc] initWithURL:videoUrl destinationPath:@"video.mp4"];
    }
    return _downloader;
}



@end
