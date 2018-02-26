//
//  News+CoreDataClass.m
//  CoreData
//
//  Created by CXY on 2017/5/10.
//  Copyright © 2017年 CXY. All rights reserved.
//

#import "News+CoreDataClass.h"

@implementation News

+ (NSString *)entityName {
    return @"News";
}

+ (instancetype)insertNewObjectInManagedObjectContext:(NSManagedObjectContext *)moc {
    return [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                         inManagedObjectContext:moc];
}

@end
