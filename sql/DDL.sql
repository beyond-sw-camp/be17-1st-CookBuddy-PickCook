CREATE DATABASE pickcook;
USE pickcook;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255),
    password VARCHAR(255),
    nickname VARCHAR(100),
    profile_image VARCHAR(255),
    role VARCHAR(45),
    created_at DATETIME,
    updated_at DATETIME,
    deleted_at DATETIME
);

DROP TABLE IF EXISTS ingredients;

CREATE TABLE ingredients (
    ingredient_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    ingredient_name VARCHAR(200),
    category VARCHAR(50),
    origin VARCHAR(100),
    default_purchase_url VARCHAR(255),
    created_at DATETIME,
    updated_at DATETIME,
    deleted_at DATETIME
);

DROP TABLE IF EXISTS boards;

CREATE TABLE boards (
    board_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME,
    updated_at DATETIME,
    deleted_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

DROP TABLE IF EXISTS public_recipes;

CREATE TABLE public_recipes (
    public_recipe_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    summary TEXT,
    cooking_time INT,
    difficulty VARCHAR(50),
    servings INT,
    image_url VARCHAR(255),
    source_api_id VARCHAR(100),
    created_at DATETIME,
    updated_at DATETIME,
    deleted_at DATETIME 
);

DROP TABLE IF EXISTS refrigerator_items;

CREATE TABLE refrigerator_items (
    refrigerator_item_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    ingredient_qty INT,
    unit VARCHAR(45),
    expiration_date DATE,
    category VARCHAR(50),
    created_at DATETIME,
    updated_at DATETIME,
    deleted_at DATETIME,
    user_id BIGINT,
    ingredient_id BIGINT,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(ingredient_id)
);

DROP TABLE IF EXISTS ingredient_links;

CREATE TABLE ingredient_links (
    ingredient_link_id BIGINT PRIMARY KEY,
    ingredient_id BIGINT NOT NULL,
    product_name VARCHAR(255),
    purchase_url VARCHAR(255),
    price INT,
    source VARCHAR(50),
    created_at DATETIME,
    updated_at DATETIME,
    deleted_at DATETIME,
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(ingredient_id)
);

DROP TABLE IF EXISTS board_ingredients;

CREATE TABLE board_ingredients (
    board_ingredient_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    board_id BIGINT NOT NULL,
    ingredient_id BIGINT NOT NULL,
    qty VARCHAR(50),
    created_at DATETIME,
    updated_at DATETIME,
    deleted_at DATETIME,
    FOREIGN KEY (board_id) REFERENCES boards(board_id),
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(ingredient_id)
);

DROP TABLE IF EXISTS recipe_steps;

CREATE TABLE recipe_steps (
    recipe_step_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    board_id BIGINT NOT NULL,
    step_number INT NOT NULL,
    description TEXT NOT NULL,
    image_url VARCHAR(255),
    created_at DATETIME,
    updated_at DATETIME,
    deleted_at DATETIME,
    FOREIGN KEY (board_id) REFERENCES boards(board_id)
);

DROP TABLE IF EXISTS public_recipe_ingredients;

CREATE TABLE public_recipe_ingredients (
    public_recipe_ingredient_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    public_recipe_id BIGINT,
    ingredient_name VARCHAR(255),
    quantity VARCHAR(100),
    created_at DATETIME,
    updated_at DATETIME,
    deleted_at DATETIME,
    FOREIGN KEY (public_recipe_id) REFERENCES public_recipes(public_recipe_id)
);

DROP TABLE IF EXISTS public_recipe_steps;

CREATE TABLE public_recipe_steps (
    public_recipe_step_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    step_number INT,
    description TEXT,
    image_url VARCHAR(255),
    created_at DATETIME,
    updated_at DATETIME,
    deleted_at DATETIME,
    public_recipe_id BIGINT,
    FOREIGN KEY (public_recipe_id) REFERENCES public_recipes(public_recipe_id)
);

DROP TABLE IF EXISTS recipe_likes;

CREATE TABLE recipe_likes (
    recipe_like_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    board_id BIGINT,
    public_recipe_id BIGINT,
    created_at DATETIME,
    updated_at DATETIME,
    deleted_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (board_id) REFERENCES boards(board_id),
    FOREIGN KEY (public_recipe_id) REFERENCES public_recipes(public_recipe_id)
);

DROP TABLE IF EXISTS scrap_recipes;

CREATE TABLE scrap_recipes (
    scrap_recipe_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    board_id BIGINT,
    public_recipe_id BIGINT,
    created_at DATETIME,
    updated_at DATETIME,
    deleted_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (board_id) REFERENCES boards(board_id),
    FOREIGN KEY (public_recipe_id) REFERENCES public_recipes(public_recipe_id)
);

DROP TABLE IF EXISTS comments;

CREATE TABLE comments (
    comment_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    board_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    parent_comment_id BIGINT,
    content TEXT NOT NULL,
    created_at DATETIME,
    updated_at DATETIME,
    deleted_at DATETIME,
    FOREIGN KEY (board_id) REFERENCES boards(board_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (parent_comment_id) REFERENCES comments(comment_id)
);