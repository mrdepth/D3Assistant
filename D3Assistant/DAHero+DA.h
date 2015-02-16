//
//  DAHero+DA.h
//  D3Assistant
//
//  Created by Artem Shimanski on 29.10.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import "DAHero.h"

@interface DAHero (DA)

+ (NSInteger) heroClassFromString:(NSString*) string;

- (id) initWithDictionary:(NSDictionary*) dictionary insertIntoManagedObjectContext:(NSManagedObjectContext*) context;
- (void) updateWithDictionary:(NSDictionary*) dictionary;

- (NSURL*) avatarURL;
- (UIImage*) avatar;
- (DAEquipment*) defaultEquipment;
- (DAEquipment*) equipmentWithName:(NSString*) name;

@end
