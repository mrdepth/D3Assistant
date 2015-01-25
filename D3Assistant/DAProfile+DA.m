//
//  DAProfile+DA.m
//  D3Assistant
//
//  Created by Artem Shimanski on 09.11.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import "DAProfile+DA.h"
#import "DAStorage.h"

@implementation DAProfile (DA)

+ (instancetype) profileWithRegion:(NSString*) region battleTag:(NSString*) battleTag {
	NSManagedObjectContext* managedObjectContext = [[DAStorage sharedStorage] managedObjectContext];
	NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Profile"];
	request.predicate = [NSPredicate predicateWithFormat:@"region == %@ AND battleTag LIKE[c] %@", region, battleTag];
	request.fetchLimit = 1;
	return [[managedObjectContext executeFetchRequest:request error:nil] lastObject];
}

- (id) initWithRegion:(NSString*) region dictionary:(NSDictionary*) dictionary insertIntoManagedObjectContext:(NSManagedObjectContext*) context {
	if (self = [super initWithEntity:[NSEntityDescription entityForName:@"Profile" inManagedObjectContext:[[DAStorage sharedStorage] managedObjectContext]] insertIntoManagedObjectContext:context]) {
		self.region = region;
		self.battleTag = dictionary[@"battleTag"];

		[self updateWithDictionary:dictionary];
	}
	return self;
}

- (void) updateWithDictionary:(NSDictionary*) dictionary {
	self.paragonLevel = [dictionary[@"paragonLevel"] shortValue];
	self.paragonLevelHardcore = [dictionary[@"paragonLevelHardcore"] shortValue];
	self.paragonLevelSeason = [dictionary[@"paragonLevelSeason"] shortValue];
	self.paragonLevelSeasonHardcore = [dictionary[@"paragonLevelSeasonHardcore"] shortValue];
	
	NSMutableSet* heroes = [NSMutableSet new];
	NSMutableSet* toDelete = [self.heroes mutableCopy];

	for (NSDictionary* item in dictionary[@"heroes"]) {
		DAHero* hero = [[toDelete filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", item[@"id"]]] anyObject];
		if (!hero) {
			hero = [[DAHero alloc] initWithDictionary:item insertIntoManagedObjectContext:self.managedObjectContext];
			hero.profile = self;
		}
		else {
			[toDelete removeObject:hero];
			[hero updateWithDictionary:item];
		}
		
		if (hero)
			[heroes addObject:hero];
	}
	
	for (DAHero* hero in toDelete) {
		[self.managedObjectContext deleteObject:hero];
	}
	
	self.lastUpdated = [NSDate date];
	self.lastHeroPlayed = [[self.heroes filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", dictionary[@"lastHeroPlayed"]]] anyObject];
}

@end
