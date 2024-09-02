//
//  ThreadViewController.m
//  AppDemo
//
//  Created by lwg on 2024/8/14.
//

#import "ThreadViewController.h"
#import "MJPermenantThread.h"

@interface ThreadViewController ()
@property (strong, nonatomic) MJPermenantThread *thread;
@end

@implementation ThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.thread = [[MJPermenantThread alloc] init];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 150, 50);
    [button setTitle:@"stop" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor systemPinkColor];
    [self.view addSubview:button];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.thread executeTask:^{
        NSLog(@"执行任务 - %@", [NSThread currentThread]);
    }];
}


- (void)stop {
    [self.thread stop];
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
    
    [self stop];
}


@end
