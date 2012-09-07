//
//  AttributesDataSource.m
//  D3Assistant
//
//  Created by Artem Shimanski on 07.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "AttributesDataSource.h"
#import "UIColor+NSNumber.h"

@interface AttributesDataSource()
@property (nonatomic, strong) NSMutableArray* sections;

@end

@implementation AttributesDataSource
@synthesize hero;

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

	rows = @[
	@{@"title" : @"Strength", @"stat" : @"strength"},
	@{@"title" : @"Dexterity", @"stat" : @"dexterity"},
	@{@"title" : @"Intelligence", @"stat" : @"intelligence"},
	@{@"title" : @"Vitality", @"stat" : @"vitality"}];

	section = @{@"title" : @"Attributes", @"rows" : rows};
	[self.sections addObject:section];

	rows = @[
	@{@"title" : @"Damage", @"stat" : @"damage"},
	@{@"title" : [NSString stringWithFormat:@"Damage Increased by %@", primaryAttribute], @"stat" : @"damageIncrease"},
	@{@"title" : @"Attacks per Second", @"stat" : @"attackSpeed"},
	@{@"title" : @"Critical Hit Change", @"stat" : @"critChance"},
	@{@"title" : @"Critical Hit Damage", @"stat" : @"critDamage"}];
	
	section = @{@"title" : @"Offense", @"rows" : rows};
	[self.sections addObject:section];
	
	rows = @[
	@{@"title" : @"Armor", @"stat" : @"armor"},
	@{@"title" : @"Block Amount", @"value" : @(([[hero valueForKeyPath:@"stats.blockAmountMax"] floatValue] + [[hero valueForKeyPath:@"stats.blockAmountMin"] floatValue]) / 2.0)},
	@{@"title" : @"Block Chance", @"stat" : @"blockChance"},
	@{@"title" : @"Damage Reduction", @"stat" : @"damageReduction"},
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
	@{@"title" : @"Life Steal", @"stat" : @"lifeSteal"},
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
	@{@"title" : @"Gold Find", @"stat" : @"goldFind"},
	@{@"title" : @"Magic Find", @"stat" : @"magicFind"}];
	
	section = @{@"title" : @"Adventure", @"rows" : rows};
	[self.sections addObject:section];
	
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
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
		cell.textLabel.textColor = [UIColor colorWithNumber:@(0x660000ff)];
		cell.textLabel.font = [cell.textLabel.font fontWithSize:14];
		cell.detailTextLabel.font = [cell.detailTextLabel.font fontWithSize:14];
		cell.detailTextLabel.textColor = [UIColor blackColor];
	}
	NSDictionary* row = [[[self.sections objectAtIndex:indexPath.section] valueForKey:@"rows"] objectAtIndex:indexPath.row];
	cell.textLabel.text = [row valueForKey:@"title"];
	NSNumber* value = [row valueForKey:@"value"];
	if (value)
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", [value floatValue]];
	else
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", [[[hero valueForKey:@"stats"] valueForKey:[row valueForKey:@"stat"]] floatValue]];
	
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

/*- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return nil;
}*/

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
