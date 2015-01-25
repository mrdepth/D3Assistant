//
//  DAGear.h
//  D3Assistant
//
//  Created by Artem Shimanski on 25.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DAEquipment, DAItem;

@interface DAGear : NSManagedObject

@property (nonatomic) int16_t slot;
@property (nonatomic, retain) DAEquipment *equipment;
@property (nonatomic, retain) DAItem *item;

@end
