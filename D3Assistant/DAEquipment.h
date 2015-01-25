//
//  DAEquipment.h
//  D3Assistant
//
//  Created by Artem Shimanski on 25.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DAGear, DAHero;

@interface DAEquipment : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *gear;
@property (nonatomic, retain) DAHero *hero;
@end

@interface DAEquipment (CoreDataGeneratedAccessors)

- (void)addGearObject:(DAGear *)value;
- (void)removeGearObject:(DAGear *)value;
- (void)addGear:(NSSet *)values;
- (void)removeGear:(NSSet *)values;

@end
