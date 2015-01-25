//
//  DAHeroesTableHeaderView.h
//  D3Assistant
//
//  Created by Artem Shimanski on 12.10.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAHeroesTableHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *battleTagLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoritesButton;

- (IBAction) onFavorites:(id)sender;
@end
