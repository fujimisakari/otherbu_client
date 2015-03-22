//
//  CustomWebView.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "CustomWebView.h"

@implementation CustomWebView {
    UIToolbar *_toolbar;
    float _beginScrollOffsetY;
    BOOL _isScrollingToolbar;
    CGRect _baseRectOfToolbar;
    UIBarButtonItem *_rightArrow;
    UIBarButtonItem *_leftArrow;
}

- (void)setupWithView:(UIView *)view {
    self.delegate = self;
    _baseRectOfToolbar = CGRectMake(0, view.bounds.size.height, view.frame.size.width, kHeightOfToolbar);

    // setup LeftArrow
    // UIButton *leftButton = [self createButtonWithString:@"〈"];
    // [leftButton addTarget:self action:@selector(backDidPush:) forControlEvents:UIControlEventTouchUpInside];
    // _leftArrow = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    _leftArrow = [[UIBarButtonItem alloc] initWithTitle:@"〈" style:UIBarButtonItemStylePlain target:self action:@selector(backDidPush)];
    [_leftArrow setTitleTextAttributes:@{
                                           NSFontAttributeName : [UIFont systemFontOfSize:kFontSizeOfToolbar]
                                       }
                              forState:UIControlStateNormal];
    _leftArrow.width = 50.0f;

    // setup RightArrow
    // UIButton *rightButton = [self createButtonWithString:@"〉"];
    // [rightButton addTarget:self action:@selector(fowardDidPush:) forControlEvents:UIControlEventTouchUpInside];
    // _rightArrow = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    _rightArrow = [[UIBarButtonItem alloc] initWithTitle:@"〉" style:UIBarButtonItemStylePlain target:self action:@selector(fowardDidPush)];
    [_rightArrow setTitleTextAttributes:@{
                                           NSFontAttributeName : [UIFont systemFontOfSize:kFontSizeOfToolbar]
                                       }
                              forState:UIControlStateNormal];

    _rightArrow.width = 50.0f;

    // setup Toolbar
    NSArray *items = [NSArray arrayWithObjects:_leftArrow, _rightArrow, nil, nil];
    _toolbar = [[UIToolbar alloc] initWithFrame:_baseRectOfToolbar];
    [view addSubview:_toolbar];
    _toolbar.items = items;
}

//--------------------------------------------------------------//
#pragma mark -- UIWebViewDelegate --
//--------------------------------------------------------------//

-(void)webViewDidStartLoad:(UIWebView *)webview {
    // 読み込みが開始した直後に呼ばれる
    [self updateToolbar];
}

-(void)webViewDidFinishLoad:(UIWebView *)webview {
    // 読み込みが完了した直後に呼ばれる
    [self updateToolbar];
}

-(void)webView:(UIWebView *)webview didFailLoadWithError:(NSError *)error {
    // 読み込み中にエラーが発生したタイミングで呼ばれる
    [self updateToolbar];
}


//--------------------------------------------------------------//
#pragma mark -- UIScrollViewDelegate --
//--------------------------------------------------------------//

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // スクロールビューをドラッグし始めたY座標を記録
    _beginScrollOffsetY = [scrollView contentOffset].y;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // ツールバーの表示、非表示のアニメーション対応
    if (_isScrollingToolbar == YES || [self isStanbyToolbar]) {
        return;
    }

    if (_beginScrollOffsetY < [scrollView contentOffset].y && !_toolbar.hidden) {
        // 下へスクロールした場合はツールバーを隠す
        [UIView animateWithDuration:0.4 animations:^{
            _isScrollingToolbar = YES;
            CGRect rect = _baseRectOfToolbar;
            _toolbar.frame = CGRectMake(rect.origin.x,
                                        rect.origin.y,
                                        rect.size.width,
                                        rect.size.height);
        } completion:^(BOOL finished) {
            _isScrollingToolbar = NO;
            _toolbar.hidden = YES;
        }];
    } else if ([scrollView contentOffset].y < _beginScrollOffsetY && _toolbar.hidden && 0.0 != _beginScrollOffsetY) {
        // 上へスクロールした場合はツールバーを表示する
        _toolbar.hidden = NO;
        [UIView animateWithDuration:0.4 animations:^{
            _isScrollingToolbar = YES;
            CGRect rect = _baseRectOfToolbar;
            _toolbar.frame = CGRectMake(rect.origin.x,
                                        rect.origin.y - rect.size.height,
                                        rect.size.width,
                                        rect.size.height);
        } completion:^(BOOL finished) {
            _isScrollingToolbar = NO;
        }];
    }
}

//--------------------------------------------------------------//
#pragma mark -- Private Method --
//--------------------------------------------------------------//

- (void)fowardDidPush {
    // 次のページへ進む
    if (self.canGoForward) {
        [self goForward];
    }
}

- (void)backDidPush {
    // 前のページへ戻る
    if (self.canGoBack) {
        [self goBack];
    }
}

- (void)updateToolbar {
    // ツールバーを表示、非表示
    if ([self isStanbyToolbar]) {
        [self didStanbyToolbar];
    } else {
        [self didActiveToolbar];
    }

    // ツールバーボタンの有効、無効
    _rightArrow.enabled = self.canGoForward;
    _leftArrow.enabled = self.canGoBack;
}

- (BOOL) isStanbyToolbar {
    // Toolbarが非表示か
    return (!self.canGoForward && !self.canGoBack) ? YES : NO;
}

- (void)didStanbyToolbar {
    // Toolbarを非表示にする
    _toolbar.frame = _baseRectOfToolbar;
}

- (void)didActiveToolbar {
    // Toolbarを表示にする
    CGRect rect = _baseRectOfToolbar;
    _toolbar.frame = CGRectMake(rect.origin.x, rect.origin.y - rect.size.height, rect.size.width, rect.size.height);
}

- (UIButton *)createButtonWithString:(NSString *)string {
    // Toolbar用のボタン生成
    UIButton *button = [UIButton buttonWithType:101];
    [button setTitle:string forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:kFontSizeOfToolbar];
    return button;
}

@end
