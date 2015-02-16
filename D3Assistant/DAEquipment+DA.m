//
//  DAEquipment+DA.m
//  D3Assistant
//
//  Created by Artem Shimanski on 25.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import "DAEquipment+DA.h"
#import "DAStorage.h"

@implementation DAEquipment (DA)

- (void) updateWithDictionary:(NSDictionary*) dictionary {
	if (dictionary) {
		for (DAGear* gear in self.gear) {
			[gear.managedObjectContext deleteObject:gear];
		}
		
		[self removeGear:self.gear];
		[[DAGear slots] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
			NSDictionary* itemDictionary = dictionary[key];
			if (itemDictionary) {
				NSString* tooltipParams = itemDictionary[@"tooltipParams"];
				if (tooltipParams) {
					DAItem* item = [DAItem itemWithTooltipParams:tooltipParams];
					if (!item) {
						item = [[DAItem alloc] initWithDictionary:itemDictionary insertIntoManagedObjectContext:self.managedObjectContext];
						item.hero = self.hero;
					}
					
					DAGear* gear = [[DAGear alloc] initWithEntity:[NSEntityDescription entityForName:@"Gear" inManagedObjectContext:[[DAStorage sharedStorage] managedObjectContext]] insertIntoManagedObjectContext:self.managedObjectContext];
					gear.item = item;
					gear.equipment = self;
					gear.slot = [obj shortValue];
				}
			}
		}];
	}
}

@end
