//
//  NSProgress+DA.m
//  D3Assistant
//
//  Created by Artem Shimanski on 18.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import "NSProgress+DA.h"
#import "AppDelegate.h"
#import "DAActivityViewController.h"

@interface AppDelegate()
@property (nonatomic, strong) DAActivityViewController* activityViewController;
@end

@implementation NSProgress (DA)

+ (instancetype) mainProgress {
	DAActivityViewController* activityViewController = [(AppDelegate*) [[UIApplication sharedApplication] delegate] activityViewController];
	return activityViewController.progress;
}

+ (instancetype) startProgressWithTotalUnitCount:(int64_t)unitCount {
	NSProgress* mainProgress = [self mainProgress];
	mainProgress.totalUnitCount += unitCount;
	[mainProgress becomeCurrentWithPendingUnitCount:unitCount];
	NSProgress* progress = [NSProgress progressWithTotalUnitCount:unitCount];
	[mainProgress resignCurrent];
	return progress;
}

@end
