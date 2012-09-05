//
//  ProfilesViewController.m
//  D3Assistant
//
//  Created by Artem Shimanski on 04.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "ProfilesViewController.h"
#import "EUOperationQueue.h"
#import "DiabloAPISession.h"
#import "HeroCellView.h"
#import "ProfileHeaderView.h"
#import "UITableViewCell+Nib.h"
#import "UIView+Nib.h"

@interface ProfilesViewController ()
@property (nonatomic, strong) NSDictionary* searchResults;
@property (nonatomic, strong) NSMutableArray* profiles;
@end

@implementation ProfilesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
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
    return tableView == self.searchDisplayController.searchResultsTableView ? (self.searchResults ? 1 : 0) : self.profiles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return tableView == self.searchDisplayController.searchResultsTableView ? [[self.searchResults valueForKey:@"heroes"] count] : [[[self.profiles objectAtIndex:section] valueForKey:@"heroes"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HeroCellView";
    HeroCellView *cell = (HeroCellView*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
		cell = [HeroCellView cellWithNibName:@"HeroCellView" bundle:nil reuseIdentifier:CellIdentifier];
	NSDictionary* profile = tableView == self.searchDisplayController.searchResultsTableView ? self.searchResults : [self.profiles objectAtIndex:indexPath.section];
	NSDictionary* hero = [[profile valueForKey:@"heroes"] objectAtIndex:indexPath.row];
	
	for (UILabel* label in cell.nameLabels)
		label.text = [hero valueForKey:@"name"];
	
	cell.levelLabel.text = [NSString stringWithFormat:@"%@", [hero valueForKey:@"level"]];
	cell.paragonLevelLabel.text = [NSString stringWithFormat:@"%@", [hero valueForKey:@"paragonLevel"]];
	cell.classLabel.text = [NSString stringWithFormat:@"%@ %@", [[hero valueForKey:@"class"] capitalizedString], [[hero valueForKey:@"hardcore"] boolValue] ? @"(Hardcore)" : @""];
	
	cell.avatarImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@.png", [hero valueForKey:@"class"], [hero valueForKey:@"gender"]]];
    // Configure the cell...
    
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
	ProfileHeaderView* view = [ProfileHeaderView viewWithNibName:@"ProfileHeaderView" bundle:nil];
	NSDictionary* profile = tableView == self.searchDisplayController.searchResultsTableView ? self.searchResults : [self.profiles objectAtIndex:section];
	view.battleTagLabel.text = [profile valueForKey:@"battleTag"];
	return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 30;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 116;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	NSString* text = searchBar.text;
	__block __weak EUOperation* operation = [EUOperation operationWithIdentifier:@"Search" name:@"Searching"];
	
	__block NSError* error = nil;
	__block NSDictionary* resultTmp = nil;
	
	[operation addExecutionBlock:^{
		@autoreleasepool {
			DiabloAPISession* session = [[DiabloAPISession alloc] initWithHost:@"http://eu.battle.net" locale:[[NSLocale currentLocale] localeIdentifier]];
			resultTmp = [session careerProfileWithBattleTag:text error:&error];
			operation.progress = 1;
		}
	}];
	
	[operation setCompletionBlockInCurrentThread:^{
		if (![operation isCancelled]) {
			if (resultTmp) {
				self.searchResults = resultTmp;
				[self.searchDisplayController.searchResultsTableView reloadData];
				[self.tableView reloadData];
			}
		}
	}];
	
	[[EUOperationQueue sharedQueue] addOperation:operation];
}

#pragma mark UISearchDisplayControllerDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	return NO;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)aTableView {
	aTableView.backgroundColor = [UIColor clearColor];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		aTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
		aTableView.backgroundView.contentMode = UIViewContentModeTopLeft;
	}
	else
		aTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
	aTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

@end
