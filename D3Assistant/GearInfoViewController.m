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

#define GEAR_STAT_CELL_HEIGHT 30
#define GEM_STAT_CELL_HEIGHT  30


@interface GearInfoViewController ()

@end

@implementation GearInfoViewController
@synthesize nameFrameImageView;
@synthesize nameLabel;
@synthesize tableView;
@synthesize itemLevelLabel;
@synthesize requiredLevelLabel;
@synthesize gear;
@synthesize slot;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	if ([self.gear valueForKey:@"dps"]) {
		WeaponBaseInfoView* view = [WeaponBaseInfoView viewWithNibName:@"WeaponBaseInfoView" bundle:nil];
		view.weapon = self.gear;
		self.tableView.tableHeaderView = view;
	}
	else {
		NSString* nibName = nil;
		if ([@[@"waist", @"rightFinger", @"leftFinger", @"neck"] containsObject:self.slot])
			nibName = @"ArmorBaseInfoSmallView";
		else
			nibName = @"ArmorBaseInfoView";
		ArmorBaseInfoView* view = [ArmorBaseInfoView viewWithNibName:nibName bundle:nil];
		view.armor = self.gear;
		self.tableView.tableHeaderView = view;
	}
	
	//self.title = [self.gear valueForKey:@"name"];
	self.title = @"Item Info";
	self.nameLabel.text = [self.gear valueForKey:@"name"];
	NSString* color = [self.gear valueForKey:@"displayColor"];
	self.nameFrameImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"title%@.png", [color capitalizedString]]];
	if (!self.nameFrameImageView.image)
		self.nameFrameImageView.image = [UIImage imageNamed:@"titleBrown.png"];
	self.nameLabel.textColor = [D3Utility colorWithColorName:color];
	
	self.itemLevelLabel.text = [NSString stringWithFormat:@"%d", [[self.gear valueForKey:@"itemLevel"] integerValue]];
	self.requiredLevelLabel.text = [NSString stringWithFormat:@"%d", [[self.gear valueForKey:@"requiredLevel"] integerValue]];

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		CGFloat height = self.tableView.frame.origin.y + self.tableView.tableHeaderView.frame.size.height + self.tableView.tableFooterView.frame.size.height + 40;
		
		NSInteger n = [self numberOfSectionsInTableView:self.tableView];
		for (NSInteger i = 0; i < n; i++) {
			NSInteger rows = [self tableView:self.tableView numberOfRowsInSection:i];
			if (rows > 0)
				height += [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]] * rows;
		}
		
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
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return section == 0 ? [[self.gear valueForKey:@"attributes"] count] : [[self.gear valueForKey:@"gems"] count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		static NSString *CellIdentifier = @"GearStatCellView";
		GearStatCellView *cell = (GearStatCellView*) [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (!cell)
			cell = [GearStatCellView cellWithNibName:@"GearStatCellView" bundle:nil reuseIdentifier:CellIdentifier];
		cell.statLabel.text = [[self.gear valueForKey:@"attributes"] objectAtIndex:indexPath.row];
		return cell;
	}
	else {
		static NSString *CellIdentifier = @"GemStatCellView";
		GemStatCellView *cell = (GemStatCellView*) [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (!cell)
			cell = [GearStatCellView cellWithNibName:@"GemStatCellView" bundle:nil reuseIdentifier:CellIdentifier];
		NSDictionary* gem = [[self.gear valueForKey:@"gems"] objectAtIndex:indexPath.row];
		cell.statLabel.text = [[gem valueForKey:@"attributes"] objectAtIndex:0];
		[cell.gemImageView setImageWithContentsOfURL:[[D3APISession sharedSession] itemImageURLWithItem:[gem valueForKeyPath:@"item.icon"] size:@"small"]];
		return cell;
	}
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
//    if (indexPath.section == 0)
  //      return GEAR_STAT_CELL_HEIGHT;
    //else
      //  return GEM_STAT_CELL_HEIGHT;
};

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return nil;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[aTableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
