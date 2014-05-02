#import <Foundation/Foundation.h>

@class Book;

@interface BookAddView : UIView
@property(nonatomic, strong) UITextField *donorField;

- (id)initWithBook:(Book *)book;

- (void)registerForKeyboardNotifications;
@end