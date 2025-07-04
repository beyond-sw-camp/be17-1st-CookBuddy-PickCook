import Recipe from '@/views/Recipe.vue'
import RecipeDetail from '@/views/RecipeDetail.vue'
import { createRouter, createWebHistory } from 'vue-router'
import Community from '@/views/Community.vue'
import CommunityDetail from '@/views/CommunityDetail.vue'
import Shopping from '@/views/Shopping.vue'
import Shopping_detail from '@/views/Shopping_detail.vue'

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
    {
      path: '/community',
      name: 'community',
      component: Community
    },
    {
      path: '/community/detail',
      name: 'communityDetail',
      component: CommunityDetail
    },
    {
      path: '/shopping',
      name: 'shopping',
      component: Shopping,
    },
    {
      path: '/shopping/detail',
      name: 'shoppingdetail',
      component: Shopping_detail,
    },
  ],
})

export default router
