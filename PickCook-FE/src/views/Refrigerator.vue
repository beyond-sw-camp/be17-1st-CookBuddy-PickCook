<script setup>
import api from '@/api/refrigerator'
import { ref, computed, onMounted } from 'vue'
import IngredientCard from '@/components/IngredientCard.vue'
import AddIngredientModal from '@/components/AddIngredientModal.vue'
import EditIngredientModal from '@/components/EditIngredientModal.vue'

const selectedIngredientIndex = ref(null)
const showSnackbar = ref(false)
const lastDeletedItem = ref(null)
const lastDeletedIndex = ref(null)

const searchQuery = ref('')
const searchedKeyword = ref('')
const composing = ref(false)

const showAddModal = ref(false)
const showEditModal = ref(false)

const items = ref([])

function getItemIndex(item) {
  return items.value.findIndex((it) => it === item)
}

const categoryImageMap = {
  유제품: 'ic-ingredient-category-milk',
  육류: 'ic-ingredient-category-meat',
  채소: 'ic-ingredient-category-vegetable',
  과일: 'ic-ingredient-category-fruit',
  디저트: 'ic-ingredient-category-dessert',
  간편식: 'ic-ingredient-category-conveniencefood',
  해산물: 'ic-ingredient-category-fish',
  냉동식품: 'ic-ingredient-category-ice',
  기타: 'ic-ingredient-category-etc',
}

const getIngredients = async () => {
  const data = await api.getIngredients()

  if (data && data.ingredients) {
    items.value = data.ingredients.map((item) => {
      const imageFileName = categoryImageMap[item.category] || 'ic-ingredient-category-etc'
      return {
        name: item.ingredient_name,
        rawDate: item.expiration_date,
        exDate: getDaysLeft(item.expiration_date),
        category: item.category,
        qnt: `${item.quantity} ${item.unit}`,
        imageUrl: `/assets/icons/${imageFileName}.png`,
        location: item.location,
      }
    })
  }
}

const updateSearch = () => {
  searchedKeyword.value = searchQuery.value.trim()
}

const clearSearch = () => {
  searchQuery.value = ''
  searchedKeyword.value = ''
}

const getChosung = (str) => {
  const CHO = [
    'ㄱ',
    'ㄲ',
    'ㄴ',
    'ㄷ',
    'ㄸ',
    'ㄹ',
    'ㅁ',
    'ㅂ',
    'ㅃ',
    'ㅅ',
    'ㅆ',
    'ㅇ',
    'ㅈ',
    'ㅉ',
    'ㅊ',
    'ㅋ',
    'ㅌ',
    'ㅍ',
    'ㅎ',
  ]
  let result = ''
  for (let i = 0; i < str.length; i++) {
    const code = str.charCodeAt(i) - 44032
    if (code >= 0 && code <= 11171) {
      result += CHO[Math.floor(code / 588)]
    } else {
      result += str[i]
    }
  }
  return result
}

const onCompositionStart = () => {
  composing.value = true
}

const onCompositionEnd = (event) => {
  composing.value = false
  searchQuery.value = event.target.value
  updateSearch()
}

const onInput = (event) => {
  searchQuery.value = event.target.value
  updateSearch()
}

const filteredItems = computed(() => {
  const keyword = searchedKeyword.value.toLowerCase()
  const keywordChosung = getChosung(keyword)

  return items.value.filter((item) => {
    const name = item.name.toLowerCase()
    return name.includes(keyword) || getChosung(name).includes(keywordChosung)
  })
})

const getDaysLeft = (dateStr) => {
  const today = new Date()
  const target = new Date(dateStr)
  const diff = Math.ceil((target - today) / (1000 * 60 * 60 * 24))
  if (diff > 0) return `${diff}일 남음`
  else if (diff === 0) return `오늘까지`
  else return `${Math.abs(diff)}일 지남`
}

const handleAddIngredient = ({ name, qnt, rawDate, category, location }) => {
  const imageFileName = categoryImageMap[category] || 'ic-ingredient-category-etc'
  const imageUrl = `/assets/icons/${imageFileName}.png`
  const exDate = getDaysLeft(rawDate)

  const newItem = { name, qnt, rawDate, exDate, category, imageUrl, location }
  items.value.push(newItem)
}

const openEditModal = (index) => {
  selectedIngredientIndex.value = index
  showEditModal.value = true
}

const closeEditModal = () => {
  showEditModal.value = false
  selectedIngredientIndex.value = null
}

const submitEdit = (editedData) => {
  if (selectedIngredientIndex.value !== null) {
    items.value[selectedIngredientIndex.value] = {
      ...items.value[selectedIngredientIndex.value],
      ...editedData,
      exDate: getDaysLeft(editedData.rawDate),
    }
  }
  closeEditModal()
}

const deleteIngredient = () => {
  if (selectedIngredientIndex.value !== null && items.value[selectedIngredientIndex.value]) {
    lastDeletedItem.value = items.value[selectedIngredientIndex.value]
    lastDeletedIndex.value = selectedIngredientIndex.value
    items.value.splice(selectedIngredientIndex.value, 1)
  }
  closeEditModal()
  showSnackbar.value = true
  setTimeout(() => (showSnackbar.value = false), 5000)
}

const undoDelete = () => {
  if (lastDeletedItem.value && lastDeletedIndex.value !== null) {
    items.value.splice(lastDeletedIndex.value, 0, lastDeletedItem.value)
    lastDeletedItem.value = null
    lastDeletedIndex.value = null
    showSnackbar.value = false
  }
}

onMounted(() => {
  getIngredients()
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
        <div class="search-input-wrapper">
          <input
            id="refrigerator-item-search"
            type="text"
            v-model="searchQuery"
            @input="onInput"
            @compositionstart="onCompositionStart"
            @compositionend="onCompositionEnd"
            placeholder="재료명을 입력하세요"
          />
          <button
            v-if="searchQuery"
            class="input-clear-btn"
            @click="clearSearch"
            aria-label="입력 초기화"
          >
            ×
          </button>
        </div>
        <div id="refrigerator-item-search-button">
          <img src="/assets/icons/ic-white-bold-search.png" alt="돋보기" />
        </div>
      </div>
    </div>
  </div>
  <div v-if="searchedKeyword" class="user-search-keyword">
    <span>'{{ searchedKeyword }}'</span>에 대한 검색 결과({{ filteredItems.length }})
  </div>

  <!-- 냉장고 섹션 -->
  <div class="refrigerator-section-container refrigerator-content-section">
    <!-- 실외 저장소 -->
    <div id="outdoor-storage-container" class="refrigerator-sections">
      <span class="refrigerator-section-name">실외 저장소</span>
      <div class="refrigerator-item-save-boxes">
        <div class="refrigerator-item-save-scroll-boxes">
          <IngredientCard
            v-for="(item, i) in filteredItems.filter((item) => item.location === '실외 저장소')"
            :key="item.ingredient_id || item.name + '-' + i"
            :image-url="item.imageUrl"
            v-bind="item"
            @click="openEditModal(getItemIndex(item))"
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
            v-for="(item, i) in filteredItems.filter((item) => item.location === '냉장실')"
            :key="item.ingredient_id || item.name + '-' + i"
            :image-url="item.imageUrl"
            v-bind="item"
            @click="openEditModal(getItemIndex(item))"
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
            v-for="(item, i) in filteredItems.filter((item) => item.location === '냉동실')"
            :key="item.ingredient_id || item.name + '-' + i"
            :image-url="item.imageUrl"
            v-bind="item"
            @click="openEditModal(getItemIndex(item))"
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
  <div class="add-refrigerator-items-button" @click="showAddModal = true">
    <img src="/assets/icons/ic-edit.png" alt="재료 추가" />
  </div>

  <AddIngredientModal
    :visible="showAddModal"
    @close="showAddModal = false"
    @submit="handleAddIngredient"
  />

  <!-- 수정 모달 -->
  <EditIngredientModal
    :visible="showEditModal"
    :ingredient="
      selectedIngredientIndex !== null && items[selectedIngredientIndex]
        ? items[selectedIngredientIndex]
        : null
    "
    @close="closeEditModal"
    @submit="submitEdit"
    @delete="deleteIngredient"
  />
  <!-- 삭제 취소 스낵바 -->
  <div id="snackbar" v-if="showSnackbar">
    삭제되었습니다.
    <button id="undoDeleteBtn" @click="undoDelete">되돌리기</button>
  </div>
</template>
<style scoped></style>
