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
- (void) reload;
@end

@implementation AttributesViewController
@synthesize hero;
@synthesize d3ceHero;

- (void) viewDidLoad {
	[super viewDidLoad];
	self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"attributesBackground.png"]];
	self.tableView.backgroundView.contentMode = UIViewContentModeScaleToFill;
	self.tableView.backgroundView.contentStretch = CGRectMake(0, 0.1, 1, 0.8);
}

- (void) setD3ceHero:(d3ce::Hero *)value {
	d3ceHero = value;
	[self reload];
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

#pragma mark - Private

- (void) reload {
	if (d3ceHero && hero) {
		self.sections = [NSMutableArray array];
		NSArray* rows;
		NSDictionary* section;
		
		if ([hero valueForKey:@"progress"]) {
			rows = @[
			@{@"progression" : @(YES)},
			@{@"title" : @"Elite Kills", @"value" : [NSNumberFormatter localizedStringFromNumber:@([[hero valueForKeyPath:@"kills.elites"] integerValue]) numberStyle:NSNumberFormatterDecimalStyle]}];
		}
		else
			rows = @[@{@"title" : @"Elite Kills", @"value" : [NSNumberFormatter localizedStringFromNumber:@([[hero valueForKeyPath:@"kills.elites"] integerValue]) numberStyle:NSNumberFormatterDecimalStyle]}];
		
		section = @{@"title" : @"Progression", @"rows" : rows};
		[self.sections addObject:section];
		
		
		rows = @[
		@{@"title" : @"Strength", @"value" : [NSString stringWithFormat:@"%s", d3ceHero->getStrength().toString().c_str()]},
		@{@"title" : @"Dexterity", @"value" : [NSString stringWithFormat:@"%s", d3ceHero->getDexterity().toString().c_str()]},
		@{@"title" : @"Intelligence", @"value" : [NSString stringWithFormat:@"%s", d3ceHero->getIntelligence().toString().c_str()]},
		@{@"title" : @"Vitality", @"value" : [NSString stringWithFormat:@"%s", d3ceHero->getVitality().toString().c_str()]}];
		
		section = @{@"title" : @"Attributes", @"rows" : rows};
		[self.sections addObject:section];
		
		
		rows = @[
		@{@"title" : @"Damage", @"value" : [NSString stringWithFormat:@"%s", d3ceHero->getDPS().toString(1).c_str()]},
		@{@"title" : @"Weapon Damage", @"value" : [NSString stringWithFormat:@"%s-%s", d3ceHero->getMinDamage().toString().c_str(), d3ceHero->getMaxDamage().toString().c_str()]},
		@{@"title" : @"Attacks per Second", @"value" : [NSString stringWithFormat:@"%s", d3ceHero->getAttackSpeed().toString(2).c_str()]},
		@{@"title" : @"Critical Hit Change", @"value" : [NSString stringWithFormat:@"%s%%", (d3ceHero->getCritChance() * 100).toString().c_str()]},
		@{@"title" : @"Critical Hit Damage", @"value" : [NSString stringWithFormat:@"%s%%", (d3ceHero->getCritDamage() * 100).toString().c_str()]}];
		
		section = @{@"title" : @"Offense", @"rows" : rows};
		[self.sections addObject:section];
		
		d3ce::Resistance resistances = d3ceHero->getResistances();
		d3ce::Resistance damageReduction = d3ceHero->getDamageReductionFromResistances();
		rows = @[
		@{@"title" : @"Armor", @"value" : [NSString stringWithFormat:@"%s (%s%%)", d3ceHero->getArmor().toString().c_str(), (d3ceHero->getDamageReductionFromArmor() * 100).toString().c_str()]},
		@{@"title" : @"Block Amount", @"value" : [NSString stringWithFormat:@"%s-%s", d3ceHero->getBlockAmmountMin().toString().c_str(), d3ceHero->getBlockAmmountMax().toString().c_str()]},
		@{@"title" : @"Block Chance", @"value" : [NSString stringWithFormat:@"%s%%", (d3ceHero->getBlockChance() * 100).toString().c_str()]},
		@{@"title" : @"Average Damage Reduction", @"value" : [NSString stringWithFormat:@"%s%%", (d3ceHero->getAverageDamageReduction() * 100).toString(1).c_str()]},
		@{@"title" : @"Physical Resistance", @"value" : [NSString stringWithFormat:@"%s (%s%%)", resistances.physical.toString().c_str(), (damageReduction.physical * 100).toString().c_str()]},
		@{@"title" : @"Cold Resistance", @"value" : [NSString stringWithFormat:@"%s (%s%%)", resistances.cold.toString().c_str(), (damageReduction.cold * 100).toString().c_str()]},
		@{@"title" : @"Fire Resistance", @"value" : [NSString stringWithFormat:@"%s (%s%%)", resistances.fire.toString().c_str(), (damageReduction.fire * 100).toString().c_str()]},
		@{@"title" : @"Lightning Resistance", @"value" : [NSString stringWithFormat:@"%s (%s%%)", resistances.lightning.toString().c_str(), (damageReduction.lightning * 100).toString().c_str()]},
		@{@"title" : @"Arcane/Holy Resistance", @"value" : [NSString stringWithFormat:@"%s (%s%%)", resistances.arcane.toString().c_str(), (damageReduction.arcane * 100).toString().c_str()]},
		@{@"title" : @"Poison Resistance", @"value" : [NSString stringWithFormat:@"%s (%s%%)", resistances.poison.toString().c_str(), (damageReduction.poison * 100).toString().c_str()]}];
		//		@{@"title" : @"Thorns", @"stat" : @"thorns"}];
		
		section = @{@"title" : @"Defense", @"rows" : rows};
		[self.sections addObject:section];
		
		rows = @[
		@{@"title" : @"Maximum Life", @"value" : [NSString stringWithFormat:@"%s", d3ceHero->getHitPoints().toString().c_str()]},
		@{@"title" : @"Life Steal", @"value" : [NSString stringWithFormat:@"%s%%", (d3ceHero->getLifeSteal() * 100).toString().c_str()]},
		@{@"title" : @"Life per Kill", @"value" : [NSString stringWithFormat:@"%s", d3ceHero->getLifePerKill().toString().c_str()]},
		@{@"title" : @"Life per Hit", @"value" : [NSString stringWithFormat:@"%s", d3ceHero->getLifePerHit().toString().c_str()]}];
		
		section = @{@"title" : @"Life", @"rows" : rows};
		[self.sections addObject:section];
		
		d3ce::AttributeSubID resourceTypePrimary = d3ceHero->getResourceTypePrimary();
		d3ce::AttributeSubID resourceTypeSecondary = d3ceHero->getResourceTypeSecondary();
		
		NSString* primaryResourceName = [D3CEHelper resourceNameFromResourceID:resourceTypePrimary];
		d3ce::Range primaryResourceMax = d3ceHero->getPrimaryResourceEffectiveMax();
		d3ce::Range primaryResourceRegen = d3ceHero->getPrimaryResourceRegen();
		NSString* primaryResourceValue = [NSString stringWithFormat:@"%s (%s/s)", primaryResourceMax.toString().c_str(), primaryResourceRegen.toString().c_str()];
		
		
		if (resourceTypeSecondary != d3ce::AttributeNoneSubID) {
			NSString* secondaryResourceName = [D3CEHelper resourceNameFromResourceID:resourceTypeSecondary];
			d3ce::Range secondaryResourceMax = d3ceHero->getSecondaryResourceEffectiveMax();
			d3ce::Range secondaryResourceRegen = d3ceHero->getSecondaryResourceRegen();
			NSString* secondaryResourceValue = [NSString stringWithFormat:@"%s (%s/s)", secondaryResourceMax.toString().c_str(), secondaryResourceRegen.toString().c_str()];
			rows = @[
			@{@"title" : [NSString stringWithFormat:@"%@", primaryResourceName], @"value" : primaryResourceValue},
			@{@"title" : [NSString stringWithFormat:@"%@", secondaryResourceName], @"value" : secondaryResourceValue}];
		}
		else {
			rows = @[@{@"title" : [NSString stringWithFormat:@"%@", primaryResourceName], @"value" : primaryResourceValue}];
		}
		
		section = @{@"title" : @"Resources", @"rows" : rows};
		[self.sections addObject:section];
		
		rows = @[
		@{@"title" : @"Gold Find", @"value" : [NSString stringWithFormat:@"%s%%", (d3ceHero->getGoldFind() * 100).toString().c_str()]},
		@{@"title" : @"Magic Find", @"value" : [NSString stringWithFormat:@"%s%%", (d3ceHero->getMagicFind() * 100).toString().c_str()]}];
		
		section = @{@"title" : @"Adventure", @"rows" : rows};
		[self.sections addObject:section];
	}
	else
		self.sections = nil;
	
	[self.tableView reloadData];
}

@end
