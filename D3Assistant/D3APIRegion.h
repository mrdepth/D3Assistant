//
//  D3APIRegion.h
//  D3Assistant
//
//  Created by Artem Shimanski on 26.11.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface D3APIRegion : NSObject
@property (nonatomic, strong, readonly) NSString* name;
@property (nonatomic, strong, readonly) NSString* identifier;
@property (nonatomic, strong, readonly) NSString* host;

+ (NSArray*) allRegions;
+ (instancetype) regionWithIdentifier:(NSString*) identifier;
@end
