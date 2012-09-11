//
//  RealmsViewController.m
//  D3Assistant
//
//  Created by Artem Shimanski on 10.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "RealmsViewController.h"
#import "AttributeCellView.h"
#import "UITableViewCell+Nib.h"
#import "UIColor+NSNumber.h"

@interface RealmsViewController ()
@property (nonatomic, strong) NSArray* realms;
- (IBAction)onCancel:(id)sender;
@end

@implementation RealmsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"Select your Region";
	self.realms = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"realms" ofType:@"plist"]];
	
	if ([[NSUserDefaults standardUserDefaults] valueForKey:@"realm"])
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(onCancel:)];

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.realms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	//AttributeCellView *cell = (AttributeCellView*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		//cell = [AttributeCellView cellWithNibName:@"AttributeCellView" bundle:nil reuseIdentifier:CellIdentifier];
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		cell.textLabel.textColor = [UIColor colorWithNumber: @(HeroSCNameColor)];
		cell.detailTextLabel.textColor = [UIColor whiteColor];
		cell.indentationLevel = 2;
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
	NSDictionary* realm = [self.realms objectAtIndex:indexPath.row];
	cell.textLabel.text = [realm valueForKey:@"name"];
	cell.detailTextLabel.text = [[realm valueForKey:@"url"] stringByReplacingOccurrencesOfString:@"http://" withString:@""];
	NSDictionary* currentRealm = [[NSUserDefaults standardUserDefaults] valueForKey:@"realm"];
	cell.accessoryType = [[currentRealm valueForKey:@"url"] isEqualToString:[realm valueForKey:@"url"]] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[[NSUserDefaults standardUserDefaults] setValue:[self.realms objectAtIndex:indexPath.row] forKey:@"realm"];
	[[NSNotificationCenter defaultCenter] postNotificationName:DidChangeRealmNotification object:nil];
	[self dismissModalViewControllerAnimated:YES];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Private

- (IBAction)onCancel:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

@end
