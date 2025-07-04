import Recipe from '@/views/Recipe.vue'
import RecipeDetail from '@/views/RecipeDetail.vue'
import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/recipe',
      name: 'recipe',
      component: Recipe,
    },
    {
      path: '/recipe/detail',
      name: 'recipedetail',
      component: RecipeDetail,
    },
  ],
})

export default router
