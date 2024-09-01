//
//  WebViewController.m
//  AppDemo
//
//  Created by lwg on 2024/6/21.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *spinView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"preview";
    
    _spinView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
//    _spinView.backgroundColor = [UIColor redColor];
    _spinView.frame = CGRectMake(0, 0, 100, 100);
    [self.view addSubview:_spinView];
    [_spinView startAnimating];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    self.webView.navigationDelegate = self;
    self.webView.hidden = YES;
    [self.view addSubview:self.webView];
    NSLog(@"frame:%@",[NSValue valueWithCGRect:self.view.frame]);
    // 加载一个示例网页
    NSURL *url = [NSURL URLWithString:@"https://img1.baidu.com/it/u=805103204,11749913&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=1200"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webView loadRequest:request];
    });
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    NSLog(@"viewDidLayoutSubviews width:%f -- height:%f", width,height);
    self.webView.frame = self.view.frame; 
    self.spinView.center = CGPointMake(width/2, height/2);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"url: %@", navigationAction.request.URL);
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"加载完成");
    self.webView.hidden = NO;
    [_spinView stopAnimating];
}


@end
