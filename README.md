Hiearchical Slide Menu, similar to facebook slide menu

There are two classes 
1. MenuViewController (subclass it to make your menu)
2. MenuItem (functor, used by MenuViewController)

// YourMenuViewController.h

#import "MenuViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "AboutViewController.h"
#import "HelpViewController.h"
#import "CommentViewController.h"

@interface YourMenuViewController : MenuViewController 
<MenuViewControllerMenuSource>

@property (nonatomic, retain) FirstViewController* first;
@property (nonatomic, retain) SecondViewController* second;
@property (nonatomic, retain) ThirdViewController* third;

@property (nonatomic, retain) AboutViewController* about;
@property (nonatomic, retain) HelpViewController* help ;
@property (nonatomic, retain) CommentViewController* comment;

@end

// YourMenuViewController.m

#import "YourMenuViewController.h"

@implementation YourMenuViewController

// setup your properties

- (NSArray*) menuDescription
{
    NSArray* subMenu1 =
    [NSArray arrayWithObjects:
     [MenuItem itemInstance:self.first],
     [MenuItem itemInstance:self.second],
     [MenuItem itemInstance:self.third],
     nil];

    NSArray* subMenu2 =
    [NSArray arrayWithObjects:
     [MenuItem itemInstance:self.about],
     [MenuItem itemInstance:self.help],
     [MenuItem itemInstance:self.comment],
     nil];

    NSArray* menu =
    [NSArray arrayWithObjects:
     [MenuItem itemInstance:(id)subMenu1 name:@"Menu"],
     [MenuItem itemInstance:(id)subMenu2 name:@"Other"],
     nil];

    return menu;
}

@end

// AppDelegate.h

#import "IIViewDeckController.h"

@interface AppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IIViewDeckController* deck; // (menu, content)

@end

// AppDelegate.m

#import "SplashViewController.h"
#import "YourMenuViewController.h"

@interface AppDelegate ()

@property (nonatomic, retain) YourMenuViewController* menu; 
@property (nonatomic, retain) SplashViewController* splash;
@end

@implementation AppDelegate

@synthesize deck = _deck;

-  (IIViewDeckController*) deck
{    
    if (_deck) { return _dec; }
    
    SplashViewController* splash = self.splash;
    deck = [[IIViewDeckController alloc] initWithCenterViewController:splash];

    AppMenuViewController* menu = self.menu;    
    deck.leftController = menu;

    [deck retain];
    return deck;
}

- (void)applicationDidFinishLaunching:(UIApplication*)application
{
    self.window = [[[UIWindow alloc] 
                    initWithFrame:[[UIScreen mainScreen] bounds]] 
                   autorelease];
    self.window.rootViewController = self.deck;
    [self.window makeKeyAndVisible];
    return;
}
