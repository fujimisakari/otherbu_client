//
//  CustomWebView.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "CustomWebView.h"

@interface CustomWebView () {
    UIToolbar       *_toolbar;
    UIBarButtonItem *_rightArrow;
    UIBarButtonItem *_leftArrow;
    float           _beginScrollOffsetY;
    CGRect          _baseRectOfToolbar;
    BOOL            _isScrollingToolbar;
}

@end

@implementation CustomWebView

//--------------------------------------------------------------//
#pragma mark -- initialize --
//--------------------------------------------------------------//

- (void)setupWithView:(UIView *)view {
    // 初期値設定
    self.delegate = self;
    self.scalesPageToFit = YES;  // Webページの大きさを自動的に画面にフィットさせる
    _baseRectOfToolbar = CGRectMake(0, view.bounds.size.height, view.frame.size.width, kHeightOfToolbar);

    // <(戻る)、>(進む)のボタン生成
    _leftArrow = [[UIBarButtonItem alloc] initWithTitle:@"〈" style:UIBarButtonItemStylePlain target:self action:@selector(_backDidPush)];
    _leftArrow.width = kArrowWidthOfToolbar;
    _rightArrow = [[UIBarButtonItem alloc] initWithTitle:@"〉" style:UIBarButtonItemStylePlain target:self action:@selector(_fowardDidPush)];
    _rightArrow.width = kArrowWidthOfToolbar;

    // 画面下部のツールバー生成
    NSArray *items = [NSArray arrayWithObjects:_leftArrow, _rightArrow, nil, nil];
    _toolbar = [[UIToolbar alloc] initWithFrame:_baseRectOfToolbar];
    [view addSubview:_toolbar];
    _toolbar.items = items;
}

//--------------------------------------------------------------//
#pragma mark -- UIWebViewDelegate --
//--------------------------------------------------------------//

- (void)webViewDidStartLoad:(UIWebView *)webview {
    // 読み込みが開始した直後に呼ばれる
    [self _updateToolbar];
}

- (void)webViewDidFinishLoad:(UIWebView *)webview {
    // 読み込みが完了した直後に呼ばれる
    [self _updateToolbar];
}

- (void)webView:(UIWebView *)webview didFailLoadWithError:(NSError *)error {
    // 読み込み中にエラーが発生したタイミングで呼ばれる
    [self _updateToolbar];
}

- (void)_updateToolbar {
    // ツールバーを表示、非表示
    if ([self _isStanbyToolbar]) {
        [self _didStanbyToolbar];
    } else {
        [self _didActiveToolbar];
    }

    // ツールバーボタンの有効、無効
    _rightArrow.enabled = self.canGoForward;
    _leftArrow.enabled = self.canGoBack;

    // ステータスバーのインジケータの更新
    [UIApplication sharedApplication].networkActivityIndicatorVisible = self.loading;
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
    if (_isScrollingToolbar == YES || [self _isStanbyToolbar]) {
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
#pragma mark -- Button Action --
//--------------------------------------------------------------//

- (void)_fowardDidPush {
    // 次のページへ進む
    if (self.canGoForward) {
        [self goForward];
    }
}

- (void)_backDidPush {
    // 前のページへ戻る
    if (self.canGoBack) {
        [self goBack];
    }
}

//--------------------------------------------------------------//
#pragma mark -- Toolbar --
//--------------------------------------------------------------//

- (BOOL)_isStanbyToolbar {
    // Toolbarが非表示か
    return (!self.canGoForward && !self.canGoBack) ? YES : NO;
}

- (void)_didStanbyToolbar {
    // Toolbarを非表示にする
    _toolbar.frame = _baseRectOfToolbar;
}

- (void)_didActiveToolbar {
    // Toolbarを表示にする
    CGRect rect = _baseRectOfToolbar;
    _toolbar.frame = CGRectMake(rect.origin.x, rect.origin.y - rect.size.height, rect.size.width, rect.size.height);
}

- (UIButton *)_createButtonWithString:(NSString *)string {
    // Toolbar用のボタン生成
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:string forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:kFontSizeOfToolbar];
    return button;
}

@end
