// Data Types and classes

export class Outgoing {
    static table_name = 'outgoing'
    data = {
      id: 0,
      date: '',
      supplier: 0,
      count: 0,
      product: 0,
      notes: '',
      seller: '',
      price: 0,
      weight: 0
    }

    static spec_datatypes = {
        price: 'decimal(15,4)',
        weight: 'decimal(15,4)'
    }
  
    constructor (data) {
      this.data.id = data.id ? data.id : this.data.id
      this.data.date = data.date ? data.date : this.data.date
      this.data.supplier = data.supplier ? data.supplier : this.data.supplier
      this.data.count = data.count ? data.count : this.data.count
      this.data.product = data.product ? data.product : this.data.product
      this.data.weight = data.weight ? data.weight : this.data.weight
      this.data.seller = data.seller ? data.seller : this.data.seller
      this.data.price = data.price ? data.price : this.data.price
      this.data.notes = data.notes ? data.notes : this.data.notes
    }
  
    static sql_types () {
      var instance = new this({})
      var keys = Object.keys(instance.data)
      var create_sql_cols = ''
      keys.forEach(col =>{
        if(col =='id')
            create_sql_cols += 'id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,'
        else if ( this.spec_datatypes[col])
            create_sql_cols += col+ ' ' + this.spec_datatypes[col] + ' ,'
        else if( instance.data[col] === 0 )
            create_sql_cols += col+ ' INT ,'
        else 
            create_sql_cols += col+ ' VARCHAR(256),'
      })
      return create_sql_cols.replace(/,\s*$/, "")
    }
  
    static createTableQ () {
      return `CREATE TABLE ${this.table_name} ( ${this.sql_types()}) ;`
    }
}


export class Product {
    static table_name = 'product'
    data = {
      id: 0,
      name: '',
      notes: '',
      active: 1
    }

    static spec_datatypes = {
      //  price: 'decimal(15,4)'
    }
  
    constructor (data) {
      this.data.id = data.id!== null ? data.id : this.data.id
      this.data.name = data.name!== null ? data.name : this.data.name
      this.data.notes = data.notes!== null ? data.notes : this.data.notes
      this.data.active = data.active !== null  ? data.active : this.data.active
    }
  
    static sql_types () {
      var instance = new this({})
      var keys = Object.keys(instance.data)
      var create_sql_cols = ''
      keys.forEach(col =>{
        if(col =='id')
          create_sql_cols += 'id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,'
        else if ( this.spec_datatypes[col])
          create_sql_cols += col+ ' ' + this.spec_datatypes[col] + ' ,'
        else if( instance.data[col] === 0 )
          create_sql_cols += col+ ' INT ,'
        else if( instance.data[col] === 1 ) 
          create_sql_cols += col+ ' tinyint ,'
        else 
          create_sql_cols += col+ ' VARCHAR(256),'
      })
      return create_sql_cols.replace(/,\s*$/, "")
    }
  
    static createTableQ () {
      return `CREATE TABLE ${this.table_name} ( ${this.sql_types()}) ;`
    }
}