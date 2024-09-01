//
//  ViewController.m
//  AppDemo
//
//  Created by lwg on 2024/6/21.
//

#import "ViewController.h"
#import "ShowWebViewController.h"
#import "DownloadViewController.h"
#import "ThreadViewController.h"
#import "LocksViewController.h"
#import "ArrayViewController.h"
#import "TimerViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 60;
    [self.view addSubview:_tableView];
    
    _dataArray = [NSMutableArray array];
    [_dataArray addObject:@"Show WebView"];
    [_dataArray addObject:@"断点续传"];
    [_dataArray addObject:@"线程保活"];
    [_dataArray addObject:@"线程同步"];
    [_dataArray addObject:@"自定义线程安全数组"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            ShowWebViewController *VC = [[ShowWebViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 1:
        {
            DownloadViewController *VC = [[DownloadViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 2:
        {
            ThreadViewController *VC = [[ThreadViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 3:
        {
            LocksViewController *VC = [[LocksViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 4:
        {
            ArrayViewController *VC = [[ArrayViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 5:
        {
            TimerViewController *VC = [[TimerViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
            
        default:
            break;
    }
}






@end
