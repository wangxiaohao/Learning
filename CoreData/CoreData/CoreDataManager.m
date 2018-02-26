//
//  CoreDataManager.m
//  CoreData
//
//  Created by CXY on 2017/5/4.
//  Copyright © 2017年 CXY. All rights reserved.
//

#import "CoreDataManager.h"


static NSString *const kSQLFileName = @"news.sqlite";
static NSString *const kEntitiesName = @"News";

@interface CoreDataManager ()


@property (nonatomic, strong) NSPersistentStore *persistentStore;
@property (nonatomic, strong) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic, strong) NSManagedObjectModel *momd;

@end

@implementation CoreDataManager

- (NSString *)sqlFilePath {
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, NO) firstObject];
    return [doc stringByAppendingPathComponent:kSQLFileName];
}

- (NSManagedObjectModel *)momd {
    if (!_momd) {
        _momd = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"News" ofType:@"momd"]]];
    }
    return _momd;
}

- (NSPersistentStoreCoordinator *)coordinator {
    if (!_coordinator) {
        _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.momd];
    }
    return _coordinator;
}

- (NSPersistentStore *)persistentStore {
    if (!_persistentStore) {
        _persistentStore = [[NSPersistentStore alloc] initWithPersistentStoreCoordinator:self.coordinator configurationName:nil URL:[NSURL fileURLWithPath:[self sqlFilePath]] options:nil];
    }
    return _persistentStore;
}

- (NSManagedObjectContext *)context {
    if (!_context) {
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _context.persistentStoreCoordinator = self.coordinator;
    }
    return _context;
}

//插入数据
- (void)insertCoreData:(NSMutableArray*)dataArray
{
//    NSManagedObjectContext *context = [self managedObjectContext];
//    for (News *info in dataArray) {
//        News *newsInfo = [NSEntityDescription insertNewObjectForEntityForName:TableName inManagedObjectContext:context];
//        newsInfo.newsid = info.newsid;
//        newsInfo.title = info.title;
//        newsInfo.imgurl = info.imgurl;
//        newsInfo.descr = info.descr;
//        newsInfo.islook = info.islook;
//        
//        NSError *error;
//        if(![context save:&error])
//        {
//            NSLog(@"不能保存：%@",[error localizedDescription]);
//        }
//    }
}

//查询
- (NSArray*)selectData:(int)pageSize andOffset:(int)currentPage
{
    NSManagedObjectContext *context = [self context];
    
    // 限定查询结果的数量
    //setFetchLimit
    // 查询的偏移量
    //setFetchOffset
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setFetchLimit:pageSize];
    [fetchRequest setFetchOffset:currentPage];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:kEntitiesName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}

//删除
-(void)deleteData
{
    NSManagedObjectContext *context = [self context];
    NSEntityDescription *entity = [NSEntityDescription entityForName:kEntitiesName inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && [datas count])
    {
        for (NSManagedObject *obj in datas)
        {
            [context deleteObject:obj];
        }
        if (![context save:&error])
        {
            NSLog(@"error:%@",error);
        }
    }
}
//更新
- (void)updateData:(NSString*)newsId  withIsLook:(NSString*)islook
{
    NSManagedObjectContext *context = [self context];
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"newsid like[cd] %@",newsId];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:kEntitiesName inManagedObjectContext:context]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    //https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Predicates/Articles/pCreating.html
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
//    for (News *info in result) {
//        info.islook = islook;
//    }
    
    //保存
    if ([context save:&error]) {
        //更新成功
        NSLog(@"更新成功");
    }
}
@end
