//
//  DAItemInfo.h
//  D3Assistant
//
//  Created by Artem Shimanski on 25.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DAItem;

@interface DAItemInfo : NSManagedObject

@property (nonatomic) float armor;
@property (nonatomic) float attacksPerSecond;
@property (nonatomic, retain) id attributes;
@property (nonatomic, retain) id attributesRaw;
@property (nonatomic) float blockChance;
@property (nonatomic, retain) NSString * displayColor;
@property (nonatomic) float dps;
@property (nonatomic, retain) NSString * flavorText;
@property (nonatomic, retain) id gems;
@property (nonatomic) int16_t itemLevel;
@property (nonatomic) float maxDamage;
@property (nonatomic) float minDamage;
@property (nonatomic) int16_t requiredLevel;
@property (nonatomic, retain) id set;
@property (nonatomic, retain) id type;
@property (nonatomic, retain) NSString * typeName;
@property (nonatomic, retain) DAItem *item;

@end
