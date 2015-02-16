//
//  D3CEHelper.m
//  D3Assistant
//
//  Created by mr_depth on 29.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "D3CEHelper.h"
#import "DAStorage.h"

@implementation D3CEHelper

+ (std::shared_ptr<d3ce::Engine>) sharedEngine {
	static std::shared_ptr<d3ce::Engine> engine;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		engine = d3ce::Engine::Create([[[NSBundle mainBundle] pathForResource:@"d3" ofType:@"sqlite"] cStringUsingEncoding:NSUTF8StringEncoding]);
	});
	return engine;
}

+ (std::shared_ptr<d3ce::Hero>) addHero:(DAHero*) hero toParty:(std::shared_ptr<d3ce::Party>) party {
	NSString* className = hero.heroClass;
	std::shared_ptr<d3ce::Hero> pHero = NULL;
	pHero = party->addHero(static_cast<d3ce::ClassMask>([DAHero heroClassFromString:className]));
	if (pHero) {
		pHero->setLevel(hero.level);
		pHero->setParagonLevel(hero.paragonLevel);
	}
	for (DAGear* gear in hero.defaultEquipment.gear)
		[self addItem:gear.item toHero:pHero slot:static_cast<d3ce::Item::Slot>(gear.slot) replaceExisting:false];
	return pHero;
}

+ (std::shared_ptr<d3ce::Gear>) addItem:(DAItem*) item toHero:(std::shared_ptr<d3ce::Hero>) hero slot:(d3ce::Item::Slot) slot replaceExisting:(BOOL) replaceExisting {
	if (!item)
		return nullptr;
	
	try {
		NSString* itemID = item.identifier;
		std::shared_ptr<d3ce::Gear> gear = hero->addItem([itemID cStringUsingEncoding:NSUTF8StringEncoding]);
		gear->setSlot(slot);
		
		NSDictionary* attributes = item.itemInfo.attributesRaw;
		[attributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
			try {
				d3ce::Range value;
				value.min = [obj[@"min"] floatValue];
				value.max = [obj[@"max"] floatValue];
				(*gear)[[key cStringUsingEncoding:NSUTF8StringEncoding]] = value;
				//NSLog(@"%@ %@ %f", item.name, key, value.min);
			}
			catch (std::invalid_argument& exception) {
				//NSLog(@"%@ %@", item.name, key);
			}
		}];
		
		for (NSDictionary* gemDic in item.itemInfo.gems) {
			try {
				auto gem = gear->addGem([gemDic[@"item"][@"id"] cStringUsingEncoding:NSUTF8StringEncoding]);
				[gemDic[@"attributesRaw"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
					d3ce::Range value;
					value.min = [obj[@"min"] floatValue];
					value.max = [obj[@"max"] floatValue];
					(*gem)[[key cStringUsingEncoding:NSUTF8StringEncoding]] = value;
					//NSLog(@"%@ %f", key, value.min);
				}];
			}
			catch(...) {
				
			}
		}
		return gear;
	} catch (d3ce::Hero::SlotIsAlreadyFilledException& exception) {
		if (replaceExisting) {
			hero->removeItem(hero->getItem(exception.slot));
			return [self addItem:item toHero:hero slot:slot replaceExisting:NO];
		}
		else
			return nil;
	}
	catch (...) {
		return nil;
	}

}

/*+ (d3ce::Skill*) addSkillFromDictionary:(NSDictionary*) skill toHero:(d3ce::Hero*) hero {
	NSString* skillName = [skill valueForKeyPath:@"rune.slug"];
	if (!skillName)
		skillName = [skill valueForKeyPath:@"skill.slug"];
	if (skillName)
		return hero->addSkill([skillName cStringUsingEncoding:NSUTF8StringEncoding]);
	else
		return NULL;
}

+ (d3ce::Item::Slot) slotFromString:(NSString*) string {
	if ([string isEqualToString:@"head"])
		return d3ce::Item::SlotHead;
	else if ([string isEqualToString:@"torso"])
		return d3ce::Item::SlotTorso;
	else if ([string isEqualToString:@"feet"])
		return d3ce::Item::SlotFeet;
	else if ([string isEqualToString:@"hands"])
		return d3ce::Item::SlotHands;
	else if ([string isEqualToString:@"shoulders"])
		return d3ce::Item::SlotShoulders;
	else if ([string isEqualToString:@"legs"])
		return d3ce::Item::SlotLegs;
	else if ([string isEqualToString:@"bracers"])
		return d3ce::Item::SlotBracers;
	else if ([string isEqualToString:@"mainHand"])
		return d3ce::Item::SlotMainHand;
	else if ([string isEqualToString:@"offHand"])
		return d3ce::Item::SlotOffHand;
	else if ([string isEqualToString:@"waist"])
		return d3ce::Item::SlotWaist;
	else if ([string isEqualToString:@"rightFinger"])
		return d3ce::Item::SlotRightFinger;
	else if ([string isEqualToString:@"leftFinger"])
		return d3ce::Item::SlotLeftFinger;
	else
		return d3ce::Item::SlotNeck;
}

+ (NSString*) heroClassNameFromClassMask:(d3ce::ClassMask) classMask {
	switch (classMask) {
		case d3ce::ClassMaskBarbarian:
			return @"Barbarian";
		case d3ce::ClassMaskWizard:
			return @"Wizard";
		case d3ce::ClassMaskWitchDoctor:
			return @"Witch Doctor";
		case d3ce::ClassMaskDemonHunter:
			return @"Demon Hunter";
		case d3ce::ClassMaskMonk:
			return @"Monk";
		default:
			break;
	}
	return nil;
}

+ (NSString*) resourceNameFromResourceID:(d3ce::AttributeSubID) resourceID {
	switch (resourceID) {
		case d3ce::AttributeManaSubID:
			return @"Mana";
		case d3ce::AttributeArcanumSubID:
			return @"Arcane Power";
		case d3ce::AttributeFurySubID:
			return @"Fury";
		case d3ce::AttributeSpiritSubID:
			return @"Spirit";
		case d3ce::AttributeHatredSubID:
			return @"Hatred";
		case d3ce::AttributeDisciplineSubID:
			return @"Discipline";
		default:
			break;
	}
	return nil;
}*/

@end
