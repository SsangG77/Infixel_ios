


# 이미지 공유 서비스앱 Infixel
![Image](https://github.com/user-attachments/assets/19343a1c-47dd-4651-81f0-8880724dfa19)
- 배포 URL : [Infixel AppStore](https://apps.apple.com/kr/app/infixel/id6711351058)


## 프로젝트 소개
- 숏폼 컨텐츠 UI를 사용하여 사용자들이 원하는 사진을 업로드하고 이미지에 Pic!을 할 수 있습니다.
- Pic!을 가장 많이 받은 이미지와 유저들의 실시간 순위를 확인할 수 있습니다.
- 앱 내부에 있는 앨범에 이미지를 보관할 수 있습니다.



##  기술 스택

- **언어:** Swift
- **프레임워크:** SwiftUI
- **네트워킹:** URLSession, WebSocket
- **인증:** Kakao 로그인 API, Apple 로그인 API
- **동시성 처리:** Swift Concurrency (async/await) 활용한 멀티스레딩

##  아키텍처

- MVVM (Model-View-ViewModel) 패턴으로 확장성과 유지보수 용이성 확보
- 비동기 네트워킹으로 부드러운 데이터 처리

##  사용된 API

- **Kakao 로그인 API:** 간편한 사용자 인증 제공
- **Apple 로그인 API:** 보안이 강화된 로그인 방식 지원
- **WebSocket:** 실시간 데이터 동기화 (순위 업데이트, 라이브 반응 등)

##  라이브러리 및 의존성

- **Alamofire :** 네트워킹 작업 간소화 (사용한 경우)
- **Combine (선택사항):** 데이터 바인딩을 위한 리액티브 프로그래밍 (사용한 경우)

## 📝 설치 방법

1. 레포지토리 클론:
   ```bash
   git clone https://github.com/your-repo/shortform-image-sharing-app.git
   ```

2. Xcode에서 프로젝트 열기:
   ```bash
   open ShortFormImageSharingApp.xcodeproj
   ```

3. 의존성 설치 (Swift Package Manager 사용 시):
   - Xcode > File > Swift Packages > Add Package Dependency로 이동하여 추가

4. Kakao 및 Apple 로그인 자격 증명을 프로젝트 설정에서 구성

5. 앱 빌드 및 실행:
   ```bash
   Cmd + R
   ```



## 2. 디자인
[Figma link](https://www.figma.com/file/ZobwDJ6BYIl2ZuRray1YxR/Infixel-Swift?type=design&node-id=0-1&mode=design&t=56yeUw7CF0F9t6A5-0)
![Image](https://github.com/user-attachments/assets/dce2ca1d-f1bc-4539-867a-379625cc9bcd)



## 3. 페이지별 기능

### 메인 페이지


- 'Pic!(좋아요)'를 클릭하면 클릭한 유저와 이미지id 값이 서버로 전송됩니다.
- 댓글 버튼을 클릭하면 해당 이미지에 달린 댓글 리스트페이지가 나오고 해당페이지에서 댓글들을 확인하거나 댓글을 입력할 수 있습니다.
- 앨범 버튼을 클릭하면 앨범리스트가 나오게 되고 리스트중 이미지를 앨범에 보관합니다.
- "..."버튼을 클릭하면 이미지파일을 로컬에 다운로드받거나 이미지를 신고할 수 있습니다.
- 업로드 유저 박스 오른쪽 ">"버튼으로 이미지 설명문을 읽을 수 있습니다.

<div>
  <img width="230" src="https://github.com/user-attachments/assets/7e9b012d-3b59-4716-b376-51c47d49f236" />
  <img width="230" src="https://github.com/user-attachments/assets/858984d6-cf1e-44a8-ba19-1493285223e2" />
  <img width="230" src="https://github.com/user-attachments/assets/5b18d30c-c639-4156-95d9-4712d4514010" />
  <img width="230" src="https://github.com/user-attachments/assets/7f19b639-f604-4b8a-9548-adefd2b5242c" />
</div> 


</br>

---

### 검색 페이지

- 검색한 단어를 포함하는 태그가 입력된 이미지들을 검색결과로 나타내는 화면입니다.

<div>
  <img width="270" src="https://github.com/user-attachments/assets/10f2f6cf-0b4c-4d13-961e-5128d2aed212" />
</div> 


</br>

- 앨범을 검색했을때 해당 앨범의 상세페이지 화면입니다.

<div>
  <img width="270" src="https://github.com/user-attachments/assets/8f1b30ff-9235-40f3-a62e-c55e3ef8b788" />
  <img width="270" src="https://github.com/user-attachments/assets/5e80b0d3-b72b-4b0a-a642-bf4eaf915d5d" />
</div>



</br>

---

### 랭킹 페이지

- 좋아요를 많이 받은 이미지와 유저를 확인할 수 있습니다.
- WebSocket을 사용하여 실시간 랭킹확인이 가능합니다.

<div>
  <img width="270" src="https://github.com/user-attachments/assets/90c7b030-117a-498d-a298-c5cce511b684" />
</div>



</br>

---

### 앨범 페이지

- 각 앨범에 저장된 이미지들을 옆으로 슬라이드하면서 확인할 수 있습니다.
- 이미지를 클릭하여 삭제할 수 있습니다.

<div>
  <img width="270" src="https://github.com/user-attachments/assets/8f10cbd1-e2a7-4338-9399-9d71870021a6" />
</div>



</br>

---

### 프로필 페이지

- 유저가 받은 좋아요의 합, 팔로우, 팔로워 수를 확인할 수 있습니다.
- 유저가 업로드한 이미지들을 이중배열로 확인할 수 있습니다.


<div>
  <img width="270" src="https://github.com/user-attachments/assets/ef400928-52e1-4ccc-bf98-c93ab780cb23" />
</div>




</br>

---

### 로그인 페이지

- 아이디, 비밀번호 입력여부에 따라 로그인 버튼이 활성화됩니다.
- 카카오 로그인 버튼을 클릭하여 카카오 아이디로 로그인이 가능합니다.
- Sign in with Apple 버튼을 클릭하여 애플 아이디로 로그인이 가능합니다.

<div>
  <img width="270" src="https://github.com/user-attachments/assets/cbfa67e1-e348-4bea-b89c-0d96857394f5" />
</div>


---
</br>

### 회원가입 페이지

- 이메일로 가입 여부를 판단한다.
- 이메일, 비밀번호, 닉네임, 아이디를 입력하여 회원가입한다.

<div>
  <img width="270" src="https://github.com/user-attachments/assets/c225499a-878e-40f0-8a43-9bc1b3e15f6e" />
</div>











