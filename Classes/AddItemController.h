//
//  AddItemController.h
//  SaleChecker
//
//  Created by Nathan Vander Wilt on 5/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ItemController.h"

@class Product;

@interface AddItemController : ItemController {
@private
	Product* product;
}

@property (nonatomic, retain) Product* product;

@end
