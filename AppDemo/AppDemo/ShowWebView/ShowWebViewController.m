//
//  ShowWebViewController.m
//  AppDemo
//
//  Created by lwg on 2024/7/2.
//

#import "ShowWebViewController.h"
#import "WebViewController.h"

@interface ShowWebViewController ()

@end

@implementation ShowWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Show WebView" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showWebView) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(100, 100, 200, 50);
    [self.view addSubview:button];
}

- (void)showWebView {
    WebViewController *webVC = [[WebViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:webVC];
    navController.modalPresentationStyle = UIModalPresentationPageSheet; // 或者 UIModalPresentationPageSheet
    
    [self presentViewController:navController animated:YES completion:nil];
   // [self.navigationController pushViewController:webVC animated:YES];
}

@end
