### Hiearchical Slide Menu, similar to facebook slide menu

This MenuViewController work with IIViewDeckController (also available
from github) to provide slide under menu like facebook app. Create
this menu instance and put that menu into IIViewDeckController's
leftController.  

Note: I have patched a bit the IIViewDeckController to be take
viewController directly, instead of wrapping all this viewController
with navigation controller. And also, add a menu button to the
navigationItem as a new default.

---

There are two classes 
- MenuViewController (subclass it to make your menu)
- MenuItem (functor, used by MenuViewController)

---

All you need to do is to subclass MenuViewController and have all the viewController(s) as properties. Also, implement the protocol <MenuViewControllerMenuSource>. In short, this subclass is the dataSource of the menu's table.

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

The most important thing is to use MenuItem to create instance of ViewController. Be sure the ViewController use lazy initialization technique(init just enough)


    // YourMenuViewController.m
    #import "YourMenuViewController.h"
    
    @implementation YourMenuViewController
    
    // setup your properties ...
    
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
            [MenuItem itemInstance:self.about] ,
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

Now, the menu is configured. AppDelegate need to have a IIViewDeckController property. This IIViewController needs to set the left viewController to the our menu (YourMenuViewController) and set the center viewController to our splash or whatever your main content.

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

Enjoy!
