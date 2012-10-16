//
//  ProfilesStorage.m
//  D3Assistant
//
//  Created by Artem Shimanski on 16.10.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "ProfilesStorage.h"
#import "AppDelegate.h"
#import "EUOperationQueue.h"
#import "D3APISession.h"
#import "NSArray+DeepMutableCopy.h"
#import "NSDictionary+DeepMutableCopy.h"

static ProfilesStorage* sharedStorage;

@interface ProfilesStorage()
@property (nonatomic, retain) NSMutableDictionary* realms;

- (NSString*) profilesFilePathWithRealm:(NSString*) realm;
- (NSMutableArray*) loadRealm:(NSString*) realm;
- (void) didChangeRealm:(NSNotification*) notification;

@end

@implementation ProfilesStorage
@synthesize realms;

+ (ProfilesStorage*) sharedStorage {
	@synchronized(self) {
		if (!sharedStorage) {
			sharedStorage = [[ProfilesStorage alloc] init];
		}
	}
	return sharedStorage;
}

- (id) init {
	if (self = [super init]) {
		self.realms = [NSMutableDictionary dictionary];
		NSDictionary* realm = [[NSUserDefaults standardUserDefaults] valueForKey:@"realm"];
		if (realm)
			[D3APISession setSharedSession:[[D3APISession alloc] initWithHost:[realm valueForKey:@"url"] locale:[[NSLocale preferredLanguages] objectAtIndex:0]]];

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeRealm:) name:DidChangeRealmNotification object:nil];
	}
	return self;
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:DidChangeRealmNotification object:nil];
}

- (NSArray*) profiles {
	@synchronized(self) {
		NSString* realm = [[[NSUserDefaults standardUserDefaults] valueForKey:@"realm"] valueForKey:@"name"];
		NSMutableArray* profiles = [self.realms valueForKey:realm];
		if (!profiles) {
			profiles =  [self loadRealm:realm];
			[self.realms setValue:profiles forKey:realm];
		}
		return profiles;
	}
}

- (NSInteger) addProfile:(NSDictionary*) profile {
	@synchronized(self) {
		NSString* battleTag = [profile valueForKey:@"battleTag"];
		NSMutableArray* profiles = (NSMutableArray*) [self profiles];
		
		NSInteger i = 0;
		for (NSDictionary* profile in self.profiles) {
			NSComparisonResult result = [[profile valueForKey:@"battleTag"] compare:battleTag options:NSCaseInsensitivePredicateOption];
			if (result == NSOrderedSame)
				return NSNotFound;
			else if (result == NSOrderedDescending) {
				break;
			}
			i++;
		}
		[profiles insertObject:profile atIndex:i];

		NSString* realm = [[[NSUserDefaults standardUserDefaults] valueForKey:@"realm"] valueForKey:@"name"];
		[profiles writeToFile:[self profilesFilePathWithRealm:realm] atomically:YES];
		return i;
	}
}

- (NSInteger) removeProfile:(NSDictionary*) profile {
	@synchronized(self) {
		NSString* battleTag = [profile valueForKey:@"battleTag"];
		NSMutableArray* profiles = (NSMutableArray*) [self profiles];
		
		NSInteger i = 0;
		for (NSDictionary* profile in self.profiles) {
			if ([[profile valueForKey:@"battleTag"] compare:battleTag options:NSCaseInsensitivePredicateOption] == NSOrderedSame) {
				break;
			}
			i++;
		}
		if (i < self.profiles.count) {
			[profiles removeObjectAtIndex:i];
			NSString* realm = [[[NSUserDefaults standardUserDefaults] valueForKey:@"realm"] valueForKey:@"name"];
			[profiles writeToFile:[self profilesFilePathWithRealm:realm] atomically:YES];
			return i;
		}
		else
			return NSNotFound;
	}
}

#pragma mark - Private

- (NSString*) profilesFilePathWithRealm:(NSString*) realm {
	return [[AppDelegate documentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"profiles%@.plist", realm]];
}

- (NSMutableArray*) loadRealm:(NSString*) realm {
	@synchronized(self) {
		NSMutableArray* profiles = [NSMutableArray arrayWithContentsOfFile:[self profilesFilePathWithRealm:realm]];
		if (profiles) {
			NSArray* profilesCopy = [NSArray arrayWithArray:profiles];
			__block __weak EUOperation* operation = [EUOperation operationWithIdentifier:[NSString stringWithFormat:@"ProfilesStorage+%@", realm] name:@"Updating"];
			
			NSMutableArray* profilesTmp = [NSMutableArray array];
			
			[operation addExecutionBlock:^{
				@autoreleasepool {
					operation.progress = 0;
					D3APISession* session = [D3APISession sharedSession];
					
					NSInteger n = profilesCopy.count;
					NSInteger i = 0;
					for (NSMutableDictionary* profile in profilesCopy) {
						NSDictionary* result = [session careerProfileWithBattleTag:[profile valueForKey:@"battleTag"] error:nil];
						if (result) {
							NSMutableDictionary* profileTmp = [result deepMutableCopy];
							[profileTmp setValue:@(YES) forKey:@"inFavorites"];
							
							NSArray* sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"hardcore" ascending:YES],
							[NSSortDescriptor sortDescriptorWithKey:@"level" ascending:NO],
							[NSSortDescriptor sortDescriptorWithKey:@"paragonLevel" ascending:NO],
							[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
							
							[[profileTmp valueForKey:@"heroes"] sortUsingDescriptors:sortDescriptors];
							[[profileTmp valueForKey:@"fallenHeroes"] sortUsingDescriptors:sortDescriptors];
							[profilesTmp addObject:profileTmp];
						}
						else
							[profilesTmp addObject:profile];
						
						operation.progress = (float) ++i / (float) n;
					}
				}
			}];
			
			[operation setCompletionBlockInCurrentThread:^{
				if (![operation isCancelled]) {
					@synchronized(self) {
						for (NSDictionary* profile in profilesTmp) {
							NSString* battleTag = [profile valueForKey:@"battleTag"];
							NSInteger index = 0;
							for (NSDictionary* item in profiles) {
								if ([[item valueForKey:@"battleTag"] isEqualToString:battleTag]) {
									[profiles replaceObjectAtIndex:index withObject:profile];
									break;
								}
								index++;
							}
						}
					}
					[profiles writeToFile:[self profilesFilePathWithRealm:realm] atomically:YES];
					[[NSNotificationCenter defaultCenter] postNotificationName:DidUpdateProfilesNotification object:nil];
				}
			}];
			
			[[EUOperationQueue sharedQueue] addOperation:operation];
		}
		else
			profiles = [NSMutableArray array];
		[self.realms setValue:profiles forKey:realm];
		return profiles;
	}
}

- (void) didChangeRealm:(NSNotification*) notification {
	NSDictionary* realm = [[NSUserDefaults standardUserDefaults] valueForKey:@"realm"];
	if (!realm)
		return;
	[D3APISession setSharedSession:[[D3APISession alloc] initWithHost:[realm valueForKey:@"url"] locale:[[NSLocale preferredLanguages] objectAtIndex:0]]];
}

@end
