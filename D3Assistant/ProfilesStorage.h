//
//  ProfilesStorage.h
//  D3Assistant
//
//  Created by Artem Shimanski on 16.10.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DidUpdateProfilesNotification @"DidUpdateProfilesNotification"

@interface ProfilesStorage : NSObject
@property (nonatomic, readonly) NSArray* profiles;
+ (ProfilesStorage*) sharedStorage;
- (NSInteger) addProfile:(NSDictionary*) profile;
- (NSInteger) removeProfile:(NSDictionary*) profile;
@end
