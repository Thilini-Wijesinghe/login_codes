import 'package:flutter/material.dart';
import'package:carousel_pro/carousel_pro.dart';
import 'package:ecommerce_tut/components/horizontal_listview.dart';
import 'package:ecommerce_tut/components/products.dart';

class Homepage extends StatefulWidget{
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<HomePage>{
  @override
  Widget build(BuildContext context){
    Widget image_carousel= new Container(
        height: 200.0,
        child: new Carousel(
          boxFit: BoxFit.cover,
          images:[
            AssetImage(''),
            AssetImage(''),
            AssetImage(''),
            AssetImage(''),
            AssetImage(''),
            AssetImage(''),
          ]
          autoplay:false,
          animationCurve:Curves.fastOutSlowIn,
          animationDuration: Duration(milliseconds:1000),
          dotSize:4.0,
          indicatorBgPadding:2.0,
        )
    )
    return Scaffold(
        appBar:new AppBar(
            elevation:0.1,
            backgroundColor: Colors.red.shade900,
            title:text('Nadeesha bookshop'),
            actions:<Widget>[
        new IconButton(
        icon:Icon(
            Icons.search,
            color:Colors.white
        )
        onPressed:(){},
    )
    new IconButton(
    icon:Icon(
    Icons.shopping_cart,
    color:Colors.white,
    )
    onPressed:(){}
    )
    ]
    )
    drawer: new Drawer(
    child:new ListView(
    children:<Widget>[
    header
    new UserAccountsDrawerHeader(
    accountName: Text('santos Enoque'),
    accountEmail: Text('santosenoque.s@gmail.com'),
    currentAccountPicture: GestureDetector(
    child:new CircleAvatar(
    backgroundColor: Colors.grey,
    child: Icon(Icons.person,color:Colors.white)
    )
    )
    decoration: new BoxDecoration(
    color:Colors.red.shade900
    )
    )



    InkWell(
    onTap: (){},
    child:ListTile(
    title: Text('Home page'),
    leading:Icon(Icons.home),
    ),
    )


    InkWell(
    onTap: (){},
    child:ListTile(
    title: Text('My account'),
    leading:Icon(Icons.person),
    ),
    )

    InkWell(
    onTap: (){},
    child:ListTile(
    title: Text('my orders'),
    leading:Icon(Icons.shopping_basket),
    ),
    )

    InkWell(
    onTap: (){},
    child:ListTile(
    title: Text('categories'),
    leading:Icon(Icons.dashboard),
    ),
    )

    InkWell(
    onTap: (){},
    child:ListTile(
    title: Text('favourites'),
    leading:Icon(Icons.favorite),
    ),
    )

    Divider(),
    InkWell(
    onTap: (){},
    child:ListTile(
    title: Text('settings'),
    leading:Icon(Icons.settings,color:Colors.blue),
    ),
    )

    InkWell(
    onTap: (){},
    child:ListTile(
    title: Text('About'),
    leading:Icon(Icons.help, color: Colors.green,),
    ),
    )

    ]
    )
    )

    body:new Column(
    children:<Widget>[
    new padding(padding:const EdgeInsets.all(4.0),
    child:Container(
    alignment:Alignment.centerLeft,
    child:new Text('categories')),
    ),
    HorizontalList(),

    new padding(padding:const EdgeInsets.all(8.0),
    child:Container(
    alignment:Alignment.centerLeft,
    child:new Text('recent products')),
    ),
    Flexible(child:products()),

    ),
    ]
    )
    )
  }
}