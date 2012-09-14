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
	set = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
	if ([s rangeOfString:@"#"].location == NSNotFound) {
		NSInteger length = s.length;
		const char* cString = [s cStringUsingEncoding:NSUTF8StringEncoding];
		for (NSInteger i = length - 1; i >= 0; i--) {
			if (![set characterIsMember:cString[i]]) {
				if (i < length - 1)
					s = [NSString stringWithFormat:@"%@#%@", [s substringToIndex:i + 1], [s substringFromIndex:i + 1]];
				break;
			}
		}
	}
	return s;
}

- (NSString*) validBattleTagURLString {
	return [[[self validBattleTagString] stringByReplacingOccurrencesOfString:@"#" withString:@"-"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
