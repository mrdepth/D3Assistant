//
//  DAItemInfo+DA.h
//  D3Assistant
//
//  Created by Artem Shimanski on 26.11.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import "DAItemInfo.h"

@interface DAItemInfo (DA)
- (id) initWithDictionary:(NSDictionary*) dictionary insertIntoManagedObjectContext:(NSManagedObjectContext*) context;
@end
