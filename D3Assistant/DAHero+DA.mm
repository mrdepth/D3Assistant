//
//  DAHero+DA.m
//  D3Assistant
//
//  Created by Artem Shimanski on 29.10.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import "DAHero+DA.h"
#import "DAStorage.h"
#import "d3ce.h"

@implementation DAHero (DA)

+ (NSInteger) heroClassFromString:(NSString*) string {
	if ([string isEqualToString:@"wizard"])
		return d3ce::ClassMaskWizard;
	else if ([string isEqualToString:@"monk"])
		return d3ce::ClassMaskMonk;
	else if ([string isEqualToString:@"barbarian"])
		return d3ce::ClassMaskBarbarian;
	else if ([string isEqualToString:@"demon-hunter"])
		return d3ce::ClassMaskDemonHunter;
	else if ([string isEqualToString:@"witch-doctor"])
		return d3ce::ClassMaskWitchDoctor;
	else if ([string isEqualToString:@"crusader"])
		return d3ce::ClassMaskCrusader;
	else
		return d3ce::classMaskUnknown;
}

- (id) initWithDictionary:(NSDictionary*) dictionary insertIntoManagedObjectContext:(NSManagedObjectContext*) context {
	if (self = [super initWithEntity:[NSEntityDescription entityForName:@"Hero" inManagedObjectContext:[[DAStorage sharedStorage] managedObjectContext]] insertIntoManagedObjectContext:context]) {
		[self updateWithDictionary:dictionary];
		
	}
	return self;
}

- (void) updateWithDictionary:(NSDictionary*) dictionary {
	self.identifier = [dictionary[@"id"] intValue];
	self.name = dictionary[@"name"];
	self.level = [dictionary[@"level"] shortValue];
	self.paragonLevel = [dictionary[@"paragonLevel"] shortValue];
	self.heroClass = dictionary[@"class"];
	self.gender = [dictionary[@"gender"] shortValue];
	self.hardcore = [dictionary[@"hardcore"] boolValue];
	self.seasonal = [dictionary[@"seasonal"] boolValue];
	self.dead = [dictionary[@"dead"] boolValue];
	
	id seasonCreated =  dictionary[@"seasonCreated"];
	if (seasonCreated)
		self.seasonCreated = [seasonCreated shortValue];
	NSDictionary* skills = dictionary[@"skills"];
	if (skills) {
		self.skills = [[DASkills alloc] initWithEntity:[NSEntityDescription entityForName:@"Skills" inManagedObjectContext:[[DAStorage sharedStorage] managedObjectContext]] insertIntoManagedObjectContext:self.managedObjectContext];
		NSArray* active = skills[@"active"];
		if ([active isKindOfClass:[NSArray class]])
			self.skills.active = active;
		NSArray* passive = skills[@"passive"];
		if ([passive isKindOfClass:[NSArray class]])
			self.skills.passive = passive;
	}
	
	NSDictionary* items = dictionary[@"items"];
	if (items) {
		[[self defaultEquipment] updateWithDictionary:items];
		self.lastUpdated = [NSDate date];
	}
}

- (NSURL*) avatarURL {
	//return [NSURL URLWithString:[NSString stringWithFormat:@"http://eu.battle.net/d3/static/images/hero/%@/crest.png", self.heroClass]];
	return [NSURL URLWithString:[NSString stringWithFormat:@"http://media.blizzard.com/d3/icons/portraits/100/%@_%@.png", self.heroClass, self.gender ? @"female" : @"male"]];
}

- (UIImage*) avatar {
	UIImage* uiImage = [UIImage imageNamed:@"portraits.jpg"];
	return uiImage;
}

- (DAEquipment*) defaultEquipment {
	DAEquipment* equipment = [self equipmentWithName:@"default"];
	if (!equipment) {
		equipment = [[DAEquipment alloc] initWithEntity:[NSEntityDescription entityForName:@"Equipment" inManagedObjectContext:[[DAStorage sharedStorage] managedObjectContext]] insertIntoManagedObjectContext:self.managedObjectContext];
		equipment.hero = self;
		equipment.name = @"default";
	}
	return equipment;
}

- (DAEquipment*) equipmentWithName:(NSString*) name {
	NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Equipment"];
	request.predicate = [NSPredicate predicateWithFormat:@"hero == %@ AND name == %@", self, name];
	return [[self.managedObjectContext executeFetchRequest:request error:nil] lastObject];
}

@end
