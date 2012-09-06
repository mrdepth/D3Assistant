//
//  ProgressionView.m
//  D3Assistant
//
//  Created by Artem Shimanski on 06.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "ProgressionView.h"

#define capWidth 11


@interface ProgressionView()
@end

@implementation ProgressionView
@synthesize progression;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
		self.clipsToBounds = NO;
    }
    return self;
}

- (void) setProgression:(float)value {
	progression = value;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
	UIImage* leftImage = [UIImage imageNamed:@"progressionLeft.png"];
	UIImage* rightImage = [UIImage imageNamed:@"progressionRight.png"];
	UIImage* progressionNoneImage = [UIImage imageNamed:@"progressionNone.png"];
	UIImage* progressionImage = [UIImage imageNamed:self.hardcore ? @"progressionHC.png" : @"progressionSC.png"];
	UIImage* dotImage = [UIImage imageNamed:self.hardcore ? @"progressionDotHC.png" : @"progressionDotSC.png"];
	UIImage* dotNoneImage = [UIImage imageNamed: @"progressionDotNone.png"];
	UIImage* mark = [UIImage imageNamed:self.hardcore ? @"progressionMarkHC.png" : @"progressionMarkSC.png"];
	
	CGFloat y = self.frame.size.height / 2 - leftImage.size.height / 2;
	[leftImage drawAtPoint:CGPointMake(5, y)];
	
	CGRect frame = CGRectMake(5 + leftImage.size.width, y, (self.frame.size.width - leftImage.size.width - rightImage.size.width - 10) / 16, leftImage.size.height);
	float progress = 0;
	for (NSInteger i = 0; i < 4 * 4; i++) {

		CGRect r = frame;
		r.size.width += 1;
		if (progress >= self.progression)
			[progressionNoneImage drawInRect:r];
		else
			[progressionImage drawInRect:r];
		
		if (i % 4 == 0) {
			if (progress > self.progression)
				[dotNoneImage drawAtPoint:CGPointMake(r.origin.x - dotNoneImage.size.width / 2, r.origin.y + r.size.height / 2 - dotNoneImage.size.height / 2)];
			else
				[dotImage drawAtPoint:CGPointMake(r.origin.x - dotImage.size.width / 2, r.origin.y + r.size.height / 2 - dotImage.size.height / 2)];
		}
		progress += 1.0 / 16.0;
		frame.origin.x += frame.size.width;
	}
	[rightImage drawAtPoint:CGPointMake(self.frame.size.width - rightImage.size.width - 5, y)];
	
	if ((int) self.progression * 4 != self.progression * 4 || self.progression == 1) {
		CGPoint p = CGPointMake((self.frame.size.width - leftImage.size.width - rightImage.size.width - 10) * progression + 5 + leftImage.size.width - mark.size.width / 2,
								self.frame.size.height / 2 - mark.size.height);
		[mark drawAtPoint:p];
	}
}

@end
