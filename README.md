[**English Ver Here**](README-en.md)
# Nursery
**Nursery**とは、Cocoaフレームワーク向けのオブジェクト指向データベース（OODB）です。
フレームワークとして開発しているので、アプリケーションに組み込む形で利用できます。

## ライセンス
ライセンスは、zlibですので、商用・非商用のどちらでも利用できます。

## 寄付
以下のサービスで寄付を受け付けています:
* [GitHub Sponsors](https://github.com/sponsors/Lily-bud)
* [PayPal(paypal.me/AkifumiTakata)](https://paypal.me/AkifumiTakata) 

## 概要
* シンプルかつパワフル
* ほぼ全てをObjective-Cで記述
* FoundationフレームワークとCore Foundationフレームワーク（ソケット作成のため）のみで実装
* ACID準拠
* 遅延読み込み
* データベースファイル内のガベージコレクションとコンパクション
* 複数プロセスからの同時使用
* ORMではない

### 永続化可能なオブジェクトのリスト
* NULibrary B+木を実装したコレクションクラス
* **NUCoding** プロトコルを実装したクラス
* **NUCoder** のサブクラスを使って永続化処理を実装したクラス
* NSObject
* NSString
* NSMutableString
* NSArray
* NSMutableArray
* NSDictionary
* NSMutableDictionary
* NSSet
* NSMutableSet
* NSNumber
* NSDate
* NSURL
* NSData
* NSMutableData
* NSIndexSet
* NSMutableIndexSet

### シンプルな使用例 
```objc
#import <Nursery/Nursery.h>

NUMainBranchNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:@"path/to/file"];
NUGarden *aGarden = [aNursery makeGarden];

[aGarden setRoot:@"Hi, I'm Nursery"];
    
[aGarden farmOut];
```

### NUCoding プロトコルを使用した例
```objc
#import <Nursery/Nursery.h>

NUMainBranchNursery *aNursery = [NUMainBranchNursery nurseryWithContentsOfFile:@"path/to/file"];
NUGarden *aGarden = [aNursery makeGarden];
    
Person *aPerson = [Person new];

[aPerson setFirstName:@"Akifumi"];
[aPerson setLastName:@"Takata"];

[aGarden setRoot:aPerson];
    
[aGarden farmOut];

// Person Class
@interface Person : NSObject <NUCoding>
{
    NSString *firstName;
    NSString *lastName;
}

@property (weak) NUBell *bell;

- (NSString *)firstName;
- (void)setFirstName:(NSString *)aFirstName;

- (NSString *)lastName;
- (void)setLastName:(NSString *)aLastName;

@end

@implementation Person

+ (BOOL)automaticallyEstablishCharacter
{
    return YES;
}

+ (void)defineCharacter:(NUCharacter *)aCharacter on:(NUGarden *)aGarden
{
    [aCharacter addOOPIvarWithName:@"firstName"];
    [aCharacter addOOPIvarWithName:@"lastName"];
}

- (void)encodeWithAliaser:(NUAliaser *)anAliaser
{
    [anAliaser encodeObject:firstName forKey:@"firstName"];
    [anAliaser encodeObject:lastName forKey:@"lastName"];
}

- (instancetype)initWithAliaser:(NUAliaser *)anAliaser
{
    self = [super init];
    if (self)
    {
        firstName = [anAliaser decodeObjectForKey:@"firstName"];
        lastName = [anAliaser decodeObjectForKey:@"lastName"];
    }
    return self;
}

- (NSString *)firstName
{
    return NUGetIvar(&firstName);
}

- (void)setFirstName:(NSString *)aFirstName
{
    NUSetIvar(&firstName, aFirstName);
    [[self bell] markChanged];
}

- (NSString *)lastName
{
    return NUGetIvar(&lastName);
}

- (void)setLastName:(NSString *)aLastName
{
    NUSetIvar(&lastName, aLastName);
    [[self bell] markChanged];
}

@end
```

## macOS サポート
macOS (10.13 以上)

## ビルド方法
1. プロジェクトページの"Open with Xcode"ボタンをクリックして、デスクトップ等にクローンする
2. Xcodeのメニューバーの"Product"から"Build"を選択する

## もう少し詳しい情報
### エンディアン非依存
インスタンス変数はエンコーディング時にビッグエンディアンに変換され、デコード時にホストのエンディアンに変換されます

### スレッドセーフティ
オブジェクトの読み込みと保存は、そのオブジェクトのエンコード/デコード時に呼び出されるメソッドがスレッドセーフである限り、スレッドセーフです。

### 複数プロセスからの同時使用
**Nursery** は複数プロセスからの同時使用をサポートしています

### 耐久性
**Nursery** は write-ahead ロギング (WAL)を実装しています

### データベースファイル内のガベージコレクション
* **Nursery** のルートオブジェクトから到着できないオブジェクトは、GCによって自動的に解放されます
* 循環参照を適切に取り扱えます
* GCのアルゴリズムには3色マーキングを採用しています
* 解放された領域はコンパクト化されます

## 参照
* [ドキュメント（英語）](Documents/)  

## コントリビューション
バグ修正歓迎です
