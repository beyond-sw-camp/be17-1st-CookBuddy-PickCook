<script setup>
import { ref, onMounted } from 'vue'
import IngredientCard from '@/components/IngredientCard.vue'

const selectedIngredientIndex = ref(null)
const selectedIngredientBackup = ref(null)  // 복사본 저장용
const showSnackbar = ref(false)
const lastDeletedItem = ref(null)
const lastDeletedIndex = ref(null)

function getItemIndex(item) {
  return items.value.findIndex(it => it === item)
}

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
}

const items = ref([
  {
    name: '우유',
    qnt: '500ml',
    rawDate: '2025-07-08',
    exDate: '3일 남음',
    category: '유제품',
    imageUrl: '/assets/icons/ic-ingredient-category-milk.png',
    location: '냉장실',
  },
  {
    name: '고기',
    qnt: '300g',
    rawDate: '2025-07-10',
    exDate: '5일 남음',
    category: '육류',
    imageUrl: '/assets/icons/ic-ingredient-category-meat.png',
    location: '냉동실',
  },
  {
    name: '감자',
    qnt: '2개',
    rawDate: '2025-07-04',
    exDate: '1일 남음',
    category: '채소',
    imageUrl: '/assets/icons/ic-ingredient-category-vegetable.png',
    location: '실외 저장소',
  },
])

function getDaysLeft(dateStr) {
  const today = new Date()
  const target = new Date(dateStr)
  const diff = Math.ceil((target - today) / (1000 * 60 * 60 * 24))
  if (diff > 0) return `${diff}일 남음`
  else if (diff === 0) return `오늘까지`
  else return `${Math.abs(diff)}일 지남`
}

function handleAddIngredient({ name, qnt, rawDate, category, location }) {
  const imageFileName = categoryImageMap[category] || 'ic-ingredient-category-etc'
  const imageUrl = `/assets/icons/${imageFileName}.png`
  const exDate = getDaysLeft(rawDate)

  const newItem = { name, qnt, rawDate, exDate, category, imageUrl, location }
  items.value.push(newItem)
}

function openEditModal(ingredient, index) {
  selectedIngredientIndex.value = index
  selectedIngredientBackup.value = JSON.parse(JSON.stringify(ingredient))
  const modal = document.getElementById('editModal')
  if (modal) modal.style.display = 'flex'
  document.getElementById('edit-name').value = ingredient.name || ''
  document.getElementById('edit-qnt').value = ingredient.qnt || ''
  document.getElementById('edit-date').value = ingredient.rawDate || ''
  document.getElementById('edit-category').value = ingredient.category || ''
  document.getElementById('edit-location').value = ingredient.location || ''
}

function undoEdit() {
  const idx = selectedIngredientIndex.value
  if (idx === null || !selectedIngredientBackup.value) return
  items.value[idx] = JSON.parse(JSON.stringify(selectedIngredientBackup.value))
  closeEditModal()
}

function closeEditModal() {
  const modal = document.getElementById('editModal')
  if (modal) modal.style.display = 'none'
  selectedIngredientIndex.value = null
  selectedIngredientBackup.value = null
}

function undoDelete() {
  if (lastDeletedItem.value && lastDeletedIndex.value !== null) {
    items.value.splice(lastDeletedIndex.value, 0, lastDeletedItem.value)
    lastDeletedItem.value = null
    lastDeletedIndex.value = null
    showSnackbar.value = false
  }
}

onMounted(() => {
  const addModal = document.getElementById('addmodal')
  const addForm = addModal.querySelector('form')
  const addOpenBtn = document.getElementById('openModalBtn')
  const addCloseBtn = document.getElementById('closeModalBtn')

  addOpenBtn?.addEventListener('click', () => addModal.style.display = 'flex')
  addCloseBtn?.addEventListener('click', () => addModal.style.display = 'none')

  addForm?.addEventListener('submit', (e) => {
    e.preventDefault()
    const name = document.getElementById('name').value.trim()
    const qnt = document.getElementById('qnt').value.trim()
    const rawDate = document.getElementById('date').value.trim()
    const category = document.querySelectorAll('.ingredient-select')[0].value
    const location = document.querySelectorAll('.ingredient-select')[1].value
    if (!name || !qnt || !rawDate || !category || !location) {
      alert('모든 항목을 입력해주세요.')
      return
    }
    handleAddIngredient({ name, qnt, rawDate, category, location })
    addModal.style.display = 'none'
    addForm.reset()
  })

  const editModal = document.getElementById('editModal')
  const editForm = document.getElementById('editForm')
  const deleteBtn = document.getElementById('deleteBtn')
  const editCloseBtn = document.getElementById('editModalCloseBtn')

  editCloseBtn?.addEventListener('click', () => {
    editModal.style.display = 'none'
    selectedIngredientIndex.value = null
  })

  window.addEventListener('click', (e) => {
    if (e.target === addModal) addModal.style.display = 'none'
    if (e.target === editModal) {
      editModal.style.display = 'none'
      selectedIngredientIndex.value = null
    }
  })

  editForm?.addEventListener('submit', (e) => {
    e.preventDefault()
    const idx = selectedIngredientIndex.value
    if (idx === null) return
    const name = document.getElementById('edit-name').value.trim()
    const qnt = document.getElementById('edit-qnt').value.trim()
    const rawDate = document.getElementById('edit-date').value.trim()
    const category = document.getElementById('edit-category').value
    const location = document.getElementById('edit-location').value
    if (!name || !qnt || !rawDate || !category || !location) {
      alert('모든 항목을 입력해주세요.')
      return
    }
    const imageFileName = categoryImageMap[category] || 'ic-ingredient-category-etc'
    const imageUrl = `/assets/icons/${imageFileName}.png`
    const exDate = getDaysLeft(rawDate)
    items.value[idx] = { name, qnt, rawDate, exDate, category, imageUrl, location }
    editModal.style.display = 'none'
    selectedIngredientIndex.value = null
  })

  deleteBtn?.addEventListener('click', () => {
    const idx = selectedIngredientIndex.value
    if (idx === null) return
    lastDeletedItem.value = items.value[idx]
    lastDeletedIndex.value = idx
    items.value.splice(idx, 1)
    editModal.style.display = 'none'
    selectedIngredientIndex.value = null
    showSnackbar.value = true
    setTimeout(() => showSnackbar.value = false, 5000)
  })
})
</script>



<template>
  <!-- 검색 필터 영역 -->
  <div class="refrigerator-search-help-section-container filter-section">
    <div class="refrigerator-search-help-section">
      <div class="refrigerator-filter-container">
        <span class="refrigerator-filter-items">정렬 &nbsp;▼</span>
        <span class="refrigerator-filter-items">카테고리 &nbsp;▼</span>
        <span class="refrigerator-filter-items">재고위치 &nbsp;▼</span>
      </div>
      <div class="search-bar-container">
        <input id="refrigerator-item-search" type="text" />
        <div id="refrigerator-item-search-button">
          <img src="/assets/icons/ic-white-bold-search.png" alt="돋보기" />
        </div>
      </div>
    </div>
  </div>

  <div class="user-search-keyword">
    <span>'당근'</span>에 대한 검색 결과
  </div>

  <!-- 냉장고 섹션 -->
  <div class="refrigerator-section-container content-section">
    <!-- 실외 저장소 -->
    <div id="outdoor-storage-container" class="refrigerator-sections">
      <span class="refrigerator-section-name">실외 저장소</span>
      <div class="refrigerator-item-save-boxes">
        <div class="refrigerator-item-save-scroll-boxes">
            <IngredientCard
            v-for="(item, i) in items.filter(item => item.location === '실외 저장소')"
            :key="item.name + '-' + i"
            v-bind="item"
            @click="() => openEditModal(item, getItemIndex(item))"
            />
        </div>
      </div>
    </div>
    <!-- 냉장실 -->
    <div id="refrigerator-room-container" class="refrigerator-sections">
      <span class="refrigerator-section-name">냉장고</span>
      <div class="refrigerator-item-save-boxes">
        <div class="refrigerator-item-save-scroll-boxes">
            <IngredientCard
            v-for="(item, i) in items.filter(item => item.location === '냉장실')"
            :key="item.name + '-' + i"
            v-bind="item"
            @click="() => openEditModal(item, getItemIndex(item))"
            />
        </div>
      </div>
    </div>
    <!-- 냉동실 -->
    <div id="freezer-room-container" class="refrigerator-sections">
      <span class="refrigerator-section-name">냉동고</span>
      <div class="refrigerator-item-save-boxes">
        <div class="refrigerator-item-save-scroll-boxes">
            <IngredientCard
            v-for="(item, i) in items.filter(item => item.location === '냉동실')"
            :key="item.name + '-' + i"
            v-bind="item"
            @click="() => openEditModal(item, getItemIndex(item))"
            />
        </div>
      </div>
    </div>
  </div>

  <!-- 추가 버튼 -->
  <div class="add-refrigerator-items-button" id="openModalBtn">
    <img src="/assets/icons/ic-edit.png" alt="재료 추가" />
  </div>

  <!-- 재료 추가 모달 -->
  <div class="modal-overlay" id="addmodal">
    <div class="add-refrigerator-modal-content modal-content">
      <span class="close-button" id="closeModalBtn">&times;</span>
      <h2>식재료 추가</h2>
      <form class="add-refrigerator-items-form">
        <div class="ingredient-info-input-boxes">
          <label class="ingredient-label">재료명</label>
          <input id="name" class="ingredient-input" type="text" placeholder="ex) 계란, 우유" />
        </div>
        <div class="ingredient-info-input-boxes">
          <label class="ingredient-label">수량</label>
          <input id="qnt" class="ingredient-input" type="text" placeholder="ex) 2개, 500g" />
        </div>
        <div class="ingredient-info-input-boxes">
          <label class="ingredient-label">유통기한</label>
          <input id="date" class="ingredient-input" type="date" />
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

  <!-- 수정 모달 -->
<div class="modal-overlay" id="editModal" style="display:none;">
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
  <!-- 삭제 취소 스낵바 -->
<div id="snackbar" v-if="showSnackbar">
  삭제되었습니다.
  <button id="undoDeleteBtn" @click="undoDelete">되돌리기</button>
</div>
</template>
<style scoped>
</style>