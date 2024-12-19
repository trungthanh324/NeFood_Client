//
//  HomeViewModel.swift
//  FoodOderring_FinalProject
//
//  Created by Trung Thành  on 9/10/24.
//

import SwiftUI
import CoreLocation
import FirebaseFirestoreInternal
import FirebaseAuth
import FirebaseDatabase
import MapKit
//fetching user location
class HomeViewModel : NSObject,ObservableObject, CLLocationManagerDelegate{
    @Published var search = ""
    @Published var locationManager = CLLocationManager()
//location detail
    @Published var userLocation : CLLocation!
    @Published var userAddress = ""
    @Published var noLocation = false
//Menu
    @Published var showMenu = false
//Item data
    @Published var items : [Item] = []
    @Published var filtered : [Item] = [] // search
//Cart data
    @Published var cartItems : [Cart] = []
//
    @Published var ordered = false
//
    @Published var userLatitude = ""
    @Published var userLongitude = ""
//
    @Published var orderStatus: String = ""
    @Published var shipperLocation: ShipperAddress?
    
    
//uy quyen cho app lay vi tri
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            //checking location
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print("authorized")
            self.noLocation = false
            manager.requestLocation()
        case .denied:
            print("denied")
            self.noLocation = true
        default:
            print("unknown")
            self.noLocation = false
            //direct call
            locationManager.requestWhenInUseAuthorization()
//modify info.plist
        }
    }
 
//neu user tu choi
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }
//lay vi tri moi nhat
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//reading user location and extract detail
        self.userLocation = locations.last
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        userLatitude = String(latitude)
        userLongitude = String(longitude)
        self.extractLocation()
        self.fetchItemsDatafromFireStore()
    }
    
//convert tu toa do thanh address
// lay toa do cua user(CLDeoCoder) -> dich ra thanh ten duong cu the
    func extractLocation(){
        CLGeocoder().reverseGeocodeLocation(self.userLocation) { res, err in
            guard let safeData = res else{return}
            var address = ""
            //get area name
            address += safeData.first?.name ?? ""
            address += ", "
            address += safeData.first?.locality ?? ""
            self.userAddress = address
        }
    }
    
//fetching data
    func fetchItemsDatafromFireStore(){
        let db = Firestore.firestore()
        db.collection("Items").getDocuments { snap, err in
            guard let itemData = snap else{return}
            self.items = itemData.documents.compactMap({ doc -> Item? in
                let id = doc.documentID // tu generate
                let name = doc.get("item_name") as! String
                let cost = doc.get("item_cost") as! NSNumber
                let rating = doc.get("item_rating") as! NSNumber
                let image = doc.get("item_image") as! String
                let details = doc.get("item_details") as! String
                
                return Item(id: id, item_name: name, item_cost: cost, item_details: details, item_image: image, item_rating: rating)
            })
            
            self.filtered = self.items
        }
    }
    
//search data
    func filterData(){
        withAnimation(.linear){
            self.filtered = self.items.filter{
                return $0.item_name.lowercased().contains(self.search.lowercased())
            }
        }
    }
    
//
    func addToCart(item: Item) {
        let itemIndex = getIndex(item: item, isCartIndex: false)
        self.items[itemIndex].isAdded.toggle()
        if let filteredIndex = self.filtered.firstIndex(where: { $0.id == item.id }) {
            self.filtered[filteredIndex].isAdded = self.items[itemIndex].isAdded
        }
        
        if self.items[itemIndex].isAdded {
            self.cartItems.append(Cart(item: item, quantity: 1))
        } else {
            let cartIndex = getIndex(item: item, isCartIndex: true)
            self.cartItems.remove(at: cartIndex)
        }
    }
    
//de xac dinh vi tri cua item trong mang items  -> de thay doi trang thai isAdded cua item(func addtoCart())
    func getIndex(item: Item, isCartIndex: Bool) -> Int {
        if isCartIndex {
            return self.cartItems.firstIndex { cartItem in
                return item.id == cartItem.item.id
            } ?? 0
        } else {
            return self.items.firstIndex { listItem in
                return item.id == listItem.id
            } ?? 0
        }
    }
    
//func tinh tong tien
    func caculateTotalPrice() -> String{
        var price : Float = 0
        cartItems.forEach{item in
            price += Float(item.quantity) * Float(truncating: item.item.item_cost)
        }
        
        return getPrice(value : 35000 + price)
    }
    
//convert Int to String
    func getPrice(value : Float) -> String{
        let format = NumberFormatter()
        format.numberStyle = .currency
        return format.string(from: NSNumber(value: value)) ?? ""
    }
    
//post date order le firestore
    func updateOrder(){
        let db = Firestore.firestore()
        let databaseReference = Database.database().reference()
        var details : [[String : Any]] = []
        cartItems.forEach { cart in
            details.append([
                "item_name" : cart.item.item_name,
                "quantity" : cart.quantity,
                "item_cost" : cart.item.item_cost,
            ])
        }
        
        ordered = true
        db.collection("Users").document(Auth.auth().currentUser!.uid).setData([
            "odered_Food" : details,
            "total": caculateTotalPrice(),
            "client_location" : userAddress,
            "email": Auth.auth().currentUser!.email,
            "client_latitude" : userLatitude,
            "client_longitude": userLongitude,
            "status": "pending"
        ]) { err in
            if err != nil{
                self.ordered = false
                return
            }
            print("post thanh cong")
            self.observeOrder()
        }
    
//post to data from firestore -> realtime database
        databaseReference.child("Orders").setValue([
            "odered_Food" : details,
            "total": caculateTotalPrice(),
            "location" : userAddress,
            "email": Auth.auth().currentUser!.email
        ])
    }
    
//cancel order
    func CancelOrder(){
        let db = Firestore.firestore()
        let databaseReference = Database.database().reference()
                if ordered{
                    ordered = false
                    db.collection("Users").document(Auth.auth().currentUser!.uid).updateData([
                        "status" : "cancel"
                    ])
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                        db.collection("Users").document(Auth.auth().currentUser!.uid).delete{err in
                            if err != nil{
                                self.ordered = true
                            }
                        }
                    }
                    return
                }
    }
    
//fetch shipper data
    func observeOrder(){
        let db = Firestore.firestore()
        let orderID = Auth.auth().currentUser!.uid
        guard !orderID.isEmpty else {
                print("k co orderID")
                return
            }
        db.collection("Users").document(orderID).addSnapshotListener { documentSnapshot, err in
            if err != nil{
                print(err?.localizedDescription ?? "")
                return
            }
            guard let document = documentSnapshot, document.exists else {
                print("K thay don hang co id: \(orderID)")
                    return
            }
            if let status = document.get("status") as? String {
                self.orderStatus = status
            }
            if let shipperLatitude = document.get("shipper_latitude") as? String,
               let shipperLongitude = document.get("shipper_longitude") as? String,
               let shipperlocation = document.get("shipper_location") as? String {
               let shipperAddress = ShipperAddress(shipper_latitude: shipperLatitude, shipper_longitude: shipperLongitude, shipper_location: shipperlocation, status: self.orderStatus)
                
                   self.shipperLocation = shipperAddress
            }else{
                print("K tim thay shipperAddress")
            }

        }
    }

}
