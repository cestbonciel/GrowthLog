## [2기] 프론티어 iOS 앱 개발자 부트캠프 - 미니프로젝트 1, 3조
### GrowthLog 
거꾸로해도 그로스로그, 개발자 맞춤형 KPT 회고 앱 개발
🥳 자라나라 개발개발 🌱
## 📱 앱 이름 및 소개
- 앱 기획의도
  -  KPT 개발 회고를 통해 개발 경험에 적용, 노력한 부분, 문제 해결, 개선 결과를 함께 생각하며 
    긍정적 관점 리마인드, 개발자의 성장을 기록 
## 🗓️ 개발 기간
2025.05.12.월 - 2025.05.15.목 (약 5일 이내)

## 🖥️ 개발 환경

- Xcode: 16.4
- Swift: 5.9
- 배포타겟: iOS 18.0
- 작업 일정관리: Notion, FigJam
- 디자인: Figma

<br>

## 🔑 핵심 기술 

### 🗃️ 기술스택(Tech Stack)
- 프레임워크: SwiftUI
- 데이터관리: swiftData
- 라이브러리: SwiftUI Charts
- 프로젝트 구조(Architecture Pattern): 기능별 폴더 중점 안 MVVM 아키텍처
- UIUX: ipad, iphone 대응, Light, Dark Mode 대응 

<br>

## 🖼️ 화면 소개
|**온보딩뷰**|**회고목록 및 등록 뷰**|**주간, 월간 통계 뷰**|**검색 필터뷰**|
|:---:|:---:|:---:|:---:|
|<img width="300" alt="온보딩뷰" src="https://github.com/user-attachments/assets/4674dd0b-b93b-4d3c-840b-82e5c8e351fc" />|<img width="300" alt="회고목록 및 등록 뷰" src="https://github.com/user-attachments/assets/ea7a349b-f04b-49cb-9e35-25d95164dcb5" />|<img width="300" alt="주간, 월간 통계 뷰" src="https://github.com/user-attachments/assets/59f5394c-8796-4af6-90ea-b49debf95cc9" />|<img width="300" alt="검색 필터뷰" src="https://github.com/user-attachments/assets/e3b46a36-a5f2-42b1-9b12-bf1d6508f96a" />|

<br>

## 🏛️ 프로젝트 구조
```
📂 GrowthLog  
├── 📂 App  
│   └── 🐦 GrowthLogApp.swift  
├── 📂 Data  
│   └── 📂 Model  
│       ├── 🐦 Category.swift  
│       ├── 🐦 ChildCategory.swift  
│       ├── 🐦 LogJson.swift  
│       ├── 🐦 LogMainData.swift  
│       ├── 🐦 LogStatstics.swift  
│       └── 🐦 StatEntry.swift  
├── 📂 Extensions  
│   └── 🐦 String+Extension.swift  
├── 📂 Features  
│   ├── 📂 CategoryFilter  
│   │   ├── 🐦 CategoryFilterView.swift  
│   │   ├── 🐦 CategoryFilterViewModel.swift  
│   │   ├── 🐦 SearchFilterView.swift  
│   │   └── 🐦 SearchFilterViewModel.swift  
│   ├── 📂 Components  
│   │   ├── 🐦 LogListCell.swift  
│   │   └── 🐦 SampleCell.swift  
│   ├── 📂 LogMain  
│   │   ├── 📂 LogDetail  
│   │   ├── 📂 LogEditor  
│   │   ├── 📂 LogList  
│   │   ├── 🐦 LogMainView.swift  
│   │   └── 🐦 LogMainViewModel.swift  
│   ├── 📂 Onboarding  
│   │   └── 🐦 OnboardingView.swift  
│   ├── 📂 Setting  
│   │   └── 🐦 SettingView.swift  
│   └── 📂 Statistics  
│       ├── 🐦 StatisticsView.swift  
│       └── 🐦 StatisticsViewModel.swift  
├── 📂 Helpers  
│   ├── 🐦 LogDataGenerator.swift  
│   ├── 🐦 LogDummyView.swift  
│   └── 🐦 LogEntry.swift  
├── 📂 Resources  
│   ├── 🎨 Assets.xcassets  
│   │   ├── 🎨 AccentColor.colorset  
│   │   ├── 🎨 AppIcon.appiconset  
│   │   ├── 📄 Contents.json  
│   │   └── 🎨 growthlogColor  
│   ├── 📄 log_data.json  
│   └── 📂 Preview Content  
│       └── 🎨 Preview Assets.xcassets  
├── 📂 GrowthLog.xcodeproj  
│   ├── 📄 project.pbxproj  
│   ├── 📂 project.xcworkspace  
│   │   ├── 📄 contents.xcworkspacedata  
│   │   ├── 📂 xcshareddata  
│   │   │   └── 📂 swiftpm  
│   │   └── 📂 xcuserdata  
│   │       └── 📂 seohyunkim.xcuserdatad  
│   └── 📂 xcuserdata  
│       └── 📂 seohyunkim.xcuserdatad  
│           ├── 📂 xcdebugger  
│           └── 📂 xcschemes  
└── 📄 README.md
```
 ## 👩🏻‍💻 팀원 소개
### Developer
[김서현](https://github.com/cestbonciel/)|[백현진](https://github.com/cestbonciel/GrowthLog)|[이주용](https://github.com/cestbonciel/GrowthLog)|
|:---:|:---:|:---:|
|<img width="150" alt="KakaoTalk_Photo_2024-03-11-15-12-05" src="https://github.com/user-attachments/assets/c942b244-f9df-42df-81a6-e0ca20d7e760" />|<img width="150" alt="appIcongL" src="https://github.com/user-attachments/assets/d94f3f9d-5779-4e0a-98c8-846e74973381" />|<img width="150" alt="appIcongL" src="https://github.com/user-attachments/assets/d94f3f9d-5779-4e0a-98c8-846e74973381" />|
|`iOS`|`iOS`|`iOS`|
|`역할`: 리더|`역할`: 팀원|`역할`: 팀원|
|JSON Mock 데이터 500개 수동 생성 및 파싱·로딩 후 데이터 저장,<br>Github PR관리,<br>프로젝트 초기 세팅<br>통계뷰 구현| 검색 및 필터링 뷰, 세팅뷰, 온보딩 UI| 회고 CRUD, 로그 메인뷰 UI|


