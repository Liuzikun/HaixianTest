//
//  JDYNativeSearchBar.m
//  JDY
//
//  Created by mesird on 2017/11/6.
//  Copyright © 2017年 Tmall.com. All rights reserved.
//

#import "JDYNativeSearchBar.h"

#import <objc/message.h>

@interface JDYNativeSearchBar () <UITextFieldDelegate>
{
    CGSize _intrinsicContentSize;
}

@property (nonatomic, assign) BOOL bIsFrameChanged;

@property (nonatomic, strong) UITextField *nativeSearchField;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) NSString *originalCancelButtonAction;

@end

@implementation JDYNativeSearchBar

- (UITextField *)nativeSearchField {
    if (!_nativeSearchField) {
        _nativeSearchField = [self valueForKey:@"searchField"];
        _nativeSearchField.delegate = self;
    }
    return _nativeSearchField;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        for (UIView *subView in self.subviews.firstObject.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                _cancelButton = (UIButton *)subView;
                NSArray<NSString *> *actions = [_cancelButton actionsForTarget:self forControlEvent:UIControlEventTouchUpInside];
                if (actions.count > 0 && actions.firstObject.length > 0) {
                    NSString *cancelButtonAction = actions.firstObject;
                    if ([cancelButtonAction isEqualToString:NSStringFromSelector(@selector(_jdyCancelButtonPressed:))]) {
                        break;
                    }
                    _originalCancelButtonAction = cancelButtonAction;
                    [_cancelButton removeTarget:self action:NSSelectorFromString(_originalCancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
                    [_cancelButton addTarget:self action:@selector(_jdyCancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                }
                break;
            }
        }
    }
    return _cancelButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentInset = UIEdgeInsetsMake(8, 16, 8, 16);
        _intrinsicContentSize = frame.size;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    _intrinsicContentSize = frame.size;
}

- (CGSize)intrinsicContentSize {
    return _intrinsicContentSize;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *subView in self.subviews.firstObject.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            // UISearchBarBackground
            [subView removeFromSuperview];
        } else if ([subView isKindOfClass:[UITextField class]]) {
            CGFloat height = self.bounds.size.height;
            CGFloat width  = self.bounds.size.width;
            
            if (_bIsFrameChanged) {
                // 根据contentInset改变 UISearchBarTextField 的布局
                subView.frame = CGRectMake(_contentInset.left, _contentInset.top, width - _contentInset.left - _contentInset.right, height - _contentInset.top - _contentInset.bottom);
            } else {
                // 设置UISearchBar中UISearchBarTextField的默认边距
                CGFloat top = (height - 28.0) / 2.0;
                CGFloat bottom = top;
                CGFloat left = 8.0;
                CGFloat right = left;
                _contentInset = UIEdgeInsetsMake(top, left, bottom, right);
            }
        }
    }
    
    if (self.nativeSearchField && [self.nativeSearchField respondsToSelector:@selector(setFont:)]) {
        [self.nativeSearchField setFont:[UIFont systemFontOfSize:14]];
    }
}

- (void)updateContentInsetForHasCancelButton:(BOOL)hasCancelButton {
    if (hasCancelButton) {
        self.contentInset = UIEdgeInsetsMake(8, 16, 8, 16 + self.cancelButton.frame.size.width);
    } else {
       self.contentInset = UIEdgeInsetsMake(8, 16, 8, 16);
    }
}

#pragma mark -

- (void)setShowsCancelButton:(BOOL)showsCancelButton {
    [super setShowsCancelButton:showsCancelButton];
    
//    if (showsCancelButton) {
//        self.contentInset = UIEdgeInsetsMake(8, 16, 8, 16 + self.cancelButton.frame.size.width + 5);
//    } else {
//        self.contentInset = UIEdgeInsetsMake(8, 16, 8, 16);
//    }
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    _contentInset.top = contentInset.top;
    _contentInset.bottom = contentInset.bottom;
    _contentInset.left = contentInset.left;
    _contentInset.right = contentInset.right;
    
    self.bIsFrameChanged = YES;
    [self layoutSubviews];
}

- (void)setBarCornerRadius:(CGFloat)cornerRadius {
    UIView *backgroundView = [self.nativeSearchField subviews].firstObject;
    if (!backgroundView || ![backgroundView isKindOfClass:UIView.class]) {
        return;
    }
    backgroundView.layer.cornerRadius = cornerRadius;
    backgroundView.clipsToBounds = YES;
}

- (void)setBarBackgroundColor:(UIColor *)barBackgroundColor {
    if (self.nativeSearchField && [self.nativeSearchField respondsToSelector:@selector(setBackgroundColor:)]) {
        self.nativeSearchField.backgroundColor = [UIColor clearColor];
    }
    
    UIView *backgroundView = [self.nativeSearchField subviews].firstObject;
    if (backgroundView && [backgroundView respondsToSelector:@selector(setBackgroundColor:)]) {
        backgroundView.backgroundColor = barBackgroundColor;
    }
}

- (void)setViewBackgroundColor:(UIColor *)viewBackgroundColor {
    self.backgroundColor = viewBackgroundColor;
}

- (void)setAlignPlaceholderToCenter:(BOOL)bAlignToCenter {
    SEL centerSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"setCenter", @"Placeholder:"]);
    if ([self respondsToSelector:centerSelector]) {
        ((void(*)(id, SEL, BOOL))objc_msgSend)(self, centerSelector, bAlignToCenter);
    }
}

- (void)setPlaceholderAlignment:(JDYNativeSearchBarPlaceholderAlignment)placeholderAlignment {
    _placeholderAlignment = placeholderAlignment;
    if (placeholderAlignment == JDYNativeSearchBarPlaceholderAlignmentLeft) {
        if (@available(iOS 11, *)) {
            [self _configPlaceholderCenter:NO];
        } else {
            SEL centerSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"setCenter", @"Placeholder:"]);
            if ([self respondsToSelector:centerSelector]) {
                ((void(*)(id, SEL, BOOL))objc_msgSend)(self, centerSelector, NO);
            }
        }
    } else if (placeholderAlignment == JDYNativeSearchBarPlaceholderAlignmentCenter) {
        if (@available(iOS 11, *)) {
            [self _configPlaceholderCenter:YES];
        } else {
            SEL centerSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"setCenter", @"Placeholder:"]);
            if ([self respondsToSelector:centerSelector]) {
                ((void(*)(id, SEL, BOOL))objc_msgSend)(self, centerSelector, YES);
            }
        }
    }
}

- (void)setSearchIcon:(UIImage *)searchIcon {
    [self setImage:searchIcon forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
}

- (void)setClearIcon:(UIImage *)clearIcon {
    [self setImage:clearIcon forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
}

- (void)setSearchTextColor:(UIColor *)searchTextColor {
    if (self.nativeSearchField && [self.nativeSearchField respondsToSelector:@selector(setTextColor:)]) {
        [self.nativeSearchField performSelector:@selector(setTextColor:) withObject:searchTextColor];
    }
}

- (void)setSearchPlaceholderColor:(UIColor *)searchPlaceholderColor {
    [self.nativeSearchField setValue:RGBCOLOR(182, 219, 246) forKeyPath:[NSString stringWithFormat:@"_%@.%@", @"placeholderLabel", @"textColor"]];
}

- (void)setSearchBarTintColor:(UIColor *)searchBarTintColor {
    if (self.nativeSearchField && [self.nativeSearchField respondsToSelector:@selector(setTintColor:)]) {
        [self.nativeSearchField performSelector:@selector(setTintColor:) withObject:searchBarTintColor];
    }
}

- (void)setCancelButtonColor:(UIColor *)cancelButtonColor {
    _cancelButtonColor = cancelButtonColor;
    if (self.cancelButton) {
        [self.cancelButton setTitleColor:cancelButtonColor forState:UIControlStateNormal];
    }
}

#pragma mark - Private Methods

- (void)_configPlaceholderCenter:(BOOL)isCenter {
    if (isCenter) {
        [self layoutSubviews];
        [self.nativeSearchField layoutSubviews];
        UILabel *textLabel;
        UIImageView *fieldBackgroundView;
        for (UIView *subview in self.nativeSearchField.subviews) {
            if ([subview isKindOfClass:UILabel.class]) {
                textLabel = (UILabel *)subview;
                continue;
            }
            if ([subview isKindOfClass:UIImageView.class] && subview.frame.size.width / subview.frame.size.height > 2) {
                fieldBackgroundView = (UIImageView *)subview;
                continue;
            }
        }
        [self setPositionAdjustment:UIOffsetMake((fieldBackgroundView.frame.size.width - textLabel.frame.size.width) / 2 - _contentInset.left - 8, 0) forSearchBarIcon:UISearchBarIconSearch];
    } else {
        [self setPositionAdjustment:UIOffsetZero forSearchBarIcon:UISearchBarIconSearch];
    }
}

- (void)_jdyCancelButtonPressed:(id)sender {
    if ([self respondsToSelector:NSSelectorFromString(_originalCancelButtonAction)]) {
        [self performSelector:NSSelectorFromString(_originalCancelButtonAction) withObject:self.cancelButton];
    }
    self.contentInset = UIEdgeInsetsMake(8, 16, 8, 16);
    [self _configPlaceholderCenter:_placeholderAlignment == JDYNativeSearchBarPlaceholderAlignmentCenter];
    _cancelButton = nil;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    BOOL bShouldBegin = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)]) {
        bShouldBegin = [self.delegate searchBarShouldBeginEditing:self];
    }
    if (bShouldBegin) {
        [self _configPlaceholderCenter:NO];
    }
    return bShouldBegin;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarTextDidBeginEditing:)]) {
        [self.delegate searchBarTextDidBeginEditing:self];
    }
    if (self.cancelButton) {
        self.contentInset = UIEdgeInsetsMake(8, 16, 8, 16 + self.cancelButton.frame.size.width + 5);
        [self.cancelButton setTitleColor:_cancelButtonColor forState:UIControlStateNormal];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    BOOL bShouldEnd = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
        bShouldEnd = [self.delegate searchBarShouldEndEditing:self];
    }
    if (bShouldEnd && textField.text.length == 0) {
        if (self.cancelButton && _bIsOnSearchController) {
            self.contentInset = UIEdgeInsetsMake(8, 16, 8, 16);
            _cancelButton = nil;
        }
        [self _configPlaceholderCenter:_placeholderAlignment == JDYNativeSearchBarPlaceholderAlignmentCenter];
    }
    return bShouldEnd;
}

@end


