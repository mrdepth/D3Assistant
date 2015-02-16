//
//  D3APIRegion.m
//  D3Assistant
//
//  Created by Artem Shimanski on 26.11.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import "D3APIRegion.h"

@interface D3APIRegion()
@property (nonatomic, strong, readwrite) NSString* name;
@property (nonatomic, strong, readwrite) NSString* identifier;
@property (nonatomic, strong, readwrite) NSString* host;

- (id) initWithName:(NSString*) name identifier:(NSString*) identifier host:(NSString*) host;
@end

@implementation D3APIRegion

- (id) initWithName:(NSString*) name identifier:(NSString*) identifier host:(NSString*) host {
	if (self = [super init]) {
		self.name = name;
		self.identifier = identifier;
		self.host = host;
	}
	return self;
}

+ (NSArray*) allRegions {
	return @[[[D3APIRegion alloc] initWithName:NSLocalizedString(@"Americas", nil) identifier:@"US" host:@"us.battle.net"],
			 [[D3APIRegion alloc] initWithName:NSLocalizedString(@"Europe", nil) identifier:@"EU" host:@"eu.battle.net"],
			 [[D3APIRegion alloc] initWithName:NSLocalizedString(@"Asia", nil) identifier:@"TW" host:@"tw.battle.net"],
			 [[D3APIRegion alloc] initWithName:NSLocalizedString(@"Korea", nil) identifier:@"KR" host:@"kr.battle.net"]];
}

+ (instancetype) regionWithIdentifier:(NSString*) identifier {
	for (D3APIRegion* region in [self allRegions]) {
		if ([region.identifier isEqualToString:identifier])
			return region;
	}
	return nil;
}


@end
