//
//  DAItemsViewController.h
//  D3Assistant
//
//  Created by Artem Shimanski on 15.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "d3ce.h"

@class DAHero;
@class DAItem;
@interface DAItemsViewController : UITableViewController
@property (assign, nonatomic) d3ce::ClassMask classMask;
@property (assign, nonatomic) d3ce::Item::Slot slot;
@property (strong, nonatomic) DAHero* hero;
@property (strong, nonatomic) DAItem* selectedItem;

@end
