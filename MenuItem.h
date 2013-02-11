//
//  MenuView.h
//
//  Created by Timothy Shiu on 1/19/13.
//
//

#import <Foundation/Foundation.h>

@interface MenuItem : NSObject

@property (nonatomic, retain) id instance;
@property (nonatomic, assign) Class klass;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* alias;
@property (nonatomic, retain) UIImage* image;
@property (nonatomic, retain) NSString* selector;
@property (nonatomic, retain) id object;

+ (MenuItem*) item;

+ (MenuItem*) itemInstance:(id) instance;

+ (MenuItem*) itemInstance:(id) instance
                      name:(NSString*) name;

+ (MenuItem*) itemInstance:(id) instance
                      name:(NSString*) name
                     alias:(NSString *)alias;

+ (MenuItem*) itemInstance:(id) instance
                      name:(NSString*) name
                     alias:(NSString*) alias
                     image:(NSString*) file
                  selector:(SEL) sel;

+ (MenuItem*) itemInstance:(id)instance
                      name:(NSString*) name
                     alias:(NSString*) alias
                     image:(NSString*) file
                  selector:(SEL) sel
                    object:(id) obj;

+ (MenuItem*) itemName:(NSString*) name
                 alias:(NSString*) alias
                 image:(NSString*) file
                 klass:(Class) klass;

+ (MenuItem*) itemName:(NSString*) name
                 alias:(NSString*) alias
                 image:(NSString*) file
              instance:(id) instance
              selector:(SEL) sel;

+ (MenuItem*) itemName:(NSString*) name
                 alias:(NSString*) alias
                 image:(NSString*) file
                 klass:(Class) klass
              instance:(id) instance
              selector:(SEL) sel;

+ (MenuItem*) itemName:(NSString*) name
                 alias:(NSString*) alias
                 image:(NSString*) file
                 klass:(Class) klass
              instance:(id) instance
              selector:(SEL) sel
                object:(id) obj;

@end
