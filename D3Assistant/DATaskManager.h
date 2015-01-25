//
//  DATaskManager.h
//  D3Assistant
//
//  Created by Artem Shimanski on 11.10.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DATask.h"

#define DATaskManagerIdentifierNone nil
#define DATaskManagerIdentifierAuto [NSString stringWithFormat:@"%@.%@", NSStringFromClass(self.class), NSStringFromSelector(_cmd)]
#define DATaskManagerDefaultTitle NSLocalizedString(@"Loading", nil)

@class DATask;
@interface DATaskManager : NSOperationQueue
@property (nonatomic, weak, readonly) UIViewController* viewController;
@property (nonatomic, assign) BOOL active;

- (id) initWithViewController:(UIViewController*) viewController;
- (void) addTaskWithIndentifier:(NSString*) identifier
                          title:(NSString*) title
                          block:(void(^)(DATask* task)) block
              completionHandler:(void(^)(DATask* task)) completionHandler;

@end
