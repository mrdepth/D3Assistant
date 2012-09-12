//
//  AppDelegate.m
//  D3Assistant
//
//  Created by Artem Shimanski on 05.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "AppDelegate.h"
#import "ProfilesViewController.h"
#import "EUOperationQueue.h"
#import "EUActivityView.h"
#import "UIAlertView+Error.h"

@interface AppDelegate()
@property (nonatomic, strong) UIView* donationActivityView;

- (void) completeTransaction: (SKPaymentTransaction *)transaction;
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;
- (void) failedTransaction: (SKPaymentTransaction *)transaction;

@end

@implementation AppDelegate
@synthesize donationActivityView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	EUActivityView* activityView = [[EUActivityView alloc] initWithFrame:self.window.rootViewController.view.bounds];
	[self.window.rootViewController.view addSubview:activityView];
	[self.window makeKeyAndVisible];
	[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
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
	SKPayment *payment = [SKPayment paymentWithProductIdentifier:productID];
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
