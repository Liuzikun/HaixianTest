//
//  JDYNativeSearchBar.h
//  JDY
//
//  Created by mesird on 2017/11/6.
//  Copyright © 2017年 Tmall.com. All rights reserved.
//
//  一个继承自 UISearchBar 的搜索框控件，为了兼容 iOS 11 原生搜索框样式改变，
//  提供了一系列属性来修改搜索框的样式。

#import <UIKit/UIKit.h>


/**
 搜索框占位符（包括 Search Icon 和搜索文字）的水平布局方案

 - JDYNativeSearchBarPlaceholderAlignmentLeft:   局左布局
 - JDYNativeSearchBarPlaceholderAlignmentCenter: 居中布局
 */
typedef NS_ENUM(NSUInteger, JDYNativeSearchBarPlaceholderAlignment) {
    JDYNativeSearchBarPlaceholderAlignmentLeft,
    JDYNativeSearchBarPlaceholderAlignmentCenter
};

@interface JDYNativeSearchBar : UISearchBar
{
    @public
    BOOL _bIsOnSearchController;    // 搜索框是否在 SearchController 上，默认为 NO
}

// SearchBar 输入框内边距，默认 上左下右 (8, 16, 8, 16)
@property (nonatomic, assign) UIEdgeInsets contentInset;

// SearchBar 内部四角半径
@property (nonatomic, assign) CGFloat barCornerRadius;

// SearchBar 内部背景色
@property (nonatomic, assign) UIColor *barBackgroundColor;

// SearchBar 周围背景色
@property (nonatomic, assign) UIColor *viewBackgroundColor;

// 占位符（包含 Search Icon 和文字占位符）的水平布局
@property (nonatomic, assign) JDYNativeSearchBarPlaceholderAlignment placeholderAlignment;

// SearchBar 搜索图标
@property (nonatomic, strong) UIImage *searchIcon;

// SearchBar 删除按钮图标
@property (nonatomic, strong) UIImage *clearIcon;

// SearchBar 文字颜色
@property (nonatomic, strong) UIColor *searchTextColor;

// SearchBar 占位符字体颜色
@property (nonatomic, strong) UIColor *searchPlaceholderColor;

// SearchBar 浮标颜色
@property (nonatomic, strong) UIColor *searchBarTintColor;

// SearchBar 取消按钮颜色
@property (nonatomic, strong) UIColor *cancelButtonColor;

@end
