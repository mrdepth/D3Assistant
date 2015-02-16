//
//  NSProgress+DA.h
//  D3Assistant
//
//  Created by Artem Shimanski on 18.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSProgress (DA)
+ (instancetype) mainProgress;
+ (instancetype) startProgressWithTotalUnitCount:(int64_t)unitCount;

@end
