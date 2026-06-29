-- ============================================================
-- 예산 초과 시나리오 더미 데이터 (2026-03, testuser)
-- 예산: 1,000,000 / 실제 지출: ~1,220,000
-- ============================================================

SET @u_test  = (SELECT uuid FROM users WHERE username = 'testuser');

SET @c_food      = (SELECT uuid FROM categories WHERE code = 'FOOD'      AND type = 0);
SET @c_cafe      = (SELECT uuid FROM categories WHERE code = 'CAFE'      AND type = 0);
SET @c_transport = (SELECT uuid FROM categories WHERE code = 'TRANSPORT' AND type = 0);
SET @c_shopping  = (SELECT uuid FROM categories WHERE code = 'SHOPPING'  AND type = 0);
SET @c_housing   = (SELECT uuid FROM categories WHERE code = 'HOUSING'   AND type = 0);
SET @c_culture   = (SELECT uuid FROM categories WHERE code = 'CULTURE'   AND type = 0);
SET @c_salary    = (SELECT uuid FROM categories WHERE code = 'SALARY'    AND type = 1);

-- 수입
INSERT INTO transactions (uuid_user, uuid_category, type, amount, memo, transaction_date) VALUES
    (@u_test, @c_salary, 1, 3000000, '3월 급여', '2026-03-25');

-- 지출 (합계 약 1,220,000 — 예산 1,000,000 초과)
INSERT INTO transactions (uuid_user, uuid_category, type, amount, memo, transaction_date) VALUES
    (@u_test, @c_housing,   0, 650000, '3월 월세',      '2026-03-01'),
    (@u_test, @c_culture,   0,  55000, '헬스장 월정액', '2026-03-01'),
    (@u_test, @c_transport, 0,   8500, '교통카드 충전', '2026-03-01'),
    (@u_test, @c_food,      0,  45000, '마트 장보기',   '2026-03-03'),
    (@u_test, @c_culture,   0,  17000, '넷플릭스',      '2026-03-05'),
    (@u_test, @c_housing,   0,  55000, '핸드폰 요금',   '2026-03-05'),
    (@u_test, @c_food,      0,  65000, '주말 외식',     '2026-03-08'),
    (@u_test, @c_cafe,      0,  12000, '카페',          '2026-03-10'),
    (@u_test, @c_shopping,  0, 180000, '의류 쇼핑',     '2026-03-15'),
    (@u_test, @c_food,      0,  38000, '편의점',        '2026-03-18'),
    (@u_test, @c_cafe,      0,   8500, '아메리카노',    '2026-03-20'),
    (@u_test, @c_food,      0,  52000, '가족 외식',     '2026-03-22'),
    (@u_test, @c_culture,   0,  35000, '영화 관람',     '2026-03-28');

-- 예산 (1,000,000 — 지출 합계보다 낮게 설정해 초과 시나리오 구성)
INSERT INTO budgets (uuid_user, `year_month`, amount) VALUES
    (@u_test, '2026-03', 1000000);
