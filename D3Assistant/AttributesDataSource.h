//
//  AttributesDataSource.h
//  D3Assistant
//
//  Created by Artem Shimanski on 07.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttributesDataSource : NSObject<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSDictionary* hero;
@property (nonatomic, assign) BOOL fallen;


@end
