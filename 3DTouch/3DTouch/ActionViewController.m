//
//  ActionViewController.m
//  3DTouch
//
//  Created by CXY on 16/11/4.
//  Copyright © 2016年 CXY. All rights reserved.
//

#import "ActionViewController.h"

@interface ActionViewController ()
@property (weak, nonatomic) IBOutlet UILabel *forceLabel;

@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Action1";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//按住移动or压力值改变时的回调
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSArray *arrayTouch = [touches allObjects];
    UITouch *touch = (UITouch *)[arrayTouch lastObject];
    //红色背景的label显示压力值
    _forceLabel.text = [NSString stringWithFormat:@"压力%f",touch.force];
}


@end
