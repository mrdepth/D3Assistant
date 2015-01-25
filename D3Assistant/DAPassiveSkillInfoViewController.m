//
//  DAPassiveSkillInfoViewController.m
//  D3Assistant
//
//  Created by Artem Shimanski on 13.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import "DAPassiveSkillInfoViewController.h"
#import "UIImageView+URL.h"
#import "D3APISession.h"
#import "NSString+DA.h"

@implementation DAPassiveSkillInfoViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.skillNameLabel.text = self.skill[@"skill"][@"name"];
	[self.skillImageView setImageWithContentsOfURL:[[D3APISession sharedSession] skillImageURLWithItem:self.skill[@"skill"][@"icon"] size:@"42"]];
	
	NSMutableAttributedString* s = [[NSMutableAttributedString alloc] initWithString:self.skill[@"skill"][@"description"] attributes:nil];
	[s.string enumerateNumbersInRange:NSMakeRange(0, s.string.length)
									usingBlock:^(NSString *string, NSRange range, BOOL *stop) {
										[s addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range];
									}];
	self.skillDescriptionLabel.attributedText = s;
	
	s = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:NSLocalizedString(@"Unlocked at level %ld", nil), (long) [self.skill[@"skill"][@"level"] integerValue]] attributes:nil];
	[s.string enumerateNumbersInRange:NSMakeRange(0, s.string.length)
									usingBlock:^(NSString *string, NSRange range, BOOL *stop) {
										[s addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range];
									}];
	self.skillLevelLabel.attributedText = s;
}


@end
