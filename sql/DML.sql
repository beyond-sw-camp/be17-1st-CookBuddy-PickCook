# 회원

1. 닉네임 중복확인
    SELECT CASE WHEN COUNT(*) = 0 THEN 'true' ELSE 'false' END AS result FROM users WHERE nickname = 'value' AND deleted_at IS NULL;

2. 이메일 중복확인 (이메일 인증 전에 중복 체크)
    SELECT CASE WHEN COUNT(*) = 0 THEN 'true' ELSE 'false' END AS result FROM users WHERE email = 'value' AND deleted_at IS NULL;

3. 회원가입
    INSERT INTO users (email, password, nickname, profile_image, role, created_at, updated_at, deleted_at) VALUES ('value@email.com', 'hashed_password', 'nickname_value', NULL, 'USER', NOW(), NOW(), NULL);

4. 일반 로그인
    SELECT CASE WHEN COUNT(*) = 1 THEN 'true' ELSE 'false' END AS result FROM users WHERE email = 'value@email.com' AND password = 'hashed_password' AND deleted_at IS NULL;

5. 회원 정보 수정
    # 존재 확인
    SELECT CASE WHEN COUNT(*) = 1 THEN 'true' ELSE 'false' END AS result FROM users WHERE email = 'value@email.com' AND deleted_at IS NULL;
    # 기존 정보 조회
    SELECT email, nickname, profile_image, role FROM users WHERE email = 'value@email.com' AND deleted_at IS NULL;
    # 정보 수정
    UPDATE users
        SET
            password = CASE WHEN password != 'new_pw' THEN 'new_pw' ELSE password END,
            nickname = CASE WHEN nickname != 'new_nickname' THEN 'new_nickname' ELSE nickname END,
            profile_image = CASE WHEN profile_image != 'new_img_url' THEN 'new_img_url' ELSE profile_image END,
            updated_at = NOW()
        WHERE
            email = 'value@email.com' AND deleted_at IS NULL AND (password != 'new_pw' OR nickname != 'new_nickname' OR profile_image != 'new_img_url');

6. 회원 탈퇴 (Soft Delete 방식)
    # 확인
    SELECT CASE WHEN COUNT(*) = 1 THEN 'true' ELSE 'false' END AS result FROM users WHERE email = 'value@email.com' AND password = 'hashed_password' AND deleted_at IS NULL;
    # 탈퇴 처리
    UPDATE users SET deleted_at = NOW() WHERE email = 'value@email.com' AND deleted_at IS NULL;


# 레시피 조회

1. 좋아요 많은 순으로 정렬
    SELECT r.*, COUNT(rl.recipe_like_id) AS like_count
    FROM public_recipes r
    LEFT JOIN recipe_likes rl ON r.public_recipe_id = rl.public_recipe_id
    WHERE r.deleted_at IS NULL
    GROUP BY r.public_recipe_id
    ORDER BY like_count DESC;

2. 최신순으로 정렬
    SELECT * FROM public_recipes
    WHERE deleted_at IS NULL
    ORDER BY created_at DESC;

3. 조리 시간 짧은 순
    SELECT * FROM public_recipes
    WHERE deleted_at IS NULL
    ORDER BY cooking_time ASC;

4. 난이도 쉬움 -> 어려움 순
    SELECT * FROM public_recipes
    WHERE deleted_at IS NULL
    ORDER BY 
    CASE difficulty
        WHEN '쉬움' THEN 1
        WHEN '보통' THEN 2
        WHEN '어려움' THEN 3
        ELSE 4
    END ASC;

5. 레시피 단계별 설명
    SELECT *
    FROM recipe_steps
    WHERE board_id = 1 AND deleted_at IS NULL
    ORDER BY step_number ASC;

6. 이 레시피에 사용된 재료
    SELECT i.ingredient_name, bi.qty
    FROM board_ingredients bi
    JOIN ingredients i ON bi.ingredient_id = i.ingredient_id
    WHERE bi.board_id = 1 AND bi.deleted_at IS NULL;


# 게시글 조회

1. 게시글 상세 조회
    SELECT b.*, u.nickname
    FROM boards b
    JOIN users u ON b.user_id = u.user_id
    WHERE b.board_id = 1 AND b.deleted_at IS NULL;

2. 게시글 댓글 조회
    SELECT c.*, u.nickname
    FROM comments c
    JOIN users u ON c.user_id = u.user_id
    WHERE c.board_id = 1 AND c.deleted_at IS NULL
    ORDER BY c.created_at ASC;