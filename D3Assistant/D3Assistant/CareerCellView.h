//
//  CareerCellView.h
//  D3Assistant
//
//  Created by Artem Shimanski on 06.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressionView.h"

@interface CareerCellView : UITableViewCell
@property (weak, nonatomic) IBOutlet ProgressionView *progressionSCView;
@property (weak, nonatomic) IBOutlet ProgressionView *progressionHCView;

@end
