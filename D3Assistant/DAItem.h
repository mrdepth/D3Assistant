//
//  DAItem.h
//  D3Assistant
//
//  Created by Artem Shimanski on 25.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DAGear, DAHero, DAItemInfo;

@interface DAItem : NSManagedObject

@property (nonatomic) int32_t classMask;
@property (nonatomic, retain) id displayColor;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic) int32_t slotMask;
@property (nonatomic, retain) NSString * tooltipParams;
@property (nonatomic, retain) NSSet *gear;
@property (nonatomic, retain) DAHero *hero;
@property (nonatomic, retain) DAItemInfo *itemInfo;
@end

@interface DAItem (CoreDataGeneratedAccessors)

- (void)addGearObject:(DAGear *)value;
- (void)removeGearObject:(DAGear *)value;
- (void)addGear:(NSSet *)values;
- (void)removeGear:(NSSet *)values;

@end
