//
//  DAItemInfoViewController.m
//  D3Assistant
//
//  Created by Artem Shimanski on 01.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import "DAItemInfoViewController.h"
#import "DAItemInfoStatCell.h"
#import "DAStorage.h"
#import "UIColor+DA.h"
#import "UIImageView+URL.h"
#import "DAItemInfoHeaderView.h"
#import "DAItemInfoBasicCell.h"
#import "NSString+DA.h"
#import "D3CEHelper.h"
#import "DAItemsViewController.h"

@interface DAItemInfoBasic : NSObject
@property (strong, nonatomic) DAItem* item;
@property (strong, nonatomic) NSString* baseStat;
@property (strong, nonatomic) NSString* baseStatName;
@property (strong, nonatomic) NSAttributedString* stat1;
@property (strong, nonatomic) NSAttributedString* stat2;

@end

@interface DAItemInfoViewControllerSection : NSObject
@property (nonatomic, strong) NSArray* rows;
@property (nonatomic, strong) NSAttributedString* title;

- (id) initWithTitle:(NSAttributedString*) title rows:(NSArray*) rows;
- (id) initWithSetRank:(NSInteger) rank active:(BOOL) active rows:(NSArray*) rows;
@end

@interface DAItemInfoViewControllerRow : NSObject
@property (nonatomic, strong) NSAttributedString* text;
@property (nonatomic, strong) NSURL* gemImageURL;
@property (nonatomic, strong) UIImage* affixTypeImage;
@property (nonatomic, assign) NSInteger indentationLevel;
@property (nonatomic, strong) DAItemInfoBasic* basicInfo;

- (id) initWithAttribute:(NSDictionary*) attribute;
- (id) initWithGem:(NSDictionary*) gem;
- (id) initWithSetItem:(NSDictionary*) item equipped:(BOOL) equipped;
- (id) initWithSetAttribute:(NSDictionary*) attribute active:(BOOL) active;
- (id) initWithStat:(NSString*) stat changes:(float) changes;
@end

@implementation DAItemInfoBasic
@end

@implementation DAItemInfoViewControllerSection

- (id) initWithTitle:(NSAttributedString*) title rows:(NSArray*) rows {
	if (self = [super init]) {
		self.title = title;
		self.rows = rows;
	}
	return self;
}

- (id) initWithSetRank:(NSInteger) rank active:(BOOL) active rows:(NSArray*) rows {
	if (self = [super init]) {
		NSString* color = active ? @"green" : @"brown";
		NSString* s = [NSString stringWithFormat:NSLocalizedString(@"(%ld) Set", nil), (long) rank];
		NSMutableAttributedString* title = [[NSMutableAttributedString alloc] initWithString:s
																				 attributes:@{NSForegroundColorAttributeName:[UIColor attributeTextColorWithName:color]}];
		
		[s enumerateNumbersInRange:NSMakeRange(0, s.length)
						usingBlock:^(NSString *string, NSRange range, BOOL *stop) {
							[title addAttribute:NSForegroundColorAttributeName value:[UIColor attributeValueColorWithName:color] range:range];
						}];
		self.title = title;
		self.rows = rows;
	}
	return self;
}

@end

@implementation DAItemInfoViewControllerRow

- (id) initWithAttribute:(NSDictionary*) attribute {
	if (self = [super init]) {
		if ([attribute[@"affixType"] isEqualToString:@"enchant"])
			self.affixTypeImage = [UIImage imageNamed:@"attributeEnchant.png"];
		else if ([attribute[@"affixType"] isEqualToString:@"utility"])
			self.affixTypeImage = [UIImage imageNamed:@"attributeUtility.png"];
		else if ([attribute[@"affixType"] isEqualToString:@"default"])
			self.affixTypeImage = [UIImage imageNamed:@"attributePrimary.png"];
		
		NSString* s = attribute[@"text"];
		NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:s attributes:@{NSForegroundColorAttributeName:[UIColor attributeTextColorWithName:attribute[@"color"]]}];
		
		[s enumerateNumbersInRange:NSMakeRange(0, s.length)
						usingBlock:^(NSString *string, NSRange range, BOOL *stop) {
							[text addAttribute:NSForegroundColorAttributeName value:[UIColor attributeValueColorWithName:attribute[@"color"]] range:range];
						}];
		self.text = text;

	}
	return self;
}

- (id) initWithGem:(NSDictionary*) gem {
	if (self = [super init]) {
		NSDictionary* item = gem[@"item"];
		self.gemImageURL = [DAItem imageURLWithName:item[@"icon"] size:DAItemImageSizeSmall];
		
		NSString* s = item[@"name"];
		BOOL isJewel = [gem[@"isJewel"] boolValue];
		
		NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:s attributes:@{NSForegroundColorAttributeName:[UIColor attributeTextColorWithName:item[@"displayColor"]]}];

		if (isJewel) {
			NSInteger jewelRank = [gem[@"jewelRank"] integerValue];
			[text appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:NSLocalizedString(@" - Rank %ld", nil), (long) jewelRank] attributes:@{NSForegroundColorAttributeName:[UIColor attributeTextColorWithName:@"brown"]}]];
		}
		self.text = text;
	}
	return self;
}

- (id) initWithSetItem:(NSDictionary*) item equipped:(BOOL) equipped {
	if (self = [super init]) {
		
		NSString* s = item[@"name"];
		NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:s attributes:@{NSForegroundColorAttributeName:equipped ? [UIColor attributeTextColorWithName:@"green"] : [UIColor attributeTextColorWithName:@"brown"]}];
		self.text = text;
		self.indentationLevel = 1;
	}
	return self;
}

- (id) initWithSetAttribute:(NSDictionary*) attribute active:(BOOL) active {
	if (self = [super init]) {
		NSString* s = attribute[@"text"];
		NSString* color = active ? @"green" : @"brown";
		NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:s attributes:@{NSForegroundColorAttributeName:[UIColor attributeTextColorWithName:color]}];
		
		[s enumerateNumbersInRange:NSMakeRange(0, s.length)
						usingBlock:^(NSString *string, NSRange range, BOOL *stop) {
							[text addAttribute:NSForegroundColorAttributeName value:[UIColor attributeValueColorWithName:color] range:range];
						}];
		self.text = text;
		self.indentationLevel = 1;
	}
	return self;
}

- (id) initWithStat:(NSString*) stat changes:(float) changes {
	if (self = [super init]) {
		NSString* s = [NSString stringWithFormat:@"%.2f%% %@", changes * 100, stat];
		NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:s attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
		
		[s enumerateNumbersInRange:NSMakeRange(0, s.length)
						usingBlock:^(NSString *string, NSRange range, BOOL *stop) {
							[text addAttribute:NSForegroundColorAttributeName value:changes < 0 ? [UIColor redColor] : [UIColor greenColor] range:range];
						}];
		
		self.text = text;
	}
	return self;
}


@end

@interface DAItemInfoViewController()
@property (nonatomic, strong) NSArray* sections;
@property (assign, nonatomic) std::shared_ptr<d3ce::Engine> engine;
@property (assign, nonatomic) std::shared_ptr<d3ce::Party> party;
@property (assign, nonatomic) std::shared_ptr<d3ce::Hero> d3ceHero;
@property (strong, nonatomic) DAItem* compareItem;
- (void) reload;
@end

@implementation DAItemInfoViewController

- (void) viewDidLoad {
	[super viewDidLoad];
	self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
	[self.tableView registerNib:[UINib nibWithNibName:@"DAItemInfoHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"Header"];
	self.engine = [D3CEHelper sharedEngine];
	[self reload];
}

- (IBAction)onClose:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"DAItemsViewController"]) {
		DAItemsViewController* controller = segue.destinationViewController;
		controller.classMask = static_cast<d3ce::ClassMask>([DAHero heroClassFromString:self.hero.heroClass]);
		controller.slot = self.slot;
		controller.hero = self.hero;
		controller.selectedItem = self.compareItem;
	}
}

- (IBAction)unwindFromItemsWithSegue:(UIStoryboardSegue*)segue {
	DAItemsViewController* controller = segue.sourceViewController;
	if (controller.selectedItem == self.item)
		self.compareItem = nil;
	else
		self.compareItem = controller.selectedItem;
	[self reload];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.sections[section] rows].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DAItemInfoViewControllerRow* row = [self.sections[indexPath.section] rows][indexPath.row];

	if (row.basicInfo) {
		DAItemInfoBasicCell* cell = [tableView dequeueReusableCellWithIdentifier:row.basicInfo.baseStat ? @"BasicCell" : @"BasicShortCell"];
		cell.backgroundColor = [UIColor clearColor];
		cell.baseStatLabel.text = row.basicInfo.baseStat;
		cell.baseStatNameLabel.text = row.basicInfo.baseStatName;
		cell.stat1Label.attributedText = row.basicInfo.stat1;
		cell.stat2Label.attributedText = row.basicInfo.stat2;
		
		cell.itemImageView.image = nil;
		[cell.itemImageView setImageWithContentsOfURL:[row.basicInfo.item imageURLWithSize:DAItemImageSizeLarge]];
		cell.itemNameLabel.text = row.basicInfo.item.name;
		cell.itemNameLabel.textColor = [UIColor itemColorWithName:row.basicInfo.item.itemInfo.displayColor];
		cell.typeNameLabel.text = row.basicInfo.item.itemInfo.typeName;
		cell.itemColorImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", row.basicInfo.item.itemInfo.displayColor]];
		if (!cell.itemColorImageView.image)
			cell.itemColorImageView.image = [UIImage imageNamed:@"brown.png"];
		return cell;
	}
	else {
		DAItemInfoStatCell* cell;
		if (row.gemImageURL && row.affixTypeImage)
			cell = [tableView dequeueReusableCellWithIdentifier:@"GemStatCell" forIndexPath:indexPath];
		else if (row.gemImageURL && !row.affixTypeImage)
			cell = [tableView dequeueReusableCellWithIdentifier:@"GemCell" forIndexPath:indexPath];
		else if (!row.gemImageURL && row.affixTypeImage)
			cell = [tableView dequeueReusableCellWithIdentifier:@"StatCell" forIndexPath:indexPath];
		else
			cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
		cell.backgroundColor = [UIColor clearColor];

		cell.valueLabel.attributedText = row.text;
		cell.affixTypeImageView.image = row.affixTypeImage;
		cell.indentationConstraint.constant = row.indentationLevel * cell.indentationWidth;
		cell.gemImageView.image = nil;
		if (row.gemImageURL)
			[cell.gemImageView setImageWithContentsOfURL:row.gemImageURL];
		return cell;
	}
}

#pragma mark - UITableViewDelegate

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	NSAttributedString* title = [(DAItemInfoViewControllerSection*) self.sections[section] title];
	if (title) {
		DAItemInfoHeaderView* header =  [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
		header.titleLabel.attributedText = title;
		return header;
	}
	else
		return nil;

}

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return self.tableView.rowHeight;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewAutomaticDimension;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	NSAttributedString* title = [(DAItemInfoViewControllerSection*) self.sections[section] title];
	return title ? self.tableView.sectionHeaderHeight : 0;
}

#pragma mark - Private

- (void) reload {
	NSMutableArray* sections = [NSMutableArray new];
	DAItem* item = self.compareItem ? self.compareItem : self.item;

	float baseStat = 0;
	NSString* baseStatName = nil;
	if (item.itemInfo.armor > 0) {
		baseStat = item.itemInfo.armor;
		baseStatName = NSLocalizedString(@"Armor", nil);
	}
	else if (item.itemInfo.dps) {
		baseStat = item.itemInfo.dps;
		baseStatName = NSLocalizedString(@"Damage Per Second", nil);
	}
	
	NSString* stat1 = nil;
	NSString* stat1Name = nil;
	
	if (item.itemInfo.minDamage > 0) {
		stat1 = [NSString stringWithFormat:@"%.0f-%.0f ", item.itemInfo.minDamage, item.itemInfo.maxDamage];
		stat1Name = NSLocalizedString(@"Damage", nil);
	}
	else if (item.itemInfo.blockChance > 0) {
		stat1 = [NSString stringWithFormat:@"%.1f%% ", item.itemInfo.blockChance * 100];
		stat1Name = NSLocalizedString(@"Chance to Block", nil);
	}
	
	NSString* stat2 = nil;
	NSString* stat2Name = nil;
	
	if (item.itemInfo.attacksPerSecond > 0) {
		stat2 = [NSString stringWithFormat:@"%.2f ", item.itemInfo.attacksPerSecond];
		stat2Name = NSLocalizedString(@"Attacks Per Second", nil);
	}
	else if (item.itemInfo.blockChance > 0) {
		float blockAmountMin = [item.itemInfo.attributesRaw[@"Block_Amount_Item_Min"][@"min"] floatValue];
		float blockAmountDelta = [item.itemInfo.attributesRaw[@"Block_Amount_Item_Delta"][@"min"] floatValue];
		if (blockAmountMin > 0 || blockAmountDelta > 0) {
			stat2 = [NSString stringWithFormat:@"%.0f-%.0f ", blockAmountMin, blockAmountMin + blockAmountDelta];
			stat2Name = NSLocalizedString(@"Block Amount", nil);
		}
		
	}
	
	DAItemInfoBasic* basicInfo = [DAItemInfoBasic new];
	basicInfo.baseStat = baseStat ? [NSString stringWithFormat:@"%.1f", baseStat] : nil;
	basicInfo.baseStatName = baseStatName;
	basicInfo.item = item;
	
	if (stat1) {
		NSMutableAttributedString* s = [[NSMutableAttributedString alloc] initWithString:[stat1 stringByAppendingString:stat1Name] attributes:nil];
		[s addAttribute:NSForegroundColorAttributeName value:[UIColor attributeValueColorWithName:@"brown"] range:NSMakeRange(0, stat1.length)];
		[s addAttribute:NSForegroundColorAttributeName value:[UIColor attributeTextColorWithName:@"brown"] range:NSMakeRange(stat1.length, stat1Name.length)];
		basicInfo.stat1 = s;
	}
	
	if (stat2) {
		NSMutableAttributedString* s = [[NSMutableAttributedString alloc] initWithString:[stat2 stringByAppendingString:stat2Name] attributes:nil];
		[s addAttribute:NSForegroundColorAttributeName value:[UIColor attributeValueColorWithName:@"brown"] range:NSMakeRange(0, stat2.length)];
		[s addAttribute:NSForegroundColorAttributeName value:[UIColor attributeTextColorWithName:@"brown"] range:NSMakeRange(stat2.length, stat2Name.length)];
		basicInfo.stat2 = s;
	}
	DAItemInfoViewControllerRow* row = [DAItemInfoViewControllerRow new];
	row.basicInfo = basicInfo;
	[sections addObject:[[DAItemInfoViewControllerSection alloc] initWithTitle:nil rows:@[row]]];
	
	if ([item.itemInfo.attributes isKindOfClass:[NSDictionary class]]) {
		NSMutableArray* rows = [NSMutableArray new];
		NSArray* primary = item.itemInfo.attributes[@"primary"];
		NSArray* secondary = item.itemInfo.attributes[@"secondary"];
		NSArray* passive = item.itemInfo.attributes[@"passive"];
		
		if ([primary isKindOfClass:[NSArray class]]) {
			for (NSDictionary* attribute in primary)
				[rows addObject:[[DAItemInfoViewControllerRow alloc] initWithAttribute:attribute]];
			if (rows.count > 0)
				[sections addObject:[[DAItemInfoViewControllerSection alloc] initWithTitle:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"Primary", nil)
																														   attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}]
																					  rows:rows]];
		}
		
		rows = [NSMutableArray new];

		if ([secondary isKindOfClass:[NSArray class]]) {
			for (NSDictionary* attribute in secondary)
				[rows addObject:[[DAItemInfoViewControllerRow alloc] initWithAttribute:attribute]];
		}
		if ([passive isKindOfClass:[NSArray class]]) {
			for (NSDictionary* attribute in passive)
				[rows addObject:[[DAItemInfoViewControllerRow alloc] initWithAttribute:attribute]];
		}
		
		if (rows.count > 0)
			[sections addObject:[[DAItemInfoViewControllerSection alloc] initWithTitle:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"Secondary", nil)
																													   attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}]
																				  rows:rows]];
	}
	if ([item.itemInfo.gems isKindOfClass:[NSArray class]]) {
		NSMutableArray* rows = [NSMutableArray new];
		for (NSDictionary* gem in  item.itemInfo.gems) {
			NSMutableArray* attributes = [NSMutableArray new];
			NSDictionary* dic = gem[@"attributes"];
			if ([dic isKindOfClass:[NSDictionary class]]) {
				[dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
					if ([obj isKindOfClass:[NSArray class]]) {
						for (NSDictionary* attribute in obj) {
							[attributes addObject:[[DAItemInfoViewControllerRow alloc] initWithAttribute:attribute]];
						}
					}
				}];
			}
			if (attributes.count == 1) {
				DAItemInfoViewControllerRow* row = attributes[0];
				row.gemImageURL = [DAItem imageURLWithName:gem[@"item"][@"icon"] size:DAItemImageSizeSmall];
				[rows addObject:row];
			}
			else {
				[rows addObject:[[DAItemInfoViewControllerRow alloc] initWithGem:gem]];
				for (DAItemInfoViewControllerRow* row in attributes) {
					row.indentationLevel = 1;
					[rows addObject:row];
				}
			}
		}
		
		if (rows.count > 0)
			[sections addObject:[[DAItemInfoViewControllerSection alloc] initWithTitle:nil rows:rows]];
	}
	if ([item.itemInfo.set isKindOfClass:[NSDictionary class]]) {
		NSArray* items = item.itemInfo.set[@"items"];
		NSInteger rank = 0;
		if ([items isKindOfClass:[NSArray class]]) {
			NSMutableArray* rows = [NSMutableArray new];
			DAEquipment* equipment = self.hero.defaultEquipment;
			for (NSDictionary* item in items) {
				NSString* identifier = item[@"id"];
				BOOL equiped = [equipment.gear filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"item.identifier == %@", identifier]].count > 0;
				[rows addObject:[[DAItemInfoViewControllerRow alloc] initWithSetItem:item equipped:equiped]];
				if (equiped)
					rank++;
			}
			if (rows.count > 0)
				[sections addObject:[[DAItemInfoViewControllerSection alloc] initWithTitle:[[NSAttributedString alloc] initWithString:item.itemInfo.set[@"name"]
																														   attributes:@{NSForegroundColorAttributeName:[UIColor attributeTextColorWithName:@"green"]}]
																					  rows:rows]];
		}
		
		NSArray* ranks = item.itemInfo.set[@"ranks"];
		if ([ranks isKindOfClass:[NSArray class]]) {
			for (NSDictionary* dic in ranks) {
				NSMutableArray* rows = [NSMutableArray new];
				NSInteger required = [dic[@"required"] integerValue];
				BOOL active = rank >= required;
				[dic[@"attributes"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
					if ([obj isKindOfClass:[NSArray class]]) {
						for (NSDictionary* attribute in obj) {
							[rows addObject:[[DAItemInfoViewControllerRow alloc] initWithSetAttribute:attribute active:active]];
						}
					}
				}];
				
				if (rows.count > 0)
					[sections addObject:[[DAItemInfoViewControllerSection alloc] initWithSetRank:required active:active rows:rows]];

			}
		}
	}
	
	if (self.compareItem) {
		self.party = std::shared_ptr<d3ce::Party>(new d3ce::Party(self.engine));
		self.d3ceHero = [D3CEHelper addHero:self.hero toParty:self.party];
		
		d3ce::Range oldDPS = self.d3ceHero->getDPS();
		d3ce::Range oldToughness = self.d3ceHero->getToughness();
		d3ce::Range oldHealing = self.d3ceHero->getHealing();
		
		self.d3ceHero->removeItem(self.d3ceHero->getItem(self.slot));
		[D3CEHelper addItem:self.compareItem toHero:self.d3ceHero slot:self.slot replaceExisting:YES];

		d3ce::Range newDPS = self.d3ceHero->getDPS();
		d3ce::Range newToughness = self.d3ceHero->getToughness();
		d3ce::Range newHealing = self.d3ceHero->getHealing();
		
		NSMutableArray* rows = [NSMutableArray new];
		[rows addObject:[[DAItemInfoViewControllerRow alloc] initWithStat:NSLocalizedString(@"Damage", nil) changes:(newDPS.min - oldDPS.min) / MAX(oldDPS.min, 1)]];
		[rows addObject:[[DAItemInfoViewControllerRow alloc] initWithStat:NSLocalizedString(@"Toughness", nil) changes:(newToughness.min - oldToughness.min) / MAX(oldToughness.min, 1)]];
		[rows addObject:[[DAItemInfoViewControllerRow alloc] initWithStat:NSLocalizedString(@"Healing", nil) changes:(newHealing.min - oldHealing.min) / MAX(oldHealing.min, 1)]];
		[sections addObject:[[DAItemInfoViewControllerSection alloc] initWithTitle:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"Stat Changes if Equipped:", nil)
																												   attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}]
																			  rows:rows]];
	}
	
	self.sections = sections;

	NSMutableAttributedString* itemLevel = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:NSLocalizedString(@"Item Level: %d", nil), item.itemInfo.itemLevel] attributes:nil];
	[itemLevel.string enumerateNumbersInRange:NSMakeRange(0, itemLevel.string.length) usingBlock:^(NSString *string, NSRange range, BOOL *stop) {
		[itemLevel addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range];
	}];
	self.levelLabel.attributedText = itemLevel;

	[self.tableView reloadData];
}

@end
