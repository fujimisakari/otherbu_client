//
//  MasterData.m
//  Otherbu
//
//  Created by fujimisakari
//  Copyright (c) 2015 fujimisakari. All rights reserved.
//

#import "MasterData.h"

@implementation MasterData

+ (NSArray *)initSearchData {
    // 検索サイトのデータ
    NSArray *dataList = @[
        @{@"dataId" : @"1", @"name" : @"Google", @"url" : @"https://www.google.co.jp"},
        @{@"dataId" : @"2", @"name" : @"Yahoo", @"url" : @"http://www.yahoo.co.jp"},
        @{@"dataId" : @"3", @"name" : @"Bing", @"url" : @"https://www.bing.com"}
    ];
    return dataList;
}

+ (NSArray *)initBookmarkBGColorData {
    // ブックマークの背景色のデータ
    NSArray *dataList = @[
        @{
            @"id" : [Helper getNumberByInt:1],
            @"name" : @"yellow",
            @"thumbnail_color_code" : @"#81f3fd",
            @"sort" : @"1",
        },
        @{
            @"id" : [Helper getNumberByInt:2],
            @"name" : @"gold",
            @"thumbnail_color_code" : @"#ffdb4c",
            @"sort" : @"2",
        },
        @{
            @"id" : [Helper getNumberByInt:3],
            @"name" : @"red",
            @"thumbnail_color_code" : @"#dd0000",
            @"sort" : @"3",
        },
        @{
            @"id" : [Helper getNumberByInt:4],
            @"name" : @"blue",
            @"thumbnail_color_code" : @"#87fc70",
            @"sort" : @"4",
        },
        @{
            @"id" : [Helper getNumberByInt:5],
            @"name" : @"white",
            @"thumbnail_color_code" : @"#52edc7",
            @"sort" : @"5",
        },
        @{
            @"id" : [Helper getNumberByInt:6],
            @"name" : @"orange",
            @"thumbnail_color_code" : @"#5ac8fb",
            @"sort" : @"6",
        },
        @{
            @"id" : [Helper getNumberByInt:7],
            @"name" : @"dodger",
            @"thumbnail_color_code" : @"#ef4db6",
            @"sort" : @"7",
        },
        @{
            @"id" : [Helper getNumberByInt:8],
            @"name" : @"pink",
            @"thumbnail_color_code" : @"#c643fc",
            @"sort" : @"8",
        },
        @{
            @"id" : [Helper getNumberByInt:9],
            @"name" : @"forest",
            @"thumbnail_color_code" : @"#228b22",
            @"sort" : @"9",
        },
        @{
            @"id" : [Helper getNumberByInt:10],
            @"name" : @"lime",
            @"thumbnail_color_code" : @"#4a4a4a",
            @"sort" : @"10",
        },
        @{
            @"id" : [Helper getNumberByInt:11],
            @"name" : @"black",
            @"thumbnail_color_code" : @"#2b2b2b",
            @"sort" : @"11",
        },
        @{
            @"id" : [Helper getNumberByInt:12],
            @"name" : @"sienna",
            @"thumbnail_color_code" : @"#898c90",
            @"sort" : @"12",
        },
        @{
            @"id" : [Helper getNumberByInt:13],
            @"name" : @"purplered",
            @"thumbnail_color_code" : @"#dbddde",
            @"sort" : @"13",
        },
        @{
            @"id" : [Helper getNumberByInt:14],
            @"name" : @"wood",
            @"thumbnail_color_code" : @"#EEDD82",
            @"sort" : @"14",
        },
        @{
            @"id" : [Helper getNumberByInt:15],
            @"name" : @"olive",
            @"thumbnail_color_code" : @"#5856d6",
            @"sort" : @"15",
        },
        @{
            @"id" : [Helper getNumberByInt:16],
            @"name" : @"purple",
            @"thumbnail_color_code" : @"#7d26cd",
            @"sort" : @"16",
        },
        @{
            @"id" : [Helper getNumberByInt:17],
            @"name" : @"tomato",
            @"thumbnail_color_code" : @"#ee5c42",
            @"sort" : @"17",
        },
        @{
            @"id" : [Helper getNumberByInt:18],
            @"name" : @"grey",
            @"thumbnail_color_code" : @"#8b7b8b",
            @"sort" : @"18",
        }
    ];

    return dataList;
}

+ (NSArray *)initColorData {
    // 共通のカラーデータ
    NSArray *dataList = @[
        @{
            @"id" : [Helper getNumberByInt:1],
            @"name" : @"yellow",
            @"font_color" : @"#000",
            @"icon_color" : @"black",
            @"sort" : @"70",
            @"color_code1" : @"#FFFF00",
            @"color_code2" : @"#B0B000",
            @"color_code3" : @"#ABAB00",
            @"thumbnail_color_code" : @"#ffff00"
        },
        @{
            @"id" : [Helper getNumberByInt:2],
            @"name" : @"gold",
            @"font_color" : @"#FFF",
            @"icon_color" : @"white",
            @"sort" : @"10",
            @"color_code1" : @"#FFC600",
            @"color_code2" : @"#AB8400",
            @"color_code3" : @"#A37F00",
            @"thumbnail_color_code" : @"#f2bc00"
        },
        @{
            @"id" : [Helper getNumberByInt:3],
            @"name" : @"red",
            @"font_color" : @"#FFF",
            @"icon_color" : @"white",
            @"sort" : @"20",
            @"color_code1" : @"#FF0000",
            @"color_code2" : @"#8F0000",
            @"color_code3" : @"#870000",
            @"thumbnail_color_code" : @"#dd0000"
        },
        @{
            @"id" : [Helper getNumberByInt:4],
            @"name" : @"blue",
            @"font_color" : @"#FFF",
            @"icon_color" : @"white",
            @"sort" : @"30",
            @"color_code1" : @"#0000FF",
            @"color_code2" : @"#00008F",
            @"color_code3" : @"#000080",
            @"thumbnail_color_code" : @"#0000ee"
        },
        @{
            @"id" : [Helper getNumberByInt:5],
            @"name" : @"white",
            @"font_color" : @"#000",
            @"icon_color" : @"black",
            @"sort" : @"120",
            @"color_code1" : @"#FFFFFF",
            @"color_code2" : @"#ADADAD",
            @"color_code3" : @"#A6A6A6",
            @"thumbnail_color_code" : @"#eeeeee"
        },
        @{
            @"id" : [Helper getNumberByInt:6],
            @"name" : @"orange",
            @"font_color" : @"#FFF",
            @"icon_color" : @"white",
            @"sort" : @"110",
            @"color_code1" : @"#F66E00",
            @"color_code2" : @"#8C3F00",
            @"color_code3" : @"#8A3D00",
            @"thumbnail_color_code" : @"#f66e00"
        },
        @{
            @"id" : [Helper getNumberByInt:7],
            @"name" : @"dodger",
            @"font_color" : @"#FFF",
            @"icon_color" : @"white",
            @"sort" : @"90",
            @"color_code1" : @"#1E90FF",
            @"color_code2" : @"#12599E",
            @"color_code3" : @"#115394",
            @"thumbnail_color_code" : @"#1e90ff"
        },
        @{
            @"id" : [Helper getNumberByInt:8],
            @"name" : @"pink",
            @"font_color" : @"#FFF",
            @"icon_color" : @"white",
            @"sort" : @"80",
            @"color_code1" : @"#FF69B4",
            @"color_code2" : @"#85375E",
            @"color_code3" : @"#82365C",
            @"thumbnail_color_code" : @"#ff69b4"
        },
        @{
            @"id" : [Helper getNumberByInt:9],
            @"name" : @"forest",
            @"font_color" : @"#FFF",
            @"icon_color" : @"white",
            @"sort" : @"40",
            @"color_code1" : @"#269C26",
            @"color_code2" : @"#104010",
            @"color_code3" : @"#0E3B0E",
            @"thumbnail_color_code" : @"#228b22"
        },
        @{
            @"id" : [Helper getNumberByInt:10],
            @"name" : @"lime",
            @"font_color" : @"#FFF",
            @"icon_color" : @"white",
            @"sort" : @"100",
            @"color_code1" : @"#3EFC3E",
            @"color_code2" : @"#28A628",
            @"color_code3" : @"#27A127",
            @"thumbnail_color_code" : @"#32cd32"
        },
        @{
            @"id" : [Helper getNumberByInt:11],
            @"name" : @"black",
            @"font_color" : @"#FFF",
            @"icon_color" : @"white",
            @"sort" : @"60",
            @"color_code1" : @"#5E5E5E",
            @"color_code2" : @"#292929",
            @"color_code3" : @"#000000",
            @"thumbnail_color_code" : @"#242424"
        },
        @{
            @"id" : [Helper getNumberByInt:12],
            @"name" : @"sienna",
            @"font_color" : @"#FFF",
            @"icon_color" : @"white",
            @"sort" : @"50",
            @"color_code1" : @"#E3733E",
            @"color_code2" : @"#6B371D",
            @"color_code3" : @"#63331B",
            @"thumbnail_color_code" : @"#8b4726"
        },
        @{
            @"id" : [Helper getNumberByInt:13],
            @"name" : @"purplered",
            @"font_color" : @"#FFF",
            @"icon_color" : @"white",
            @"sort" : @"140",
            @"color_code1" : @"#FF1FB4",
            @"color_code2" : @"#85105E",
            @"color_code3" : @"#82105C",
            @"thumbnail_color_code" : @"#FF1FB4"
        },
        @{
            @"id" : [Helper getNumberByInt:14],
            @"name" : @"wood",
            @"font_color" : @"#FFF",
            @"icon_color" : @"white",
            @"sort" : @"130",
            @"color_code1" : @"#FFED8B",
            @"color_code2" : @"#7A7143",
            @"color_code3" : @"#7D7544",
            @"thumbnail_color_code" : @"#EEDD82"
        },
        @{
            @"id" : [Helper getNumberByInt:15],
            @"name" : @"olive",
            @"font_color" : @"#FFF",
            @"icon_color" : @"white",
            @"sort" : @"160",
            @"color_code1" : @"#739140",
            @"color_code2" : @"#293316",
            @"color_code3" : @"#242E14",
            @"thumbnail_color_code" : @"#556b2f"
        },
        @{
            @"id" : [Helper getNumberByInt:16],
            @"name" : @"purple",
            @"font_color" : @"#FFF",
            @"icon_color" : @"white",
            @"sort" : @"150",
            @"color_code1" : @"#9B2FFF",
            @"color_code2" : @"#591B91",
            @"color_code3" : @"#54198A",
            @"thumbnail_color_code" : @"#7d26cd"
        },
        @{
            @"id" : [Helper getNumberByInt:17],
            @"name" : @"tomato",
            @"font_color" : @"#FFF",
            @"icon_color" : @"white",
            @"sort" : @"170",
            @"color_code1" : @"#FF6347",
            @"color_code2" : @"#9C3C2B",
            @"color_code3" : @"#963A2A",
            @"thumbnail_color_code" : @"#ee5c42"
        },
        @{
            @"id" : [Helper getNumberByInt:18],
            @"name" : @"grey",
            @"font_color" : @"#FFF",
            @"icon_color" : @"white",
            @"sort" : @"180",
            @"color_code1" : @"#8B7B8B",
            @"color_code2" : @"#524852",
            @"color_code3" : @"#4D444D",
            @"thumbnail_color_code" : @"#8b7b8b"
        }
    ];

    return dataList;
}

@end
