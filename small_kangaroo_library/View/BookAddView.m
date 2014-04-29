#import "BookAddView.h"
#import "Book.h"
#import "Masonry.h"

#define VERTICAL_OFFSET 15
#define HORIZONTAL_OFFSET 20

@interface BookAddView ()
@property(nonatomic, strong) Book *book;
@property(nonatomic, strong) UIScrollView *contentView;
@property(nonatomic, strong) UILabel *bookNameLabel;
@property (nonatomic, strong) UITextView *bookNameView;
@property(nonatomic, strong) UITextView *bookSummaryView;
@property(nonatomic, strong) UIView *bookSummaryLabel;
@end

@implementation BookAddView {

}

- (id)initWithBook:(Book *)book {
  self = [super init];
  if (!self) return nil;
  self.book = book;
  self.backgroundColor = [UIColor whiteColor];
  [self createElements];
  [self layout];
  return self;
}

- (void)layout {
  [self.contentView mas_makeConstraints:^(MASConstraintMaker *maker) {
    maker.edges.equalTo(self);
  }];

  [self.bookNameLabel mas_makeConstraints:^(MASConstraintMaker *maker){
    maker.top.equalTo(self.contentView).with.offset(20);
    maker.left.equalTo(self).with.offset(HORIZONTAL_OFFSET);
  }];

  [self.bookNameView mas_makeConstraints:^(MASConstraintMaker *maker) {
    maker.top.equalTo(self.bookNameLabel.mas_bottom).with.offset(VERTICAL_OFFSET);
    maker.left.equalTo(self).with.offset(HORIZONTAL_OFFSET);
    maker.right.equalTo(self.mas_right).with.offset(-HORIZONTAL_OFFSET);
    CGSize sizeThatShouldFitTheContent = [self.bookNameView sizeThatFits:self.bookNameView.frame.size];
    maker.height.equalTo(@(sizeThatShouldFitTheContent.height));
  }];

  [self.bookSummaryLabel mas_makeConstraints:^(MASConstraintMaker *maker){
    maker.top.equalTo(self.bookNameView.mas_bottom).with.offset(VERTICAL_OFFSET);
    maker.left.equalTo(self).with.offset(HORIZONTAL_OFFSET);
  }];

  [self.bookSummaryView mas_makeConstraints:^(MASConstraintMaker *maker) {
    maker.top.equalTo(self.bookSummaryLabel.mas_bottom).with.offset(VERTICAL_OFFSET);
    maker.left.equalTo(self).with.offset(HORIZONTAL_OFFSET);
    maker.right.equalTo(self.mas_right).with.offset(-HORIZONTAL_OFFSET);
    CGSize sizeThatShouldFitTheContent = [self.bookSummaryView sizeThatFits:self.bookSummaryView.frame.size];
    maker.height.equalTo(@(sizeThatShouldFitTheContent.height));
  }];
}

- (void)createElements {
  self.contentView = [[UIScrollView alloc] init];
  [self addSubview:self.contentView];

  self.bookNameLabel = [self labelWithTitle:@"书名"];
  [self.contentView addSubview:self.bookNameLabel];

  self.bookNameView = [self textViewWithText:[self.book title]];
  [self.contentView addSubview:self.bookNameView];
  
  self.bookSummaryLabel = [self labelWithTitle:@"摘要"];
  [self.contentView addSubview:self.bookSummaryLabel];

  self.bookSummaryView = [self textViewWithText:[self.book summary]];
  [self.contentView addSubview:self.bookSummaryView];
}

- (UILabel *)labelWithTitle: (NSString *)title{
  UILabel *label = [[UILabel alloc]init];
  [label setText:title];
  [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
  [label setTextColor:[UIColor blackColor]];
  return label;
}

- (UITextView *)textViewWithText: (NSString *)text{
  UITextView *view = [[UITextView alloc]init];
  [[view layer] setBorderColor:[UIColor blackColor].CGColor];
  [[view layer] setBorderWidth:0.6f];
  [view setTextColor:[UIColor blackColor]];
  [view setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
  [view setBackgroundColor:[UIColor grayColor]];
  [view setText:text];
  [view setEditable:NO];
  return view;
}
@end