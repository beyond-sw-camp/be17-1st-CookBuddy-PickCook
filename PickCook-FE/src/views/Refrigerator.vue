<script setup>
const categoryImageMap = {
            '유제품': 'ic-ingredient-category-milk',
            '육류': 'ic-ingredient-category-meat',
            '채소': 'ic-ingredient-category-vegetable',
            '과일': 'ic-ingredient-category-fruit',
            '디저트': 'ic-ingredient-category-dessert',
            '간편식': 'ic-ingredient-category-conveniencefood',
            '해산물': 'ic-ingredient-category-fish',
            '냉동식품': 'ic-ingredient-category-ice',
            '기타': 'ic-ingredient-category-etc'
        };


        document.addEventListener('DOMContentLoaded', () => {

            // 재고 추가 기능
            const openBtn = document.getElementById('openModalBtn');
            const modal = document.getElementById('addmodal');
            const closeBtn = document.getElementById('closeModalBtn');

            openBtn.addEventListener('click', () => {
                modal.style.display = 'flex';
            });

            closeBtn.addEventListener('click', () => {
                modal.style.display = 'none';
            });

            window.addEventListener('click', (e) => {
                if (e.target === modal) {
                    modal.style.display = 'none';
                }
            });

            const form = document.querySelector('.add-refrigerator-items-form');

            form.addEventListener('submit', function (e) {
                e.preventDefault();

                // 입력값 수집
                const name = document.getElementById('name').value.trim();
                const qnt = document.getElementById('qnt').value.trim();
                const date = document.getElementById('date').value.trim();
                const category = document.querySelectorAll('.ingredient-select')[0].value;
                const location = document.querySelectorAll('.ingredient-select')[1].value;

                // 필수 항목 체크
                if (!name || !qnt || !date || !category || !location) {
                    alert('모든 항목을 입력해주세요.');
                    return;
                }

                // 요소 만들기
                const imageFileName = categoryImageMap[category] || 'ic-ingredient-category-etc';
                const imageUrl = `/assets/icons/${imageFileName}.png`;

                const card = document.createElement('div');
                card.className = 'ingredient-card-container';
                card.innerHTML = `
                    <img class="ingredient-item-image" src="${imageUrl}" alt="${category} 이미지">
                    <div class="ingredient-content-container">
                    <div class="ingredient-name-and-qnt-container">
                        <span class="ingredient-item-name">${name}</span>
                        <span class="ingredient-item-qnt">${qnt}</span>
                    </div>
                    <div class="ingredient-category-and-exdate">
                        <span class="ingredient-item-category">${category}</span>
                        <span>|</span>
                        <span class="ingredient-item-exdate">${getDaysLeft(date)}</span>
                    </div>
                    </div>
                    <img class="ingredient-setting-button" src="/assets/icons/ic-banner-right.png" alt="재료 수정 및 삭제">
                `;

                // 보관위치에 따라 카드 삽입
                let targetId = '';
                if (location === '실외 저장소') targetId = 'outdoor-storage-container';
                else if (location === '냉장실') targetId = 'refrigerator-room-container';
                else if (location === '냉동실') targetId = 'freezer-room-container';

                const targetContainer = document
                    .querySelector(`#${targetId} .refrigerator-item-save-scroll-boxes`);
                targetContainer.appendChild(card);

                // 모달 닫기 & 폼 초기화
                document.getElementById('addmodal').style.display = 'none';
                form.reset();
            });

            function getDaysLeft(dateStr) {
                const today = new Date();
                const target = new Date(dateStr);

                // 시간 차이 (밀리초) → 일 수
                const diff = Math.ceil((target - today) / (1000 * 60 * 60 * 24));

                if (diff > 0) {
                    return `${diff}일 남음`;
                } else if (diff === 0) {
                    return `오늘까지`;
                } else {
                    return `${Math.abs(diff)}일 지남`;
                }
            }


            //---------------------------------------------------------------------
            // 재고 수정 기능
            const editModal = document.getElementById('editModal');
            const editForm = document.getElementById('editForm');
            const closeEditModalBtn = document.getElementById('editModalCloseBtn');

            const editName = document.getElementById('edit-name');
            const editQnt = document.getElementById('edit-qnt');
            const editDate = document.getElementById('edit-date');
            const editCategory = document.getElementById('edit-category');
            const editLocation = document.getElementById('edit-location');

            const deleteBtn = document.getElementById('deleteBtn');
            const snackbar = document.getElementById('snackbar');
            const undoBtn = document.getElementById('undoDeleteBtn');

            let editingCard = null;
            let lastDeletedCard = null;
            let lastDeletedParent = null;

            // 설정 버튼 눌렀을 때 수정 모달 띄우기
            document.addEventListener('click', (e) => {
                if (e.target.classList.contains('ingredient-setting-button')) {
                    editingCard = e.target.closest('.ingredient-card-container');

                    const name = editingCard.querySelector('.ingredient-item-name').innerText;
                    const qnt = editingCard.querySelector('.ingredient-item-qnt').innerText;
                    const category = editingCard.querySelector('.ingredient-item-category').innerText;
                    const exDateText = editingCard.querySelector('.ingredient-item-exdate').innerText;
                    const exDays = parseInt(exDateText.replace('일 남음', '')) || 0;

                    // 날짜 역산
                    const today = new Date();
                    today.setDate(today.getDate() + exDays);
                    const dateStr = today.toISOString().split('T')[0];

                    const parentId = editingCard.closest('.refrigerator-sections').id;
                    const location =
                        parentId === 'outdoor-storage-container'
                            ? '실외 저장소'
                            : parentId === 'refrigerator-room-container'
                                ? '냉장실'
                                : '냉동실';

                    editName.value = name;
                    editQnt.value = qnt;
                    editDate.value = dateStr;
                    editCategory.value = category;
                    editLocation.value = location;

                    editModal.style.display = 'flex';
                }
            });

            // 수정 완료
            editForm.addEventListener('submit', (e) => {
                e.preventDefault();

                const name = editName.value.trim();
                const qnt = editQnt.value.trim();
                const date = editDate.value;
                const category = editCategory.value;
                const location = editLocation.value;

                if (!name || !qnt || !date || !category || !location) {
                    alert('모든 항목을 입력해주세요.');
                    return;
                }

                const exDate = getDaysLeft(date);

                const imageFileName = categoryImageMap[category] || 'ic-ingredient-category-etc';
                const imageUrl = `/assets/icons/${imageFileName}.png`;

                const card = document.createElement('div');
                card.className = 'ingredient-card-container';
                card.innerHTML = `
                    <img class="ingredient-item-image" src="${imageUrl}" alt="${category} 이미지">
                    <div class="ingredient-content-container">
                        <div class="ingredient-name-and-qnt-container">
                        <span class="ingredient-item-name">${name}</span>
                        <span class="ingredient-item-qnt">${qnt}</span>
                        </div>
                        <div class="ingredient-category-and-exdate">
                        <span class="ingredient-item-category">${category}</span>
                        <span>|</span>
                        <span class="ingredient-item-exdate">${exDate}</span>
                        </div>
                    </div>
                    <img class="ingredient-setting-button" src="/assets/icons/ic-banner-right.png" alt="재료 수정 및 삭제">
                `;

                const targetId =
                    location === '실외 저장소'
                        ? 'outdoor-storage-container'
                        : location === '냉장실'
                            ? 'refrigerator-room-container'
                            : 'freezer-room-container';

                const targetBox = document.querySelector(`#${targetId} .refrigerator-item-save-scroll-boxes`);

                // 기존 카드 제거 후 새 카드 추가
                if (editingCard) editingCard.remove();
                targetBox.appendChild(card);

                editModal.style.display = 'none';
            });

            // 삭제 버튼
            deleteBtn.addEventListener('click', () => {
                if (!editingCard) return;

                lastDeletedCard = editingCard;
                lastDeletedParent = editingCard.parentElement;

                editingCard.remove();
                editModal.style.display = 'none';

                showSnackbar();
            });

            // 취소 버튼 눌렀을 때 되돌리기
            undoBtn.addEventListener('click', () => {
                if (lastDeletedCard && lastDeletedParent) {
                    lastDeletedParent.appendChild(lastDeletedCard);
                    lastDeletedCard = null;
                    lastDeletedParent = null;
                }
                snackbar.style.visibility = 'hidden';
            });

            // 스낵바 보이기
            function showSnackbar() {
                snackbar.style.visibility = 'visible';
                setTimeout(() => {
                    snackbar.style.visibility = 'hidden';
                }, 5000);
            }

            // 닫기 버튼 또는 바깥 클릭
            closeEditModalBtn.addEventListener('click', () => (editModal.style.display = 'none'));
            window.addEventListener('click', (e) => {
                if (e.target === editModal) editModal.style.display = 'none';
            });


            //----------------------------------------------------------------  
            // 재료 키워드 검색 기능
            const input = document.getElementById('refrigerator-item-search');
            const searchBtn = document.getElementById('refrigerator-item-search-button');
            const keywordBox = document.querySelector('.user-search-keyword');
            const keywordSpan = keywordBox.querySelector('span');

            // 검색 실행 함수
            function performSearch() {
                const keyword = input.value.trim();

                if (keyword) {
                    keywordSpan.textContent = `'${keyword}'`;
                    keywordBox.style.display = 'block';
                } else {
                    keywordBox.style.display = 'none';
                }
            }

            // 버튼 클릭 시
            searchBtn.addEventListener('click', performSearch);

            // 엔터 키 입력 시
            input.addEventListener('keydown', function (e) {
                if (e.key === 'Enter') {
                    performSearch();
                }
            });
        });
</script>

<template>
<!-- ========== 검색 & 필터 섹션 ========== -->
    <div class="refrigerator-search-help-section-container filter-section">
        <div class="refrigerator-search-help-section">
            <div class="refrigerator-filter-container">
                <span class="refrigerator-filter-items">정렬 &nbsp;▼</span>
                <span class="refrigerator-filter-items">카테고리 &nbsp;▼</span>
                <span class="refrigerator-filter-items">재고위치 &nbsp;▼</span>
            </div>
            <div class="search-bar-container">
                <input id="refrigerator-item-search" type="text">
                <div id="refrigerator-item-search-button"><img src="/assets/icons/ic-white-bold-search.png" alt="돋보기">
                </div>
            </div>
        </div>
    </div>

    <div class="user-search-keyword"><span>'당근'</span>에 대한 검색 결과</div>

    <!-- ========== 냉장고 섹션 ========== -->
    <div class="refrigerator-section-container content-section">
        <!-- 실외 저장소 -->
        <div id="outdoor-storage-container" class="refrigerator-sections">
            <span class="refrigerator-section-name">실외 저장소</span>
            <div class="refrigerator-item-save-boxes">
                <div class="refrigerator-item-save-scroll-boxes">
                    <!-- 재료 카드 들어갈 곳-->
                </div>
            </div>
        </div>

        <!-- 냉동실 -->
        <div id="refrigerator-room-container" class="refrigerator-sections">
            <span class="refrigerator-section-name">냉장고</span>
            <div class="refrigerator-item-save-boxes">
                <div class="refrigerator-item-save-scroll-boxes">
                    <!-- 재료 카드 들어갈 곳-->
                </div>
            </div>
        </div>

        <!-- 냉동고 -->
        <div id="freezer-room-container" class="refrigerator-sections">
            <span class="refrigerator-section-name">냉동고</span>
            <div class="refrigerator-item-save-boxes">
                <div class="refrigerator-item-save-scroll-boxes">
                    <!-- 재료 카드 들어갈 곳-->
                </div>
            </div>
        </div>

        <!-- 식재료 추가하기 버튼 -->
        <div class="add-refrigerator-items-button" id="openModalBtn">
            <img src="/assets/icons/ic-edit.png" alt="재료 추가">
        </div>

        <!-- 식재료 추가 모달   -->
        <div class="modal-overlay" id="addmodal">
            <div class="add-refrigerator-modal-content modal-content">
                <span class="close-button" id="closeModalBtn">&times;</span>
                <h2>식재료 추가</h2>
                <form class="add-refrigerator-items-form">
                    <div class="ingredient-info-input-boxes">
                        <label class="ingredient-label">재료명</label>
                        <input id="name" class="ingredient-input" type="text" placeholder="ex) 계란, 우유">
                    </div>
                    <div class="ingredient-info-input-boxes">
                        <label class="ingredient-label">수량</label>
                        <input id="qnt" class="ingredient-input" type="text" placeholder="ex) 2개, 500g">
                    </div>
                    <div class="ingredient-info-input-boxes">
                        <label class="ingredient-label">유통기한</label>
                        <input id="date" class="ingredient-input" type="date">
                    </div>
                    <div class="ingredient-info-input-boxes">
                        <label class="ingredient-label">카테고리</label>
                        <select class="ingredient-select">
                            <option value="">선택</option>
                            <option>채소</option>
                            <option>육류</option>
                            <option>해산물</option>
                            <option>과일</option>
                            <option>간편식</option>
                            <option>냉동식품</option>
                            <option>디저트</option>
                            <option>유제품</option>
                            <option>기타</option>
                        </select>
                    </div>
                    <div class="ingredient-info-input-boxes">
                        <label class="ingredient-label">보관위치</label>
                        <select class="ingredient-select">
                            <option value="">선택</option>
                            <option>실외 저장소</option>
                            <option>냉장실</option>
                            <option>냉동실</option>
                        </select>
                    </div>

                    <button type="submit" class="ingredient-add-btn">추가하기</button>
                </form>
            </div>
        </div>
    </div>

    <!-- 식재료 수정 모달 -->
    <div class="modal-overlay" id="editModal">
        <div class="add-refrigerator-modal-content modal-content">
            <span class="close-button" id="editModalCloseBtn">&times;</span>
            <h2>식재료 수정</h2>
            <form id="editForm" class="add-refrigerator-items-form">
                <div class="ingredient-info-input-boxes">
                    <label class="ingredient-label">재료명</label>
                    <input id="edit-name" class="ingredient-input" type="text" placeholder="ex) 계란, 우유" />
                </div>
                <div class="ingredient-info-input-boxes">
                    <label class="ingredient-label">수량</label>
                    <input id="edit-qnt" class="ingredient-input" type="text" placeholder="ex) 2개, 500g" />
                </div>
                <div class="ingredient-info-input-boxes">
                    <label class="ingredient-label">유통기한</label>
                    <input id="edit-date" class="ingredient-input" type="date" />
                </div>
                <div class="ingredient-info-input-boxes">
                    <label class="ingredient-label">카테고리</label>
                    <select id="edit-category" class="ingredient-select">
                        <option value="">선택</option>
                        <option>채소</option>
                        <option>육류</option>
                        <option>해산물</option>
                        <option>과일</option>
                        <option>간편식</option>
                        <option>냉동식품</option>
                        <option>디저트</option>
                        <option>유제품</option>
                        <option>기타</option>
                    </select>
                </div>
                <div class="ingredient-info-input-boxes">
                    <label class="ingredient-label">보관위치</label>
                    <select id="edit-location" class="ingredient-select">
                        <option value="">선택</option>
                        <option>실외 저장소</option>
                        <option>냉장실</option>
                        <option>냉동실</option>
                    </select>
                </div>

                <div class="ingredient-edit-modal-button-container">
                    <button type="button" id="deleteBtn" class="ingredient-add-btn">삭제</button>
                    <button type="submit" class="ingredient-add-btn">수정 완료</button>
                </div>
            </form>
        </div>
    </div>

    <!-- 스낵바 -->
    <div id="snackbar">
        삭제되었습니다.
        <button id="undoDeleteBtn">되돌리기</button>
    </div>
</template>

<style scoped>

</style>