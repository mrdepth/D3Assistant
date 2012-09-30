//
//  AttributesViewController.h
//  D3Assistant
//
//  Created by Artem Shimanski on 18.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D3CEHelper.h"

@interface AttributesViewController : UITableViewController
@property (nonatomic, strong, readonly) NSDictionary* hero;
@property (nonatomic, assign, readonly) BOOL fallen;
@property (nonatomic, assign) d3ce::Hero* d3ceHero;

- (void) setHero:(NSDictionary *)hero fallen:(BOOL) fallen;

@end
