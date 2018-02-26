//
//  ViewController.m
//  CoreData
//
//  Created by CXY on 2017/5/2.
//  Copyright © 2017年 CXY. All rights reserved.
//

#import "ViewController.h"
#import "News+CoreDataClass.h"
#import "CoreDataManager.h"

@interface ViewController ()

@property (nonatomic, strong) CoreDataManager *manager;
@property (nonatomic, strong) NSMutableArray *arr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareData];
    NSArray *ret = [self.manager selectData:10 andOffset:0];
    [self.arr addObjectsFromArray:ret];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSMutableArray *)arr {
    if (!_arr) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}

- (CoreDataManager *)manager {
    if (!_manager) {
        _manager = [[CoreDataManager alloc] init];
    }
    return _manager;
}

- (void)prepareData {
    for (NSInteger i = 0; i < 10; i++) {
        NSString *newsid = [NSString stringWithFormat:@"%ld", i];
        NSString *title = [NSString stringWithFormat:@"title->%@", newsid];
        News *info = [News insertNewObjectInManagedObjectContext:self.manager.context];
        info.newsId = newsid;
        info.title = title;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ReuseId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReuseId];
    }
    News *info = self.arr[indexPath.row];
    cell.textLabel.text = info.title;
    return cell;
}

@end
