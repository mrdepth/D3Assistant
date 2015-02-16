//
//  DAStorage.m
//  D3Assistant
//
//  Created by Artem Shimanski on 09.10.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import "DAStorage.h"
#import "UIAlertView+Error.h"

@implementation DAStorage
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


+ (id) sharedStorage {
    static DAStorage* sharedStorage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStorage = [DAStorage new];
    });
    return sharedStorage;
}

- (void) saveContext {
    if ([self.managedObjectContext hasChanges])
        [self.managedObjectContext save:nil];
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    @synchronized(self) {
        if (_managedObjectContext != nil) {
            return _managedObjectContext;
        }
        
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (coordinator != nil) {
            _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [_managedObjectContext setPersistentStoreCoordinator:coordinator];
            [_managedObjectContext setMergePolicy:[[NSMergePolicy alloc] initWithMergeType:NSRollbackMergePolicyType]];
        }
        return _managedObjectContext;
    }
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    @synchronized(self) {
        if (_managedObjectModel != nil) {
            return _managedObjectModel;
        }
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DAStorage" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        return _managedObjectModel;
    }
}

- (NSPersistentStoreCoordinator*) persistentStoreCoordinator {
	@synchronized(self) {
		NSString* directory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"DAStorage"];
		[[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
		
		_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
		
		NSError *error = nil;
		NSURL *storeURL = [NSURL fileURLWithPath:[directory stringByAppendingPathComponent:@"store.sqlite"]];
		for (int n = 0; n < 2; n++) {
			error = nil;
			if ([_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
														  configuration:nil
																	URL:storeURL
																options:nil
																  error:&error])
				break;
			else
				[[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
		}
		if (error) {
			dispatch_async(dispatch_get_main_queue(), ^{
				[[UIAlertView alertViewWithError:error] show];
			});
			return nil;
		}
		return _persistentStoreCoordinator;
	}
}

@end
