//
//  D3APISession.m
//  D3Assistant
//
//  Created by Artem Shimanski on 04.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "D3APISession.h"

static D3APISession* sharedSession;

@interface D3APISession()
@property (nonatomic, strong, readwrite) NSString* locale;
@property (nonatomic, strong, readwrite) D3APIRegion* region;

- (NSDictionary*) sendRequestWithPath:(NSString*) path error:(NSError* __autoreleasing*) error;

@end

@implementation D3APISession

+ (instancetype) sharedSession {
	@synchronized(self) {
		return sharedSession;
	}
}

+ (void) setSharedSession: (D3APISession*) session {
	@synchronized(self) {
		sharedSession = session;
		[[NSNotificationCenter defaultCenter] postNotificationName:DADidChangeRegionNotification object:nil];
	}
}


- (id) initWithRegion:(D3APIRegion*) region locale:(NSString*) locale {
	if (self = [super init]) {
		self.region = region;
		self.locale = locale;
	}
	return self;
}

- (NSDictionary*) careerProfileWithBattleTag:(NSString*) battleTag error:(NSError* __autoreleasing*) error {
	return [self sendRequestWithPath:[NSString stringWithFormat:@"profile/%@/index", [battleTag validBattleTagURLString]] error:error];
}

- (NSDictionary*) heroProfileWithBattleTag:(NSString*) battleTag heroID:(int32_t) heroID error:(NSError* __autoreleasing*) error {
	return [self sendRequestWithPath:[NSString stringWithFormat:@"profile/%@/hero/%d", [battleTag validBattleTagURLString], heroID] error:error];
}

- (NSDictionary*) itemInfoWithItemID:(NSString*) itemID error:(NSError* __autoreleasing*) error {
	if ([itemID hasPrefix:@"item/"])
		itemID = [itemID substringFromIndex:5];
	return [self sendRequestWithPath:[NSString stringWithFormat:@"data/item/%@", itemID] error:error];
}

- (NSDictionary*) followerInfoWithFollowerType:(NSString*) followerType error:(NSError* __autoreleasing*) error {
	return [self sendRequestWithPath:[NSString stringWithFormat:@"data/follower/%@", followerType] error:error];
}

- (NSDictionary*) artisanInfoWithArtisanType:(NSString*) artisanType error:(NSError* __autoreleasing*) error {
	return [self sendRequestWithPath:[NSString stringWithFormat:@"data/artisan/%@", artisanType] error:error];
}

- (UIImage*) profileImageWithClass:(NSString*) className gender:(NSInteger) gender {
	return nil;
}

- (NSURL*) itemImageURLWithItem:(NSString*) item size:(NSString*) size {
	return [NSURL URLWithString:[NSString stringWithFormat:@"http://eu.media.blizzard.com/d3/icons/items/%@/%@.png", size, item]];
}

- (NSURL*) skillImageURLWithItem:(NSString*) item size:(NSString*) size {
	return [NSURL URLWithString:[NSString stringWithFormat:@"http://eu.media.blizzard.com/d3/icons/skills/%@/%@.png", size, item]];
}

#pragma mark - Private

- (NSDictionary*) sendRequestWithPath:(NSString*) path error:(NSError* __autoreleasing*) error {
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/d3/%@%@", self.region.host, path, (self.locale ? [NSString stringWithFormat:@"?locale=%@", self.locale] : @"")]];
	
	NSHTTPURLResponse* response = nil;
	NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url] returningResponse:&response error:error];
	if (data) {
		NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
		
		if ([result isKindOfClass:[NSDictionary class]]) {
			NSString* reason = [result valueForKey:@"reason"];
			if (reason) {
				if (error)
					*error = [NSError errorWithDomain:@"D3" code:0 userInfo:@{NSLocalizedDescriptionKey: reason}];
				return nil;
			}
			return result;
		}
		else if (error) {
			NSString* s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
			if (s)
				*error = [NSError errorWithDomain:@"D3" code:0 userInfo:@{NSLocalizedDescriptionKey: s}];
		}
		return nil;
	}
	return nil;
}

@end
