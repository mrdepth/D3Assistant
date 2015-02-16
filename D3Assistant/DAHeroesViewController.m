//
//  DAHeroesViewController.m
//  D3Assistant
//
//  Created by Artem Shimanski on 09.10.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import "DAHeroesViewController.h"
#import "DAHeroCell.h"
#import "UIImageView+URL.h"
#import "DAStorage.h"
#import "DAHeroViewController.h"
#import "UIColor+DA.h"
#import "DAProfilesHeaderView.h"
#import "NSProgress+DA.h"
#import "D3APISession.h"

@interface DAHeroesViewControllerSection : NSObject
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSArray* rows;

- (id) initWithTitle:(NSString*) title rows:(NSArray*) rows;
@end

@implementation DAHeroesViewControllerSection

- (id) initWithTitle:(NSString*) title rows:(NSArray*) rows {
	if (self = [super init]) {
		self.title = title;
		self.rows = rows;
	}
	return self;
}

@end

@interface DAHeroesViewController ()
@property (nonatomic, strong) NSArray* sections;
- (void) reload;
- (void) didSave:(NSNotification*) notification;
- (IBAction)onRefresh:(id)sender;
@end

@implementation DAHeroesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.tableView registerNib:[UINib nibWithNibName:@"DAProfilesHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"Header"];
	self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
	self.refreshControl = [UIRefreshControl new];
	self.refreshControl.layer.zPosition = 1;
	[self.refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSave:) name:NSManagedObjectContextDidSaveNotification object:nil];

	
	self.title = self.profile.battleTag;
	[self reload];
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"DAHeroViewController"]) {
		DAHeroViewController* controller = [segue.destinationViewController isKindOfClass:[UINavigationController class]] ? (DAHeroViewController*) [(UINavigationController*) segue.destinationViewController topViewController] : segue.destinationViewController;
		controller.hero = [sender object];
	}
}

- (IBAction)unwindFromHeroWithSegue:(UIStoryboardSegue*)segue {
	
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
	DAHeroesViewControllerSection* section = self.sections[sectionIndex];
    return section.rows.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DAHeroesViewControllerSection* section = self.sections[indexPath.section];
	DAHero* hero = section.rows[indexPath.row];

	DAHeroCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	cell.backgroundColor = [UIColor clearColor];
	cell.object = hero;
	cell.nameLabel.text = hero.name;
	
	NSMutableAttributedString* s = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Level ", nil) attributes:nil];
	[s appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", hero.level] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}]];
	[s appendAttributedString:[[NSAttributedString alloc] initWithString:@" (" attributes:nil]];
	[s appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", hero.paragonLevel] attributes:@{NSForegroundColorAttributeName:[UIColor paragonColor]}]];
	[s appendAttributedString:[[NSAttributedString alloc] initWithString:@"), " attributes:nil]];
	[s appendAttributedString:[[NSAttributedString alloc] initWithString:[hero.heroClass capitalizedString] attributes:nil]];
	
	
	cell.infoLabel.attributedText = s;
	//cell.avatarImageView.image = nil;
	
	if (hero.dead) {
		cell.deadLabel.text = NSLocalizedString(@"dead", nil);
		cell.deadImageView.hidden = NO;
	}
	else {
		cell.deadLabel.text = nil;
		cell.deadImageView.hidden = YES;
	}
	
	//[cell.avatarImageView setImageWithContentsOfURL:hero.avatarURL];
	CGPoint p;
	p.x = hero.gender ? 0.5 : 0.0;
	if ([hero.heroClass isEqualToString:@"barbarian"])
		p.y = 0;
	else if ([hero.heroClass isEqualToString:@"demon-hunter"])
		p.y = 1.0 / 6.0;
	else if ([hero.heroClass isEqualToString:@"monk"])
		p.y = 2.0 / 6.0;
	else if ([hero.heroClass isEqualToString:@"witch-doctor"])
		p.y = 3.0 / 6.0;
	else if ([hero.heroClass isEqualToString:@"wizard"])
		p.y = 4.0 / 6.0;
	else if ([hero.heroClass isEqualToString:@"crusader"])
		p.y = 5.0 / 6.0;
	cell.avatarImageView.layer.contentsRect = CGRectMake(p.x, p.y, 0.5, 1.0 / 6.0);

    return cell;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex {
	DAHeroesViewControllerSection* section = self.sections[sectionIndex];
	return section.title;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	DAProfilesHeaderView* header = (DAProfilesHeaderView*) [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
	header.titleLabel.text = [self tableView:tableView titleForHeaderInSection:section];
	return header;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
	NSMutableArray* softcore = [NSMutableArray new];
	NSMutableArray* hardcore = [NSMutableArray new];
	NSMutableArray* seasonalSoftcore = [NSMutableArray new];
	NSMutableArray* seasonalHardcore = [NSMutableArray new];
	
	for (DAHero* hero in self.profile.heroes) {
		if (hero.seasonal) {
			if (hero.hardcore)
				[seasonalHardcore addObject:hero];
			else
				[seasonalSoftcore addObject:hero];
		}
		else {
			if (hero.hardcore)
				[hardcore addObject:hero];
			else
				[softcore addObject:hero];
		}
	}
	[softcore sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
	[seasonalSoftcore sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
	[hardcore sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"dead" ascending:NO], [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
	[seasonalHardcore sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"dead" ascending:NO], [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
	
	NSMutableArray* sections = [NSMutableArray new];
	if (self.profile.lastHeroPlayed)
		[sections addObject:[[DAHeroesViewControllerSection alloc] initWithTitle:NSLocalizedString(@"Last Hero Played", nil) rows:@[self.profile.lastHeroPlayed]]];
	
	if (softcore.count > 0)
		[sections addObject:[[DAHeroesViewControllerSection alloc] initWithTitle:NSLocalizedString(@"Softcore", nil) rows:softcore]];
	if (hardcore.count > 0)
		[sections addObject:[[DAHeroesViewControllerSection alloc] initWithTitle:NSLocalizedString(@"Hardcore", nil) rows:hardcore]];
	if (seasonalSoftcore.count > 0)
		[sections addObject:[[DAHeroesViewControllerSection alloc] initWithTitle:NSLocalizedString(@"Seasonal Softcore", nil) rows:seasonalSoftcore]];
	if (seasonalHardcore.count > 0)
		[sections addObject:[[DAHeroesViewControllerSection alloc] initWithTitle:NSLocalizedString(@"Seasonal Hardcore", nil) rows:seasonalHardcore]];
	self.sections = sections;
	[self.tableView reloadData];
}

- (void) didSave:(NSNotification*) notification {
	for (id object in notification.userInfo[NSUpdatedObjectsKey]) {
		if (object == self.profile) {
			[self reload];
			return;
		}
	}
}

- (IBAction)onRefresh:(id)sender {
	NSProgress* progress = [NSProgress startProgressWithTotalUnitCount:1];
	D3APISession* session = [D3APISession sharedSession];
	NSString* battleTag = self.profile.battleTag;
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
		@autoreleasepool {
			NSDictionary* career = [session careerProfileWithBattleTag:battleTag error:nil];
			dispatch_async(dispatch_get_main_queue(), ^{
				progress.completedUnitCount = 1;
				if (career) {
					[self.profile updateWithDictionary:career];
					if ([self.profile.managedObjectContext hasChanges])
						[self.profile.managedObjectContext save:nil];
				}
				[self.refreshControl endRefreshing];
			});
		}
	});

}

@end
