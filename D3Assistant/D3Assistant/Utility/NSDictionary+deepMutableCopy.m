//
//  NSDictionary+DeepMutableCopy.m
//  D3Assistant
//
//  Created by mr_depth on 06.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "NSDictionary+DeepMutableCopy.h"

@implementation NSDictionary (DeepMutableCopy)

- (id) deepMutableCopy {
	NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
	for (NSObject* key in [self allKeys]) {
		id object = [self objectForKey:key];
		if ([object respondsToSelector:@selector(deepMutableCopy)])
			[dictionary setObject:[object deepMutableCopy] forKey:[key copy]];
		else if ([object respondsToSelector:@selector(copy)])
			[dictionary setObject:[object copy] forKey:[key copy]];
		else
			[dictionary setObject:object forKey:[key copy]];
	}
	return dictionary;
}

@end
