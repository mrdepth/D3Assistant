//
//  SkillInfoViewController.m
//  D3Assistant
//
//  Created by Artem Shimanski on 10.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "SkillInfoViewController.h"
#import "ActiveSkillInfoCellView.h"
#import "PassiveSkillInfoCellView.h"
#import "RuneInfoCellView.h"
#import "UITableViewCell+Nib.h"
#import "UIImageView+URL.h"
#import "D3APISession.h"

@interface SkillInfoViewController ()

@end

@implementation SkillInfoViewController
@synthesize skillNameLabel;
@synthesize activeSkill;
@synthesize passiveSkill;
@synthesize runes;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"Skill info";
	if (self.activeSkill)
		self.skillNameLabel.text = [self.activeSkill valueForKey:@"name"];
	else
		self.skillNameLabel.text = [self.passiveSkill valueForKey:@"name"];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
	[self setSkillNameLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return self.runes.count > 0 ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return section == 0 ? 1 : [self.runes count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		BOOL active = self.activeSkill ? YES : NO;
		if (active) {
			static NSString *CellIdentifier = @"ActiveSkillInfoCellView";
			ActiveSkillInfoCellView *cell = (ActiveSkillInfoCellView*) [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (!cell)
				cell = [ActiveSkillInfoCellView cellWithNibName:@"ActiveSkillInfoCellView" bundle:nil reuseIdentifier:CellIdentifier];
			cell.skillDescriptionLabel.text = [self.activeSkill valueForKey:@"description"];
			cell.skillCategoryLabel.text = [[self.activeSkill valueForKey:@"categorySlug"] capitalizedString];
			cell.levelLabel.text = [NSString stringWithFormat:@"%d", [[self.activeSkill valueForKey:@"level"] integerValue]];
			[cell.skillImageView setImageWithContentsOfURL:[[D3APISession sharedSession] skillImageURLWithItem:[self.activeSkill valueForKey:@"icon"] size:@"64"]];
			return cell;
		}
		else {
			static NSString *CellIdentifier = @"PassiveSkillInfoCellView";
			PassiveSkillInfoCellView *cell = (PassiveSkillInfoCellView*) [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (!cell)
				cell = [PassiveSkillInfoCellView cellWithNibName:@"PassiveSkillInfoCellView" bundle:nil reuseIdentifier:CellIdentifier];
			cell.skillDescriptionLabel.text = [self.passiveSkill valueForKey:@"description"];
			cell.levelLabel.text = [NSString stringWithFormat:@"%d", [[self.passiveSkill valueForKey:@"level"] integerValue]];
			[cell.skillImageView setImageWithContentsOfURL:[[D3APISession sharedSession] skillImageURLWithItem:[self.passiveSkill valueForKey:@"icon"] size:@"64"]];
			return cell;
		}
	}
	else {
		static NSString *CellIdentifier = @"RuneInfoCellView";
		RuneInfoCellView *cell = (RuneInfoCellView*) [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (!cell)
			cell = [RuneInfoCellView cellWithNibName:@"RuneInfoCellView" bundle:nil reuseIdentifier:CellIdentifier];
		NSDictionary* rune = [self.runes objectAtIndex:indexPath.row];
		cell.runeNameLabel.text = [[rune valueForKey:@"name"] uppercaseString];
		cell.runeDescriptionLabel.text = [rune valueForKey:@"description"];
		cell.levelLabel.text = [NSString stringWithFormat:@"%d", [[rune valueForKey:@"level"] integerValue]];
		cell.runeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rune%@.png", [[rune valueForKey:@"type"] capitalizedString]]];
		return cell;
	}
}


#pragma mark - Table view delegate

- (CGFloat) tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell* cell = [self tableView:aTableView cellForRowAtIndexPath:indexPath];
	return [cell sizeThatFits:CGSizeMake(cell.frame.size.width, 512)].height;
}

/*- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
 return nil;
 }*/

/*- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
 return 30;
 }*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
