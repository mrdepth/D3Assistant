//
//  DAItemsViewController.m
//  D3Assistant
//
//  Created by Artem Shimanski on 15.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import "DAItemsViewController.h"
#import "DAItemCell.h"
#import "DAStorage.h"
#import "UIImageView+URL.h"
#import "D3CEHelper.h"
#import "NSString+DA.h"
#import "UIColor+DA.h"

@interface DAItemsViewController()<NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController* resultsController;
@property (strong, nonatomic) NSMutableDictionary* itemsStats;
@property (assign, nonatomic) std::shared_ptr<d3ce::Party> party;
@property (assign, nonatomic) std::shared_ptr<d3ce::Hero> d3ceHero;
@property (assign, nonatomic) std::shared_ptr<d3ce::Gear> offHand;
@property (assign, nonatomic) std::shared_ptr<d3ce::Gear> mainHand;

@property (assign, nonatomic) d3ce::Range oldDPS;
@property (assign, nonatomic) d3ce::Range oldToughness;
@property (assign, nonatomic) d3ce::Range oldHealing;

@end

@implementation DAItemsViewController

- (void) viewDidLoad {
	[super viewDidLoad];
	switch (self.slot) {
		case d3ce::Item::SlotBracers:
			self.title = NSLocalizedString(@"Bracers", nil);
			break;
		case d3ce::Item::SlotFeet:
			self.title = NSLocalizedString(@"Feet", nil);
			break;
		case d3ce::Item::SlotHands:
			self.title = NSLocalizedString(@"Hands", nil);
			break;
		case d3ce::Item::SlotHead:
			self.title = NSLocalizedString(@"Head", nil);
			break;
		case d3ce::Item::SlotLeftFinger:
			self.title = NSLocalizedString(@"Left Finger", nil);
			break;
		case d3ce::Item::SlotRightFinger:
			self.title = NSLocalizedString(@"Right Finger", nil);
			break;
		case d3ce::Item::SlotShoulders:
			self.title = NSLocalizedString(@"Shoulders", nil);
			break;
		case d3ce::Item::SlotTorso:
			self.title = NSLocalizedString(@"Torso", nil);
			break;
		case d3ce::Item::SlotLegs:
			self.title = NSLocalizedString(@"Legs", nil);
			break;
		case d3ce::Item::SlotMainHand:
			self.title = NSLocalizedString(@"Main Hand", nil);
			break;
		case d3ce::Item::SlotOffHand:
			self.title = NSLocalizedString(@"Off-Hand", nil);
			break;
		case d3ce::Item::SlotNeck:
			self.title = NSLocalizedString(@"Neck", nil);
			break;
		case d3ce::Item::SlotWaist:
			self.title = NSLocalizedString(@"Waist", nil);
			break;
		default:
			break;
	}
	
	self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
	self.itemsStats = [NSMutableDictionary new];
	auto engine = [D3CEHelper sharedEngine];
	self.party = std::shared_ptr<d3ce::Party>(new d3ce::Party(engine));
	self.d3ceHero = [D3CEHelper addHero:self.hero toParty:self.party];
	self.offHand = self.d3ceHero->getItem(d3ce::Item::SlotOffHand);
	self.mainHand = self.d3ceHero->getItem(d3ce::Item::SlotMainHand);
	
	self.oldDPS = self.d3ceHero->getDPS();
	self.oldToughness = self.d3ceHero->getToughness();
	self.oldHealing = self.d3ceHero->getHealing();

	DAStorage* storage = [DAStorage sharedStorage];
	NSManagedObjectContext* managedObjectContext = storage.managedObjectContext;

	NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
	request.predicate = [NSPredicate predicateWithFormat:@"(classMask & %d) > 0 AND (slotMask & %d) > 0 AND itemInfo.requiredLevel <= %d", self.classMask, self.slot, self.hero.level];
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"itemInfo.itemLevel" ascending:NO],
								[NSSortDescriptor sortDescriptorWithKey:@"itemInfo.dps" ascending:NO],
								[NSSortDescriptor sortDescriptorWithKey:@"itemInfo.armor" ascending:NO],
								[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
	request.fetchBatchSize = 32;

	self.resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
	self.resultsController.delegate = self;
	[self.resultsController performFetch:nil];
	[self.tableView reloadData];
	
	if (self.selectedItem) {
		NSIndexPath* indexPath = [self.resultsController indexPathForObject:self.selectedItem];
		if (indexPath)
			[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
		}
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"Unwind"]) {
		self.selectedItem = [sender object];
	}
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.resultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id<NSFetchedResultsSectionInfo> sectionInfo = self.resultsController.sections[section];
	return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DAItem* item = [self.resultsController objectAtIndexPath:indexPath];
	DAItemCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	cell.backgroundColor = [UIColor clearColor];
	cell.object = item;
	
	cell.itemImageView.image = nil;
	[cell.itemImageView setImageWithContentsOfURL:[item imageURLWithSize:DAItemImageSizeLarge]];
	cell.itemNameLabel.text = item.name;
	cell.typeNameLabel.text = item.itemInfo.typeName;
	
	cell.itemNameLabel.textColor = [UIColor itemColorWithName:item.itemInfo.displayColor];

	cell.itemColorImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", item.itemInfo.displayColor]];
	if (!cell.itemColorImageView.image)
		cell.itemColorImageView.image = [UIImage imageNamed:@"brown.png"];

	if (item.hero) {
		cell.heroNameLabel.text = [NSString stringWithFormat:@"%@/%@", item.hero.profile.battleTag, item.hero.name];
	}
	else
		cell.heroNameLabel.text = nil;
	
	NSMutableAttributedString* itemLevel = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:NSLocalizedString(@"Item Level: %d", nil), item.itemInfo.itemLevel] attributes:nil];
	[itemLevel.string enumerateNumbersInRange:NSMakeRange(0, itemLevel.string.length) usingBlock:^(NSString *string, NSRange range, BOOL *stop) {
		[itemLevel addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range];
	}];
	cell.itemLevelLabel.attributedText = itemLevel;
	
	NSMutableDictionary* stats = self.itemsStats[item.objectID];
	if (!stats) {
		NSAttributedString* (^toString)(NSString*, float) = ^(NSString* stat, float changes) {
			NSString* s = [NSString stringWithFormat:@"%.2f%% %@", changes * 100, stat];
			NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:s attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
			
			[s enumerateNumbersInRange:NSMakeRange(0, s.length)
							usingBlock:^(NSString *string, NSRange range, BOOL *stop) {
								[text addAttribute:NSForegroundColorAttributeName value:changes < 0 ? [UIColor redColor] : [UIColor greenColor] range:range];
							}];
			return text;
		};
		
		self.d3ceHero->removeItem(self.d3ceHero->getItem(self.slot));
		if (self.slot == d3ce::Item::SlotMainHand && self.offHand && self.d3ceHero->getItem(d3ce::Item::SlotOffHand) != self.offHand) {
			try {
				self.d3ceHero->addItem(self.offHand);
			}
			catch (d3ce::Hero::SlotIsAlreadyFilledException& exception) {
				self.d3ceHero->removeItem(self.d3ceHero->getItem(exception.slot));
				self.d3ceHero->addItem(self.offHand);
			}
			self.offHand->setSlot(d3ce::Item::SlotOffHand);
		}
		else if (self.slot == d3ce::Item::SlotOffHand && self.mainHand && self.d3ceHero->getItem(d3ce::Item::SlotMainHand) != self.mainHand) {
			try {
				self.d3ceHero->addItem(self.mainHand);
			}
			catch (d3ce::Hero::SlotIsAlreadyFilledException& exception) {
				self.d3ceHero->removeItem(self.d3ceHero->getItem(exception.slot));
				self.d3ceHero->addItem(self.mainHand);
			}
			self.mainHand->setSlot(d3ce::Item::SlotMainHand);
			self.offHand->setSlot(d3ce::Item::SlotOffHand);
		}
		
		[D3CEHelper addItem:item toHero:self.d3ceHero slot:self.slot replaceExisting:YES];
		
		d3ce::Range newDPS = self.d3ceHero->getDPS();
		d3ce::Range newToughness = self.d3ceHero->getToughness();
		d3ce::Range newHealing = self.d3ceHero->getHealing();
		
		self.itemsStats[item.objectID] = stats = [NSMutableDictionary new];
		stats[@"damage"] = toString(NSLocalizedString(@"Damage", nil), (newDPS.min - self.oldDPS.min) / MAX(self.oldDPS.min, 1));
		stats[@"toughness"] = toString(NSLocalizedString(@"Toughness", nil), (newToughness.min - self.oldToughness.min) / MAX(self.oldToughness.min, 1));
		stats[@"healing"] = toString(NSLocalizedString(@"Healing", nil), (newHealing.min - self.oldHealing.min) / MAX(self.oldHealing.min, 1));
	}
	cell.damageLabel.attributedText = stats[@"damage"];
	cell.toughnessLabel.attributedText = stats[@"toughness"];
	cell.healingLabel.attributedText = stats[@"healing"];

	return cell;
}

#pragma mark - UITableViewDelegate

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	DAItem* item = [self.resultsController objectAtIndexPath:indexPath];
	return item.gear.count == 0;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		DAItem* item = [self.resultsController objectAtIndexPath:indexPath];
		NSManagedObjectContext* context = item.managedObjectContext;
		[context deleteObject:item];
		[context save:nil];
	}
}

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return self.tableView.rowHeight;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewAutomaticDimension;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView endUpdates];
}

- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	switch (type) {
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeInsert:
			[self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeMove:
			[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeUpdate:
			[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		default:
			break;
	}
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	switch (type) {
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
		default:
			break;
	}
}

@end
