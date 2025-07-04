<script setup>
import Header from './components/Header.vue'
import Footer from './components/Footer.vue'
</script>

<template>
  <Header v-if="!routeLocationKey?.meta?.hideLayout" />
  <RouterView />
  <Footer v-if="!routeLocationKey?.meta?.hideLayout" />
</template>

<style scoped></style>
