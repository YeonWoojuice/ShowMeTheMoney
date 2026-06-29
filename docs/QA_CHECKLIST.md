# 체크리스트

---

## QA

> 테스트 계정: `testuser` / `password123`

### 인증

- [ ] 회원가입 — `username`, `name`, `email`, `password` 정상 등록
- [ ] 회원가입 — 중복 username 409 반환
- [ ] 회원가입 — 중복 email 409 반환
- [ ] 로그인 — `username`으로 로그인 (이메일 입력 시 실패 확인)
- [ ] 로그인 — 잘못된 비밀번호 401 반환
- [ ] 로그아웃
- [ ] 인증 없이 보호 API 접근 시 401 반환
- [ ] 만료/위조 토큰으로 접근 시 401 반환

### 카테고리

- [ ] `GET /categories` — 전체 목록 조회 (`code`, `codeNumber`, `name`, `type` 필드 확인)
- [ ] `GET /categories?type=0` — 지출 카테고리만 반환
- [ ] `GET /categories?type=1` — 수입 카테고리만 반환

### 거래 내역

#### 등록
- [ ] 지출 카테고리(`ETC`, type=0) 등록 정상 동작
- [ ] 수입 카테고리(`ETC`, type=1) 등록 정상 동작
- [ ] 지출 거래에 수입 카테고리 코드 전송 시 400 반환 (type 불일치)
- [ ] 존재하지 않는 categoryCode 전송 시 404 반환

#### 조회
- [ ] `GET /transactions` — 목록 조회, 응답 `categoryCode`가 `"ETC"` 등 code 형식
- [ ] `GET /transactions?type=0` — 지출만 필터
- [ ] `GET /transactions?type=1` — 수입만 필터
- [ ] `GET /transactions?categoryCode=FOOD` — 카테고리 필터
- [ ] `GET /transactions?period=2026` — 연간 필터
- [ ] `GET /transactions?period=2026-06` — 월간 필터
- [ ] `GET /transactions?period=2026-06-29` — 일간 필터
- [ ] `GET /transactions?sort=asc` / `sort=desc` 정렬 확인
- [ ] `GET /transactions/{id}` — 단건 조회
- [ ] 타인 거래 단건 조회 시 403 반환

#### 수정
- [ ] 금액, 메모 수정
- [ ] 카테고리 변경
- [ ] 타인 거래 수정 시 403 반환

#### 삭제
- [ ] 소프트 딜리트 후 목록에서 제외 확인
- [ ] 삭제된 거래 단건 조회 시 404 반환
- [ ] 타인 거래 삭제 시 403 반환

### 고정 수입/지출

- [ ] 등록 — `categoryCode`(`"FOOD"` 등) 정상 저장
- [ ] 등록 — billingDay 범위 초과(0, 32) 시 400 반환
- [ ] `GET /recurring-items` — 전체 목록 조회
- [ ] `GET /recurring-items?isActive=true` / `isActive=false` 필터
- [ ] `GET /recurring-items?type=0` / `type=1` 필터
- [ ] 수정 — `isActive` 토글 (활성/비활성)
- [ ] 삭제 후 목록에서 제외 확인
- [ ] 타인 항목 수정/삭제 시 403 반환

### 예산

- [ ] 등록 — `yearMonth` 형식 `"202606"` 정상 저장
- [ ] 동일 월 중복 등록 시 409 반환
- [ ] `GET /budgets?yearMonth=202606` — 조회
- [ ] 예산 미등록 월 조회 시 404 반환
- [ ] 수정 — amount 변경
- [ ] 타인 예산 수정 시 403 반환

### 대시보드

- [ ] `GET /dashboard/summary?yearMonth=202603` — 예산 초과 케이스 (testuser 2026-03, 예산 1,000,000 / 지출 ~1,220,000)
- [ ] `GET /dashboard/summary?yearMonth=202606` — income, expense, budget, 잔액, isOverBudget 값 확인
- [ ] 예산 미등록 월 summary 조회 시 isOverBudget=false, budget=0 정상 처리
- [ ] `GET /dashboard/categories?yearMonth=202606` — 카테고리별 합계
- [ ] `GET /dashboard/categories?yearMonth=202606&type=0` — 지출만 필터
- [ ] `GET /dashboard/categories?yearMonth=202606&type=1` — 수입만 필터

### 사용자

- [ ] `GET /users/me` — 내 정보 조회 (username, email, name 확인)
- [ ] `PUT /users/me` — 닉네임 수정
- [ ] `DELETE /users/me` — 소프트 딜리트 후 재로그인 불가 확인

### 공통

- [ ] `GET /health` — 인증 없이 200 반환
- [ ] 잘못된 JSON body 전송 시 400 반환
- [ ] 필수 필드 누락 시 400 반환

---

## 배포 전

### DB 마이그레이션

- [ ] **더미 데이터(V3) prod 분리**
  - `db/migration/V3__seed_dummy_data.sql` → `db/dev/V3__seed_dummy_data.sql` 로 이동
  - `application.yml`: `locations: classpath:db/migration` (prod 기본값)
  - `application-local.yml`: `locations: classpath:db/migration,classpath:db/dev` 추가
  - prod에서는 V1(테이블), V2(카테고리)만 실행되어야 함
- [ ] `createDatabaseIfNotExist=true` prod URL에 없는지 확인
  - `DB_URL` 환경변수로 덮어쓰면 자동 제외되나 명시적으로 확인

### 보안

- [ ] `JWT_SECRET` 32바이트 이상 설정
- [ ] `DB_PASSWORD` 강도 확인
- [ ] `application-local.yml` git에 포함되지 않았는지 확인
- [ ] HTTPS 적용 여부 확인

### 환경변수

| 환경변수 | 확인 |
|---|---|
| `DB_URL` | |
| `DB_USERNAME` | |
| `DB_PASSWORD` | |
| `JWT_SECRET` | |
| `JWT_EXPIRATION` | |
| `SPRING_PROFILES_ACTIVE` | |

### 인프라

- [ ] MySQL 8.x 실행 중
- [ ] 방화벽 — 8080 포트 외부 노출 여부 결정
- [ ] 로그 저장 경로 설정

### 배포 후 확인

- [ ] `GET /api/health` → 200 응답
- [ ] 회원가입 / 로그인 정상 동작
- [ ] 거래 내역 등록 정상 동작
- [ ] Flyway 히스토리 확인 (`SELECT * FROM flyway_schema_history`)
  - V1, V2만 `success=1` 로 존재해야 함 (V3 없어야 함)
