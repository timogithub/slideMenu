//
//  MenuViewController.m
//
//  Created by Timothy Shiu on 12/24/12.
//
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MenuViewController.h"
#import "MenuItem.h"

@implementation MenuViewController

@synthesize menuSource = _menuSource;

@synthesize menu = _menu;

- (NSArray*) menu
{
    if (_menu) { return _menu; }

    _menu = [self.menuSource menuDescription];
    [_menu retain];
    return _menu;
}

@synthesize menuID = _menuID;

- (NSString*) menuID
{
    if (_menuID) { return _menuID; }
    _menuID = @"MenuCell";
    return _menuID;

}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIColor *bgColor = [UIColor colorWithRed:(50.0f/255.0f)
                                       green:(57.0f/255.0f)
                                        blue:(74.0f/255.0f)
                                       alpha:1.0f];
    self.view.backgroundColor = bgColor;
    self.tableView.separatorColor = [UIColor clearColor];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSUInteger count = [self.menu count];
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    NSArray* submenu = [self submenuAtIndexPath:indexPath];
    NSUInteger count = [submenu count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuItem* item = [self itemAtIndexPath:indexPath];
    NSString* alias = item.alias;
    NSString* title = item.name;
    UIImage* image = item.image;

    UITableViewCellStyle style = alias ? UITableViewCellStyleSubtitle : UITableViewCellStyleDefault;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.menuID];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:style
                                      reuseIdentifier:self.menuID] autorelease];
    }

    cell.textLabel.text = title;
    cell.imageView.image = image;
    cell.detailTextLabel.text = alias;

    [self configColorForCell:cell];
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuItem* item = [self itemAtIndexPath:indexPath];
    id instance = item.instance;
    if (instance == nil) { return; }
    NSString* action = item.selector;
    if (action) {
        id object = item.object;
        SEL selector = NSSelectorFromString(action);
        [instance performSelector:selector withObject:object];
        [self pushSubMenuController:instance];
        [self.viewDeckController closeLeftView];
        [self.viewDeckController setCenterController:instance];
    } else if ([instance isKindOfClass:[UIViewController class]]) {
        BOOL push = [self pushSubMenuController:instance];
        if (!push) {
            [self.viewDeckController setCenterController:instance];
            [self.viewDeckController closeLeftView];
        }
    }
}

- (MenuViewController*) getSubMenuController:(id) instance
{
    if (instance == nil) { return nil; }

    BOOL ok = [instance respondsToSelector:@selector(menuViewController)];
    if (!ok) { return nil; }

    MenuViewController* submenu = [instance menuViewController];
    return submenu;
}

- (BOOL) pushSubMenuController:(id) instance
{
    MenuViewController* submenu = [self getSubMenuController:instance];
    if (submenu == nil) { return FALSE; }

    UIViewController* left = self.viewDeckController.leftController;
    bool navi = [left isMemberOfClass:[UINavigationController class]];
    if (!navi) { return FALSE; }

    UINavigationController* nav = (UINavigationController*) left;

    UIViewController* menu = nav.topViewController;
    bool same = (menu == submenu);
    if (same) { return TRUE; } // already pushed

    [nav pushViewController:submenu animated:YES];
    return TRUE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString* header = [self submenuTitleInSection:section];
	return (header) ? 21.0f: 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	NSString *headerText = [self submenuTitleInSection:section];
	UIView *headerView = nil;
	if (!headerText) { return headerView; }

    headerView = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 21.0f)] autorelease];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = headerView.bounds;
    gradient.colors = @[
    (id)[UIColor colorWithRed:(67.0f/255.0f) green:(74.0f/255.0f) blue:(94.0f/255.0f) alpha:1.0f].CGColor,
    (id)[UIColor colorWithRed:(57.0f/255.0f) green:(64.0f/255.0f) blue:(82.0f/255.0f) alpha:1.0f].CGColor,
    ];
    [headerView.layer insertSublayer:gradient atIndex:0];

    UILabel *textLabel = [[[UILabel alloc] initWithFrame:CGRectInset(headerView.bounds, 12.0f, 5.0f)] autorelease];
    textLabel.text = (NSString *) headerText;
    textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:([UIFont systemFontSize] * 0.8f)];
    textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    textLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
    textLabel.textColor = [UIColor colorWithRed:(125.0f/255.0f)
                                          green:(129.0f/255.0f)
                                           blue:(146.0f/255.0f)
                                          alpha:1.0f];
    textLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:textLabel];

    UIView *topLine = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)] autorelease];
    topLine.backgroundColor = [UIColor colorWithRed:(78.0f/255.0f)
                                              green:(86.0f/255.0f)
                                               blue:(103.0f/255.0f)
                                              alpha:1.0f];
    [headerView addSubview:topLine];

    UIView *bottomLine = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 21.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)] autorelease];
    bottomLine.backgroundColor = [UIColor colorWithRed:(36.0f/255.0f)
                                                 green:(42.0f/255.0f)
                                                  blue:(5.0f/255.0f)
                                                 alpha:1.0f];
    [headerView addSubview:bottomLine];
    return headerView;
}

#pragma mark - Table view

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    NSString* name = [self submenuTitleAtIndexPath:indexPath];
    return name;
}

#pragma mark - cell color

- (void)configColorForCell:(UITableViewCell*)cell
{
    cell.textLabel.backgroundColor = [UIColor colorWithRed:(196.0f/255.0f)
                                                     green:(204.0f/255.0f)
                                                      blue:(218.0f/255.0f)
                                                     alpha:1.0f];

    UIView *bgView = [[[UIView alloc] init] autorelease];
    bgView.backgroundColor = [UIColor colorWithRed:(38.0f/255.0f)
                                             green:(44.0f/255.0f)
                                              blue:(58.0f/255.0f)
                                             alpha:1.0f];
    cell.selectedBackgroundView = bgView;

    cell.imageView.contentMode = UIViewContentModeCenter;

    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:([UIFont systemFontSize] * 1.2f)];
    cell.textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    cell.textLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
    cell.textLabel.textColor = [UIColor colorWithRed:(196.0f/255.0f)
                                               green:(204.0f/255.0f)
                                                blue:(218.0f/255.0f)
                                               alpha:1.0f];

    UIView *topLine = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)] autorelease];
    topLine.backgroundColor = [UIColor colorWithRed:(54.0f/255.0f)
                                              green:(61.0f/255.0f)
                                               blue:(76.0f/255.0f)
                                              alpha:1.0f];
    [cell.textLabel.superview addSubview:topLine];

    UIView *topLine2 = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 1.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)] autorelease];
    topLine2.backgroundColor = [UIColor colorWithRed:(54.0f/255.0f)
                                               green:(61.0f/255.0f)
                                                blue:(77.0f/255.0f)
                                               alpha:1.0f];
    [cell.textLabel.superview addSubview:topLine2];

    UIView *bottomLine = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 43.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)] autorelease];
    bottomLine.backgroundColor = [UIColor colorWithRed:(40.0f/255.0f)
                                                 green:(47.0f/255.0f)
                                                  blue:(61.0f/255.0f)
                                                 alpha:1.0f];
    [cell.textLabel.superview addSubview:bottomLine];

}

#pragma mark - menu (item, and submenu) helper

- (MenuItem*) itemAtIndexPath:(NSIndexPath*) indexPath
{
    NSArray* submenu = [self submenuAtIndexPath:indexPath];
    MenuItem* item = [submenu objectAtIndex:indexPath.row];
    return item;
}

- (NSArray*) submenuAtIndexPath:(NSIndexPath*) indexPath
{
    NSArray* submenu = [self submenuInSection:indexPath.section];
    return submenu;
}

- (NSArray*) submenuInSection:(NSUInteger) section
{
    MenuItem* menu = [self.menu objectAtIndex:section];
    id instance = menu.instance;
    BOOL ok = ([instance isKindOfClass:[NSArray class]]);
    if (!ok) {return nil; }
    return (NSArray*) instance;
}

- (NSString*) submenuTitleAtIndexPath:(NSIndexPath*) indexPath
{
    NSString* name = [self submenuTitleInSection:indexPath.section];
    return name;
}

- (NSString*) submenuTitleInSection:(NSUInteger) section
{
    MenuItem* item = [self.menu objectAtIndex:section];
    return item.name;
}

@end
