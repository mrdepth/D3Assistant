//
//  NSArray+DeepMutableCopy.m
//  D3Assistant
//
//  Created by mr_depth on 06.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "NSArray+DeepMutableCopy.h"

@implementation NSArray (DeepMutableCopy)

- (id) deepMutableCopy {
	NSMutableArray* array = [[NSMutableArray alloc] init];
	for (id object in self) {
		if ([object respondsToSelector:@selector(deepMutableCopy)])
			[array addObject:[object deepMutableCopy]];
		else if ([object respondsToSelector:@selector(copy)])
			[array addObject:[object copy]];
		else
			[array addObject:object];
	}
	return array;
}

@end
