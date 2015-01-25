//
//  DAItemInfoViewController.h
//  D3Assistant
//
//  Created by Artem Shimanski on 01.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "d3ce.h"

@class DAItem;
@class DAHero;
@interface DAItemInfoViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (strong, nonatomic) DAItem* item;
@property (assign, nonatomic) d3ce::Item::Slot slot;
@property (strong, nonatomic) DAHero* hero;

- (IBAction)onClose:(id)sender;
@end
