//
//  DABrowserViewController.m
//  D3Assistant
//
//  Created by Artem Shimanski on 19.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import "DABrowserViewController.h"
#import "D3APISession.h"
#import "DAStorage.h"
#import "DATaskManager.h"
#import "NSProgress+DA.h"
#import "DAHeroesViewController.h"

@interface DABrowserViewController ()
@property (nonatomic, strong) DATaskManager* taskManager;
@property (nonatomic, strong) NSProgress* progress;
- (void) loadProfileWithBattleTag:(NSString*) battleTag;
- (IBAction)onClose:(id)sender;
@end

@implementation DABrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.taskManager = [[DATaskManager alloc] initWithViewController:self];

	self.title = NSLocalizedString(@"Rankings", nil);
	D3APISession* session = [D3APISession sharedSession];
	if (session) {
		NSString* urlString = [NSString stringWithFormat:@"http://%@.battle.net/d3/%@/rankings/", session.region.identifier, session.locale];
		[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
	}
	self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"goForward.png"] style:UIBarButtonItemStylePlain target:self.webView action:@selector(goForward)],
												[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"goBack.png"] style:UIBarButtonItemStylePlain target:self.webView action:@selector(goBack)]];
	[self.navigationItem.rightBarButtonItems[0] setEnabled:NO];
	[self.navigationItem.rightBarButtonItems[1] setEnabled:NO];
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", nil) style:UIBarButtonItemStylePlain target:self action:@selector(onClose:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"DAHeroesViewController"]) {
		DAHeroesViewController* controller = segue.destinationViewController;
		controller.profile = sender;
		controller.profile.lastSeen = [NSDate date];
		[controller.profile.managedObjectContext save:nil];
	}
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSArray* components = [request.URL pathComponents];
	if (components.count > 2) {
		NSString* battleTag = [[components lastObject] validBattleTagString];
		NSString* profilePath = components[components.count - 2];
		if (battleTag && [[profilePath lowercaseString] isEqualToString:@"profile"]) {
			[self loadProfileWithBattleTag:battleTag];
			return NO;
		}
	}
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	if (!self.progress)
		self.progress = [NSProgress startProgressWithTotalUnitCount:1];
	else
		self.progress.totalUnitCount++;
	
	[self.navigationItem.rightBarButtonItems[0] setEnabled:webView.canGoForward];
	[self.navigationItem.rightBarButtonItems[1] setEnabled:webView.canGoBack];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	self.progress.completedUnitCount++;
	
	[self.navigationItem.rightBarButtonItems[0] setEnabled:webView.canGoForward];
	[self.navigationItem.rightBarButtonItems[1] setEnabled:webView.canGoBack];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	/*UIAlertController* controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction* action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Close", nil) style:UIAlertActionStyleDefault handler:nil];
	[controller addAction:action];
	[self presentViewController:controller animated:YES completion:nil];*/
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

- (void) loadProfileWithBattleTag:(NSString *)battleTag {
	if (battleTag) {
		D3APISession* session = [D3APISession sharedSession];
		
		DAStorage* storage = [DAStorage sharedStorage];
		NSManagedObjectContext* managedObjectContext = storage.managedObjectContext;
		
		DAProfile* profile = [DAProfile profileWithRegion:session.region.identifier battleTag:battleTag];
		if (profile) {
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
				[self performSegueWithIdentifier:@"DAHeroesViewController" sender:profile];
			else {
				self.profile = profile;
				[self performSegueWithIdentifier:@"Unwind" sender:profile];
			}

			//[self performSegueWithIdentifier:@"DAHeroesViewController" sender:profile];
		}
		else {
			__block NSError* error = nil;
			__block NSDictionary* career;
			NSProgress* progress = [NSProgress startProgressWithTotalUnitCount:1];
			[[self taskManager] addTaskWithIndentifier:DATaskManagerIdentifierAuto
												 title:DATaskManagerDefaultTitle
												 block:^(DATask *task) {
													 career = [session careerProfileWithBattleTag:battleTag error:&error];
												 }
									 completionHandler:^(DATask *task) {
										 progress.completedUnitCount = 1;
										 if (career) {
											 DAProfile* profile = [[DAProfile alloc] initWithRegion:session.region.identifier dictionary:career insertIntoManagedObjectContext:managedObjectContext];
											 profile.lastSeen = [NSDate date];
											 NSError* error = nil;
											 [managedObjectContext save:&error];
											 if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
												 [self performSegueWithIdentifier:@"DAHeroesViewController" sender:profile];
											 else {
												 self.profile = profile;
												 [self performSegueWithIdentifier:@"Unwind" sender:profile];
											 }
										 }
										 else {
											 UIAlertController* controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
											 UIAlertAction* action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Close", nil) style:UIAlertActionStyleDefault handler:nil];
											 [controller addAction:action];
											 [self presentViewController:controller animated:YES completion:nil];
										 }
									 }];
		}
	}
}

- (IBAction)onClose:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}


@end
