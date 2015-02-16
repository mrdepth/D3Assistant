//
//  DABannerView.m
//  D3Assistant
//
//  Created by Artem Shimanski on 20.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import "DABannerView.h"
#import "GADBannerView.h"

@interface DABannerView()<GADBannerViewDelegate>
@property (nonatomic, assign) BOOL hasAds;
@property (nonatomic, strong) IBOutlet GADBannerView* gadBannerView;

@end

@implementation DABannerView

- (void) awakeFromNib {
	self.hasAds = NO;
	//return;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		//self.gadBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:CGPointMake(0, 0)];
		self.gadBannerView = [[GADBannerView alloc] initWithAdSize:GADAdSizeFromCGSize(CGSizeMake(320, 50)) origin:CGPointMake(0, 0)];
	else
		self.gadBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait origin:CGPointMake(0, 0)];
	self.gadBannerView.adSize = kGADAdSizeSmartBannerPortrait;
	self.gadBannerView.rootViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
	self.gadBannerView.adUnitID = @"ca-app-pub-0434787749004673/1971969344";
	self.gadBannerView.delegate = self;
	[self addSubview:self.gadBannerView];
	
	GADRequest *request = [GADRequest request];
	request.testDevices = @[GAD_SIMULATOR_ID];
	[self.gadBannerView loadRequest:request];
}

- (CGSize) intrinsicContentSize {
	if (self.hasAds) {
		CGSize size = CGSizeFromGADAdSize(self.gadBannerView.adSize);
		return size;
	}
	else
		return CGSizeZero;
}

#pragma mark - GADBannerViewDelegate

- (void)adViewDidReceiveAd:(GADBannerView *)view {
	self.hasAds = YES;
	[self invalidateIntrinsicContentSize];
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
	self.hasAds = NO;
	[self invalidateIntrinsicContentSize];
}

@end
