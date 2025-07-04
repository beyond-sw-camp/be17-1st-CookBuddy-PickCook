<script setup>

</script>

<template>
<div class="shopping-detail-container" data-product-id="1234">
        <div class="shopping-detail-row">
            <!-- 좌측 이미지 영역 -->
            <div class="shopping-detail-col-half">
                <!-- 메인 이미지 -->
                <div class="main-image" id="mainImage"
                    style="background-image: url('https://semie.cooking/image/contents/wn/cv/solcqifp/149437687iajp.jpg');">
                </div>

                <!-- 썸네일 -->
                <div class="thumbnail-container" id="thumbnailContainer">
                    <div class="thumbnail"
                        style="background-image: url('https://cdn.pixabay.com/photo/2018/04/13/17/14/vegetable-skewer-3317060_1280.jpg');">
                    </div>
                    <div class="thumbnail"
                        style="background-image: url('https://cdn.pixabay.com/photo/2015/05/31/13/59/salad-791891_1280.jpg');"></div>
                    <div class="thumbnail"
                        style="background-image: url('https://cdn.pixabay.com/photo/2014/12/20/13/59/vegetables-573958_1280.jpg');">
                    </div>
                </div>
            </div><!-- 우측 상품 정보 -->
            <div class="shopping-detail-col-half">
                <h5 class="brand-name" id="brandName">유기농채소</h5>
                <h2 class="product-title" id="productTitle">[오늘특가] 유기농 채소 모음전</h2>

                <!-- 별점 -->
                <div class="mb-2">
                    <span class="product-rate" id="productRating">
                        <i class="fas fa-star" style="color: #ffc107;"></i>
                        <i class="fas fa-star" style="color: #ffc107;"></i>
                        <i class="fas fa-star" style="color: #ffc107;"></i>
                        <i class="fas fa-star" style="color: #ffc107;"></i>
                        <i class="fas fa-star-half-alt" style="color: #ffc107;"></i>
                    </span>
                    <span class="text-muted" id="reviewSummary">4.8 (리뷰 1,234)</span>
                </div>

                <!-- 서브 설명 -->
                <p class="text-secondary" id="productSubDesc">유기농 채소를 한 번에! 건강한 식단을 위한 선택</p>

                <!-- 가격 정보 -->
                <div class="mb-3" id="priceSection">
                    <span class="discount-rate"
                        style="color: #dc3545; font-weight: bold; font-size: 18px;">30%</span>&nbsp;
                    <span class="fs-4 fw-bold text-primary" id="salePrice">15,900원</span>&nbsp;
                    <span class="text-decoration-line-through text-muted" id="originalPrice">22,900원</span>
                </div>

                <!-- 상세 정보 리스트 -->
                <ul class="text-muted" id="productDetails">
                    <li>유형: 유기농 인증 채소 모음</li>
                    <li>구성: 랜덤 구성 채소 5~6종</li>
                    <li>보관: 냉장 보관 권장 (0~10℃)</li>
                    <li>배송비: 무료배송</li>
                </ul>

                <!-- 버튼 -->
                <div class="d-flex gap-2 mt-4">
                    <button class="btn btn-outline-secondary flex-fill" id="addToCartBtn">장바구니</button>
                    <button class="btn btn-danger flex-fill" id="buyNowBtn">바로구매</button>
                </div>
            </div>

        </div>
    </div>
    <!-- 탭 영역 -->
    <div class="tab-section">
        <div class="tab-nav">
            <button class="tab-button active" data-tab="info">상품정보</button>
            <button class="tab-button" data-tab="review">리뷰</button>
        </div>
        <!-- 상품 정보 탭 -->
        <div class="tab-content active" id="tab-info">
            <p>여기는 상품 정보입니다. 상품의 상세 설명이나 이미지 등을 보여줄 수 있습니다.</p>
        </div>
        <!-- 리뷰 탭 -->
        <div class="tab-content" id="tab-review">
            <p>여기는 리뷰 영역입니다. 사용자 리뷰나 평점을 보여줄 수 있습니다.</p>
        </div>
    </div>
</template>

<style scoped>

</style>