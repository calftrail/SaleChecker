//
//  ProductController.h
//  SaleChecker
//
//  Created by Nathan Vander Wilt on 4/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Product;

@interface ProductController : UITableViewController {
@private
	Product* product;
}

@property (nonatomic, retain) Product* product;

@end
