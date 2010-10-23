//
//  SaleCheckerAppDelegate.h
//  SaleChecker
//
//  Created by Nathan Vander Wilt on 4/27/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <sqlite3.h>

@class Product, Store;

@interface SaleCheckerAppDelegate : NSObject <UIApplicationDelegate> {
@private
	sqlite3* database;
    UIWindow* window;
	UINavigationController* navController;
	NSMutableArray* products;
}

@property (nonatomic, retain) IBOutlet UIWindow* window;
@property (nonatomic, retain) IBOutlet UINavigationController* navController;

@property (nonatomic, readonly) NSArray* products;
- (void)addProduct:(Product*)product;
- (void)removeProduct:(Product*)product;

@end
