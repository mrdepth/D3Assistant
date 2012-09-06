//
//  D3Utility.m
//  D3Assistant
//
//  Created by Artem Shimanski on 06.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "D3Utility.h"

@implementation D3Utility

+ (float) progressionWithProfile:(NSDictionary*) profile hardcore:(BOOL) hardcore {
	CGFloat progression = 1;
	NSDictionary* mode = [profile valueForKey:hardcore ? @"hardcoreProgression" : @"progression"];
	
	for (NSString* key in @[@"inferno", @"hell", @"nightmare", @"normal"]) {
		NSDictionary* difficulty = [mode valueForKey:key];

		BOOL finish = NO;
		for (NSString* key in @[@"act4", @"act3", @"act2", @"act1"]) {
			NSDictionary* act = [difficulty valueForKey:key];
			if (![[act valueForKey:@"completed"] boolValue]) {
				progression -= 1 / 16.0;
			}
			else {
				finish = YES;
				break;
			}
		}
		
		if (finish)
			break;
	}
	return progression;
}

@end
