//
//  NSString+D3API.m
//  D3Assistant
//
//  Created by Artem Shimanski on 06.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "NSString+D3API.h"

@implementation NSString (D3API)

- (NSString*) validBattleTagString {
	NSMutableString* s = [NSMutableString stringWithString:self];
	NSCharacterSet* set = [NSCharacterSet characterSetWithCharactersInString:@" _-/\\?.,"];
	NSRange r;
	
	while ((r = [s rangeOfCharacterFromSet:set]).location != NSNotFound) {
		[s replaceCharactersInRange:r withString:@"#"];
	}
	return s;
}

- (NSString*) validBattleTagURLString {
	return [[[self validBattleTagString] stringByReplacingOccurrencesOfString:@"#" withString:@"-"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
