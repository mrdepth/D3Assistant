//
//  D3CEHelper.h
//  D3Assistant
//
//  Created by mr_depth on 29.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "d3ce.h"

@class DAHero;
@class DAItem;
@interface D3CEHelper : NSObject

+ (std::shared_ptr<d3ce::Engine>) sharedEngine;
+ (std::shared_ptr<d3ce::Hero>) addHero:(DAHero*) hero toParty:(std::shared_ptr<d3ce::Party>) party;
+ (std::shared_ptr<d3ce::Gear>) addItem:(DAItem*) item toHero:(std::shared_ptr<d3ce::Hero>) hero slot:(d3ce::Item::Slot) slot replaceExisting:(BOOL) replaceExisting;
//+ (d3ce::Skill*) addSkillFromDictionary:(NSDictionary*) skill toHero:(d3ce::Hero*) hero;
//+ (d3ce::Item::Slot) slotFromString:(NSString*) string;
//+ (NSString*) heroClassNameFromClassMask:(d3ce::ClassMask) classMask;
//+ (NSString*) resourceNameFromResourceID:(d3ce::AttributeSubID) resourceID;
@end
