//
//  AppDelegate.m
//  D3Assistant
//
//  Created by Artem Shimanski on 05.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "AppDelegate.h"
#import "UIAlertView+Error.h"
#import "D3APISession.h"
#import "Flurry.h"

@interface AppDelegate()<UISplitViewControllerDelegate>
@property (nonatomic, strong) UIView* donationActivityView;
@property (nonatomic, strong) UIViewController* activityViewController;

- (void) completeTransaction: (SKPaymentTransaction *)transaction;
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;
- (void) failedTransaction: (SKPaymentTransaction *)transaction;

@property (nonatomic, strong) UIViewController* ctrl;

@end

@implementation AppDelegate
@synthesize donationActivityView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#if !TARGET_IPHONE_SIMULATOR
	[Flurry setCrashReportingEnabled:YES];
	[Flurry startSession:@"TVQZ6RVBYXCMZ9G4YGFP"];
#endif

	application.statusBarStyle = UIStatusBarStyleLightContent;
	//EUActivityView* activityView = [[EUActivityView alloc] initWithFrame:self.window.rootViewController.view.bounds];
	UISplitViewController* controller = (UISplitViewController*) self.window.rootViewController;
	controller.delegate = self;
	if (controller.displayMode != UISplitViewControllerDisplayModeAllVisible)
		[[controller.viewControllers[1] viewControllers][0] navigationItem].leftBarButtonItem = controller.displayModeButtonItem;

	//controller.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryOverlay;
	
	[self.window makeKeyAndVisible];
	//[self.window addSubview:activityView];
	self.activityViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"DAActivityViewController"];
	self.activityViewController.view.frame = self.window.bounds;
	[self.window addSubview:self.activityViewController.view];
	
	[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	
	D3APIRegion* region = [D3APIRegion regionWithIdentifier:[[NSUserDefaults standardUserDefaults] valueForKey:DASettingsRegionKey]];
	if (!region) {
		UIAlertController* alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Choose your region", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
		for (D3APIRegion* region in [D3APIRegion allRegions]) {
			UIAlertAction* action = [UIAlertAction actionWithTitle:region.name style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
				D3APISession* session = [[D3APISession alloc] initWithRegion:region locale:[NSLocale preferredLanguages][0]];
				[D3APISession setSharedSession:session];
				[[NSUserDefaults standardUserDefaults] setValue:region.identifier forKey:DASettingsRegionKey];
			}];
			[alertController addAction:action];
		}
		[self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
	}
	else {
		D3APISession* session = [[D3APISession alloc] initWithRegion:region locale:[NSLocale preferredLanguages][0]];
		[D3APISession setSharedSession:session];
	}
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (NSString*) documentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

- (void) donate:(NSString*) productID {
	self.donationActivityView.hidden = NO;
	
	SKPaymentQueue *paymentQueue = [SKPaymentQueue defaultQueue];
	[paymentQueue addTransactionObserver:self];
	SKMutablePayment* payment = [[SKMutablePayment alloc] init];
	payment.productIdentifier = productID;
	payment.quantity = 1;
	[paymentQueue addPayment:payment];
}

#pragma mark SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
	for (SKPaymentTransaction *transaction in transactions)
	{
		switch (transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchased:
				[self completeTransaction:transaction];
				break;
			case SKPaymentTransactionStateFailed:
				[self failedTransaction:transaction];
				break;
			case SKPaymentTransactionStateRestored:
				[self restoreTransaction:transaction];
			default:
				break;
		}
	}
}

#pragma mark - UISplitViewControllerDelegate

- (BOOL)splitViewController:(UISplitViewController *)splitViewController showDetailViewController:(UIViewController *)vc sender:(id)sender {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		UINavigationController* navigationController = [[splitViewController.viewControllers[0] childViewControllers] lastObject];
		[navigationController pushViewController:vc animated:YES];
		return YES;
	}
	else
		return NO;
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
		return YES;
	else
		return NO;
}

- (void) splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode {
	if (displayMode == UISplitViewControllerDisplayModeAllVisible) {
		[[svc.viewControllers[1] viewControllers][0] navigationItem].leftBarButtonItem = nil;
	}
	else
		[[svc.viewControllers[1] viewControllers][0] navigationItem].leftBarButtonItem = svc.displayModeButtonItem;
}

#pragma mark - Private

- (UIView*) donationActivityView {
	if (!donationActivityView) {
		donationActivityView = [[UIView alloc] initWithFrame:self.window.bounds];
		donationActivityView.opaque = NO;
		donationActivityView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
		UIActivityIndicatorView* activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		activityIndicator.center = CGPointMake(donationActivityView.frame.size.width / 2, donationActivityView.frame.size.height / 2);
		[donationActivityView addSubview:activityIndicator];
		[activityIndicator startAnimating];
		donationActivityView.hidden = YES;
		[self.window addSubview:donationActivityView];
	}
	return donationActivityView;
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Thanks for the donation" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alertView show];
	[self.donationActivityView removeFromSuperview];
	self.donationActivityView = nil;
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Thanks for the donation" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alertView show];
	[self.donationActivityView removeFromSuperview];
	self.donationActivityView = nil;
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled) {
        [[UIAlertView alertViewWithError:transaction.error] show];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	[self.donationActivityView removeFromSuperview];
	self.donationActivityView = nil;
}


@end
