//
//  ViewController.m
//  MultLagTest
//
//  Created by CXY on 2018/2/6.
//  Copyright © 2018年 ubtechinc. All rights reserved.
//

#import "ViewController.h"
#import "JCDataWraper.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray *timeZonesArray;
@property (nonatomic, strong) NSMutableArray *sectionsArray;
@property (nonatomic, strong) UILocalizedIndexedCollation *collation;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureSections];
}

- (void)configureSections {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ML" ofType:@"plist"];
    NSArray *tmp = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *ret = [NSMutableArray array];
    for (NSString *str in tmp) {
        [ret addObject:[[JCDataWraper alloc] initWithString:str]];
    }
    self.timeZonesArray = [ret copy];
    
    // Get the current collation and keep a reference to it.
    self.collation = [UILocalizedIndexedCollation currentCollation];
    
    NSInteger index, sectionTitlesCount = self.collation.sectionTitles.count;
    
    NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    // Set up the sections array: elements are mutable arrays that will contain the time zones for that section.
    for (index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [newSectionsArray addObject:array];
    }
    
    // Segregate the time zones into the appropriate arrays.
    for (JCDataWraper *str in self.timeZonesArray) {
        // Ask the collation which section number the time zone belongs in, based on its locale name.
        NSInteger sectionNumber = [self.collation sectionForObject:str collationStringSelector:@selector(string)];

        
        // Get the array for the section.
        NSMutableArray *sectionTimeZones = newSectionsArray[sectionNumber];
        
        //  Add the time zone to the section.
        [sectionTimeZones addObject:str];
    }
    
    // Now that all the data's in place, each section array needs to be sorted.
    for (index = 0; index < sectionTitlesCount; index++) {
        
        NSMutableArray *timeZonesArrayForSection = newSectionsArray[index];
        
        // If the table view or its contents were editable, you would make a mutable copy here.
        NSArray *sortedTimeZonesArrayForSection = [self.collation sortedArrayFromArray:timeZonesArrayForSection collationStringSelector:@selector(string)];
        
        // Replace the existing array with the sorted array.
        newSectionsArray[index] = sortedTimeZonesArrayForSection;
    }
    
    self.sectionsArray = newSectionsArray;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // The number of sections is the same as the number of titles in the collation.
    return self.collation.sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // The number of time zones in the section is the count of the array associated with the section in the sections array.
    NSArray *timeZonesInSection = self.sectionsArray[section];
    
    return timeZonesInSection.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Get the time zone from the array associated with the section index in the sections array.
    NSArray *timeZonesInSection = self.sectionsArray[indexPath.section];
    
    // Configure the cell with the time zone's name.
    JCDataWraper *timeZone = timeZonesInSection[indexPath.row];
    cell.textLabel.text = timeZone.string;
    
    return cell;
}

/*
 Section-related methods: Retrieve the section titles and section index titles from the collation.
 */

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.collation.sectionTitles[section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.collation.sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.collation sectionForSectionIndexTitleAtIndex:index];
}

@end
