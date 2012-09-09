//
//  D3Utility.h
//  D3Assistant
//
//  Created by Artem Shimanski on 06.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface D3Utility : NSObject

+ (float) progressionWithProfile:(NSDictionary*) profile hardcore:(BOOL) hardcore;
+ (UIColor*) itemBorderColorWithColorName:(NSString*) colorName highlighted:(BOOL) highlighted;
+ (UIColor*) colorWithColorName:(NSString*) colorName;

@end
