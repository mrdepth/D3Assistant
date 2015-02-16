//
//  DAGear+DA.h
//  D3Assistant
//
//  Created by Artem Shimanski on 18.12.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import "DAGear.h"

@interface DAGear (DA)

+ (NSInteger) slotFromString:(NSString*) string;
+ (NSString*) stringFromSlot:(NSInteger) slot;
+ (NSDictionary*) slots;
@end
