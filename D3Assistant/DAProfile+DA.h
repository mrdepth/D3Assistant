//
//  DAProfile+DA.h
//  D3Assistant
//
//  Created by Artem Shimanski on 09.11.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import "DAProfile.h"

@interface DAProfile (DA)

+ (instancetype) profileWithRegion:(NSString*) region battleTag:(NSString*) battleTag;
- (id) initWithRegion:(NSString*) region dictionary:(NSDictionary*) dictionary insertIntoManagedObjectContext:(NSManagedObjectContext*) context;
- (void) updateWithDictionary:(NSDictionary*) dictionary;

@end
