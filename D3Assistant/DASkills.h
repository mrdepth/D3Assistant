//
//  DASkills.h
//  D3Assistant
//
//  Created by Artem Shimanski on 25.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DAHero;

@interface DASkills : NSManagedObject

@property (nonatomic, retain) id active;
@property (nonatomic, retain) id passive;
@property (nonatomic, retain) DAHero *hero;

@end
