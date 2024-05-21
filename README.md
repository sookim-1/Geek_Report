# 📚 덕후감
애니메이션을 보고 난 후 정보를 저장하는 서비스

## 📸 스크린샷
<img width="874" alt="home" src="https://github.com/sookim-1/Geek_Report/assets/55218398/5d82ad40-1a44-471f-9e04-aa594f60c91b">

<img width="874" alt="searchMyList" src="https://github.com/sookim-1/Geek_Report/assets/55218398/ffe8b826-5c84-4787-8c93-e9254e89461f">

<img width="874" alt="detail" src="https://github.com/sookim-1/Geek_Report/assets/55218398/83c52743-3226-418a-9334-1e67cc137b77">

# 사용기술
- **UIKit**, **CoreData**, **UICollectionViewCompositional Layout**, **DiffableDataSource**
- 3rdParty : **SnapKit**, **Then**, **RxSwift**, **RxGesture**, **Kingfisher**, **Lookin**, **Tuist**
- API : [**JikanAPI**](https://jikan.moe/)
- **CleanArchitecture**, **MVVM**


## 기술소개
### UICollectionViewCompositional Layout + DiffableDataSource

전체적인 UI구성을 위해 iOS13이상부터 사용가능한 UICollectionViewCompositional Layout과 DiffableDataSource를 활용했습니다.
홈 메인화면, 홈 더보기화면, 검색화면, 나의 목록화면에서 사용했습니다.

> Compositional Layout의 사용 장점
1. 확장성이 좋습니다.
  - 레이아웃이 변경되는 경우 유연하게 변경할 수 있습니다.
2. 가독성이 좋습니다.
  - 복잡한 레이아웃을 간단하게 구축가능하여 코드의 수가 줄어들고 명확합니다.

> Diffable DataSource의 사용 장점
1. 데이터가 변경될때마다 자동으로 데이터가 변경되는 애니메이션을 처리할 수 있습니다.
2. 기존방식을 사용한 경우 데이터가 변경될 때 DataSource와 UI의 버전이 다른 경우 에러가 발생하는데 Hashable을 활용하여 대비할 수 있습니다.
3. 가독성이 좋습니다. - 코드 수를 줄일 수 있습니다.

그 외로 iOS14이상부터 사용가능한 CellRegistration과 SupplementaryRegistration도 활용하여 가독성을 향상시켰습니다.<br>
사용방법들을 정리한 블로그글이 있는데 공감주시면 감사하겠습니다.<br>
👋 [iOS 14이상에서 UICollectionView 사용하기](https://sookim-1.tistory.com/entry/iOS-iOS-14이상에서-UICollectionView-사용하기)

---
### CleanArchitecture + MVVM 
▶️ CleanArchitecture

- **Data Layer** : (Network, Core Data -> DTO), Repository Implementation
- **Domain Layer** : UseCase, Model, Repository Interface
- **Presenter Layer** : UI, ViewModel

> Clean Architecture를 사용하고 느낀점
- DTO를 작성할 때, quicktype.io를 사용하는데 실제 필요한 키값만 정리를 할 필요가 없이 그대로 가져온 후 Domain Layer에서 Entities를 필요한 키값만 사용하면 프로젝트내에서 2가지(DTO, Entities)를 비교해갈 수 있는 장점이 있는 것 같다.
- UnitTest를 작성할 때, ViewModel만을 테스트하면 되기 때문에 테스트코드 작성이 수월한 것 같다.
- View의 변경이 자유로운 것 같다. (UIKit과 SwiftUI의 이동이 수월하다.)
- 자동으로 모듈화가 되고 추후 프레임워크로 분리한다면 더욱 편리할 것 같다.
- 파일의 갯수가 많아 개발 속도가 더 오래걸리는 단점이 있지만, Xcode 템플릿을 활용하면 보완이 될 것 같다.
- 원하는 파일 및 원하는 부분등을 찾기 쉬워 작업(이슈 수정, 기능추가, 코드리뷰)등이 편리할 것 같다.

👋 [Clean Architecture for iOS](https://sookim-1.tistory.com/entry/Clean-Architecture-for-iOS)

▶️ MVVM

- **Model** : 앱이 동작할 때 필요한 데이터
- **View** : UI가 보이는 요소, 화면을 구성하는 요소
- **ViewModel** : View에서 입력이 들어오면 모델을 업데이트하고, 모델이 출력하면 뷰를 업데이트합니다.
    - 비즈니스 로직이 들어가는 곳

> MVC에서 MVVM을 사용했을 때 장점
- 뷰컨트롤러에서 많은 비즈니스로직을 제거하여 뷰컨트롤러의 코드를 줄일 수 있습니다.
- 비즈니스로직만을 뷰모델로 분리하기 때문에 표현성이 뛰어납니다.
- 뷰모델은 뷰와 연결되어 있지 않아 테스트가 용이합니다.
