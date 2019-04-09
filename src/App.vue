<template>
  <div id="app" >
    <nav class="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow d-print-none">
      <a class="navbar-brand col-sm-3 col-md-2 mr-0" href="#">ادارة اليوميات</a>
      <input class="form-control form-control-dark w-100" type="text" placeholder="Search" aria-label="Search">
      <ul class="navbar-nav px-3">
        <li class="nav-item text-nowrap">
          <a class="nav-link" href="#">Exit</a>
        </li>
      </ul>
    </nav>

    <div class="container-fluid ">
      <div class="row" style="max-width: 100%;">
        <nav class="col-md-2 d-none d-md-block bg-light sidebar d-print-none" >
          <div class="sidebar-sticky mt-3">
            <b class=" text-muted">
              {{ day_comp.d_week }}
            </b>
            <h3 class="d-flex justify-content-between align-items-center px-3  mb-1 text-muted">
              <router-link to="/daily" > {{ day_comp.arab }} </router-link>
            </h3>
            <b class="m-3 ">
              <router-link class="text-danger" to="/daily" style="float:left;padding: 0 10px;">
              تغيير اليوم
              </router-link>
            </b>
            <div><br></div>
            <!--
            <datetime v-model="luxon_date" @close="change_luxon_date"></datetime>
            -->
            <ul class="nav flex-column">

              <li class="nav-item bg-incoming ">
                <router-link class="nav-link active" to="/">
                  <span class="fa fa-sign-in-alt "></span>
                  الوارد <span class="sr-only">(current)</span>
                </router-link>
              </li>
              <li class="nav-item bg-outgoing ">
                <router-link class="nav-link active" to="/outgoing">
                  <span class="fa fa-sign-out-alt"></span>
                  المبيعات <span class="sr-only">(current)</span>
                </router-link>
              </li>
              <li class="nav-item bg-dailymoves">
                <router-link class="nav-link active" to="/daily_moves">
                  <span class="fa fa-dolly"></span>
                  كشف الحركة <span class="sr-only">(current)</span>
                </router-link>
              </li>
              <li class="nav-item bg-receipts">
                <router-link class="nav-link active" to="/suppliers_receipts">
                  <span class="fa fa-receipt"></span>
                  فواتير العملاء  
                </router-link>
              </li>
              <li class="nav-item bg-accounts">
                <router-link class="nav-link active" to="/customers_accounts">
                  <span class="fa fa-cash-register"></span>
                  حساب البائعين
                </router-link>
              </li>
              <!--
              <li class="nav-item">
                <router-link class="nav-link active" to="/payments">
                  <span class="fa fa-money-bill-wave"></span>
                  مدفوعات 
                </router-link>
              </li>
              -->
              <li class="nav-item">
                <router-link class="nav-link active" to="/expensess">
                  <span class="fa fa-money-bill-wave"></span>
                  مصروفات 
                </router-link>
              </li>
              <li class="nav-item">
                <router-link class="nav-link active" to="/collecting">
                  <span class="fa fa-credit-card"></span>
                  تحصيلات 
                </router-link>
              </li>

            </ul>

            <h3 class="d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted">
              <span>مدير النظام</span>
              <a class="d-flex align-items-center text-muted" href="#">
                <span data-feather="plus-circle"></span>
              </a>
            </h3>
            <ul class="nav flex-column mb-2">
              <li class="nav-item">
                <router-link class="nav-link active" to="/suppliers">
                  <span class="fa fa-th-list"></span>
                  ادارة العملاء <span class="sr-only">(current)</span>
                </router-link>
              </li>
              <li class="nav-item">
                <router-link class="nav-link active" to="/customers">
                  <span class="fa fa-handshake"></span>
                  ادارة البائعين <span class="sr-only">(current)</span>
                </router-link>
              </li>
              <li class="nav-item">
                <router-link class="nav-link active" to="/products">
                  <span class="fa fa-apple-alt"></span>
                   ادارة الاصناف 
                   <span class="sr-only">(current)</span>
                </router-link>
              </li>
              
              <li class="nav-item">
                <router-link class="nav-link active" to="/developer">
                  <span class="fa fa-code"></span>
                   معلومات النظام<span class="sr-only">(current)</span>
                </router-link>
              </li>
              <!--
              -->
            </ul>
            <!--
            <ul class="nav flex-column mb-2">
              <li class="nav-item">
                <a class="nav-link" href="#">
                  <span data-feather="file-text"></span>
                  Current month
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="#">
                  <span data-feather="file-text"></span>
                  Last quarter
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="#">
                  <span data-feather="file-text"></span>
                  Social engagement
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="#">
                  <span data-feather="file-text"></span>
                  Year-end sale
                </a>
              </li>
            </ul>
            -->
          </div>
        </nav>

        <main role="main" class="col-md-9 mr-sm-auto col-lg-10 px-0 col-print-12" >
          <router-view/>
        </main>
      </div>
    </div>
  </div>
</template>
<script>
//<router-view/>
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'
import { moment } from './main.js'
import { Settings, DateTime } from 'luxon'

Settings.defaultLocale = 'ar'
Settings.defaultZoneName = 'UTC'

export default {
  data() {
    return {

    }
  },
  beforeMount () {
    let dateTime= DateTime.fromJSDate(new Date())
    let arab = moment().format('LL')
    let d_week = dateTime.toLocaleString({ weekday: 'long'})
    if ( ! this.$store.state.day.now )
      this.$store.commit('setDay' ,{ts: Date.now(), iso: dateTime.toISODate(), arab: arab, d_week: d_week })
  },
  methods: {

  },
  computed: {
    day_comp : function () {
      return this.$store.state.day
    }
  },
  watch :{
    // luxon_date: function() {}
  }
}
</script>
<style>
body {
  direction: rtl;
  text-align: right;
}

h1,h2,h3,h4,h5 {
  color: #666
}

.feather {
  width: 16px;
  height: 16px;
  vertical-align: text-bottom;
}

/*
 * Sidebar
 */

.sidebar {
  position: fixed;
  top: 0;
  bottom: 0;
  right: 0;
  z-index: 100; /* Behind the navbar */
  padding: 48px 0 0; /* Height of navbar */
  box-shadow: inset -1px 0 0 rgba(0, 0, 0, .1);
}

.sidebar-sticky {
  position: relative;
  font-size: large;
  top: 0;
  height: calc(100vh - 48px);
  padding-top: .5rem;
  overflow-x: hidden;
  overflow-y: auto; /* Scrollable contents if viewport is shorter than content. */
}

@supports ((position: -webkit-sticky) or (position: sticky)) {
  .sidebar-sticky {
    position: -webkit-sticky;
    position: sticky;
  }
}

.sidebar .nav-link {
  font-weight: 500;
  color: #333;
}

.sidebar .nav-link .feather {
  margin-right: 4px;
  color: #999;
}

.sidebar .nav-link.active {
  color: #007bff;
}

.btn-printo {
  color: white;
  background-color: #55595d;
}

.sidebar .nav-link:hover .feather,
.sidebar .nav-link.active .feather {
  color: inherit;
}

.sidebar-heading {
  font-size: .75rem;
  text-transform: uppercase;
}

/*
 * Content
 */

[role="main"] {
  padding-top: 133px; /* Space for fixed navbar */
}

@media (min-width: 768px) {
  [role="main"] {
    padding-top: 48px; /* Space for fixed navbar */
  }
}

/*
 * Navbar
 */

.navbar-brand {
  padding-top: .75rem;
  padding-bottom: .75rem;
  font-size: 1rem;
  background-color: rgba(0, 0, 0, .25);
  box-shadow: inset -1px 0 0 rgba(0, 0, 0, .25);
}

.navbar .form-control {
  padding: .75rem 1rem;
  border-width: 0;
  border-radius: 0;
}

.form-control-dark {
  color: #fff;
  background-color: rgba(255, 255, 255, .1);
  border-color: rgba(255, 255, 255, .1);
}

.form-control-dark:focus {
  border-color: transparent;
  box-shadow: 0 0 0 3px rgba(255, 255, 255, .25);
}
.minh90 {
  min-height: 90vh;
}

.bg-incoming {
  background-color: #cff9c4;
  border-radius: 0 10px 10px 0 ;
}
.bg-outgoing {
  background-color: #f5c5b6;
  border-radius: 0 10px 10px 0 ;
}
.bg-receipts {
  background-color: #f1e1e1;
  border-radius: 0 10px 10px 0 ;
}
.bg-accounts {
  background-color: #d1dbf3;
  border-radius: 0 10px 10px 0 ;
}
.bg-dailymoves {
  /*
  background-color: #e1e6b3;
  */
  border-radius: 0 10px 10px 0 ;

}


.vdatetime-input{
  padding: 8px 10px;
  font-size: 18px;
  border: solid 1px #ddd;
  color: #444;
}

.collect-box {
  margin: 5px;
  width: 100%;
  height: 3em;
  display: block;
  border: 2px solid;
}
/*
#app {
  direction: rtl;
  text-align: right;
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
  max-width: 90%;
  padding:10px;
  margin:10px;
}
#nav {
  padding: 30px;
}

#nav a {
  font-weight: bold;
  color: #2c3e50;
}

#nav a.router-link-exact-active {
  color: #42b983;
}
*/

/* printing */
@media print {
  .col-print-1 {
    flex: 0 0 8.33333%;
    max-width: 8.33333%; } }

@media print {
  .col-print-2 {
    flex: 0 0 16.66667%;
    max-width: 16.66667%; } }

@media print {
  .col-print-3 {
    flex: 0 0 25%;
    max-width: 25%; } }

@media print {
  .col-print-4 {
    flex: 0 0 33.33333%;
    max-width: 33.33333%; } }

@media print {
  .col-print-5 {
    flex: 0 0 41.66667%;
    max-width: 41.66667%; } }

@media print {
  .col-print-6 {
    flex: 0 0 50%;
    max-width: 50%; } }

@media print {
  .col-print-7 {
    flex: 0 0 58.33333%;
    max-width: 58.33333%; } }

@media print {
  .col-print-8 {
    flex: 0 0 66.66667%;
    max-width: 66.66667%; } }

@media print {
  .col-print-9 {
    flex: 0 0 75%;
    max-width: 75%; } }

@media print {
  .col-print-10 {
    flex: 0 0 83.33333%;
    max-width: 83.33333%; } }

@media print {
  .col-print-11 {
    flex: 0 0 91.66667%;
    max-width: 91.66667%; } }

@media print {
  .col-print-12 {
    flex: 0 0 100%;
    max-width: 100%; } }

@media print {
  h1, h2 {
    margin: 1rem;
    font-size: 3rem;
    color: black !important;
  }
  h3, h4 {
    margin: 1rem;
    font-size: 2rem;
    color: black !important;
  }
  .pr-me {
    color: black !important;
    font-size: x-large
  }
  .pr-hideme {
    display: none
  }
  .pr-mt-2 {
    margin-top: 2em;
  }
  .pr-mt-3 {
    margin-top: 3em;
  }
  .nav-link {
    text-decoration: none !important;
    color: black !important;
  }
  .table thead tr , .table thead tr td  {
    /*
    ,.table tbody tr
    border-color: black !important;
    
    border-top-style: solid !important;
    border-top-width: 3px;
    
    border-top: 1px solid #000  !important;
    */
    border-top-width: 2px;
    border-top-style: solid;

    border-bottom-style: solid;
    border-color: black;
    -webkit-print-color-adjust:exact;
    -webkit-border-vertical-spacing: 0px !important;
  }

}
</style>
