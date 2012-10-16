//
//  D3APISession.h
//  D3Assistant
//
//  Created by Artem Shimanski on 04.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+D3API.h"
#import "D3Utility.h"

@interface D3APISession : NSObject
@property (nonatomic, strong) NSString* host;
@property (nonatomic, strong) NSString* locale;
@property (nonatomic, strong) NSString* realm;

+ (id) sharedSession;
+ (void) setSharedSession: (D3APISession*) session;

- (id) initWithHost:(NSString*) host locale:(NSString*) locale;
- (NSDictionary*) careerProfileWithBattleTag:(NSString*) battleTag error:(NSError* __autoreleasing*) error;
- (NSDictionary*) heroProfileWithBattleTag:(NSString*) battleTag heroID:(NSInteger) heroID error:(NSError* __autoreleasing*) error;
- (NSDictionary*) itemInfoWithItemID:(NSString*) itemID error:(NSError* __autoreleasing*) error;
- (NSDictionary*) followerInfoWithFollowerType:(NSString*) followerType error:(NSError* __autoreleasing*) error;
- (NSDictionary*) artisanInfoWithArtisanType:(NSString*) artisanType error:(NSError* __autoreleasing*) error;

- (UIImage*) profileImageWithClass:(NSString*) className gender:(NSInteger) gender;
- (NSURL*) itemImageURLWithItem:(NSString*) item size:(NSString*) size;
- (NSURL*) skillImageURLWithItem:(NSString*) skill size:(NSString*) size;
@end
