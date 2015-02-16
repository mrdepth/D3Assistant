//
//  DAProfile.h
//  D3Assistant
//
//  Created by Artem Shimanski on 25.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DAHero;

@interface DAProfile : NSManagedObject

@property (nonatomic, retain) NSString * battleTag;
@property (nonatomic) BOOL favorite;
@property (nonatomic, retain) NSDate* lastSeen;
@property (nonatomic, retain) NSDate* lastUpdated;
@property (nonatomic) int16_t paragonLevel;
@property (nonatomic) int16_t paragonLevelHardcore;
@property (nonatomic) int16_t paragonLevelSeason;
@property (nonatomic) int16_t paragonLevelSeasonHardcore;
@property (nonatomic, retain) NSString * region;
@property (nonatomic, retain) NSSet *heroes;
@property (nonatomic, retain) DAHero *lastHeroPlayed;
@end

@interface DAProfile (CoreDataGeneratedAccessors)

- (void)addHeroesObject:(DAHero *)value;
- (void)removeHeroesObject:(DAHero *)value;
- (void)addHeroes:(NSSet *)values;
- (void)removeHeroes:(NSSet *)values;

@end
