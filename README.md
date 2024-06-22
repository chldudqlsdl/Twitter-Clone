
# 트위터 클론<img src="https://github.com/chldudqlsdl/Twitter-Clone/assets/83645833/8f1f4b8b-e8c6-47b4-a181-8f455f8b32b2" align=left width=120>

> SNS 트위터 앱 클론코딩 프로젝트 🐦  
> 1인 개발 (24.04.11 ~ 24.04.28)

<br />

## ✨ 기능 및 구현사항
<img src="https://github.com/chldudqlsdl/Twitter-Clone/assets/83645833/908a38fc-a75c-4e4c-a5d7-8c360a5acc92" >

**0. 아키텍쳐 및 주요기술** 
  - MVVM 아키텍쳐를 활용해 View ∙ ViewModel 의 역할 구분
 - Firebase 를 활용한 서버통신 및 인증(로그인 ∙ 회원가입)

**1. 로그인 ∙ 회원가입** (이미지 1)
  - **FirebaseAuth 를 활용해 로그인 ∙ 회원가입 구현**
  - FirebaseAuth 내부에선 로그인시 인증정보를 Keychain 에 저장함
  - 메인뷰에서 Keychain 저장 정보 확인 후 인증정보가 있으면 메인뷰 그대로 표출
  - 인증정보가 없으면 로그인 화면 present

**2. 메인탭(피드)** (이미지 2 ∙ 3 ∙ 4)
  - **사용자의 모든 트윗을 불러와 피드에(컬렉션뷰) 표출**
  - 피드는 refreshControl 을 이용해 새로고침
 -  다른 사람의 트윗에 댓글 작성 기능
  - 프로필뷰 - 사용자의 프로필 ∙ 작성한 트윗을 표출, 팔로우 기능
  - 트윗 상세 뷰 - 좋아요 수 ∙ 작성된 댓글 표출

**3. 트윗 업로드 뷰** (이미지 5)
 - **트윗 ∙ 댓글 업로드 기능**
 - 뷰의 매개변수로 열거형을 받아 tweet ∙ reply 여부에 따라 하나의 뷰에서 다른 UI와 메서드 사용

**4. 유저 탐색 탭** (이미지 6)
 - **트위터를 사용중인 모든 유저 검색 기능**
- UISearchController ∙ UISearchResultsUpdating 를 사용해 구현

**5. 알림 탭** (이미지 7)
 - **나를 팔로우하거나 트윗에 좋아요 ∙ 댓글을 남길 시 알림이 도착**
- 누군가를 팔로우하거나, 트윗에 좋아요 ∙ 댓글을 남길 시 DB의 notifications 테이블에 이를 저장
- firebase 의 `.observe(.childAdded)` 메서드를 사용하여 이를 실시간으로 감지 후 알림 표출



<br />


## 🤔 개발과정의 고민

<details>
<summary><strong style="font-size: 1.2em;">고민한 점</strong></summary>

## 순환참조를 통한 메모리 누수를 실험을 통해 눈으로 확인

**[실험영상링크(Youtube)](https://youtu.be/3YWHEmkB2C0?si=6q0Q1wwKUlTxYHmC&t=1m44s)**

**커스텀 델리게이트 패턴을 사용하면서 순환참조가 일어나는 상황이 발생**

`ProfileController` 클래스가 참조하는 컬렉션뷰의 헤더로 `ProfileHeader` 의 인스턴스가 할당되면서 참조가 발생한다. 이어서 `ProfileHeader` 의 delegate 로 `ProfileController(self)` 가 할당되면서 다시 참조가 발생한다.  
이는 서로 강하게 참조하고 있기 때문에 순환참조가 발생하는 상황이며 이것이 메모리 누수를 야기한다

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
    // ... [후략] ...
}
```

 **메모리 누수를 실험을 통해 그래프로 확인하기**

순환참조를 방지하는 것은 `weak var delegate` 과 같이 약하게 참조하게 변경하면 달성할 수 있다. 하지만 나아가 실제로 메모리 누수가 발생할 경우 메모리 그래프가 어떻게 변하는지 확인해보았다. 

`weak` 를 써준 경우와 안 써준 경우 각각 열번씩 `ProfileController` 뷰를 열고 닫은 후 메모리 사용량을 비교해본 모습이다. `weak` 를 써주지 않은 경우 반대의 경우보다 4MB 의 메모리가 더 사용되고 있음을 확인하였다.

커스텀 델리게이트 패턴 사용의 경우나, 클로저가 self 를 캡처하는 경우 기계적으로 weak 를 써줄 때가 많았지만, 메모리 누수 상황을 실험하면서 중요성을 절감하게 되었다.

<img width="250" src="https://github.com/chldudqlsdl/Twitter-Clone/assets/83645833/59298d38-ed09-47ba-8a04-b124e3e71222">

<img width="250" alt="스크린샷 2024-06-22 오후 4 31 19" src="https://github.com/chldudqlsdl/Twitter-Clone/assets/83645833/ba36dab7-67ba-4d68-bf61-ab245bbbb44e">



## 커스텀 액션시트 만들기

<img width="200" alt="스크린샷 2024-06-22 오후 6 00 35" src="https://github.com/chldudqlsdl/Twitter-Clone/assets/83645833/d32537ff-d5bb-434f-b90c-83e337dbf2c9">

<br>
<br>

 **UIAlertController 와 최대한 유사하게 구현하기**

UIAlertController 와 같이 네비게이션바나 탭바 위를 덮어야 하고, 뒷배경이 흐려져야 한다. 기존의 ViewController 를 present 하거나, navigationController 에서 pushViewController 하는 방식으로는 구현불가

**뷰의 계층구조**

배경의 뷰를 그대로 살리면서 앞단에 액션시트를 추가하려면 뷰 계층구조의 루트 컨테이너인 UIWindow 에 뷰를 추가하여야 한다. 뷰 계층구조는 넓게 보면 UIScreen - UIWindowScene - UIWindow 로 구성되어 있는데, UIWindowScene 을 통해서 UIWindow 에 접근할 수 있다. `isKeyWindow` 속성은 현재 사용자 입력을 받는 UIWindow 를 의미하기에 해당 속성이 true 인 UIWindow 에 접근하여 원하는 작업을 수행할 수 있다.

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
<summary><strong style="font-size: 1.2em;">학습한 점</strong></summary>

## 커스텀 델리게이트 패턴

### 뷰 컨트롤러간의 소통을 통해 이벤트 처리를 할 때, 커스텀 델리게이트 패턴 사용

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

## Enum 을 활용해 재사용 가능한 코드 작성하기

<img width="200" alt="스크린샷 2024-06-22 오후 9 53 22" src="https://github.com/chldudqlsdl/Twitter-Clone/assets/83645833/90386eac-98a7-4467-854d-369e22ba531f">
<img width="200" alt="스크린샷 2024-06-22 오후 9 53 40" src="https://github.com/chldudqlsdl/Twitter-Clone/assets/83645833/36a5e429-0bbf-41f9-ad55-16af0ad5df88">

위 그림과 같이 트윗을 작성하는 뷰와 다른 사람의 트윗에 대해 댓글을 작성한 뷰는 매우 유사하다. 뷰를 따로 만들지 않고, 하나의 뷰에 매개변수로 tweet 과 reply 케이스를 가지는 Enum 을 할당하여 재사용 가능한 뷰를 구현하였다. 

reply 케이스는 연관값을 매개변수로 받아 어떤 tweet 에 대한 reply 인지도 구분하도록 하였다. 작성된 글을 업로드하는 메서드에서도 케이스 별로 다른 코드를 작성해주었다.

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
<summary><strong style="font-size: 1.2em;">전체 개발일지 보기</strong></summary>

<br />
  
**[전체 개발 일지 링크(Notion)](https://slowsteadybrown.notion.site/Twitter-iOS-Clone-5d7e0d87ea594045a448c9f636283782?pvs=4)**
  
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

## 🗂 폴더 구조
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

## 📺 앱 구동 화면 
|로그인 ∙ 회원가입 뷰|메인 탭|트윗 업로드 뷰|유저 탐색 탭|알림 탭|
|-|-|-|-|-|
|<img width="180" src="https://github.com/chldudqlsdl/ODindi/assets/83645833/ce54e955-4b91-4c8d-9e98-78feb91d4bae">|<img width="180" src="https://github.com/chldudqlsdl/ODindi/assets/83645833/7aafa33b-6249-4931-a922-086e87816e6f">|<img width="180" src="https://github.com/chldudqlsdl/ODindi/assets/83645833/45486562-e6c1-42db-bf18-3d19cababcb5">|<img width="180" src="https://github.com/chldudqlsdl/ODindi/assets/83645833/e4c8b61f-ecc0-4c6f-9ce7-51f39197b308">|<img width="180" src="https://github.com/chldudqlsdl/ODindi/assets/83645833/525a2c96-d117-4522-b2f6-cee401af29f3">|




