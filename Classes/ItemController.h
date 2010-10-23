//
//  ItemController.h
//  SaleChecker
//
//  Created by Nathan Vander Wilt on 4/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Item;

@interface ItemController : UITableViewController {
@private
	Item* item;
}

@property (nonatomic, retain) Item* item;

@end
