//
//  GearInfoViewController.m
//  D3Assistant
//
//  Created by Artem Shimanski on 07.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "GearInfoViewController.h"
#import "WeaponBaseInfoView.h"
#import "ArmorBaseInfoView.h"
#import "UIView+Nib.h"
#import "D3APISession.h"
#import "GearStatCellView.h"
#import "GemStatCellView.h"
#import "UITableViewCell+Nib.h"
#import "UIImageView+URL.h"
#import "SummaryCellView.h"

#define GEAR_STAT_CELL_HEIGHT 30
#define GEM_STAT_CELL_HEIGHT  30


@interface GearInfoViewController () {
	d3ce::Party* alternateParty;
}

@end

@implementation GearInfoViewController
@synthesize nameFrameImageView;
@synthesize nameLabel;
@synthesize tableView;
@synthesize itemLevelLabel;
@synthesize requiredLevelLabel;
@synthesize gear;
@synthesize slot;
@synthesize party;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc {
	delete alternateParty;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	alternateParty = self.party->clone();
	d3ce::Hero* d3ceHero = alternateParty->getHeroes().front();
	d3ceHero->removeItem(d3ceHero->getItem([D3CEHelper slotFromString:self.slot]));
	
	if ([self.gear valueForKey:@"dps"]) {
		WeaponBaseInfoView* view = [WeaponBaseInfoView viewWithNibName:@"WeaponBaseInfoView" bundle:nil];
		view.weapon = self.gear;
		self.tableView.tableHeaderView = view;
	}
	else {
		NSString* nibName = nil;
		if ([@[@"waist", @"rightFinger", @"leftFinger", @"neck"] containsObject:self.slot])
			nibName = @"ArmorBaseInfoSmallView";
		else
			nibName = @"ArmorBaseInfoView";
		ArmorBaseInfoView* view = [ArmorBaseInfoView viewWithNibName:nibName bundle:nil];
		view.armor = self.gear;
		self.tableView.tableHeaderView = view;
	}
	
	self.title = [self.hero valueForKey:@"name"];
	self.nameLabel.text = [self.gear valueForKey:@"name"];
	NSString* color = [self.gear valueForKey:@"displayColor"];
	self.nameFrameImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"title%@.png", [color capitalizedString]]];
	if (!self.nameFrameImageView.image)
		self.nameFrameImageView.image = [UIImage imageNamed:@"titleBrown.png"];
	self.nameLabel.textColor = [D3Utility colorWithColorName:color];
	
	self.itemLevelLabel.text = [NSString stringWithFormat:@"%d", [[self.gear valueForKey:@"itemLevel"] integerValue]];
	self.requiredLevelLabel.text = [NSString stringWithFormat:@"%d", [[self.gear valueForKey:@"requiredLevel"] integerValue]];
	

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[self.tableView reloadData];
		CGRect r = [self.tableView rectForSection:[self numberOfSectionsInTableView:self.tableView] - 1];
		CGFloat height = self.tableView.frame.origin.y + self.tableView.tableFooterView.frame.size.height + 40;
		height += r.origin.y + r.size.height;
		self.contentSizeForViewInPopover = CGSizeMake(320, height);
	}
}

- (void)viewDidUnload
{
	[self setNameFrameImageView:nil];
	[self setNameLabel:nil];
	[self setTableView:nil];
	[self setItemLevelLabel:nil];
	[self setRequiredLevelLabel:nil];
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
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0) {
		return [[self.gear valueForKey:@"attributes"] count];
	}
	else if (section == 1) {
		return [[self.gear valueForKey:@"gems"] count];
	}
	else
		return 1;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		static NSString *CellIdentifier = @"GearStatCellView";
		GearStatCellView *cell = (GearStatCellView*) [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (!cell)
			cell = [GearStatCellView cellWithNibName:@"GearStatCellView" bundle:nil reuseIdentifier:CellIdentifier];
		cell.statLabel.text = [[self.gear valueForKey:@"attributes"] objectAtIndex:indexPath.row];
		return cell;
	}
	else if (indexPath.section == 1) {
		static NSString *CellIdentifier = @"GemStatCellView";
		GemStatCellView *cell = (GemStatCellView*) [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (!cell)
			cell = [GearStatCellView cellWithNibName:@"GemStatCellView" bundle:nil reuseIdentifier:CellIdentifier];
		NSDictionary* gem = [[self.gear valueForKey:@"gems"] objectAtIndex:indexPath.row];
		cell.statLabel.text = [[gem valueForKey:@"attributes"] objectAtIndex:0];
		[cell.gemImageView setImageWithContentsOfURL:[[D3APISession sharedSession] itemImageURLWithItem:[gem valueForKeyPath:@"item.icon"] size:@"small"]];
		return cell;
	}
	else if (indexPath.section == 2) {
		static NSString *CellIdentifier = @"SummaryCellView";
		SummaryCellView *cell = (SummaryCellView*) [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (!cell)
			cell = [GearStatCellView cellWithNibName:@"SummaryCellView" bundle:nil reuseIdentifier:CellIdentifier];
		
		d3ce::Hero* oldHero = self.party->getHeroes().front();
		d3ce::Hero* newHero = alternateParty->getHeroes().front();
		
		d3ce::Range oldDPS = oldHero->getDPS();
		d3ce::Range newDPS = newHero->getDPS();
		float dpsDif = oldDPS.max - newDPS.max;

		d3ce::Range oldDefnse = oldHero->getAverageDamageReduction();
		d3ce::Range newDefnse = newHero->getAverageDamageReduction();
		float defnseDif = (oldDefnse.max - newDefnse.max) * 100;

		d3ce::Range oldHP = oldHero->getHitPoints();
		d3ce::Range newHP = newHero->getHitPoints();
		float hpDif = oldHP.max - newHP.max;
		
		cell.damageLabel.text = [NSString stringWithFormat:@"%@%.1f", dpsDif >= 0 ? @"+" : @"", dpsDif];
		cell.defenseLabel.text = [NSString stringWithFormat:@"%@%.1f%%", defnseDif >= 0 ? @"+" : @"", defnseDif];
		cell.hitPointsLabel.text = [NSString stringWithFormat:@"%@%.1f", hpDif >= 0 ? @"+" : @"", hpDif];
		
		cell.damageLabel.textColor = dpsDif >= 0 ? [UIColor greenColor] : [UIColor redColor];
		cell.defenseLabel.textColor = defnseDif >= 0 ? [UIColor greenColor] : [UIColor redColor];
		cell.hitPointsLabel.textColor = hpDif >= 0 ? [UIColor greenColor] : [UIColor redColor];
		return cell;
	}
	return nil;
}

#pragma mark - Table view delegate

/*- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
 return nil;
 }*/

/*- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
 return 30;
 }*/

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell* cell = [self tableView:aTableView cellForRowAtIndexPath:indexPath];
	return [cell sizeThatFits:CGSizeMake(self.tableView.frame.size.width, 64)].height;
};

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return nil;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[aTableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
