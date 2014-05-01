#import <Foundation/Foundation.h>

@class Book;

@interface BookAddView : UIView
- (id)initWithBook:(Book *)book;

- (void)registerForKeyboardNotifications;
@end