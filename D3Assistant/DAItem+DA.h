//
//  DAItem+DA.h
//  D3Assistant
//
//  Created by Artem Shimanski on 24.11.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import "DAItem.h"

#define DAItemImageSizeSmall @"small"
#define DAItemImageSizeLarge @"large"

@interface DAItem (DA)

+ (instancetype) itemWithTooltipParams:(NSString*) tooltipParams;
+ (NSURL*) imageURLWithName:(NSString*) name size:(NSString*) size;

- (id) initWithDictionary:(NSDictionary*) dictionary insertIntoManagedObjectContext:(NSManagedObjectContext*) context;

- (NSURL*) imageURLWithSize:(NSString*) size;

@end
