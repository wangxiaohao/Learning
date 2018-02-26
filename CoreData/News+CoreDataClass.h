//
//  News+CoreDataClass.h
//  CoreData
//
//  Created by CXY on 2017/5/10.
//  Copyright © 2017年 CXY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface News : NSManagedObject
+ (instancetype)insertNewObjectInManagedObjectContext:(NSManagedObjectContext *)moc;
@end

NS_ASSUME_NONNULL_END

#import "News+CoreDataProperties.h"
