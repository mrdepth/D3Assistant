//
//  D3CEHelper.m
//  D3Assistant
//
//  Created by mr_depth on 29.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "D3CEHelper.h"

@implementation D3CEHelper

+ (d3ce::Engine*) newEgine {
	return new d3ce::Engine([[[NSBundle mainBundle] pathForResource:@"d3" ofType:@"sqlite"] cStringUsingEncoding:NSUTF8StringEncoding]);
}

+ (d3ce::Hero*) addHeroFromDictionary:(NSDictionary*) hero toParty:(d3ce::Party*) party {
	NSString* className = [hero valueForKey:@"class"];
	d3ce::Hero* pHero = NULL;
	if ([className isEqualToString:@"wizard"])
		pHero = party->addHero(d3ce::ClassMaskWizard);
	else if ([className isEqualToString:@"monk"])
		pHero = party->addHero(d3ce::ClassMaskMonk);
	else if ([className isEqualToString:@"barbarian"])
		pHero = party->addHero(d3ce::ClassMaskBarbarian);
	else if ([className isEqualToString:@"demon-hunter"])
		pHero = party->addHero(d3ce::ClassMaskDemonHunter);
	else if ([className isEqualToString:@"witch-doctor"])
		pHero = party->addHero(d3ce::ClassMaskWitchDoctor);
	if (pHero) {
		pHero->setLevel([[hero valueForKey:@"level"] integerValue]);
		pHero->setParagonLevel([[hero valueForKey:@"paragonLevel"] integerValue]);
	}
	return pHero;
}

+ (d3ce::Gear*) addItemFromDictionary:(NSDictionary*) item toHero:(d3ce::Hero*) hero slot:(d3ce::Item::Slot) slot replaceExisting:(BOOL) replaceExisting {
	try {
		NSString* itemID = [item valueForKey:@"id"];
		try {
			d3ce::Gear* gear = hero->addItem([itemID cStringUsingEncoding:NSUTF8StringEncoding]);
			gear->setSlot(slot);
			
			NSDictionary* attributes = [item valueForKey:@"attributesRaw"];
			for (NSString* key in [attributes allKeys]) {
				NSDictionary* attribute = [attributes valueForKey:key];
				d3ce::Range value;
				value.min = [[attribute valueForKey:@"min"] floatValue];
				value.max = [[attribute valueForKey:@"max"] floatValue];
				gear->getAttribute([key cStringUsingEncoding:NSUTF8StringEncoding])->setValue(value);
			}
			
			for (NSDictionary* gem in [item valueForKey:@"gems"]) {
				try {
					gear->addGem([[gem valueForKeyPath:@"item.id"] cStringUsingEncoding:NSUTF8StringEncoding]);
				}
				catch(...) {
					
				}
			}
			return gear;
		}
		catch (...) {
			return NULL;
		}

	} catch (d3ce::Hero::SlotIsAlreadyFilledException& exception) {
		if (replaceExisting) {
			hero->removeItem(hero->getItem(exception.slot));
			return [self addItemFromDictionary:item toHero:hero slot:slot replaceExisting:NO];
		}
		else
			return nil;
	}
}

+ (d3ce::Skill*) addSkillFromDictionary:(NSDictionary*) skill toHero:(d3ce::Hero*) hero {
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
}

@end
