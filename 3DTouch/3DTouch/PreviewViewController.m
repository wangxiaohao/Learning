//
//  PreviewViewController.m
//  3DTouch
//
//  Created by CXY on 16/11/3.
//  Copyright © 2016年 CXY. All rights reserved.
//

#import "PreviewViewController.h"
#import "ActionViewController.h"

@interface PreviewViewController ()
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;


@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _msgLabel.text = _str;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setStr:(NSString *)str {
    _str = str;
}

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    // setup a list of preview actions
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"Aciton1" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Aciton1");
        ActionViewController *actionVC = [ActionViewController new];
        [(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController pushViewController:actionVC animated:YES];
    }];
    
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"Aciton2" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Aciton2");
    }];
    
    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"Aciton3" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Aciton3");
    }];
    
    NSArray *actions = @[action1,action2,action3];
    
    // and return them (return the array of actions instead to see all items ungrouped)
    return actions;
}



@end
