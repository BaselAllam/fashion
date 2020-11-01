import 'package:fashion/models/mainmodel.dart';
import 'package:fashion/responsive/responsiveHomePage.dart';
import 'package:fashion/screens/bottomnavbar/searchresult.dart';
import 'package:fashion/widgets/item.dart';
import 'package:fashion/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scoped_model/scoped_model.dart';


class HomePage extends StatefulWidget {

final MainModel item;

HomePage(this.item);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

List<String> categoryName = ['Men', 'Women', 'Devices', 'Shoes', 'Accessories', 'Bags'];

List<IconData> categoryIcon = [Icons.shop, Icons.shopping_basket, Icons.shopping_cart, Icons.short_text, Icons.show_chart, Icons.shuffle];

List<String> itemName = ['Chair', 'Lamp', 'Home', 'Office'];

List<String> itemImage = ['assets/chair.jpg', 'assets/lamp.jpg', 'assets/home.jpg', 'assets/office.jpg'];


@override
void initState(){
  widget.item.getItems();
  super.initState();
}

  @override
  Widget build(BuildContext context) {
    var data = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: ListView(
          padding: EdgeInsets.only(top: 60.0),
          scrollDirection: Axis.vertical,
          children: [
            ListTile(
              title: Container(
                padding: EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 20.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(15.0),
                ),
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.search,
                  color: Color(0xff0073a6),
                  size: 20.0,
                ),
              ),
              trailing: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xff0073a6),
                  shape: BoxShape.circle
                ),
                child: IconButton(
                    icon: Icon(Icons.location_history),
                    color: Colors.white,
                    iconSize: 20.0,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(fullscreenDialog: true, builder: (_) {return Map();}));
                    }
                  ),
              ),
            ),
            ListTile(
              title: Text(
                'Categories',
                style: TextStyle(color: Color(0xff0073a6), fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                'see all',
                style: TextStyle(color: Color(0xff0073a6), fontSize: 15.0, fontWeight: FontWeight.normal),
              ),
            ),
            Container(
              height: 75.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryIcon.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 120.0,
                    child: ListTile(
                      title: Icon(categoryIcon[index], color: Color(0xff0073a6), size: 20.0),
                      subtitle: Text(categoryName[index], textAlign: TextAlign.center, style: TextStyle(color: Color(0xff0073a6), fontSize: 20.0 )),
                      onTap: () {},
                    ),
                  );
                },
              )
            ),
            ListTile(
              title: Text(
                'Best Selling',
                style: TextStyle(color: Color(0xff0073a6), fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                'see all',
                style: TextStyle(color: Color(0xff0073a6), fontSize: 15.0, fontWeight: FontWeight.normal),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {return SearchResult('Best Selling');}));
              },
            ),
            Container(
              height: responsiveScrollContainer(data),
              child: homePageItem(true),
            ),
            ListTile(
              title: Text(
                'New Arrival',
                style: TextStyle(color: Color(0xff0073a6), fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                'see all',
                style: TextStyle(color: Color(0xff0073a6), fontSize: 15.0, fontWeight: FontWeight.normal),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {return SearchResult('New Arrival');}));
              },
            ),
            Container(
              height: responsiveScrollContainer(data),
              child: homePageItem(false),
            ),
          ],
        ),
      ),
    );
  }
  homePageItem(bool isBestSelling) {
    // if(isBestSelling == true){
      
    // }
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, MainModel item){
        if(item.isProductLoading == true){
          return Center(child: Loading());
        }else if(item.allItems.length < 1){
          return Center(child: Text('no item found'));
        }else{
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: item.allItems.length,
            itemBuilder: (context, index){
              return Item(
                itemImage[index],
                item.allItems[index].itemName,
                item.allItems[index].itemDescription,
                item.allItems[index].itemPrice,
                '!order',
                item.allItems[index].id
              );
            }
          );
        }
      }
    );
  }
}







class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {


final TextEditingController searchController = TextEditingController();

Position position;

bool isMapLoading = false;

List<Marker> markers = [];

@override
void initState() {
  getLocation();
  super.initState();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: field('ex: cairo', Icons.location_on, searchController),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black, size: 20.0),
        elevation: 0.0,
      ),
      body: isMapLoading == true ? 
      Center(child: CircularProgressIndicator(backgroundColor: Colors.black,)) :
       map()
    );
  }
  Future getLocation() async {

    setState(() {
      isMapLoading = true;
    });


    bool _enabled = await Geolocator().isLocationServiceEnabled();

    if(_enabled == false){
      setState(() {
          isMapLoading = false;
        });
      return Text('location service is disabled\n kindly enable it');
    }else if(searchController.text.isNotEmpty){
      List<Placemark> _search = await Geolocator().placemarkFromAddress(searchController.text);
      final Marker _newMarkers = Marker(
        markerId: MarkerId(_search[0].name),
        position: LatLng(_search[0].position.latitude, _search[0].position.longitude),
        icon: BitmapDescriptor.defaultMarker
      );
      setState(() {
        markers.add(_newMarkers);
        isMapLoading = false;
      });
    }else{
      var _current = await Geolocator().getCurrentPosition();
        setState(() {
          position = _current;
          isMapLoading = false;
        });
      }
  }
  map() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        zoom: 12,
        target: LatLng(position.latitude, position.longitude),
      ),
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      markers: Set.from(markers)
    );
  }
  field(String label, IconData icon, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Colors.black, width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Colors.black, width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Colors.black, width: 0.5),
          ),
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey, fontSize: 15.0),
          prefixIcon: Icon(icon, color: Colors.grey, size: 20.0),
        ),
        textInputAction: TextInputAction.search,
        controller: controller,
        onSubmitted: (value) {
          getLocation();
        },
      ),
    );
  }
}