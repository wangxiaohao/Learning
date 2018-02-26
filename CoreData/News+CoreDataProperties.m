//
//  News+CoreDataProperties.m
//  CoreData
//
//  Created by CXY on 2017/5/10.
//  Copyright © 2017年 CXY. All rights reserved.
//

#import "News+CoreDataProperties.h"

@implementation News (CoreDataProperties)

+ (NSFetchRequest<News *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"News"];
}

@dynamic content;
@dynamic imageUrl;
@dynamic newsId;
@dynamic title;

@end
