//
//  GearAttributesViewController.h
//  D3Assistant
//
//  Created by Artem Shimanski on 18.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttributesViewController.h"
#import "GearViewController.h"

@interface GearAttributesViewController : UIViewController
@property (nonatomic, strong) AttributesViewController* attributesViewController;
@property (nonatomic, strong) GearViewController* gearViewController;

@end
