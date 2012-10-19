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
	float perfection;
	float comparePerfection;
}

- (void) reload;
- (IBAction)onChangeHero:(id)sender;
@end

@implementation GearInfoViewController
@synthesize nameFrameImageView;
@synthesize nameLabel;
@synthesize tableView;
@synthesize itemLevelLabel;
@synthesize requiredLevelLabel;
@synthesize perfectionLabel;
@synthesize gear;
@synthesize compareGear;
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
	d3ce::Gear* item = d3ceHero->getItem([D3CEHelper slotFromString:self.slot]);

	if (item) {
		perfection = item->perfection();
		d3ceHero->removeItem(item);
	}
	else
		perfection = 0;
	
	if (self.compareGear && self.compareHero) {

		item = [D3CEHelper addItemFromDictionary:self.compareGear toHero:d3ceHero slot:[D3CEHelper slotFromString:self.slot] replaceExisting:YES];
		comparePerfection = 0;
		if (item)
			comparePerfection = item->perfection();
		else
			comparePerfection = 0;
			
		

		UISegmentedControl* control = [[UISegmentedControl alloc] initWithItems:@[[self.hero valueForKey:@"name"], [self.compareHero valueForKey:@"name"]]];
		control.segmentedControlStyle = UISegmentedControlStyleBar;
		control.selectedSegmentIndex = self.activeCompareHero ? 1 : 0;
		[control addTarget:self action:@selector(onChangeHero:) forControlEvents:UIControlEventValueChanged];
		self.navigationItem.titleView = control;
	}
	else
		self.title = [self.hero valueForKey:@"name"];
	
	
	[self reload];

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
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
	[self setPerfectionLabel:nil];
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
	if (self.compareGear)
		return self.activeCompareHero ? 3 : 2;
	else
		return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSDictionary* currentGear = self.activeCompareHero ? self.compareGear : self.gear;
	if (section == 0) {
		return [[currentGear valueForKey:@"attributes"] count];
	}
	else if (section == 1) {
		return [[currentGear valueForKey:@"gems"] count];
	}
	else
		return 1;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary* currentGear = self.activeCompareHero ? self.compareGear : self.gear;
	if (indexPath.section == 0) {
		static NSString *CellIdentifier = @"GearStatCellView";
		GearStatCellView *cell = (GearStatCellView*) [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (!cell)
			cell = [GearStatCellView cellWithNibName:@"GearStatCellView" bundle:nil reuseIdentifier:CellIdentifier];
		cell.statLabel.text = [[currentGear valueForKey:@"attributes"] objectAtIndex:indexPath.row];
		return cell;
	}
	else if (indexPath.section == 1) {
		static NSString *CellIdentifier = @"GemStatCellView";
		GemStatCellView *cell = (GemStatCellView*) [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (!cell)
			cell = [GearStatCellView cellWithNibName:@"GemStatCellView" bundle:nil reuseIdentifier:CellIdentifier];
		NSDictionary* gem = [[currentGear valueForKey:@"gems"] objectAtIndex:indexPath.row];
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

		d3ce::Range oldDefense = oldHero->getAverageDamageReduction();
		d3ce::Range newDefense = newHero->getAverageDamageReduction();
		float defenseDif = (oldDefense.max - newDefense.max) * 100;

		d3ce::Range oldHP = oldHero->getHitPoints();
		d3ce::Range newHP = newHero->getHitPoints();
		float hpDif = oldHP.max - newHP.max;
		
		if (compareGear) {
			dpsDif = -dpsDif;
			defenseDif = -defenseDif;
			hpDif = -hpDif;
		}
		
		cell.damageLabel.text = [NSString stringWithFormat:@"%@%.1f", dpsDif >= 0 ? @"+" : @"", dpsDif];
		cell.defenseLabel.text = [NSString stringWithFormat:@"%@%.1f%%", defenseDif >= 0 ? @"+" : @"", defenseDif];
		cell.hitPointsLabel.text = [NSString stringWithFormat:@"%@%.1f", hpDif >= 0 ? @"+" : @"", hpDif];
		
		cell.damageLabel.textColor = dpsDif >= 0 ? [UIColor greenColor] : [UIColor redColor];
		cell.defenseLabel.textColor = defenseDif >= 0 ? [UIColor greenColor] : [UIColor redColor];
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

#pragma mark - Private

- (void) reload {
	NSDictionary* currentGear = self.activeCompareHero ? self.compareGear : self.gear;
	if ([currentGear valueForKey:@"dps"]) {
		WeaponBaseInfoView* view = [WeaponBaseInfoView viewWithNibName:@"WeaponBaseInfoView" bundle:nil];
		view.weapon = currentGear;
		self.tableView.tableHeaderView = view;
	}
	else {
		NSString* nibName = nil;
		if ([@[@"waist", @"rightFinger", @"leftFinger", @"neck"] containsObject:self.slot])
			nibName = @"ArmorBaseInfoSmallView";
		else
			nibName = @"ArmorBaseInfoView";
		ArmorBaseInfoView* view = [ArmorBaseInfoView viewWithNibName:nibName bundle:nil];
		view.armor = currentGear;
		self.tableView.tableHeaderView = view;
	}
	self.nameLabel.text = [currentGear valueForKey:@"name"];

	NSString* color = [currentGear valueForKey:@"displayColor"];
	self.nameFrameImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"title%@.png", [color capitalizedString]]];
	if (!self.nameFrameImageView.image)
		self.nameFrameImageView.image = [UIImage imageNamed:@"titleBrown.png"];
	self.nameLabel.textColor = [D3Utility colorWithColorName:color];
	
	self.itemLevelLabel.text = [NSString stringWithFormat:@"%d", [[currentGear valueForKey:@"itemLevel"] integerValue]];
	self.requiredLevelLabel.text = [NSString stringWithFormat:@"%d", [[currentGear valueForKey:@"requiredLevel"] integerValue]];
	self.perfectionLabel.text = [NSString stringWithFormat:@"%.0f%%", self.activeCompareHero ? comparePerfection * 100 : perfection * 100];
	[self.tableView reloadData];
}

- (IBAction)onChangeHero:(id)sender {
	self.activeCompareHero = [sender selectedSegmentIndex] == 1;
	[self reload];
}

@end
