//  Copyright (c) 2019 Aleksander Woźniak
//  Licensed under Apache License v2.0

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:vicosmebio/model/databaseClient.dart';
import 'package:vicosmebio/model/item.dart';





final colorbg = const Color(0xFFDEF1F3);
final colorviolet= const Color(0xFF3c3dfe);
final colorvioletfond= const Color(0xFFeef6fe);
final colorvioletbg= const Color(0xFFeef6fe);



// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2019, 1, 1): ['New Year\'s Day'],
  DateTime(2019, 1, 6): ['Epiphany'],
  DateTime(2019, 2, 14): ['Valentine\'s Day'],
  DateTime(2019, 4, 21): ['Easter Sunday'],
  DateTime(2019, 4, 22): ['Easter Monday'],
};

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
  statusBarColor: Colors.transparent, //or set color with: Color(0xFF0000FF)
));

   
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vicosmebio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        
      ),
      home: MyHomePage(title: 'Vicosmebio'),
      

    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  Map<DateTime, List> mapevenementsnamedate={DateTime.now().subtract(Duration(days: 2)):["test123"]};

  Map<DateTime, List> evenements;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  String nouvelleListe;
  List<Item> items=[];
  int a;
  List items_names=[];
  

  @override
  void initState() {
    super.initState();
    recuperer();
    final _selectedDay = DateTime.now();
    final evenementbg= "Shampoing";
    
    
    // _events = {
    //   _selectedDay.subtract(Duration(days: 30)): [evenementbg, 'Event B0', 'Event C0'],
    //   _selectedDay.subtract(Duration(days: 27)): ['Event A1'],
    //   _selectedDay.subtract(Duration(days: 20)): ['Event A2', 'Event B2', 'Event C2', 'Event D2'],
    //   _selectedDay.subtract(Duration(days: 16)): ['Event A3', 'Event B3'],
    //   _selectedDay.subtract(Duration(days: 10)): ['Event A4', 'Event B4', 'Event C4'],
    //   _selectedDay.subtract(Duration(days: 4)): ['Event A5', 'Event B5', 'Event C5'],
    //   _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
    //   _selectedDay: ['Event A6', 'Event B6'],
    //   _selectedDay.add(Duration(days: 1)): ['Event A8', 'Event B8', 'Event C8', 'Event D8'],
    //   _selectedDay.add(Duration(days: 3)): Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
    //   _selectedDay.add(Duration(days: 7)): ['Event A10', 'Event B10', 'Event C10'],
    //   _selectedDay.add(Duration(days: 11)): ['Event A11', 'Event B11'],
    //   _selectedDay.add(Duration(days: 17)): ['Event A12', 'Event B12', 'Event C12', 'Event D12'],
    //   _selectedDay.add(Duration(days: 22)): ['Event A13', 'Event B13'],
    //   _selectedDay.add(Duration(days: 26)): ['Event A14', 'Event B14', 'Event C14'],
    // };

    
    


    _selectedEvents = mapevenementsnamedate[_selectedDay] ?? [];

    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
      print(mapevenementsnamedate);
    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(      
      backgroundColor: Colors.grey.shade100,
      
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
        
          Card(
            margin: EdgeInsets.all(2),            
            elevation: 2.7,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(bottomLeft:Radius.circular(35.0),bottomRight:Radius.circular(35.0), ) ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 37.0),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,

                
                  children: <Widget>[
                      IconButton(
                          padding: EdgeInsets.only(left: 5),

                            onPressed: ajouter,
                            icon: Icon(Icons.dehaze, color: Colors.black,size: 25,)),
                    
                        IconButton(
                          padding: EdgeInsets.only(right: 5),

                            onPressed: ajouter,
                            icon: Icon(Icons.add, color: colorviolet,size: 25,)),
                        

                        // Padding(
                        //   padding: const EdgeInsets.only(left:5.0),
                        //   child: Text('Vic',style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20  ) ,),
                        // )
                        ],
                        ),                        
                
                _buildTableCalendarWithBuilders()
              ],
            )),
           //_buildTableCalendarWithBuilders()),
          
          // _buildButtons(),
          SizedBox(height: 20,),
          Text("    Les soins du jour :", style: TextStyle(color: Colors.black26,fontWeight: FontWeight.w600, fontSize: 16),),
          SizedBox(height: 1),  
         Expanded(child: _buildEventList()),
          
        ],
      ),
    );
  }

  String newProduct;
  Future<Null> ajouter() async{
    await showDialog(
      context: context,
      builder:(BuildContext buildContext){
        return new AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text("Ajouter un soin"),
          content: TextField(decoration: InputDecoration(
            labelText: "Nom:", hintText: "ex: Shampoing, Masque, Bain d'Huile"),
            onChanged: (String str){
              nouvelleListe= str;
            },),
            
         actions: <Widget>[
           ButtonBar(

             alignment: MainAxisAlignment.start,
             children:<Widget>[
             //FlatButton(onPressed: (()=>Navigator.pop(context)),child: Icon(Icons.arrow_back,size: 22,),),
             FlatButton(onPressed: (){
             if(nouvelleListe!=null){
             Map<String,dynamic> map={'nom':nouvelleListe};
             Item item= new Item();
             item.fromMap(map);
             DatabaseClient().ajoutItem(item).then((i)=>recuperer());}
             Navigator.pop(context);
             nouvelleListe=null;
             },child: Icon(Icons.done,))]


           
           )



         ], 
         
        );
      }
      );

  }

  // Simple TableCalendar configuration (using Styles)
 

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
          
          locale: 'fr_FR',
          calendarController: _calendarController,
          events: mapevenementsnamedate,
          holidays: _holidays,
          startingDayOfWeek: StartingDayOfWeek.monday,
          
          calendarStyle: CalendarStyle(
            weekdayStyle: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold ),
            weekendStyle: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            outsideStyle: TextStyle(color: Colors.grey.shade400,fontWeight: FontWeight.bold),
            unavailableStyle: TextStyle(color: Colors.grey.shade400,fontWeight: FontWeight.bold),
            outsideWeekendStyle: TextStyle(color: Colors.grey.shade400,fontWeight: FontWeight.bold),
            selectedColor:colorviolet,
            todayColor: colorviolet.withGreen(100),
            markersColor: colorbg,
            outsideDaysVisible: false,

          ),

          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(color: Colors.black38,fontWeight: FontWeight.bold),
            weekendStyle: TextStyle(color: Colors.black38,fontWeight: FontWeight.bold),
          ),
          headerStyle: HeaderStyle(
            titleTextBuilder:(date, locale) => DateFormat.yMMMd(locale).format(date),
            titleTextStyle: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 22 ),
            formatButtonVisible: false,
            formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
            formatButtonDecoration: BoxDecoration(
              color: Colors.pinkAccent[200],
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          initialCalendarFormat: CalendarFormat.week ,
          availableCalendarFormats: {CalendarFormat.month : 'Month', CalendarFormat.week : 'Week'},
          rowHeight: 57.0,
          formatAnimation: FormatAnimation.slide,
    
      builders: CalendarBuilders(
        

        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.amber[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, evenements) {
        _onDaySelected(date, evenements);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date) ? Colors.brown[300] : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container( 

                // decoration: BoxDecoration(
                //   color: colorbg, 
                //   shape: BoxShape.rectangle,                 
                //   borderRadius: BorderRadius.circular(20.0),
                // ),
                margin: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 8),
                child: Material(
                  color: Color.fromRGBO(	238, 246, 254,1),
                  elevation: 2.0,                   
                  borderRadius: BorderRadius.circular(10), 
                  
                  
                  child: Center(
                    child: GroovinExpansionTile(
                      
                                  
                        // contentPadding: EdgeInsets.all(15 ) ,
                        title:Text(event,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black87 ),),
                        trailing: Icon(Icons.keyboard_arrow_down,color: colorviolet,),    
                        subtitle: Text("Shampoing"),
                        children: <Widget>[
                          Text("  Nunc lege, nunc ora, cum fervore labora sic erit hora brevis, sic labor ipse brevis."), 
                         Row(mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              
                              IconButton(icon: Icon(Icons.edit,),padding: EdgeInsets.all(0),
                              onPressed: (){},color: Colors.black45, ),
                              IconButton(icon: Icon(Icons.delete,),padding: EdgeInsets.all(0),
                              onPressed: (){},color:Colors.black45)
                              
                              
                              
                            ],
                          ),
                        ],
                        leading: Container(                        
                              decoration: BoxDecoration( 
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(100), 
                                border: Border.all(width: 6,color: Colors.transparent,)              
                                
                                 ),
                              child: Image.asset('assets/soap (4).png'),height: 40, width: 40,),
                         
                        
                        
                        // onTap: () => print('$event tapped!'),
                      ),
                  ),
                ),
                
              )
              )
          .toList(),
          
    );
    
  }

  void recuperer(){
    DatabaseClient().allItem().then((items){
      setState(() {
        this.items=items;
        
          
        items.forEach((item) => items_names.add(item.nom));

      });
      print("La List des items est recupérée");
      items.forEach((item) => print(item.nom));
      items.forEach((item){ 

        this.mapevenementsnamedate=itemtoMapDateName(item);});
     print(mapevenementsnamedate);
      

    });
  }

   

  Map<DateTime,List> itemtoMapDateName(Item item){
    Map<DateTime, List> mapdatesnames= {
    item.date_event:[item.nom]};

  return mapdatesnames;  
}


}