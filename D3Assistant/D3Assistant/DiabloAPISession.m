//
//  DiabloAPISession.m
//  D3Assistant
//
//  Created by Artem Shimanski on 04.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import "DiabloAPISession.h"
#import "SBJSON.h"

@interface DiabloAPISession()

- (NSDictionary*) sendRequestWithPath:(NSString*) path error:(NSError* __autoreleasing*) error;

@end

@implementation DiabloAPISession

- (id) initWithHost:(NSString*) host locale:(NSString*) locale {
	if (self = [super init]) {
		self.host = host;
		self.locale = locale;
	}
	return self;
}

- (NSDictionary*) careerProfileWithBattleTag:(NSString*) battleTag error:(NSError* __autoreleasing*) error {
	return [self sendRequestWithPath:[NSString stringWithFormat:@"profile/%@/", [battleTag stringByReplacingOccurrencesOfString:@"#" withString:@"-"]] error:error];
}

- (NSDictionary*) heroProfileWithBattleTag:(NSString*) battleTag heroID:(NSInteger) heroID error:(NSError* __autoreleasing*) error {
	return [self sendRequestWithPath:[NSString stringWithFormat:@"profile/%@/hero/%d", [battleTag stringByReplacingOccurrencesOfString:@"#" withString:@"-"], heroID] error:error];
}

- (NSDictionary*) itemInfoWithItemID:(NSString*) itemID error:(NSError* __autoreleasing*) error {
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

- (NSURL*) itemImageURLWithItem:(NSString*) item {
	return [NSURL URLWithString:[NSString stringWithFormat:@"http://us.media.blizzard.com/d3/icons/items/large/%@.png", item]];
}

#pragma mark - Private

- (NSDictionary*) sendRequestWithPath:(NSString*) path error:(NSError* __autoreleasing*) error {
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/d3/%@%@", self.host, path, (self.locale ? [NSString stringWithFormat:@"?locale=%@", self.locale] : @"")]];
	
	NSHTTPURLResponse* response = nil;
	NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url] returningResponse:&response error:error];
	if (data) {
		NSString* s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		SBJsonParser* parser = [[SBJsonParser alloc] init];
		NSDictionary* result = [parser objectWithString:s];
		
		if ([result isKindOfClass:[NSDictionary class]]) {
			NSString* reason = [result valueForKey:@"reason"];
			if (reason) {
				if (error)
					*error = [NSError errorWithDomain:@"D3" code:0 userInfo:@{NSLocalizedDescriptionKey: reason}];
				return nil;
			}
			return result;
		}
		else if (error)
			*error = [NSError errorWithDomain:@"D3" code:0 userInfo:@{NSLocalizedDescriptionKey: s}];
		return nil;
	}
	return nil;
}

@end
