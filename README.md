<br>

<h1 align="center" style="color: #FFD675;">🍽️ PickCook </h1>

<div align="center">
  <img src="images/pickcook_logo.png" alt="pickcook logo" height="400" align="center" />
</div>


<h3 align="center">5팀 - Team CookBuddy </h3>


## 🕵️ 팀원 소개

<div align="center">

|   <img src="images/bibim.png" width="100" height="100"/>   |   <img src="images/tteok.png" width="100" height="100"/>   | <img src="images/icecream.png" width="100" height="100"/>  |  <img src="images/sushi.png" width="100" height="100"/>  |    <img src="images/ramen.png" width="100" height="100"/>    |     <img src="images/burger.png" width="100" height="100"/>      |
| :--------------------------------------------------------: | :--------------------------------------------------------: | :--------------------------------------------------------: | :------------------------------------------------------: | :----------------------------------------------------------: | :--------------------------------------------------------------: |
| 🐰 **김아영**<br/>[@thay123028](https://github.com/thay123028) | 🧶 **김영재**<br/>[@young1042](https://github.com/young1042) | ⚽ **허정빈**<br/>[@jeongbin5211](https://github.com/jeongbin5211) | 🤪 **허정우**<br/>[@JohnHeo81](https://github.com/JohnHeo81) | 🐢 **홍서연**<br/>[@seoyeon22](https://github.com/seoyeon22) |

</div>
<br>



## 🍕 프로젝트 소개
PickCook은 냉장고 속 재료를 등록해 재고와 유통기한을 관리하고, 그 재료로 만들 수 있는 요리를 추천해주는 플랫폼입니다. 만들고 싶은 요리를 고르면 필요한 재료도 알려주고, 부족한 재료는 바로 구매할 수 있어 요리가 더 쉬워집니다.

<br>

## 🍔 기술 스택

![VMWare](https://img.shields.io/badge/VMware-607078?logo=vmware&logoColor=white&style=for-the-badge)
![Ubuntu](https://img.shields.io/badge/ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=FFFFFF)

![MariaDB](https://img.shields.io/badge/MariaDB-003545?style=for-the-badge&logo=mariadb&logoColor=white)

![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=Prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/grafana-%23F46800.svg?style=for-the-badge&logo=grafana&logoColor=white)

![Git](https://img.shields.io/badge/git-%23F05033.svg?style=for-the-badge&logo=git&logoColor=white)
![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)
![Discord](https://img.shields.io/badge/Discord-5865F2.svg?style=for-the-badge&logo=discord&logoColor=white)

<br>

## 🌭 프로젝트 기획안

[프로젝트 기획안](https://docs.google.com/document/d/1JnNK9_vFxRizyXFUWUOrr1eKcOqdAXpH/edit?usp=sharing&ouid=105575553151863966937&rtpof=true&sd=true)

<br>

## 🍣 요구사항 정의서

[요구사항 정의서](https://docs.google.com/spreadsheets/d/1-NKiu4zpKw2Tl4Qjumd1SISX_odnlNEE/edit?usp=sharing&ouid=105575553151863966937&rtpof=true&sd=true)

<br>


## ERD

[ERD 다이어그램](https://www.erdcloud.com/d/i9Qf2BLnaAYZ4dCrH)

<img src="images/pickcook_erd.png" alt="ERD" width="800"/>

## 시스템 아키텍처

<img src="images/pickcook_system_architecture.png" alt="ERD" width="800"/>


## 🍩 재해 복구 (DR)

<details>
  <summary><b>양방향 레플리케이션 방식을 사용한 이유</b></summary>
  <div markdown="1">
  <br>

  **✔️ 데이터 일관성 유지**
    
  레플리케이션은 Master 서버에서 발생하는 데이터 변경 사항을 실시간 또는 거의 실시간으로 Slave 서버에 자동 복제한다. 이를 통해 항상 최신 상태의 데이터를 보조 서버에 유지할 수 있다.

  <br>

  **✔️ 부하 분산**

   실시간 트래픽이 급증하는 상황에도 여러 서버로 분산 처리하여 성능이 저하하는 것을 방지하고, 안정적인 응답 속도를 유지할 수 있다.

  <br>

  **✔️ 읽기 작업에 강한 구조**

  서비스 특성 상 레시피, 커뮤니티 등 데이터 읽기 작업이 많은 환경이기 때문에, 다수의 슬레이브 서버가 작업을 처리하게 설계하여 높은 읽기 성능을 제공한다.

  <br> 

  **✔️ 고가용성**

  한쪽 마스터에 장애가 발생하더라도, HAProxy가 정상적인 서버로 트래픽을 분배하여 서비스 중단 없이 시스템을 지속적으로 동작할 수 있다.  
  
  <br>
  
  **✔️ 확장성**

  마스터 서버에 새로운 슬레이브 서버를 연결하여 쉽게 확장할 수 있어, 트래픽이 증가할 때 유연하게 대처가 가능하다.

  </div>
</details>

<br>
<details>
  <summary><b>장애 복구 시나리오</b></summary>
  <div markdown="1">
  <br>

**✔️ 마스터 1대 장애 발생 시**
  - HAProxy가 장애 난 마스터 노드를 감지하고, 해당 노드로의 쓰기 트래픽을 자동으로 차단
  - 클라이언트는 정상 마스터를 통해 쓰기, 슬레이브를 통해 읽기 요청을 지속 처리 가능
  - 장애 발생한 마스터 노드는 복구 시 슬레이브로 초기화한 뒤, 살아 있는 마스터에서 복제를 받아 데이터 동기화
  - 동기화 완료 후 필요 시 다시 마스터로 승격하고, 양방향 복제 재구성
  - HAProxy 설정을 갱신하여 복구된 노드에도 트래픽을 분산하도록 재설정

<br>

**✔️ 슬레이브 1대 장애 발생 시**
  - HAProxy가 장애 슬레이브를 감지하고, 해당 슬레이브로의 읽기 요청을 차단
  - 클라이언트는 정상 슬레이브 또는 마스터로부터 읽기 처리 가능
  - 슬레이브 복구 후, 마스터로부터 복제 설정 재구성하여 자동 동기화
  - 복구 완료 후 HAProxy가 해당 슬레이브로 다시 읽기 트래픽 분산

<br>

**✔️ 마스터 + 슬레이브 한 쌍(2대) 동시 장애 시**
  - HAProxy는 남은 마스터와 슬레이브 쌍으로 모든 트래픽을 집중 처리
  - 복구된 노드는 순차적으로 클러스터에 재투입, 살아 있는 마스터에서 복제를 통해 최신 상태로 동기화
  - 전체 클러스터 복원 후 HAProxy 설정을 통해 트래픽 분산 정상화

<br>

**✔️ 전체 장애 예방 및 대비 방안**
  - 모든 노드는 Prometheus + Alertmanager 등으로 모니터링하여 이상 조기 감지
  - 정기적인 자동 백업 및 스냅샷 관리로 데이터 손실 방지
  - 이중화된 HA 구성 (예: HAProxy + Keepalived)으로 프록시 서버 자체 장애도 대비

  <br>
  </div>
</details>
<br> 

## 🥨 SQL

#### ✅ DDL
[DDL SQL 파일](/sql/DDL.sql)


#### ✅ DML
[DML SQL 파일](/sql/DML.sql)

<br>


