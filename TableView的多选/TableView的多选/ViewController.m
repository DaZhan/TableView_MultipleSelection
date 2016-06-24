//
//  ViewController.m
//  TableView的多选
//
//  Created by 大展 on 16/6/24.
//  Copyright © 2016年 大展. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataSource;

@property (nonatomic, strong)UIBarButtonItem *rightItem;

@property (nonatomic, assign)BOOL isEditing; 

@end

@implementation ViewController


- (UIBarButtonItem *)rightItem {


    if (!_rightItem) {

        _rightItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:(UIBarButtonItemStylePlain) target:self action:@selector(itemAction:)];
    }
    return _rightItem;
}


- (NSMutableArray *)dataSource {

    if (!_dataSource) {

        _dataSource = [NSMutableArray array];
        for (int i = 0 ; i < 10; i++) {

            [_dataSource addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return _dataSource;
}

- (UITableView *)tableView {

    if (!_tableView) {

        _tableView = [[UITableView alloc]initWithFrame:self.view.frame];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    self.navigationItem.rightBarButtonItem = self.rightItem;
}


// 右边item的点击事件
- (void)itemAction:(UIBarButtonItem *)sender {


    if (!self.isEditing) {

        // 允许多个编辑
        self.tableView.allowsMultipleSelectionDuringEditing = YES;
        // 允许编辑
        self.tableView.editing = YES;
        [sender setTitle:@"完成"];
    }else {

        [sender setTitle:@"编辑"];

        // 放置要删除的对象
        NSMutableArray *deleteArray = [NSMutableArray array];
        // 要删除的row
        NSArray *selectedArray = [self.tableView indexPathsForSelectedRows];

        for (NSIndexPath *indexPath in selectedArray) {

            [deleteArray addObject:self.dataSource[indexPath.row]];
        }
        // 先删除数据源
        [self.dataSource removeObjectsInArray:deleteArray];
        // 在删除UI
        [self.tableView deleteRowsAtIndexPaths:selectedArray withRowAnimation:UITableViewRowAnimationNone];
        // 关掉编辑
        self.tableView.editing = NO;
    }
    self.isEditing = !self.isEditing;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {

    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    cell.textLabel.text = self.dataSource[indexPath.row];

    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
