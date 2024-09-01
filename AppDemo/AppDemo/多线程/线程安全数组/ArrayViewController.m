//
//  ViewController.m
//  ArrayTest
//
//  Created by lwg on 2024/2/5.
//

#import "ArrayViewController.h"
#import "OriginalArray.h"
#import "ArrayWithLock.h"
#import "ArrayWithGCD.h"

@interface ArrayViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ArrayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"测试";
    [self setupUI];
    
    [self.tableView reloadData];
}

- (NSArray *)getDataSourceArray {
    return @[
        @{
            @"title" : @"原始数组读写",
            @"method" : @"testOriginalArray"
        },
        @{
            @"title" : @"NSLock数组读写",
            @"method" : @"testArrayWithLock"
        },
        @{
            @"title" : @"GCD数组读写",
            @"method" : @"testArrayWithGCD"
        },
    
    ];
}


- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

// 可能会出现崩溃，出现数组越界
- (void)testOriginalArray {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    OriginalArray *array = [OriginalArray new];
    for (int i = 0; i < 50; i++) {
        [array addItem:[NSString stringWithFormat:@"%d", i]];
    }
    
    for (int i = 0; i < 50; i++) {
        dispatch_async(queue, ^{
            [NSThread sleepForTimeInterval:1.f];
            NSLog(@"获取最后一个元素并移除-第%d次", i);
            id item = [array getLastItem];
            if (item) {
                [array removeItem:item];
            }
        });
    }
}

- (void)testArrayWithLock {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    ArrayWithLock *array = [ArrayWithLock new];
    for (int i = 0; i < 50; i++) {
        [array addItem:[NSString stringWithFormat:@"%d", i]];
    }
    
    for (int i = 0; i < 50; i++) {
        dispatch_async(queue, ^{
            [NSThread sleepForTimeInterval:1.f];
            NSLog(@"获取最后一个元素并移除-第%d次", i);
            id item = [array getLastItem];
            if (item) {
                [array removeItem:item];
            }
        });
    }
}

- (void)testArrayWithGCD {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    ArrayWithGCD *array = [ArrayWithGCD new];
    for (int i = 0; i < 50; i++) {
        [array addItem:[NSString stringWithFormat:@"%d", i]];
    }
    
    for (int i = 0; i < 50; i++) {
        dispatch_async(queue, ^{
            [NSThread sleepForTimeInterval:1.f];
            NSLog(@"获取最后一个元素并移除-第%d次", i);
            id item = [array getLastItemSync];
            if (item) {
                [array removeItem:item];
            }
        });
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self getDataSourceArray].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *dict = [[self getDataSourceArray] objectAtIndex:indexPath.row];
    cell.textLabel.text = dict[@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [[self getDataSourceArray] objectAtIndex:indexPath.row];
    
    NSString *method = dict[@"method"];
    
    [self performSelector: NSSelectorFromString(method)];
    
}


@end
