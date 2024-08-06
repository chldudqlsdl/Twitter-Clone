
# ツイッタークローン<img src="https://github.com/chldudqlsdl/Twitter-Clone/assets/83645833/8f1f4b8b-e8c6-47b4-a181-8f455f8b32b2" align=left width=150>

> SNS ツイッターアプリのクローンコーディングプロジェクト 🐦  
> 一人開発 (24.04.11 ~ 24.04.28)  
> [📺 アプリデモ動画のリンク(YouTube)](https://www.youtube.com/watch?v=S8YdGWRe8kQ&t=36s)


<br />

## ✨機能と実装内容
<img src="https://github.com/chldudqlsdl/Twitter-Clone/assets/83645833/908a38fc-a75c-4e4c-a5d7-8c360a5acc92" >

**0. アーキテクチャおよび主要技術** 
  - MVVMアーキテクチャを活用して、ViewとViewModelの役割を区別
 - Firebaseを活用したサーバー通信および認証（ログイン・会員登録）

**1. ログイン・会員登録（画像1）**
  - **FirebaseAuthを利用したログイン・会員登録の実装**
  - FirebaseAuth内部では、ログイン時に認証情報をKeychainに保存
-   メインビューでKeychainの保存情報を確認し、認証情報があればメインビューをそのまま表示
- 認証情報がなければ、ログイン画面を表示

**2. メインタブ（フィード）（画像2・3・4）**
  - **ユーザーのすべてのツイートを取得し、フィード（コレクションビュー）に表示**
  - フィードはrefreshControlを使用して更新
- 他のユーザーのツイートにコメントを投稿する機能
- プロフィールビュー - ユーザーのプロフィールおよび投稿したツイートを表示、フォロー機能
- ツイート詳細ビュー - いいねの数や投稿されたコメントを表示

**3. ツイートアップロードビュー（画像5）**
 - **ツイート・コメントのアップロード機能**
 - ビューのパラメータとして列挙型を受け取り、ツイート・リプライに応じて異なるUIとメソッドを使用

**4. ユーザー検索タブ（画像6）**
 - **Twitterを利用しているすべてのユーザーを検索する機能**
- UISearchController・UISearchResultsUpdatingを使用して実装

**5. 通知タブ（画像7）**
 - **自分をフォローしたり、ツイートにいいねやコメントを残した際に通知が届く**
- 誰かをフォローしたり、ツイートにいいねやコメントを残した際に、DBのnotificationsテーブルに保存
- Firebaseの.observe(.childAdded)メソッドを使用してこれをリアルタイムで検知し、通知を表示



<br />


## 🤔 開発過程での悩みと学んだ点
<details>
<summary><strong style="font-size: 1.2em;">循環参照によるメモリリークを実験を通じて視覚的に確認</strong></summary>
<br>

**[実験動画のリンク(Youtube)](https://youtu.be/3YWHEmkB2C0?si=6q0Q1wwKUlTxYHmC&t=1m44s)**

**カスタムデリゲートパターンを使用している際に循環参照が発生する状況が発生**

`ProfileController` クラスが参照するコレクションビューのヘッダーとして `ProfileHeader` のインスタンスが割り当てられると参照が発生します。その後、`ProfileHeader` のデリゲートとして `ProfileController(self)` が割り当てられることで、再び参照が発生します。これは、お互いを強く参照しているため、循環参照が発生し、これがメモリリークを引き起こす状況です。

```swift
// ProfileController
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        header.user = user
        header.delegate = self
        return header
    }
}
// ProfileHeader
class ProfileHeader: UICollectionReusableView {
    var delegate: ProfileHeaderDelegate?
    // weak var delegate: ProfileHeaderDelegate?
    // ... [中略] ...
}
```

 **メモリリークを実験を通じてグラフで確認する**

循環参照を防ぐためには、`weak var delegate` のように弱い参照を使用することで達成できます。しかし、実際にメモリリークが発生する場合にメモリグラフがどのように変化するかを確認してみました。

`weak` を使用した場合と使用しない場合、それぞれ10回ずつ `ProfileController` ビューを開いて閉じた後のメモリ使用量を比較しました。`weak` を使用しなかった場合、使用したメモリ量が逆のケースよりも4MB多いことが確認されました。

カスタムデリゲートパターンやクロージャーが `self` をキャプチャする場合など、機械的に `weak` を使うことが多いですが、メモリリークの状況を実験することでその重要性を再認識しました。

<img width="250" src="https://github.com/chldudqlsdl/Twitter-Clone/assets/83645833/59298d38-ed09-47ba-8a04-b124e3e71222">

<img width="250" alt="스크린샷 2024-06-22 오후 4 31 19" src="https://github.com/chldudqlsdl/Twitter-Clone/assets/83645833/ba36dab7-67ba-4d68-bf61-ab245bbbb44e">
</details>

<details>
<summary><strong style="font-size: 1.2em;">カスタムアクションシートを実装</strong></summary>
<br>
<img width="200" alt="스크린샷 2024-06-22 오후 6 00 35" src="https://github.com/chldudqlsdl/Twitter-Clone/assets/83645833/d32537ff-d5bb-434f-b90c-83e337dbf2c9">

<br>
<br>

 **UIAlertController とできるだけ似た形で実装する**

`UIAlertController` のように、ナビゲーションバーやタブバーの上に表示し、背景がぼやけるようにする必要があります。既存の `UIViewController` をプレゼンテーションする方法や、`navigationController` で `pushViewController` する方法では実装できません。

**ビューの階層構造**

背景のビューをそのまま維持しながら、前面にアクションシートを追加するには、ビュー階層のルートコンテナである `UIWindow` にビューを追加する必要があります。ビュー階層は広い視点で見ると、`UIScreen` - `UIWindowScene` - `UIWindow` で構成されています。`UIWindowScene` を通じて `UIWindow` にアクセスできます。`isKeyWindow` プロパティは現在ユーザー入力を受け取っている `UIWindow` を意味するため、このプロパティが `true` の `UIWindow` にアクセスして、必要な操作を実行することができます。

```swift
// ActionSheetLauncher
func show() {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
    guard let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
    
    window.addSubview(blackView)
    blackView.frame = window.frame
    
    window.addSubview(tableView)
    tableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: actionSheetHeight)
    
    UIView.animate(withDuration: 0.5) {
        self.blackView.alpha = 1
        self.tableView.frame.origin.y -= self.actionSheetHeight
    }
}
```

</details>

<details>
<summary><strong style="font-size: 1.2em;">学んだこと</strong></summary>

## カスタムデリゲートパターン

### ビューコントローラー間の通信を通じてイベント処理を行う際に、カスタムデリゲートパターンを使用する

```swift
// FeedController
extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.delegate = self
        return cell
    }
}
extension FeedController: TweetCellDelegate {
    func handleProfileImageTapped(_ cell: TweetCell) {
        let vc = ProfileController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// TweetCell
protocol TweetCellDelegate: AnyObject {
    func handleProfileImageTapped(_ cell: TweetCell)
}
class TweetCell : UICollectionViewCell {
    weak var delegate: TweetCellDelegate?
    
    @objc func handleProfileImageTapped() {
        delegate?.handleProfileImageTapped(self)
    }
}
```

## Enum を活用して再利用可能なコードを書く

<img width="200" alt="스크린샷 2024-06-22 오후 9 53 22" src="https://github.com/chldudqlsdl/Twitter-Clone/assets/83645833/90386eac-98a7-4467-854d-369e22ba531f">
<img width="200" alt="스크린샷 2024-06-22 오후 9 53 40" src="https://github.com/chldudqlsdl/Twitter-Clone/assets/83645833/36a5e429-0bbf-41f9-ad55-16af0ad5df88">

上の図のように、ツイートを作成するビューと他の人のツイートにコメントを作成するビューは非常に似ています。ビューを別々に作成せず、1つのビューに `tweet` と `reply` のケースを持つ Enum を渡すことで再利用可能なビューを実装しました。

`reply` ケースは関連値をパラメータとして受け取り、どのツイートへの返信かを区別できるようにしました。投稿するメソッドでも、ケースごとに異なるコードを記述しました。

```swift
// UploadTweetViewModel
enum UploadTweetConfiguration {
    case tweet
    case reply(Tweet)
}

class UploadTweetViewModel {
    let actionButtonTitle: String
    init(config: UploadTweetConfiguration) {
        switch config {
        case .tweet:
            actionButtonTitle = "Tweet"
        case .reply(let tweet):
            actionButtonTitle = "Reply"
        }
    }
}

// uploadTweetController
class UploadTweetController: UIViewController {
    private let config: UploadTweetConfiguration
    private lazy var viewModel = UploadTweetViewModel(config: config)
    
    @objc func handleUploadTweet() {
        TweetService.shared.uploadTweet(caption: caption, type: config) 
    }
}

// TweetService
struct TweetService {
    func uploadTweet(caption: String, type: UploadTweetConfiguration, completion: @escaping ( Error?, DatabaseReference) -> Void) {       
        switch type {
        case .tweet:
            REF_TWEETS.childByAutoId().updateChildValues(values) { err, ref in
                REF_USER_TWEETS.child(uid).updateChildValues([tweetID: 1], withCompletionBlock: completion)
            }
        case .reply(let tweet):
            REF_TWEET_REPLIES.child(tweet.tweetID).childByAutoId().updateChildValues(values, withCompletionBlock: completion)
        }
    }
}
```

</details>

<details>
<summary><strong style="font-size: 1.2em;">全体開発日誌</strong></summary>

<br />
  
**[全体開発日誌のリンク(Notion)](https://slowsteadybrown.notion.site/Twitter-iOS-Clone-5d7e0d87ea594045a448c9f636283782?pvs=4)**
  
</details>

<br />

## 📚 Architecture ∙ Framework ∙ Library

| Category| Name | Tag |
| ---| --- | --- |
| Architecture| MVVM |  |
| Framework| UIKit | UI |
|Library | Firebase | DB ∙ Authentication |
| | SnapKit | Layout |
| | Kingfisher | Image Caching |

<br />

## 🗂 フォルダー構造
~~~
📦 TwitterTutorial
 ┣ 📂App
 ┣ 📂Network
 ┣ 📂Model
 ┣ 📂Presentation
 ┃ ┣ 📂AuthenticationScene
 ┃ ┣ 📂MainTabBarScene
 ┃ ┣ 📂FeedScene
 ┃ ┣ 📂UploadTweetScene
 ┃ ┣ 📂ProfileScene
 ┃ ┣ 📂TweetScene
 ┃ ┣ 📂ExploreScene
 ┃ ┣ 📂NotificationScene
 ┃ ┣ 📂ConversationScene
 ┃ ┗ 📂Common
 ┗ 📂Utility
~~~

<br />

## 📺 アプリの起動画面
|ログイン・会員登録ビュー|メインタブ|ツイートアップロードビュー|ユーザー検索タブ|通知タブ|
|-|-|-|-|-|
|<img width="180" src="https://github.com/chldudqlsdl/ODindi/assets/83645833/ce54e955-4b91-4c8d-9e98-78feb91d4bae">|<img width="180" src="https://github.com/chldudqlsdl/ODindi/assets/83645833/7aafa33b-6249-4931-a922-086e87816e6f">|<img width="180" src="https://github.com/chldudqlsdl/ODindi/assets/83645833/45486562-e6c1-42db-bf18-3d19cababcb5">|<img width="180" src="https://github.com/chldudqlsdl/ODindi/assets/83645833/e4c8b61f-ecc0-4c6f-9ce7-51f39197b308">|<img width="180" src="https://github.com/chldudqlsdl/ODindi/assets/83645833/525a2c96-d117-4522-b2f6-cee401af29f3">|





