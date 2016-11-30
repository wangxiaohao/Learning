//
//  AppDelegate.m
//  3DTouch
//
//  Created by CXY on 16/11/3.
//  Copyright © 2016年 CXY. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //创建应用图标上的3D touch快捷选项
    [self creatShortcutItem];
    return YES;
}

/**
 创建应用图标上的3D touch快捷选项
 */
- (void)creatShortcutItem {
    //创建系统风格的icon
//    UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAdd];
    
    //创建自定义图标的icon
//    UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"分享.png"];
    
    //创建快捷选项
    UIApplicationShortcutItem *shareItem = [[UIApplicationShortcutItem alloc] initWithType:@"com.cxy.-DTouch.share" localizedTitle:@"分享" localizedSubtitle:@"分享联系人信息" icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare] userInfo:nil];
    UIApplicationShortcutItem *searchItem = [[UIApplicationShortcutItem alloc] initWithType:@"com.cxy.-DTouch.search" localizedTitle:@"搜索" localizedSubtitle:@"搜索联系人" icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch] userInfo:nil];
    UIApplicationShortcutItem * addItem = [[UIApplicationShortcutItem alloc] initWithType:@"com.cxy.-DTouch.add" localizedTitle:@"添加" localizedSubtitle:@"添加联系人到通讯录" icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAdd] userInfo:nil];
    
    //添加到快捷选项数组
    [UIApplication sharedApplication].shortcutItems = @[shareItem, searchItem, addItem];
//    UIApplicationShortcutItem *shortcutItem = [launchOptions valueForKey:UIApplicationLaunchOptionsShortcutItemKey];
}


/**
 改变快捷按钮显示文字
 */
- (void)changeShortcutItem {
    //将shortcutItem0的类型由UIApplicationShortcutItem改为可修改类型UIMutableApplicationShortcutItem
    UIApplicationShortcutItem *shortcutItem0 = [[UIApplication sharedApplication].shortcutItems objectAtIndex:0];
    UIMutableApplicationShortcutItem * newShortcutItem0 = [shortcutItem0 mutableCopy];
    //修改shortcutItem的标题
    [newShortcutItem0 setLocalizedTitle:@"按钮1"];
    //将shortcutItems数组改为可变数组
    NSMutableArray *newShortcutItems = [[UIApplication sharedApplication].shortcutItems mutableCopy];
    //替换原ShortcutItem
    [newShortcutItems replaceObjectAtIndex:0 withObject:newShortcutItem0];
    [UIApplication sharedApplication].shortcutItems = newShortcutItems;
}


/**
 如果是从快捷选项标签启动app，则根据不同标识执行不同操作，然后返回NO，防止调用

 @param application       <#application description#>
 @param shortcutItem      <#shortcutItem description#>
 @param completionHandler <#completionHandler description#>
 */
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    if (shortcutItem) {
        //判断先前我们设置的快捷选项标签唯一标识，根据不同标识执行不同操作
        if([shortcutItem.type isEqualToString:@"com.cxy.-DTouch.share"]) {//进入分享界面
            NSArray *arr = @[@"3D Touch 分享"];
            UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:arr applicationActivities:nil];
            [self.window.rootViewController presentViewController:vc animated:YES completion:^{
                
            }];
        } else if ([shortcutItem.type isEqualToString:@"com.cxy.-DTouch.search"]) {//进入搜索界面
//            NSArray *arr = @[@"3D Touch 搜索"];
//            UISearchController *searchVC = [[UISearchController alloc] init];
//            searchVC.title = @"搜索";
//            [(UINavigationController *)self.window.rootViewController pushViewController:searchVC animated:YES];
            UIViewController *vc = [UIViewController new];
//            [vc.view addSubview:searchVC.searchBar];
            [self.window.rootViewController presentViewController:vc animated:YES completion:^{
                
            }];
        } else if ([shortcutItem.type isEqualToString:@"com.cxy.-DTouch.add"]) {//进入分享界面
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *addContactsVC = [storyboard instantiateViewControllerWithIdentifier:@"AddContactsViewController"];
            [(UINavigationController *)self.window.rootViewController pushViewController:addContactsVC animated:YES];
        }
        completionHandler(YES);
    }
    return completionHandler(NO);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
