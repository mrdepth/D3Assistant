//
//  DAStorage.h
//  D3Assistant
//
//  Created by Artem Shimanski on 09.10.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DAProfile.h"
#import "DAHero.h"
#import "DAGear.h"
#import "DAItem.h"
#import "DAItemInfo.h"
#import "DASkills.h"
#import "DAEquipment.h"

#import "DAHero+DA.h"
#import "DAProfile+DA.h"
#import "DAItem+DA.h"
#import "DAGear+DA.h"
#import "DAItemInfo+DA.h"
#import "DAEquipment+DA.h"

#define DAProfileUpdateTimeInterval (60 * 60)
//#define DAProfileUpdateTimeInterval (5)
//#define DAProfileUpdateTimeInterval (60)

@interface DAStorage : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (id) sharedStorage;
- (void) saveContext;

@end
