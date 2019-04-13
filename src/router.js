import Vue from 'vue'
import Router from 'vue-router'
import Incoming from './views/Incoming.vue'
import Daily from './views/Daily.vue'
import Products from './views/Products.vue'
import Suppliers from './views/Suppliers.vue'
import Customers from './views/Customers.vue'
import SuppliersReceipts from './views/SuppliersReceipts.vue'
import CustomersAccounts from './views/CustomersAccounts.vue'
import Outgoing from './views/Outgoing.vue'
import Cashflow from './views/Cashflow.vue'
import DeveloperTools from './views/DeveloperTools.vue'
import SupplierDetails from './views/SupplierDetails.vue'
import CustomerDetails from './views/CustomerDetails.vue'
import DailyMoves from './views/DailyMoves.vue'
import OutHeadTable from './views/OutHeadTable.vue'
Vue.use(Router)

export default new Router({
  // mode: 'history',
  base: process.env.BASE_URL,
  routes: [
    {
      path: '/',
      name: 'incoming',
      component: Incoming
    },
    {
      path: '/daily',
      name: 'daily',
      component: Daily
    },
    {
      path: '/outgoing',
      name: 'outgoing',
      component: Outgoing
    },
    {
      path: '/daily_moves',
      name: 'daily_moves',
      component: DailyMoves
    },
        {
      path: '/outhead_table',
      name: 'outhead_table',
      component: OutHeadTable
    },
    {
      path: '/customers_accounts',
      name: 'customers_accounts',
      component: CustomersAccounts
    },
    {
      path: '/suppliers_receipts',
      name: 'suppliers_receipts',
      component: SuppliersReceipts
    },
    {
      path: '/products',
      name: 'products',
      component: Products
    },
    {
      path: '/suppliers',
      name: 'suppliers',
      component: Suppliers
    },
    {
      path: '/customers',
      name: 'customers',
      component: Customers
    },
    {
      path: '/expenses',
      name: 'expenses',
      component: Cashflow
    },
    {
      path: '/payments',
      name: 'payments',
      component: Cashflow
    },
    {
      path: '/collecting',
      name: 'collecting',
      component: Cashflow
    },
    {
      path: '/developer',
      name: 'developer',
      component: DeveloperTools
    },
    {
      path: '/supplier_details/:id',
      name: 'supplier_details',
      component: SupplierDetails
    },
    {
      path: '/customer_details/:id',
      name: 'customer_details',
      component: CustomerDetails
    },
    {
      path: '/about',
      name: 'about',
      // route level code-splitting
      // this generates a separate chunk (about.[hash].js) for this route
      // which is lazy-loaded when the route is visited.
      component: () => import(/* webpackChunkName: "about" */ './views/About.vue')
    },
    {
      path: '/image',
      name: 'image',
      // route level code-splitting
      // this generates a separate chunk (about.[hash].js) for this route
      // which is lazy-loaded when the route is visited.
      component: () => import(/* webpackChunkName: "about" */ './views/Image.vue')
    },
    {
      path: '/settings',
      name: 'settings',
      // route level code-splitting
      // this generates a separate chunk (about.[hash].js) for this route
      // which is lazy-loaded when the route is visited.
      component: () => import(/* webpackChunkName: "about" */ './views/Settings.vue')
    }
  ]
})
