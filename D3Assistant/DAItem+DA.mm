//
//  DAItem+DA.m
//  D3Assistant
//
//  Created by Artem Shimanski on 24.11.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import "DAItem+DA.h"
#import "DAStorage.h"
#import "D3CEHelper.h"

@implementation DAItem (DA)

+ (instancetype) itemWithTooltipParams:(NSString*) tooltipParams {
	NSManagedObjectContext* managedObjectContext = [[DAStorage sharedStorage] managedObjectContext];
	NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
	request.predicate = [NSPredicate predicateWithFormat:@"tooltipParams == %@", tooltipParams];
	request.fetchLimit = 1;
	return [[managedObjectContext executeFetchRequest:request error:nil] lastObject];
}

+ (NSURL*) imageURLWithName:(NSString*) name size:(NSString*) size {
	return [NSURL URLWithString:[NSString stringWithFormat:@"http://eu.media.blizzard.com/d3/icons/items/%@/%@.png", size, name]];
}

- (id) initWithDictionary:(NSDictionary*) dictionary insertIntoManagedObjectContext:(NSManagedObjectContext*) context {
	if (self = [super initWithEntity:[NSEntityDescription entityForName:@"Item" inManagedObjectContext:[[DAStorage sharedStorage] managedObjectContext]] insertIntoManagedObjectContext:context]) {
		self.identifier = dictionary[@"id"];
		self.name = dictionary[@"name"];
		self.tooltipParams = dictionary[@"tooltipParams"];
		self.icon = dictionary[@"icon"];
		NSDictionary* colors = @{@"green": [UIColor greenColor],
								 @"orange": [UIColor orangeColor],
								 @"yellow": [UIColor yellowColor],
								 @"blue": [UIColor blueColor],
								 @"white": [UIColor whiteColor],
								 @"brown": [UIColor brownColor]};
		self.displayColor = colors[dictionary[@"displayColor"]];
		if (!self.displayColor)
			self.displayColor = [UIColor whiteColor];
		
		try {
			auto engine = [D3CEHelper sharedEngine];
			auto item = d3ce::Item::CreateItem(engine, nullptr, [self.identifier UTF8String]);
			if (item) {
				self.classMask = item->getClassMask();
				self.slotMask = item->possibleSlots();
			}
			else {
				self.classMask = d3ce::ClassMaskAnyClass;
				self.slotMask = d3ce::Item::SlotAny;
			}
		}
		catch(...) {
			self.classMask = d3ce::ClassMaskAnyClass;
			self.slotMask = d3ce::Item::SlotAny;
		}
	}
	return self;
}

- (NSURL*) imageURLWithSize:(NSString*) size {
	//return [NSURL URLWithString:[NSString stringWithFormat:@"http://eu.media.blizzard.com/d3/icons/items/%@/%@.png", size, self.icon]];
	return [DAItem imageURLWithName:self.icon size:size];
}

@end
