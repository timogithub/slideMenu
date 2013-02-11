//
//  MenuView.m
//
//  Created by Timothy Shiu on 1/19/13.
//
//

#import "MenuItem.h"

@interface MenuItem ()

@end

@implementation MenuItem

- (id) init
{
    self = [super init];
    if (self == nil) { return nil; }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

@synthesize instance = _instance;

- (id) instance
{
    if (_instance) { return _instance; }
    
    Class klass = self.klass;
    BOOL bad = [klass isSubclassOfClass:[NSNull class]];
    if (bad) { return nil; }

    _instance = [[[klass alloc] init] retain];
    return _instance;
}

@synthesize klass = _klass;

@synthesize name = _name;

@synthesize alias = _alias;

@synthesize image = _image;

@synthesize selector = _selector;

@synthesize object = _object;

#pragma mark - item detail helper

+ (MenuItem*) item
{
    MenuItem* inst = [[[self alloc] init] autorelease];
    return inst;
}

+ (MenuItem*) itemInstance:(id) instance
                      name:(NSString*) name
                     alias:(NSString*) alias
                     image:(NSString*) file
                  selector:(SEL) sel
                    object:(id) obj
{
    return [MenuItem itemName:name
                        alias:alias
                        image:file
                        klass:[instance class]
                     instance:instance
                     selector:sel
                       object:obj];
}

+ (MenuItem*) itemInstance:(id) instance
                      name:(NSString*) name
                     alias:(NSString*) alias
                     image:(NSString*) file
                  selector:(SEL) sel;
{
    return [MenuItem itemName:name
                        alias:alias
                        image:file
                        klass:[instance class]
                     instance:instance
                     selector:sel
                       object:nil];
}

+ (MenuItem*) itemInstance:(id) instance
{
    return [MenuItem itemName:nil
                        alias:nil
                        image:nil
                        klass:[instance class]
                     instance:instance
                     selector:nil
                       object:nil];
}

+ (MenuItem*) itemInstance:(id) instance
                      name:(NSString*) name
{
    return [MenuItem itemName:name
                        alias:nil
                        image:nil
                        klass:[instance class]
                     instance:instance
                     selector:nil
                       object:nil];
}

+ (MenuItem*) itemInstance:(id) instance
                      name:(NSString*) name
                     alias:(NSString *)alias
{
    return [MenuItem itemName:name
                        alias:alias
                        image:nil
                        klass:[instance class]
                     instance:instance
                     selector:nil
                       object:nil];
}

+ (MenuItem*) itemName:(NSString*) name
                 alias:(NSString*) alias
                 image:(NSString*) file
              instance:(id) instance
              selector:(SEL) sel
{
    return [MenuItem itemName:name
                        alias:alias
                        image:file
                        klass:[instance class]
                     instance:instance
                     selector:sel
                       object:nil];
}

+ (MenuItem*) itemName:(NSString*) name
                 alias:(NSString*) alias
                 image:(NSString*) file
                 klass:(Class) klass
{
    return [MenuItem itemName:name
                        alias:alias
                        image:file
                        klass:klass
                     instance:nil
                     selector:nil
                       object:nil];
}

+ (MenuItem*) itemName:(NSString*) name
                 alias:(NSString*) alias
                 image:(NSString*) file
                 klass:(Class) klass
              instance:(id) instance
              selector:(SEL) sel
{
    return [MenuItem itemName:name
                        alias:alias
                        image:file
                        klass:klass
                     instance:instance
                     selector:sel
                       object:nil];
}

+ (MenuItem*) itemName:(NSString*) name
                 alias:(NSString*) alias
                 image:(NSString*) file
                 klass:(Class) klass
              instance:(id) instance
              selector:(SEL) sel
                object:(id) obj
{
    if (instance == nil) { return nil; }
    MenuItem* item = [MenuItem item];
    NSString* title = [item name:name otherwise:instance];
    UIImage* image = [item image:file otherwise:instance ];

    if (instance) {
        item.instance = instance;
    }
    if (item) {
        item.klass = klass;
    }
    if (title) {
        item.name = title;
    }
    if ((alias) && (![alias isEqualToString:title])) {
        item.alias = alias;
    }
    if (image) {
        item.image = image;
    }
    if (sel) {
        NSString* selector = NSStringFromSelector(sel);
        item.selector = selector;
    }
    if (obj) {
        item.object = obj;
    }
    return item;
}

- (NSString*) name:(NSString*) name
         otherwise:(id) instance
{
    if (name) { return name; }
    BOOL ok = [instance respondsToSelector:@selector(title)];
    if (!ok) { return nil; }

    return [instance title];
}

- (UIImage*) image:(NSString*) file
         otherwise:(id) instance
{
    UIImage* image = nil;
    if (file) {
        image = [UIImage imageNamed:file];
    }
    if (image) { return image; }

    BOOL ctrl = [instance isKindOfClass:[UIViewController class]];
    if (!ctrl) { return image; }

    UIViewController* control = (UIViewController*) instance;    
    BOOL ok = [control respondsToSelector:@selector(tabBarItem)];
    if (!ok) { return image; }

    image = control.tabBarItem.image;
    return image;
}

@end
