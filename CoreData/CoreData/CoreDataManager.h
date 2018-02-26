//
//  CoreDataManager.h
//  CoreData
//
//  Created by CXY on 2017/5/4.
//  Copyright © 2017年 CXY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject
@property (nonatomic, strong) NSManagedObjectContext *context;
//查询
- (NSArray*)selectData:(int)pageSize andOffset:(int)currentPage;
@end
