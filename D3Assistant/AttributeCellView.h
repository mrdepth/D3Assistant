//
//  AttributeCellView.h
//  D3Assistant
//
//  Created by mr_depth on 08.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttributeCellView : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end
