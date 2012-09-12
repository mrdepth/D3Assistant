//
//  D3Utility.m
//  D3Assistant
//
//  Created by Artem Shimanski on 06.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "D3Utility.h"
#import "UIColor+NSNumber.h"

@implementation D3Utility

+ (float) progressionWithProfile:(NSDictionary*) profile hardcore:(BOOL) hardcore {
	CGFloat progression = 1;
	NSDictionary* mode = [profile valueForKey:hardcore ? @"hardcoreProgression" : @"progression"];
	if (!mode)
		mode = [profile valueForKey:@"progress"];
	
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

+ (UIColor*) itemBorderColorWithColorName:(NSString*) colorName highlighted:(BOOL) highlighted {
	if (highlighted) {
		if ([colorName isEqualToString:@"blue"])
			return [UIColor colorWithNumber:@(ItemBlueBorderHighlightedColor)];
		else if ([colorName isEqualToString:@"brown"])
			return [UIColor colorWithNumber:@(ItemBrownBorderHighlightedColor)];
		else if ([colorName isEqualToString:@"gray"])
			return [UIColor colorWithNumber:@(ItemBrownBorderHighlightedColor)];
		else if ([colorName isEqualToString:@"white"])
			return [UIColor colorWithNumber:@(ItemBrownBorderHighlightedColor)];
		else if ([colorName isEqualToString:@"green"])
			return [UIColor colorWithNumber:@(ItemGreenBorderHighlightedColor)];
		else if ([colorName isEqualToString:@"orange"])
			return [UIColor colorWithNumber:@(ItemOrangeBorderHighlightedColor)];
		else if ([colorName isEqualToString:@"yellow"])
			return [UIColor colorWithNumber:@(ItemYellowBorderHighlightedColor)];
		else
			return [UIColor colorWithNumber:@(ItemBrownBorderHighlightedColor)];
	}
	else {
		if ([colorName isEqualToString:@"blue"])
			return [UIColor colorWithNumber:@(ItemBlueBorderColor)];
		else if ([colorName isEqualToString:@"brown"])
			return [UIColor colorWithNumber:@(ItemBrownBorderColor)];
		else if ([colorName isEqualToString:@"gray"])
			return [UIColor colorWithNumber:@(ItemBrownBorderColor)];
		else if ([colorName isEqualToString:@"white"])
			return [UIColor colorWithNumber:@(ItemBrownBorderColor)];
		else if ([colorName isEqualToString:@"green"])
			return [UIColor colorWithNumber:@(ItemGreenBorderColor)];
		else if ([colorName isEqualToString:@"orange"])
			return [UIColor colorWithNumber:@(ItemOrangeBorderColor)];
		else if ([colorName isEqualToString:@"yellow"])
			return [UIColor colorWithNumber:@(ItemYellowBorderColor)];
		else
			return [UIColor colorWithNumber:@(ItemBrownBorderColor)];
	}
}

+ (UIColor*) colorWithColorName:(NSString*) colorName {
	if ([colorName isEqualToString:@"blue"])
		return [UIColor colorWithNumber:@(0x7171c6ff)];
	else if ([colorName isEqualToString:@"gray"])
		return [UIColor colorWithNumber:@(0x909090ff)];
	else if ([colorName isEqualToString:@"white"])
		return [UIColor colorWithNumber:@(0xe1e1e0ff)];
	else if ([colorName isEqualToString:@"green"])
		return [UIColor colorWithNumber:@(0x748e3dff)];
	else if ([colorName isEqualToString:@"orange"])
		return [UIColor colorWithNumber:@(0xbf642fff)];
	else if ([colorName isEqualToString:@"yellow"])
		return [UIColor colorWithNumber:@(0xf8cc35ff)];
	else
		return [UIColor colorWithNumber:@(0xe1e1e0ff)];
}

@end
