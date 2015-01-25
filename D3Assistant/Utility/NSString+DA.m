//
//  NSString+DA.m
//  D3Assistant
//
//  Created by Artem Shimanski on 13.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import "NSString+DA.h"

@implementation NSString (DA)

- (void) enumerateNumbersInRange:(NSRange)range usingBlock:(void (^)(NSString* string, NSRange range, BOOL* stop))block {
	
	NSRegularExpression* expression = [NSRegularExpression regularExpressionWithPattern:@"[+–-]?\\d+\\.?\\d*\%?" options:0 error:nil];
	[expression enumerateMatchesInString:self
								 options:0
								   range:range
							  usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
								  block([self substringWithRange:result.range], result.range, stop);
							  }];
}

@end
