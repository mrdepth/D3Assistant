//
//  UIColor+DA.h
//  D3Assistant
//
//  Created by Artem Shimanski on 01.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (DA)

+ (UIColor*) attributeTextColorWithName:(NSString*) name;
+ (UIColor*) attributeValueColorWithName:(NSString*) name;
+ (UIColor*) itemColorWithName:(NSString*) name;
+ (UIColor*) paragonColor;
@end
