# 이미지 공유 서비스앱 Infixel
![Image](https://github.com/user-attachments/assets/19343a1c-47dd-4651-81f0-8880724dfa19)
- 배포 URL : [Infixel AppStore](https://apps.apple.com/kr/app/infixel/id6711351058)


## 프로젝트 소개
- 숏폼 컨텐츠 UI를 사용하여 사용자들이 원하는 사진을 업로드하고 이미지에 Pic!을 할 수 있습니다.
- Pic!을 가장 많이 받은 이미지와 유저들의 실시간 순위를 확인할 수 있습니다.
- 앱 내부에 있는 앨범에 이미지를 보관할 수 있습니다.



## 1. 기술 스택
- SwiftUI
- UIKit
- Web Socket
- Kakao login
- URLSession
- Multi thread


## 2. 디자인
[Figma](https://www.figma.com/file/ZobwDJ6BYIl2ZuRray1YxR/Infixel-Swift?type=design&node-id=0-1&mode=design&t=56yeUw7CF0F9t6A5-0)



## 3. 페이지별 기능

### 메인 페이지
<div>
  <img width="200" src="https://github.com/user-attachments/assets/7e9b012d-3b59-4716-b376-51c47d49f236" />
  <img width="200" src="https://github.com/user-attachments/assets/858984d6-cf1e-44a8-ba19-1493285223e2" />
</div>
- 'Pic!(좋아요)'를 클릭하면 클릭한 유저와 이미지id 값이 서버로 전송됩니다.
- 댓글 버튼을 클릭하면 해당 이미지에 달린 댓글 리스트페이지가 나오고 해당페이지에서 댓글들을 확인하거나 댓글을 입력할 수 있습니다.
- 앨범 버튼을 클릭하면 앨범리스트가 나오게 되고 리스트중 이미지를 앨범에 보관합니다.
- "..."버튼을 클릭하면 이미지파일을 로컬에 다운로드받거나 이미지를 신고할 수 있습니다.
- 업로드 유저 박스 오른쪽 ">"버튼으로 이미지 설명문을 읽을 수 있습니다.


### 검색 페이지


### 랭킹 페이지
<div>
  <img width="200" src="https://github.com/user-attachments/assets/90c7b030-117a-498d-a298-c5cce511b684" />
</div>
좋아요를 많이 받은 이미지와 유저를 확인할 수 있습니다.
WebSocket을 사용하여 실시간 랭킹확인이 가능합니다.



### 앨범 페이지
<div>
  <img width="200" src="https://github.com/user-attachments/assets/8f10cbd1-e2a7-4338-9399-9d71870021a6" />
</div>
각 앨범에 저장된 이미지들을 옆으로 슬라이드하면서 확인할 수 있습니다.
이미지를 클릭하여 삭제할 수 있습니다.


### 프로필 페이지
<div>
  <img width="200" src="https://github.com/user-attachments/assets/ef400928-52e1-4ccc-bf98-c93ab780cb23" />
</div>
유저가 받은 좋아요의 합, 팔로우, 팔로워 수를 확인할 수 있습니다.
유저가 업로드한 이미지들을 이중배열로 확인할 수 있습니다.


### 로그인 페이지

### 회원가입 페이지
