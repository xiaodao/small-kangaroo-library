#import "LoadingView.h"
#import "Masonry.h"

@interface LoadingView ()
@property(strong, nonatomic) UIView *markView;
@property(strong, nonatomic) UIActivityIndicatorView *activityView;
@property(strong, nonatomic) UILabel *loadingLabel;
@end

@implementation LoadingView {

}

- (id)initWithText:(NSString *)text backgroundColor:(UIColor *)backgroundColor {
  self = [super init];
  if (!self) return nil;
  self.markView = [[UIView alloc] init];
  self.markView.backgroundColor = backgroundColor;
  self.markView.layer.opacity = 0.3f;
  [self addSubview:self.markView];
  [self.markView mas_makeConstraints:^(MASConstraintMaker *maker) {
    maker.top.equalTo(self.mas_top);
    maker.bottom.equalTo(self.mas_bottom);
    maker.right.equalTo(self.mas_right);
    maker.left.equalTo(self.mas_left);
  }];

  self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
  self.activityView.hidesWhenStopped = YES;
  [self.activityView startAnimating];
  [self addSubview:self.activityView];

  [self.activityView mas_makeConstraints:^(MASConstraintMaker *maker) {
    maker.top.equalTo(self.markView.mas_top);
    maker.bottom.equalTo(self.markView.mas_bottom);
    maker.right.equalTo(self.markView.mas_right);
    maker.left.equalTo(self.markView.mas_left);
    maker.centerX.equalTo(self.markView.mas_centerX);
  }];

  self.loadingLabel = [[UILabel alloc] init];
  self.loadingLabel.text = text;
  self.loadingLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
  self.loadingLabel.textColor = [UIColor whiteColor];
  [self addSubview:self.loadingLabel];

  [self.loadingLabel mas_makeConstraints:^(MASConstraintMaker *maker) {
    maker.bottom.equalTo(self.markView.mas_bottom).with.offset(-10);
    maker.centerX.equalTo(self.markView.mas_centerX);
  }];
  return self;
}

@end