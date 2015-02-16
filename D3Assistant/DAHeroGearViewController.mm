//
//  DAHeroGearViewController.m
//  D3Assistant
//
//  Created by Artem Shimanski on 18.12.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import "DAHeroGearViewController.h"
#import "DAHeroViewController.h"
#import "DAStorage.h"
#import "DAItemInfoViewController.h"
#import "UIImageView+URL.h"
#import "UIColor+DA.h"

@interface DAHeroGearViewController ()
- (void) reload;
- (void) didSave:(NSNotification*) notification;
@end

@implementation DAHeroGearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.nameLabel.text = @" ";
	self.levelLabel.text = @" ";
	self.view.translatesAutoresizingMaskIntoConstraints = YES;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSave:) name:NSManagedObjectContextDidSaveNotification object:nil];
	if (_hero)
		[self reload];
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setHero:(DAHero *)hero {
	_hero = hero;
	if ([self isViewLoaded])
		[self reload];
}

- (IBAction)onItemInfo:(id)sender {
	DAGearView* gearView = sender;
	if (gearView.gear) {
		DAItemInfoViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DAItemInfoViewController"];
		controller.item = gearView.gear.item;
		controller.slot = static_cast<d3ce::Item::Slot>([DAGear slotFromString:gearView.slot]);
		controller.hero = self.hero;

		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
			[self.navigationController pushViewController:controller animated:YES];
		}
		else {
			UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
			navigationController.navigationBar.barStyle = self.navigationController.navigationBar.barStyle;
			navigationController.modalPresentationStyle = UIModalPresentationPopover;
			navigationController.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
			navigationController.preferredContentSize = CGSizeMake(320, 768);
			[self presentViewController:navigationController animated:YES completion:nil];
			UIPopoverPresentationController *presentationController = [navigationController popoverPresentationController];
			presentationController.permittedArrowDirections = UIPopoverArrowDirectionLeft | UIPopoverArrowDirectionRight;
			presentationController.sourceView = gearView;
			presentationController.sourceRect = gearView.bounds;
		}
	}
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"DAItemInfoViewController"]) {
		DAItemInfoViewController* controller = (DAItemInfoViewController*) [(UINavigationController*) segue.destinationViewController topViewController];
		DAGearView* gearView = sender;
		controller.item = gearView.gear.item;
		controller.slot = static_cast<d3ce::Item::Slot>([DAGear slotFromString:gearView.slot]);
		controller.hero = self.hero;
	}
}

#pragma makr - Private

- (void) reload {
	if (self.hero) {
		dispatch_async(dispatch_get_main_queue(), ^{
			self.nameLabel.text = self.hero.name;
			NSMutableAttributedString* s = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %ld (", [self.hero.heroClass capitalizedString], (long) self.hero.level]attributes:nil];
			[s appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %ld ", (long) self.hero.paragonLevel] attributes:@{NSForegroundColorAttributeName:[UIColor paragonColor]}]];
			[s appendAttributedString:[[NSAttributedString alloc] initWithString:@")" attributes:nil]];
			self.levelLabel.attributedText = s;
		});
		
		
		NSMutableDictionary* slots = [NSMutableDictionary new];
		for (DAGear* gear in self.hero.defaultEquipment.gear) {
			if (gear.item.itemInfo)
				slots[@(gear.slot)] = gear;
		}
		for (DAGearView* gearView in self.gearViews) {
			gearView.gear = slots[@([DAGear slotFromString:gearView.slot])];
		}
	}
}

- (void) didSave:(NSNotification*) notification {
	for (NSManagedObject* object in notification.userInfo[NSUpdatedObjectsKey])
		if (object == _hero || ([object isKindOfClass:[DAItem class]] && [(DAItem*) object hero] == _hero)) {
			[self reload];
			return;
		}
}

@end
