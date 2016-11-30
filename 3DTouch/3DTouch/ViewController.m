//
//  ViewController.m
//  3DTouch
//
//  Created by CXY on 16/11/3.
//  Copyright © 2016年 CXY. All rights reserved.
//

#import "ViewController.h"
#import "PreviewViewController.h"

@interface ViewController ()<UIViewControllerPreviewingDelegate>
{}
@property (strong, nonatomic) NSArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        NSMutableArray *tmp = [NSMutableArray new];
        for (NSInteger i = 0; i < 20; i++) {
            [tmp addObject:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:i]]];
        }
        _dataArray = [tmp copy];
    }
    return _dataArray;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ReuseID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReuseID];
        
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        NSLog(@"3D Touch  可用!");
        //给cell注册3DTouch的peek（预览）和pop功能
        [self registerForPreviewingWithDelegate:self sourceView:cell];
    } else {
        NSLog(@"3D Touch 无效");
    }
    return cell;
}


//peek(轻按预览)
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    //获取按压的cell所在行，[previewingContext sourceView]就是按压的那个视图
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell* )[previewingContext sourceView]];
    
    //设定预览的界面
    PreviewViewController *childVC = [PreviewViewController new];
    childVC.preferredContentSize = CGSizeMake(0.0f,500.0f);
    NSString *str = [NSString stringWithFormat:@"我是%@,用力按一下进来", self.dataArray[indexPath.row]];
    childVC.str = str;
    //调整不被虚化的范围，按压的那个cell不被虚化（轻轻按压时周边会被虚化，再少用力展示预览，再加力跳页至设定界面）
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width,40);
    previewingContext.sourceRect = rect;
    
    //返回预览界面
    return childVC;
}

//pop（按用点力进入）
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}





@end
