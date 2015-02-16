//
//  DAHero.h
//  D3Assistant
//
//  Created by Artem Shimanski on 25.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DAEquipment, DAItem, DAProfile, DASkills;

@interface DAHero : NSManagedObject

@property (nonatomic) BOOL dead;
@property (nonatomic) int16_t gender;
@property (nonatomic) BOOL hardcore;
@property (nonatomic, retain) NSString * heroClass;
@property (nonatomic) int32_t identifier;
@property (nonatomic, retain) NSDate* lastSeen;
@property (nonatomic, retain) NSDate* lastUpdated;
@property (nonatomic) int16_t level;
@property (nonatomic, retain) NSString * name;
@property (nonatomic) int16_t paragonLevel;
@property (nonatomic) BOOL seasonal;
@property (nonatomic) int16_t seasonCreated;
@property (nonatomic) BOOL favorite;
@property (nonatomic, retain) NSSet *equipment;
@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) DAProfile *profile;
@property (nonatomic, retain) DASkills *skills;
@end

@interface DAHero (CoreDataGeneratedAccessors)

- (void)addEquipmentObject:(DAEquipment *)value;
- (void)removeEquipmentObject:(DAEquipment *)value;
- (void)addEquipment:(NSSet *)values;
- (void)removeEquipment:(NSSet *)values;

- (void)addItemsObject:(DAItem *)value;
- (void)removeItemsObject:(DAItem *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
