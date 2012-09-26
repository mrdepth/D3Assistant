//
//  EUActivityView.m
//  EUOperationQueue
//
//  Created by Artem Shimanski on 28.08.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "EUActivityView.h"
#import <QuartzCore/QuartzCore.h>

@interface EUActivityView()
@property (nonatomic, retain) UIView* contentView;
@property (nonatomic, retain) UIActivityIndicatorView* activityIndicatorView;
@property (nonatomic, retain) UILabel* activityNameLabel;
@property (nonatomic, retain) UIProgressView* progressView;
@property (nonatomic, retain) NSMutableArray* operations;
- (void) layout;
- (void) setup;
@end

@implementation EUActivityView
@synthesize contentView;
@synthesize activityIndicatorView;
@synthesize activityNameLabel;
@synthesize progressView;
@synthesize operations;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		[self setup];
    }
    return self;
}

- (void) dealloc {
	[[EUOperationQueue sharedQueue] setDelegate:nil];
#if ! __has_feature(objc_arc)
	[contentView release];
	[activityIndicatorView release];
	[activityNameLabel release];
	[progressView release];
	[operations release];
	[super dealloc];
#endif
}

- (void) didMoveToSuperview {
	
}

- (void) layoutSubviews {
	[super layoutSubviews];
	[self layout];
}


#pragma mark - Private

- (void) layout {
	CGSize labelSize = [self.activityNameLabel sizeThatFits:CGSizeMake(self.bounds.size.width - 20, self.activityNameLabel.frame.size.height)];
	CGRect frame = self.contentView.frame;
	
	if (labelSize.width < 128 - 20)
		labelSize.width = 128 - 20;
	frame.size.width = labelSize.width + 20;
	frame.origin.x = self.frame.size.width / 2 - frame.size.width / 2;
	self.contentView.frame = frame;
}

- (void) setup {
	self.userInteractionEnabled = NO;
	[[EUOperationQueue sharedQueue] setDelegate:self];
	self.operations = [NSMutableArray array];
	self.alpha = 0;
	self.hidden = YES;

	self.opaque = NO;
	self.backgroundColor = [UIColor clearColor];
	self.backgroundColor = [UIColor clearColor];
	
	CGSize size = CGSizeMake(128, 128);
	
#if ! __has_feature(objc_arc)
	self.contentView = [[[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2 - size.width / 2, self.bounds.size.height / 2 - size.height / 2, size.width, size.height)] autorelease];
#else
	self.contentView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2 - size.width / 2, self.bounds.size.height / 2 - size.height / 2, size.width, size.height)];
#endif
	
	self.contentView.opaque = NO;
	self.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
	self.contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	self.contentView.layer.cornerRadius = 10;
	[self addSubview:self.contentView];

#if ! __has_feature(objc_arc)
	self.activityIndicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
#else
	self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
#endif
	
	self.activityIndicatorView.center = CGPointMake(size.width / 2, 64);
	self.activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	[self.activityIndicatorView startAnimating];
	[self.contentView addSubview:self.activityIndicatorView];
	
#if ! __has_feature(objc_arc)
	self.activityNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 16, size.width - 20, 21)] autorelease];
#else
	self.activityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 16, size.width - 20, 21)];
#endif
	
	self.activityNameLabel.backgroundColor = [UIColor clearColor];
	self.activityNameLabel.opaque = NO;
	self.activityNameLabel.textAlignment = UITextAlignmentCenter;
	self.activityNameLabel.textColor = [UIColor whiteColor];
	self.activityNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
	[self.contentView addSubview:self.activityNameLabel];
	
#if ! __has_feature(objc_arc)
	self.progressView = [[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault] autorelease];
#else
	self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
#endif
	
	self.progressView.frame = CGRectMake(10, 64 + 32, size.width - 20, self.progressView.frame.size.height);
	self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
	[self.contentView addSubview:self.progressView];
}

#pragma mark - EUOperationQueueDelegate

- (void) operationQueue:(EUOperationQueue*) operationQueue didStartOperation:(EUOperation*)operation {
	if (self.operations.count == 0) {
		self.hidden = NO;
		[UIView animateWithDuration:0.5
							  delay:0
							options:UIViewAnimationOptionBeginFromCurrentState
						 animations:^{
							 self.alpha = 1;
						 }
						 completion:nil];

		self.activityNameLabel.text = operation.operationName;
		self.progressView.progress = operation.progress;
		[self layout];
	}
	
	[self.operations addObject:operation];
}

- (void) operationQueue:(EUOperationQueue*) operationQueue didFinishOperation:(EUOperation*)operation {
	if (self.operations.count > 0) {
		EUOperation* activeOperation = [self.operations objectAtIndex:0];
		[self.operations removeObject:operation];
		if (operation == activeOperation) {
			if (self.operations.count > 0) {
				activeOperation = [self.operations objectAtIndex:0];
				self.activityNameLabel.text = activeOperation.operationName;
				self.progressView.progress = activeOperation.progress;
				
				[UIView animateWithDuration:0.25
									  delay:0
									options:UIViewAnimationOptionBeginFromCurrentState
								 animations:^{
									 [self layout];
								 }
								 completion:nil];

			}
			else {
				[UIView animateWithDuration:0.5
									  delay:0
									options:UIViewAnimationOptionBeginFromCurrentState
								 animations:^{
									 self.alpha = 0;
								 }
								 completion:^(BOOL finished) {
									 if (finished)
										 self.hidden = YES;
								 }];
			}
		}
	}
}

- (void) operationQueue:(EUOperationQueue*) operationQueue didUpdateOperation:(EUOperation*)operation withProgress:(float) progress {
	if (self.operations.count > 0 && operation == [self.operations objectAtIndex:0])
		self.progressView.progress = operation.progress;

}

@end
