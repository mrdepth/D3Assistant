//
//  NSString+DA.h
//  D3Assistant
//
//  Created by Artem Shimanski on 13.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DA)
- (void) enumerateNumbersInRange:(NSRange)range usingBlock:(void (^)(NSString* string, NSRange range, BOOL* stop))block;

@end
