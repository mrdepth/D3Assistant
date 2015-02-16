//
//  DAGear+DA.m
//  D3Assistant
//
//  Created by Artem Shimanski on 18.12.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import "DAGear+DA.h"
#import "d3ce.h"

@implementation DAGear (DA)

+ (NSInteger) slotFromString:(NSString*) string {
	static NSDictionary* slots = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		slots = [self slots];

	});
	return [slots[string] integerValue];
}

+ (NSString*) stringFromSlot:(NSInteger) slot {
	static NSDictionary* slots = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSMutableDictionary* d = [NSMutableDictionary new];
		[[self slots] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
			d[obj] = key;
		}];
		slots = d;
	});
	return slots[@(slot)];
}

+ (NSDictionary*) slots {
	return @{@"head": @(d3ce::Item::SlotHead),
			 @"torso": @(d3ce::Item::SlotTorso),
			 @"offHand":@(d3ce::Item::SlotOffHand) ,
			 @"mainHand":@(d3ce::Item::SlotMainHand),
			 @"hands":@(d3ce::Item::SlotHands),
			 @"waist":@(d3ce::Item::SlotWaist),
			 @"feet":@(d3ce::Item::SlotFeet),
			 @"shoulders":@(d3ce::Item::SlotShoulders),
			 @"legs":@(d3ce::Item::SlotLegs),
			 @"bracers":@(d3ce::Item::SlotBracers),
			 @"rightFinger":@(d3ce::Item::SlotRightFinger),
			 @"leftFinger":@(d3ce::Item::SlotLeftFinger),
			 @"neck":@(d3ce::Item::SlotNeck)};
}

@end
