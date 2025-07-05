<script setup>
import { useRouter } from 'vue-router'
import Header from './components/Header.vue'
import Footer from './components/Footer.vue'

const router = useRouter()
</script>

<template>
  <Header v-if="!router.meta?.hideLayout" />
  <RouterView />
  <Footer v-if="!router.meta?.hideLayout" />
</template>

<style scoped></style>
