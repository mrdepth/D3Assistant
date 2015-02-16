//
//  DAActiveSkillInfoViewController.m
//  D3Assistant
//
//  Created by Artem Shimanski on 13.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import "DAActiveSkillInfoViewController.h"
#import "UIImageView+URL.h"
#import "D3APISession.h"
#import "NSString+DA.h"

@interface DAActiveSkillInfoViewController ()

@end

@implementation DAActiveSkillInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.skillNameLabel.text = self.skill[@"skill"][@"name"];
	[self.skillImageView setImageWithContentsOfURL:[[D3APISession sharedSession] skillImageURLWithItem:self.skill[@"skill"][@"icon"] size:@"42"]];
	self.skillCategoryLabel.text = [self.skill[@"skill"][@"categorySlug"] capitalizedString];
	
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
	
	NSDictionary* rune = self.skill[@"rune"];
	if (rune) {
		self.runeNameLabel.text = rune[@"name"];
		self.runeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rune%@.png", [rune[@"type"] capitalizedString]]];
		
		s = [[NSMutableAttributedString alloc] initWithString:rune[@"description"] attributes:nil];
		[s.string enumerateNumbersInRange:NSMakeRange(0, s.string.length)
							   usingBlock:^(NSString *string, NSRange range, BOOL *stop) {
								   [s addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range];
							   }];
		self.runeDescriptionLabel.attributedText = s;
		
		s = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:NSLocalizedString(@"Unlocked at level %ld", nil), (long) [rune[@"level"] integerValue]] attributes:nil];
		[s.string enumerateNumbersInRange:NSMakeRange(0, s.string.length)
							   usingBlock:^(NSString *string, NSRange range, BOOL *stop) {
								   [s addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range];
							   }];
		self.runeLevelLabel.attributedText = s;

	}
	else {
		self.runeNameLabel.text = nil;
		self.runeDescriptionLabel.text = nil;
		self.runeImageView.image = nil;
		self.runeLevelLabel.text = nil;
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
