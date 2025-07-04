import Recipe from '@/views/Recipe.vue'
import RecipeDetail from '@/views/RecipeDetail.vue'
import { createRouter, createWebHistory } from 'vue-router'
import Login from '@/views/Login.vue'
import SignupTypeSelect from '@/views/SignupTypeselect.vue'
import Signup from '@/views/Signup.vue'

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
      path: '/login',
      name: 'login',
      component: Login,
      meta: { hideLayout: true },
    },
    {
      path: '/signup',
      name: 'signup',
      component: SignupTypeSelect,
      meta: { hideLayout: true },
    },
    {
      path: '/signup/write',
      name: 'signup_write',
      component: Signup,
      meta: { hideLayout: true },
    },
  ],
})

export default router
