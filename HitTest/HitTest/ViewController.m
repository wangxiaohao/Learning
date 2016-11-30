//
//  ViewController.m
//  HitTest
//
//  Created by CXY on 16/11/16.
//  Copyright © 2016年 CXY. All rights reserved.
//

#import "ViewController.h"
#import "JCTestView.h"
#import "UIView+JCKit.h"
#import "JCButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    JCTestView *view = [[JCTestView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    view.backgroundColor = [UIColor greenColor];
    [self.view addSubview:view];
//    view.hitTestBlock = ^UIView *(CGPoint point, UIEvent *event, BOOL *returnSuper) {
//        return nil;
//    };
    
    JCButton *button = [[JCButton alloc] initWithFrame:CGRectMake(110, 110, 80, 80)];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(sayHi) forControlEvents:UIControlEventTouchUpInside];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)sayHi {
    NSLog(@"-----click me-----");
}

//output:
//2016-11-17 16:29:42.875 HitTest[12596:1437910] UIWindow:[hitTest:withEvent:]
//2016-11-17 16:29:42.875 HitTest[12596:1437910] ----UIView:[hitTest:withEvent:]
//2016-11-17 16:29:42.875 HitTest[12596:1437910] --------JCTestView:[hitTest:withEvent:]




@end
