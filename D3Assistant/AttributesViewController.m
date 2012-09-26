//
//  AttributesViewController.m
//  D3Assistant
//
//  Created by Artem Shimanski on 18.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "AttributesViewController.h"
#import "UIColor+NSNumber.h"
#import "AttributesHeaderView.h"
#import "UIView+Nib.h"
#import "AttributeCellView.h"
#import "UITableViewCell+Nib.h"
#import "HeroCareerCellView.h"
#import "D3APISession.h"

@interface AttributesViewController ()
@property (nonatomic, strong) NSMutableArray* sections;
@end

@implementation AttributesViewController
@synthesize hero;
@synthesize fallen;

- (void) viewDidLoad {
	[super viewDidLoad];
	self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"attributesBackground.png"]];
	self.tableView.backgroundView.contentMode = UIViewContentModeScaleToFill;
	self.tableView.backgroundView.contentStretch = CGRectMake(0, 0.1, 1, 0.8);
}

- (void) setHero:(NSDictionary *)aHero fallen:(BOOL) isFallen {
	hero = aHero;
	fallen = isFallen;
	
	if (hero) {
		self.sections = [NSMutableArray array];
		NSArray* rows;
		NSDictionary* section;
		
		if (!self.fallen) {
			rows = @[
			@{@"progression" : @(YES)},
			@{@"title" : @"Elite Kills", @"value" : [NSNumberFormatter localizedStringFromNumber:@([[hero valueForKeyPath:@"kills.elites"] integerValue]) numberStyle:NSNumberFormatterDecimalStyle]}];
			
			section = @{@"title" : @"Progression", @"rows" : rows};
			[self.sections addObject:section];
		}
		
		
		NSString* class = [hero valueForKey:@"class"];
		NSDictionary* primaryAttributes = @{@"demon-hunter" : @"Dexterity", @"monk" : @"Dexterity", @"witch-doctor" : @"Intelligence", @"wizard" : @"Intelligence", @"barbarian" : @"Strength"};
		NSString* primaryAttribute = [primaryAttributes valueForKey:class];
		
		rows = @[
		@{@"title" : @"Strength", @"stat" : @"strength"},
		@{@"title" : @"Dexterity", @"stat" : @"dexterity"},
		@{@"title" : @"Intelligence", @"stat" : @"intelligence"},
		@{@"title" : @"Vitality", @"stat" : @"vitality"}];
		
		section = @{@"title" : @"Attributes", @"rows" : rows};
		[self.sections addObject:section];
		
		if (self.fallen) {
			rows = @[
			@{@"title" : @"Damage", @"stat" : @"damage"},
			@{@"title" : [NSString stringWithFormat:@"Damage Increased by %@", primaryAttribute], @"value" : [NSString stringWithFormat:@"%.1f%%", [[self.hero valueForKeyPath:@"stats.damageIncrease"] floatValue] * 100]},
			@{@"title" : @"Critical Hit Change", @"value" : [NSString stringWithFormat:@"%.1f%%", [[self.hero valueForKeyPath:@"stats.critChance"] floatValue] * 100]}];
			
			section = @{@"title" : @"Offense", @"rows" : rows};
			[self.sections addObject:section];
			
			rows = @[
			@{@"title" : @"Armor", @"stat" : @"armor"},
			@{@"title" : @"Damage Reduction", @"value" : [NSString stringWithFormat:@"%.1f%%", [[self.hero valueForKeyPath:@"stats.damageReduction"] floatValue] * 100]},
			@{@"title" : @"Physical Resistance", @"stat" : @"physicalResist"},
			@{@"title" : @"Cold Resistance", @"stat" : @"coldResist"},
			@{@"title" : @"Fire Resistance", @"stat" : @"fireResist"},
			@{@"title" : @"Lightning Resistance", @"stat" : @"lightningResist"},
			@{@"title" : @"Arcane/Holy Resistance", @"stat" : @"arcaneResist"},
			@{@"title" : @"Poison Resistance", @"stat" : @"poisonResist"}];
			
			section = @{@"title" : @"Defense", @"rows" : rows};
			[self.sections addObject:section];
			
			rows = @[
			@{@"title" : @"Maximum Life", @"stat" : @"life"}];
			
			section = @{@"title" : @"Life", @"rows" : rows};
			[self.sections addObject:section];
		}
		else {
			rows = @[
			@{@"title" : @"Damage", @"stat" : @"damage"},
			@{@"title" : [NSString stringWithFormat:@"Damage Increased by %@", primaryAttribute], @"value" : [NSString stringWithFormat:@"%.1f%%", [[self.hero valueForKeyPath:@"stats.damageIncrease"] floatValue] * 100]},
			@{@"title" : @"Attacks per Second", @"stat" : @"attackSpeed"},
			@{@"title" : @"Critical Hit Change", @"value" : [NSString stringWithFormat:@"%.1f%%", [[self.hero valueForKeyPath:@"stats.critChance"] floatValue] * 100]},
			@{@"title" : @"Critical Hit Damage", @"value" : [NSString stringWithFormat:@"%.1f%%", ([[self.hero valueForKeyPath:@"stats.critDamage"] floatValue] - 1) * 100]}];
			
			section = @{@"title" : @"Offense", @"rows" : rows};
			[self.sections addObject:section];
			
			rows = @[
			@{@"title" : @"Armor", @"stat" : @"armor"},
			@{@"title" : @"Block Amount", @"stat" : @"blockAmountMax"},
			@{@"title" : @"Block Chance", @"value" : [NSString stringWithFormat:@"%.1f%%", [[self.hero valueForKeyPath:@"stats.blockChance"] floatValue] * 100]},
			@{@"title" : @"Damage Reduction", @"value" : [NSString stringWithFormat:@"%.1f%%", [[self.hero valueForKeyPath:@"stats.damageReduction"] floatValue] * 100]},
			@{@"title" : @"Physical Resistance", @"stat" : @"physicalResist"},
			@{@"title" : @"Cold Resistance", @"stat" : @"coldResist"},
			@{@"title" : @"Fire Resistance", @"stat" : @"fireResist"},
			@{@"title" : @"Lightning Resistance", @"stat" : @"lightningResist"},
			@{@"title" : @"Arcane/Holy Resistance", @"stat" : @"arcaneResist"},
			@{@"title" : @"Poison Resistance", @"stat" : @"poisonResist"},
			@{@"title" : @"Thorns", @"stat" : @"thorns"}];
			
			section = @{@"title" : @"Defense", @"rows" : rows};
			[self.sections addObject:section];
			
			rows = @[
			@{@"title" : @"Maximum Life", @"stat" : @"life"},
			@{@"title" : @"Life Steal", @"value" : [NSString stringWithFormat:@"%.1f%%", [[self.hero valueForKeyPath:@"stats.lifeSteal"] floatValue] * 100]},
			@{@"title" : @"Life per Kill", @"stat" : @"lifePerKill"},
			@{@"title" : @"Life per Hit", @"stat" : @"lifeOnHit"}];
			
			section = @{@"title" : @"Life", @"rows" : rows};
			[self.sections addObject:section];
			
			
			
			NSDictionary* primaryResources = @{@"demon-hunter" : @"Maximum Hatred", @"monk" : @"Maximum Spirit", @"witch-doctor" : @"Maximum Mana", @"wizard" : @"Maximum Arcane Power", @"barbarian" : @"Maximum Fury"};
			NSDictionary* secondaryResources = @{@"demon-hunter" : @"Maximum Discipline"};
			NSString* primaryResourceName = [primaryResources valueForKey:class];
			NSString* secondaryResourceName = [secondaryResources valueForKey:class];
			
			
			NSDictionary* primaryResource = @{@"title" : primaryResourceName, @"stat" : @"primaryResource"};
			NSDictionary* secondaryResource = secondaryResourceName ? @{@"title" : secondaryResourceName, @"stat" : @"secondaryResource"} : nil;
			
			if (secondaryResource)
				rows = @[primaryResource, secondaryResource];
			else
				rows = @[primaryResource];
			
			section = @{@"title" : @"Resources", @"rows" : rows};
			[self.sections addObject:section];
			
			rows = @[
			@{@"title" : @"Gold Find", @"value" : [NSString stringWithFormat:@"%.1f%%", [[self.hero valueForKeyPath:@"stats.goldFind"] floatValue] * 100]},
			@{@"title" : @"Magic Find", @"value" : [NSString stringWithFormat:@"%.1f%%", [[self.hero valueForKeyPath:@"stats.magicFind"] floatValue] * 100]}];
			
			section = @{@"title" : @"Adventure", @"rows" : rows};
			[self.sections addObject:section];
		}
	}
	else
		self.sections = nil;
	
	[self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[[self.sections objectAtIndex:section] valueForKey:@"rows"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary* row = [[[self.sections objectAtIndex:indexPath.section] valueForKey:@"rows"] objectAtIndex:indexPath.row];
	if ([[row valueForKey:@"progression"] boolValue]) {
		static NSString *CellIdentifier = @"HeroCareerCellView";
		HeroCareerCellView *cell = (HeroCareerCellView*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		BOOL hardcore = [[hero valueForKey:@"hardcore"] boolValue];
		cell.progressionView.hardcore = hardcore;
		
		cell.progressionView.progression = [D3Utility progressionWithProfile:hero hardcore:hardcore];
		return cell;
	}
	else {
		static NSString *CellIdentifier = @"AttributeCellView";
		AttributeCellView *cell = (AttributeCellView*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		cell.titleLabel.text = [row valueForKey:@"title"];
		NSString* value = [row valueForKey:@"value"];
		if (value)
			cell.valueLabel.text = value;
		else
			cell.valueLabel.text = [NSString stringWithFormat:@"%.1f", [[[hero valueForKey:@"stats"] valueForKey:[row valueForKey:@"stat"]] floatValue]];
		
		return cell;
	}
}

#pragma mark - Table view delegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary* row = [[[self.sections objectAtIndex:indexPath.section] valueForKey:@"rows"] objectAtIndex:indexPath.row];
	return [[row valueForKey:@"progression"] boolValue] ? 38 : 28;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	AttributesHeaderView* view = [AttributesHeaderView viewWithNibName:@"AttributesHeaderView" bundle:nil];
	view.titleLabel.text = [self tableView:tableView titleForHeaderInSection:section];
	return view;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [[self.sections objectAtIndex:section] valueForKey:@"title"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
