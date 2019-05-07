# Daily Manger Demo

- first clone electron-vue example https://github.com/drehimself/electron-vue-example
- add vue-cli-plugin-electron-builder https://github.com/nklayman/vue-cli-plugin-electron-builder
- in background.js window.maximize()
- Adding bootstrap (only -s) https://bootstrap-vue.js.org/docs (also App.js)
- Addin mysql see #mysql configs
- Adding dashboard layout to bootstrap https://getbootstrap.com/docs/4.3/examples/dashboard/# 
- Change body direction and text-align for arabic and change main class ml-sm-auto to mr-sm-auto
- Adding fontawsome to public/index.html
- Changing icon and builder options https://nklayman.github.io/vue-cli-plugin-electron-builder/guide/configuration.html#table-of-contents
- Changing icon for serve in background.js main window BrowserWindow config `icon:  'assets/logo.png'`

## VS Code ext
- MySQL : Jun Han
- Todo+ : Fabio Spampinato
- Vue.js Extension Pack : Muhammad Ubaid Raza

## Mysql Configs

- go with aysnc await https://medium.com/@mhagemann/create-a-mysql-database-middleware-with-node-js-8-and-async-await-6984a09d49f4

## Demo TODOS

- Demo Products form Oboor site.
- Multi Users Support
- Accounting Support !
- 10 Price / 1 Comm (Yearly ) includes PC & Printer
- 24/7 Support ( 9 am - 3 am )
- Printed Manual / Brochure

## APP TODOS 

- mysql views, trans and SP

`
SELECT *, sum(weight) as sum_weight, sum(count) as sum_count FROM outgoings GROUP BY income_head_id, kg_price;
`

## Tricks

- increase backup file size from php.ini post_max_size , upload_max_filesize
- jaf00091

## Project setup
```
npm install
```

### Compiles and hot-reloads for development
```
npm run serve
```

### Compiles and minifies for production
```
npm run build
```

### Lints and fixes files
```
npm run lint
```
