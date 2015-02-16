//
//  DAHeroStatsViewController.m
//  D3Assistant
//
//  Created by Artem Shimanski on 03.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import "DAHeroStatsViewController.h"
#import "DAHeroStatsCell.h"
#import "DAItemInfoHeaderView.h"

@interface DAHeroStatsViewController ()
@property (nonatomic, strong) NSArray* sections;
- (void) reload;
@end

@implementation DAHeroStatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.tableView registerNib:[UINib nibWithNibName:@"DAItemInfoHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"Header"];
	if (self.hero)
		[self reload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) setHero:(std::shared_ptr<d3ce::Hero>)hero {
	_hero = hero;
	if ([self isViewLoaded]) {
		[self reload];
	}
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sections[section][@"rows"] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary* row = self.sections[indexPath.section][@"rows"][indexPath.row];
    DAHeroStatsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	cell.backgroundColor = [UIColor clearColor];
	cell.titleLabel.text = row[@"title"];
	cell.valueLabel.text = row[@"value"];
    return cell;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return self.sections[section][@"title"];
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	NSString* title = [self tableView:tableView titleForHeaderInSection:section];
	if (title) {
		DAItemInfoHeaderView* header =  [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
		header.titleLabel.text = title;
		return header;
	}
	else
		return nil;
	
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Private

- (void) reload {
	if (!_hero) {
		self.sections = nil;
		[self.tableView reloadData];
		return;
	}
	
	NSMutableArray* sections = [NSMutableArray new];
	
	NSNumberFormatter* integerFormatter = [NSNumberFormatter new];
	integerFormatter = [[NSNumberFormatter alloc] init];
	[integerFormatter setPositiveFormat:@"#,##0"];
	[integerFormatter setGroupingSeparator:@" "];

	NSNumberFormatter* float1Formatter = [NSNumberFormatter new];
	float1Formatter = [[NSNumberFormatter alloc] init];
	[float1Formatter setPositiveFormat:@"#,##0.#"];
	[float1Formatter setGroupingSeparator:@" "];

	NSNumberFormatter* float2Formatter = [NSNumberFormatter new];
	float2Formatter = [[NSNumberFormatter alloc] init];
	[float2Formatter setPositiveFormat:@"#,##0.##"];
	[float2Formatter setGroupingSeparator:@" "];

	NSString* (^toString)(d3ce::Range) = ^(d3ce::Range range) {
		if (range.min == trunc(range.min))
			return [integerFormatter stringFromNumber:@(range.min)];
		
		if (fabs(range.min) < 10)
			return [float2Formatter stringFromNumber:@(range.min)];
		else if (fabs(range.min) < 100)
			return [float1Formatter stringFromNumber:@(range.min)];
		else
			return [integerFormatter stringFromNumber:@(range.min)];
	};
	
	//Basic
	[sections addObject:@{@"title": NSLocalizedString(@"Basic", nil),
						  @"rows":@[
								  @{@"title": NSLocalizedString(@"Damage", nil),
									@"value": toString(_hero->getDPS())},
								  @{@"title": NSLocalizedString(@"Elemental Damage", nil),
									@"value": toString(_hero->getElementalDPS())},
								  @{@"title": NSLocalizedString(@"Elemental Elite Damage", nil),
									@"value": toString(_hero->getEliteElementalDPS())},
								  @{@"title": NSLocalizedString(@"Toughness", nil),
									@"value": toString(_hero->getToughness())},
								  @{@"title": NSLocalizedString(@"Recovery", nil),
									@"value": toString(_hero->getRecovery())}
								  ]}];

	
	//Attributes
	[sections addObject:@{@"title": NSLocalizedString(@"Attributes", nil),
						  @"rows":@[
								  @{@"title": NSLocalizedString(@"Strength", nil),
									@"value": toString(_hero->getStrength())},
								  @{@"title": NSLocalizedString(@"Dexterity", nil),
									@"value": toString(_hero->getDexterity())},
								  @{@"title": NSLocalizedString(@"Intelligence", nil),
									@"value": toString(_hero->getIntelligence())},
								  @{@"title": NSLocalizedString(@"Vitality", nil),
									@"value": toString(_hero->getVitality())}
								  ]}];
	
	//Offense
	NSMutableArray* rows = [NSMutableArray new];
	NSString* damageAttribute = nil;
	switch (_hero->getPrimaryDamageAttribute()) {
		case d3ce::PrimaryDamageAttributeDexterity:
			damageAttribute = NSLocalizedString(@"Dex", nil);
			break;
		case d3ce::PrimaryDamageAttributeIntelligence:
			damageAttribute = NSLocalizedString(@"Int", nil);
			break;
		case d3ce::PrimaryDamageAttributeStrength:
			damageAttribute = NSLocalizedString(@"Str", nil);
			break;
		default:
			break;
	}
	[rows addObject:@{@"title": [NSString stringWithFormat:NSLocalizedString(@"Damage Increased by %@", nil), damageAttribute],
					  @"value": [toString(_hero->getDamageBonusFromPrimaryDamageAttribute() * 100) stringByAppendingString:@"%"]}];
	
	[rows addObject:@{@"title": NSLocalizedString(@"Bonus Damage to Elites", nil),
					  @"value": [toString(_hero->getDamageBonusVsElites() * 100) stringByAppendingString:@"%"]}];
	[rows addObject:@{@"title": NSLocalizedString(@"Attacks per Second", nil),
					  @"value": toString(_hero->getAttackSpeed())}];
	[rows addObject:@{@"title": NSLocalizedString(@"Attack Speed Increase", nil),
					  @"value": [toString(_hero->getAttackSpeedBonus() * 100) stringByAppendingString:@"%"]}];
	[rows addObject:@{@"title": NSLocalizedString(@"Critical Hit Chance", nil),
					  @"value": [toString(_hero->getCritChance() * 100) stringByAppendingString:@"%"]}];
	[rows addObject:@{@"title": NSLocalizedString(@"Critical Hit Damage", nil),
					  @"value": [NSString stringWithFormat:@"+%@%%", toString(_hero->getCritDamage() * 100)]}];
	[rows addObject:@{@"title": NSLocalizedString(@"Area Damage", nil),
					  @"value": [toString(_hero->getSplashDamage() * 100) stringByAppendingString:@"%"]}];
	[rows addObject:@{@"title": NSLocalizedString(@"Cooldown Reduction", nil),
					  @"value": [toString(_hero->getPowerCooldownReduction() * 100) stringByAppendingString:@"%"]}];
	
	NSArray* damageTypes = @[@{@"type":@(d3ce::AttributePhysicalSubID), @"name": NSLocalizedString(@"Physical", nil)},
							 @{@"type":@(d3ce::AttributeFireSubID), @"name": NSLocalizedString(@"Fire", nil)},
							 @{@"type":@(d3ce::AttributeLightningSubID), @"name": NSLocalizedString(@"Lightning", nil)},
							 @{@"type":@(d3ce::AttributeColdSubID), @"name": NSLocalizedString(@"Cold", nil)},
							 @{@"type":@(d3ce::AttributePoisonSubID), @"name": NSLocalizedString(@"Poison", nil)},
							 @{@"type":@(d3ce::AttributeArcaneSubID), @"name": NSLocalizedString(@"Arcane", nil)},
							 @{@"type":@(d3ce::AttributeHolySubID), @"name": NSLocalizedString(@"Holy", nil)}];
	
	for (NSDictionary* damage in damageTypes) {
		auto value = (*_hero)[d3ce::AttributeDamageDealtPercentBonusID][static_cast<d3ce::AttributeSubID>([damage[@"type"] intValue])];
		if (value > 0) {
			[rows addObject:@{@"title": [NSString stringWithFormat:NSLocalizedString(@"%@ Damage Increase", nil), damage[@"name"]],
							  @"value": [toString(value * 100) stringByAppendingString:@"%"]}];
		}
	}
	
	NSString* classPrefix = nil;
	switch (_hero->getClass()) {
		case d3ce::ClassMaskBarbarian:
			classPrefix = @"Barbarian";
			break;
		case d3ce::ClassMaskCrusader:
			classPrefix = @"Crusader";
			break;
		case d3ce::ClassMaskDemonHunter:
			classPrefix = @"DemonHunter";
			break;
		case d3ce::ClassMaskMonk:
			classPrefix = @"Monk";
			break;
		case d3ce::ClassMaskWitchDoctor:
			classPrefix = @"WitchDoctor";
			break;
		case d3ce::ClassMaskWizard:
			classPrefix = @"Wizard";
			break;
		default:
			break;
	}
	if (classPrefix) {
		NSString* sql = [NSString stringWithFormat:@"SELECT stringHash, description1 FROM string WHERE nonNlsKey LIKE \"%@\\_%%\\_name\" ESCAPE '\\'", classPrefix];
		_hero->getEngine()->exec([sql cStringUsingEncoding:NSUTF8StringEncoding], [&](sqlite3_stmt* stmt) -> bool {
			auto value = (*_hero)[d3ce::AttributePowerDamagePercentBonusID][static_cast<d3ce::AttributeSubID>(sqlite3_column_int(stmt, 0))];
			if (value > 0) {
				const unsigned char* name = sqlite3_column_text(stmt, 1);
				[rows addObject:@{@"title": [NSString stringWithFormat:NSLocalizedString(@"%s Damage Increase", nil), name],
								  @"value": [toString(value * 100) stringByAppendingString:@"%"]}];
			}
			return true;
		});
	}
	
	[sections addObject:@{@"title": NSLocalizedString(@"Offense", nil), @"rows":rows}];
	
	//Defense
	auto resistances = _hero->getResistances();
	[sections addObject:@{@"title": NSLocalizedString(@"Defense", nil), @"rows":@[
								  @{@"title": NSLocalizedString(@"Armor", nil),
									@"value": toString(_hero->getArmor())},
								  @{@"title": NSLocalizedString(@"Block Ammount", nil),
									@"value": [NSString stringWithFormat:@"%@-%@", toString(_hero->getBlockAmmountMin()), toString(_hero->getBlockAmmountMax())]},
								  @{@"title": NSLocalizedString(@"Block Chance", nil),
									@"value": [toString(_hero->getBlockChance() * 100) stringByAppendingString:@"%"]},
								  @{@"title": NSLocalizedString(@"Dodge Chance", nil),
									@"value": [toString(_hero->getDodgeChance() * 100) stringByAppendingString:@"%"]},
								  @{@"title": NSLocalizedString(@"Physical Resistance", nil),
									@"value": toString(resistances.physical)},
								  @{@"title": NSLocalizedString(@"Cold Resistance", nil),
									@"value": toString(resistances.cold)},
								  @{@"title": NSLocalizedString(@"Fire Resistance", nil),
									@"value": toString(resistances.fire)},
								  @{@"title": NSLocalizedString(@"Lightning Resistance", nil),
									@"value": toString(resistances.lightning)},
								  @{@"title": NSLocalizedString(@"Poison Resistance", nil),
									@"value": toString(resistances.poison)},
								  @{@"title": NSLocalizedString(@"Arcane/Holy Resistance", nil),
									@"value": toString(resistances.arcane)},
								  @{@"title": NSLocalizedString(@"Crowd Control Reduction", nil),
									@"value": [toString(_hero->getCrowdControlReduction() * 100) stringByAppendingString:@"%"]},
								  @{@"title": NSLocalizedString(@"Missile Damage Reduction", nil),
									@"value": [toString(_hero->getDamageReductionFromRanged() * 100) stringByAppendingString:@"%"]},
								  @{@"title": NSLocalizedString(@"Melee Damage Reduction", nil),
									@"value": [toString(_hero->getDamageReductionFromMelee() * 100) stringByAppendingString:@"%"]},
								  @{@"title": NSLocalizedString(@"Elite Damage Reduction", nil),
									@"value": [toString(_hero->getDamageReductionFromElites() * 100) stringByAppendingString:@"%"]},
								  @{@"title": NSLocalizedString(@"Thorns", nil),
									@"value": toString(_hero->getThorns())}
								  ]}];
	
	//Life
	[sections addObject:@{@"title": NSLocalizedString(@"Life", nil), @"rows":@[
								  @{@"title": NSLocalizedString(@"Maximum Life", nil),
									@"value": toString(_hero->getHitPoints())},
								  @{@"title": NSLocalizedString(@"Total Life Bonus", nil),
									@"value": [toString(_hero->getLifeBonus() * 100) stringByAppendingString:@"%"]},
								  @{@"title": NSLocalizedString(@"Life per Second", nil),
									@"value": toString(_hero->getLifeRegen())},
								  @{@"title": NSLocalizedString(@"Life per Hit", nil),
									@"value": toString(_hero->getLifePerHit())},
								  @{@"title": NSLocalizedString(@"Life per Kill", nil),
									@"value": toString(_hero->getLifePerKill())},
								  @{@"title": NSLocalizedString(@"Health Globe Healing Bonus", nil),
									@"value": toString(_hero->getHealthGlobeBonus())},
								  @{@"title": NSLocalizedString(@"Bonus to Gold/Globe Radius", nil),
									@"value": toString(_hero->getGoldPickUpRadius())}
								  ]}];

	//Resource
	rows = [NSMutableArray new];
	NSString* (^resourceName)(d3ce::AttributeSubID) = ^(d3ce::AttributeSubID resourceType) {
		switch (resourceType) {
			case d3ce::AttributeManaSubID:
				return NSLocalizedString(@"Mana", nil);
			case d3ce::AttributeArcanumSubID:
				return NSLocalizedString(@"Arcane Power", nil);
			case d3ce::AttributeFurySubID:
				return NSLocalizedString(@"Fury", nil);
			case d3ce::AttributeSpiritSubID:
				return NSLocalizedString(@"Spirit", nil);
			case d3ce::AttributeHatredSubID:
				return NSLocalizedString(@"Hatred", nil);
			case d3ce::AttributeDisciplineSubID:
				return NSLocalizedString(@"Discipline", nil);
			case d3ce::AttributeFaithSubID:
				return NSLocalizedString(@"Wrath", nil);
		break;
			default:
				return @"";
		}
	};
	
	if (_hero->getResourceTypePrimary() != d3ce::AttributeNoneSubID) {
		NSString* name = resourceName(_hero->getResourceTypePrimary());
		[rows addObject:@{@"title": [NSString stringWithFormat:NSLocalizedString(@"Maximum %@", nil), name],
						  @"value": toString(_hero->getPrimaryResourceMax())}];
		[rows addObject:@{@"title": [NSString stringWithFormat:NSLocalizedString(@"%@ Regeneration", nil), name],
						  @"value": toString(_hero->getPrimaryResourceRegen())}];
		[rows addObject:@{@"title": [NSString stringWithFormat:NSLocalizedString(@"%@ Cost Reduction", nil), name],
						  @"value": [toString(_hero->getPrimaryResourceCostReduction() * 100) stringByAppendingString:@"%"]}];
		[rows addObject:@{@"title": [NSString stringWithFormat:NSLocalizedString(@"%@ on Crit", nil), name],
						  @"value": toString(_hero->getPrimaryResourceOnCrit())}];
	}

	if (_hero->getResourceTypeSecondary() != d3ce::AttributeNoneSubID) {
		NSString* name = resourceName(_hero->getResourceTypeSecondary());
		[rows addObject:@{@"title": [NSString stringWithFormat:NSLocalizedString(@"Maximum %@", nil), name],
						  @"value": toString(_hero->getSecondaryResourceMax())}];
		[rows addObject:@{@"title": [NSString stringWithFormat:NSLocalizedString(@"%@ Regeneration", nil), name],
						  @"value": toString(_hero->getSecondaryResourceRegen())}];
		[rows addObject:@{@"title": [NSString stringWithFormat:NSLocalizedString(@"%@ Cost Reduction", nil), name],
						  @"value": [toString(_hero->getSecondaryResourceCostReduction() * 100) stringByAppendingString:@"%"]}];
		[rows addObject:@{@"title": [NSString stringWithFormat:NSLocalizedString(@"%@ on Crit", nil), name],
						  @"value": toString(_hero->getSecondaryResourceOnCrit())}];
	}

	[sections addObject:@{@"title": NSLocalizedString(@"Resource", nil), @"rows":rows}];

	//Adventure
	[sections addObject:@{@"title": NSLocalizedString(@"Adventure", nil), @"rows":@[
								  @{@"title": NSLocalizedString(@"Movement Speed", nil),
									@"value": [toString(_hero->getMovementBonus() * 100) stringByAppendingString:@"%"]},
								  @{@"title": NSLocalizedString(@"Gold Find", nil),
									@"value": [toString(_hero->getGoldFind() * 100) stringByAppendingString:@"%"]},
								  @{@"title": NSLocalizedString(@"Magic Find", nil),
									@"value": [toString(_hero->getMagicFind() * 100) stringByAppendingString:@"%"]},
								  @{@"title": NSLocalizedString(@"Bonus Experience", nil),
									@"value": [toString(_hero->getExperienceBonus() * 100) stringByAppendingString:@"%"]},
								  @{@"title": NSLocalizedString(@"Bonus Experience per Kill", nil),
									@"value": toString(_hero->getExperiencePerKill())}
								  ]}];
	self.sections = sections;
	[self.tableView reloadData];
}
@end
