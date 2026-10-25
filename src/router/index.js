import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    name: 'inicio',
    component: () => import('../views/InicioView.vue'),
  },
  {
    path: '/catalogo',
    name: 'catalogo',
    component: () => import('../views/CatalogoView.vue'),
  },
  {
    path: '/objetos/nuevo',
    name: 'nuevo-objeto',
    component: () => import('../views/ObjetoFormView.vue'),
  },
  {
    path: '/objetos/:id',
    name: 'detalle-objeto',
    component: () => import('../views/ObjetoDetalleView.vue'),
  },
  {
    path: '/objetos/:id/editar',
    name: 'editar-objeto',
    component: () => import('../views/ObjetoFormView.vue'),
  },
  {
    path: '/login',
    name: 'login',
    component: () => import('../views/LoginView.vue'),
  },
  {
    path: '/registro',
    name: 'registro',
    component: () => import('../views/RegistroView.vue'),
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior() {
    return { top: 0 }
  },
})

export default router
