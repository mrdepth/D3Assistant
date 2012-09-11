//
//  AttributesDataSource.m
//  D3Assistant
//
//  Created by Artem Shimanski on 07.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "AttributesDataSource.h"
#import "UIColor+NSNumber.h"
#import "AttributesHeaderView.h"
#import "UIView+Nib.h"
#import "AttributeCellView.h"
#import "UITableViewCell+Nib.h"

@interface AttributesDataSource()
@property (nonatomic, strong) NSMutableArray* sections;

@end

@implementation AttributesDataSource
@synthesize hero;
@synthesize fallen;

- (void) setHero:(NSDictionary *)value {
	NSDictionary* tmp = hero;
	hero = value;
	tmp = nil;
	
	self.sections = [NSMutableArray array];
	NSArray* rows;
	NSDictionary* section;
	
	
	NSString* class = [hero valueForKey:@"class"];
	NSDictionary* primaryAttributes = @{@"demon-hunter" : @"Dexterity", @"monk" : @"Dexterity", @"witch-doctor" : @"Intelligence", @"wizard" : @"Intelligence", @"barbarian" : @"Strength"};
	NSString* primaryAttribute = [primaryAttributes valueForKey:class];
	
	if (self.fallen) {
		rows = @[
		@{@"title" : @"Strength", @"stat" : @"strength"},
		@{@"title" : @"Dexterity", @"stat" : @"dexterity"},
		@{@"title" : @"Intelligence", @"stat" : @"intelligence"},
		@{@"title" : @"Vitality", @"stat" : @"vitality"}];
		
		section = @{@"title" : @"Attributes", @"rows" : rows};
		[self.sections addObject:section];
		
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
		@{@"title" : @"Strength", @"stat" : @"strength"},
		@{@"title" : @"Dexterity", @"stat" : @"dexterity"},
		@{@"title" : @"Intelligence", @"stat" : @"intelligence"},
		@{@"title" : @"Vitality", @"stat" : @"vitality"}];
		
		section = @{@"title" : @"Attributes", @"rows" : rows};
		[self.sections addObject:section];
		
		rows = @[
		@{@"title" : @"Damage", @"stat" : @"damage"},
		@{@"title" : [NSString stringWithFormat:@"Damage Increased by %@", primaryAttribute], @"value" : [NSString stringWithFormat:@"%.1f%%", [[self.hero valueForKeyPath:@"stats.damageIncrease"] floatValue] * 100]},
		@{@"title" : @"Attacks per Second", @"stat" : @"attackSpeed"},
		@{@"title" : @"Critical Hit Change", @"value" : [NSString stringWithFormat:@"%.1f%%", [[self.hero valueForKeyPath:@"stats.critChance"] floatValue] * 100]},
		@{@"title" : @"Critical Hit Damage", @"value" : [NSString stringWithFormat:@"%.1f%%", [[self.hero valueForKeyPath:@"stats.critDamage"] floatValue] * 100]}];
		
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
	static NSString *CellIdentifier = @"AttributeCellView";
	AttributeCellView *cell = (AttributeCellView*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [AttributeCellView cellWithNibName:@"AttributeCellView" bundle:nil reuseIdentifier:CellIdentifier];
	}
	NSDictionary* row = [[[self.sections objectAtIndex:indexPath.section] valueForKey:@"rows"] objectAtIndex:indexPath.row];
	cell.titleLabel.text = [row valueForKey:@"title"];
	NSString* value = [row valueForKey:@"value"];
	if (value)
		cell.valueLabel.text = value;
	else
		cell.valueLabel.text = [NSString stringWithFormat:@"%.1f", [[[hero valueForKey:@"stats"] valueForKey:[row valueForKey:@"stat"]] floatValue]];
	
	return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	AttributesHeaderView* view = [AttributesHeaderView viewWithNibName:@"AttributesHeaderView" bundle:nil];
	view.titleLabel.text = [self tableView:tableView titleForHeaderInSection:section];
	return view;
}

/*- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 30;
}*/

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [[self.sections objectAtIndex:section] valueForKey:@"title"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
