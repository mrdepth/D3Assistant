//
//  DAProfileCell.h
//  D3Assistant
//
//  Created by Artem Shimanski on 10.12.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAProfileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *battleTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (strong, nonatomic) id object;

@end
