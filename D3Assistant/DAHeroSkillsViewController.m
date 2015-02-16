//
//  DAHeroSkillsViewController.m
//  D3Assistant
//
//  Created by Artem Shimanski on 12.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import "DAHeroSkillsViewController.h"
#import "DAStorage.h"
#import "DAActiveSkillCell.h"
#import "DAPassiveSkillCell.h"
#import "UIImageView+URL.h"
#import "D3APISession.h"
#import "DAActiveSkillInfoViewController.h"
#import "DAPassiveSkillInfoViewController.h"

@interface DAHeroSkillsViewController ()<UICollectionViewDelegateFlowLayout>
@end

@implementation DAHeroSkillsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	//UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
	//layout.estimatedItemSize = CGSizeMake(250, 83);
}

- (void) setHero:(DAHero *)hero {
	_hero = hero;
	if ([self isViewLoaded])
		[self.collectionView reloadData];
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	for (NSIndexPath* indexPath in [self.collectionView indexPathsForSelectedItems])
		[self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return section == 0 ? [self.hero.skills.active count] : [self.hero.skills.passive count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		DAActiveSkillCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DAActiveSkillCell" forIndexPath:indexPath];
		NSDictionary* skill = self.hero.skills.active[indexPath.row][@"skill"];
		NSDictionary* rune = self.hero.skills.active[indexPath.row][@"rune"];
		cell.object = self.hero.skills.active[indexPath.row];
		cell.skillNameLabel.text = skill[@"name"];
		
		if (rune) {
			cell.runeNameLabel.text = rune[@"name"];
			cell.runeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"runeSmall%@.png", [rune[@"type"] capitalizedString]]];
		}
		else {
			cell.runeNameLabel.text = nil;
			cell.runeImageView.image = nil;
		}
		
		if (skill) {
			cell.skillImageView.image = nil;
			cell.skillNameLabel.text = skill[@"name"];
			[cell.skillImageView setImageWithContentsOfURL:[[D3APISession sharedSession] skillImageURLWithItem:[skill valueForKey:@"icon"] size:@"42"]];
		}
		else {
			cell.skillNameLabel.text = nil;
			cell.skillImageView.image = nil;
		}
		
		if (indexPath.row == 0) {
			cell.orderImageView.image = [UIImage imageNamed:@"skillPrimary.png"];
			cell.orderLabel.text = nil;
		}
		else if (indexPath.row == 1) {
			cell.orderImageView.image = [UIImage imageNamed:@"skillSecondary.png"];
			cell.orderLabel.text = nil;
		}
		else {
			cell.orderImageView.image = nil;
			cell.orderLabel.text = [NSString stringWithFormat:@"%ld", (long)(indexPath.row - 1)];
		}
		
		
		return cell;
	}
	else {
		DAPassiveSkillCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DAPassiveSkillCell" forIndexPath:indexPath];
		NSDictionary* skill = self.hero.skills.passive[indexPath.row][@"skill"];
		cell.object = self.hero.skills.passive[indexPath.row];
		cell.skillNameLabel.text = skill[@"name"];
		
		if (skill) {
			cell.skillImageView.image = nil;
			cell.skillNameLabel.text = skill[@"name"];
			[cell.skillImageView setImageWithContentsOfURL:[[D3APISession sharedSession] skillImageURLWithItem:[skill valueForKey:@"icon"] size:@"42"]];
		}
		else {
			cell.skillNameLabel.text = nil;
			cell.skillImageView.image = nil;
		}
		return cell;
	}
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return indexPath.section == 0 ? CGSizeMake(250, 83) : CGSizeMake(145, 79);
}

#pragma mark <UICollectionViewDelegate>

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	UIViewController* controller;
	id skill = [(id) [collectionView cellForItemAtIndexPath:indexPath] object];
	if (!skill[@"skill"])
		return;
	if (indexPath.section == 0) {
		DAActiveSkillInfoViewController* skillInfoController = [self.storyboard instantiateViewControllerWithIdentifier:@"DAActiveSkillInfoViewController"];
		skillInfoController.skill = skill;
		controller = skillInfoController;
	}
	else {
		DAPassiveSkillInfoViewController* skillInfoController = [self.storyboard instantiateViewControllerWithIdentifier:@"DAPassiveSkillInfoViewController"];
		skillInfoController.skill = skill;
		controller = skillInfoController;
	}

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		[self.navigationController pushViewController:controller animated:YES];
	}
	else {
		UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
		navigationController.navigationBar.barStyle = self.navigationController.navigationBar.barStyle;
		navigationController.modalPresentationStyle = UIModalPresentationPopover;
		navigationController.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
		[self presentViewController:navigationController animated:YES completion:nil];
		UIPopoverPresentationController *presentationController = [navigationController popoverPresentationController];
		presentationController.permittedArrowDirections = UIPopoverArrowDirectionLeft | UIPopoverArrowDirectionRight;
		UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:indexPath];
		presentationController.sourceView = cell;
		presentationController.sourceRect = cell.bounds;
	}
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
