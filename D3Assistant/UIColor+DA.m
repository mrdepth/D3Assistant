//
//  UIColor+DA.m
//  D3Assistant
//
//  Created by Artem Shimanski on 01.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import "UIColor+DA.h"
#import "UIColor+NSNumber.h"

@implementation UIColor (DA)

+ (UIColor*) attributeTextColorWithName:(NSString*) name {
	if ([name isEqualToString:@"blue"])
		return [UIColor colorWithUInteger:0x7979D4FF];
	else if ([name isEqualToString:@"green"])
		return [UIColor colorWithUInteger:0x00FF00FF];
	else if ([name isEqualToString:@"orange"])
		return [UIColor colorWithUInteger:0xBF642FFF];
	else
		return [UIColor lightGrayColor];
		//return [UIColor colorWithUInteger:0x909090FF];
}

+ (UIColor*) attributeValueColorWithName:(NSString*) name {
	if ([name isEqualToString:@"blue"])
		return [UIColor colorWithUInteger:0xBDA6DBFF];
	else if ([name isEqualToString:@"green"])
		return [UIColor whiteColor];
	else
		return [UIColor whiteColor];
}

+ (UIColor*) itemColorWithName:(NSString*) name {
	if ([name isEqualToString:@"green"])
		return [UIColor colorWithUInteger:0x00FF00FF];
	else if ([name isEqualToString:@"orange"])
		return [UIColor colorWithUInteger:0xBF642FFF];
	else if ([name isEqualToString:@"yellow"])
		return [UIColor colorWithUInteger:0xFFFF00FF];
	else if ([name isEqualToString:@"blue"])
		return [UIColor colorWithUInteger:0x7979D4FF];
	else if ([name isEqualToString:@"white"])
		return [UIColor colorWithUInteger:0xFFFFFFFF];
	else
		return [UIColor lightGrayColor];
}

+ (UIColor*) paragonColor {
	return [UIColor colorWithUInteger:0xa791c2ff];
}

@end
