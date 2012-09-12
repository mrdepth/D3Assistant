//
//  HeroCareerCellView.h
//  D3Assistant
//
//  Created by Artem Shimanski on 12.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressionView.h"

@interface HeroCareerCellView : UITableViewCell
@property (unsafe_unretained, nonatomic) IBOutlet ProgressionView *progressionView;

@end
