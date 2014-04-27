#import "Book.h"
#import "NSArray+ObjectiveSugar.h"

@interface Book ()
@property(strong, nonatomic, readwrite) NSString *isbn;
@property(strong, nonatomic, readwrite) NSString *title;
@property(strong, nonatomic, readwrite) NSString *author;
@property(strong, nonatomic, readwrite) NSString *authorIntro;
@property(strong, nonatomic, readwrite) NSString *publisher;
@property(strong, nonatomic, readwrite) NSString *rating;
@property(strong, nonatomic, readwrite) NSString *summary;
@end

@implementation Book {

}

+ (id)newFromJson:(NSDictionary *)jsonDictionary andIsbn:(NSString *)isbn {
  Book *book = [[Book alloc] init];

  book.title = jsonDictionary[@"title"];
  book.isbn = isbn;
  book.authorIntro = jsonDictionary[@"author_intro"];
  book.publisher = jsonDictionary[@"publisher"];
  book.rating = jsonDictionary[@"rating"][@"average"];
  book.summary = jsonDictionary[@"summary"];
  NSArray *authors = jsonDictionary[@"author"];
  book.author = [authors join:@","];
  return book;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"Book: title - %@, isbn - %@, authorIntro - %@, publisher - %@, rating - %@, summary - %@, author - %@",
                                    self.title, self.isbn, self.authorIntro, self.publisher, self.rating, self.summary, self.author];
}

- (NSString *)donor {
  return @"李剑";
}
@end