//
//  MenuViewController.h
//
//  Created by Timothy Shiu on 12/24/12.
//
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"
#import "MenuItem.h"
@class MenuViewController;

@protocol MenuViewControllerMenuSource

- (NSArray*) menuDescription;

@end

@protocol MenuViewControllerDelegate

- (MenuViewController*) menuViewController;

@end

@interface MenuViewController : UITableViewController

@property (nonatomic, retain) NSArray* menu;
@property (nonatomic, retain) NSString *menuID;
@property (nonatomic, retain) id<MenuViewControllerMenuSource> menuSource;

- (MenuItem*) itemAtIndexPath:(NSIndexPath*) indexPath;

- (NSArray*) submenuAtIndexPath:(NSIndexPath*) indexPath;
- (NSArray*) submenuInSection:(NSUInteger) section;
- (NSString*) submenuTitleAtIndexPath:(NSIndexPath*) indexPath;
- (NSString*) submenuTitleInSection:(NSUInteger) section;

@end
