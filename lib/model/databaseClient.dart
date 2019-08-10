import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'item.dart';
class DatabaseClient{

  Database _database;

  Future <Database> get database async{
    if (_database !=null){
      return _database;
    } else {
      //Créer cette database
      _database= await create();
      print("DataBaseCreateddebut");
      return _database;
    }
  }

  Future create() async{    
  Directory directory= await getApplicationDocumentsDirectory();
  String databasedirectory= join(directory.path, 'database.db');
  var bdd= await openDatabase(
    databasedirectory,
    version:1,
    onCreate: _onCreate ); 
    print('Databasecreatedfin');
  return bdd;

  }

Future _onCreate(Database db, int version) async {
  await db.execute(
  'CREATE TABLE item('
  ' id INTEGER PRIMARY KEY,'
  ' nom TEXT NOT NULL'
  ')'
  );}

  //ECRITURE DES DONNEES 

  Future<Item> ajoutItem(Item item) async {
    Database maDatabase=await database;
    item.id = await maDatabase.insert('item', item.toMap());
    print("Ajout d'un item dans la database");
    return item;

  }

//LECTURE DES DONNEES
Future<List<Item>> allItem() async {
  Database maDatabase=await database;
  List<Map<String, dynamic>> resultat= await maDatabase.rawQuery('SELECT * FROM item');
  List<Item> items=[];
  resultat.forEach((map){
    Item item= new Item();
    item.fromMap(map);
    items.add(item);

  });
  print("Lecture des données");
  return items;
}

Map<DateTime,String> itemtoMapDateName(Item item){

  
    Map<DateTime, String> map= {
    item.date_event:item.nom};

  return map;  
}


}