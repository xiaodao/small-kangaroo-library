#import <Foundation/Foundation.h>

@interface Book : NSObject
@property (strong, nonatomic, readonly) NSString *isbn;
@property (strong, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readonly) NSString *author;
@property (strong, nonatomic, readonly) NSString *authorIntro;
@property (strong, nonatomic, readonly) NSString *publisher;
@property (strong, nonatomic, readonly) NSString *rating;
@property (strong, nonatomic, readonly) NSString *summary;

+ (id)newFromJson:(NSDictionary *)jsonDictionary andIsbn:(NSString *)isbn;
@end