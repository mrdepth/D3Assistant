//
//  DAItemInfo+DA.m
//  D3Assistant
//
//  Created by Artem Shimanski on 26.11.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import "DAItemInfo+DA.h"
#import "DAStorage.h"

@implementation DAItemInfo (DA)

- (id) initWithDictionary:(NSDictionary*) dictionary insertIntoManagedObjectContext:(NSManagedObjectContext*) context {
	if (self = [super initWithEntity:[NSEntityDescription entityForName:@"ItemInfo" inManagedObjectContext:[[DAStorage sharedStorage] managedObjectContext]] insertIntoManagedObjectContext:context]) {
		self.itemLevel = [dictionary[@"itemLevel"] shortValue];
		self.requiredLevel = [dictionary[@"requiredLevel"] shortValue];
		self.attributes = dictionary[@"attributes"];
		self.attributesRaw = dictionary[@"attributesRaw"];
		self.armor = [dictionary[@"armor"][@"min"] floatValue];
		self.dps = [dictionary[@"dps"][@"min"] floatValue];
		self.attacksPerSecond = [dictionary[@"attacksPerSecond"][@"min"] floatValue];
		self.minDamage = [dictionary[@"minDamage"][@"min"] floatValue];
		self.maxDamage = [dictionary[@"maxDamage"][@"min"] floatValue];
		self.blockChance = [dictionary[@"blockChance"][@"min"] floatValue];
		self.typeName = dictionary[@"typeName"];
		self.flavorText = dictionary[@"flavorText"];
		self.gems = dictionary[@"gems"];
		self.type = dictionary[@"type"];
		self.displayColor = dictionary[@"displayColor"];
		self.set = dictionary[@"set"];
	}
	return self;
}

@end
