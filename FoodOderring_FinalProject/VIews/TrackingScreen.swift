//
//  TrackingScreen.swift
//  FoodOderring_FinalProject
//
//  Created by Trung Thành  on 7/11/24.
//

import SwiftUI
import MapKit
import FirebaseAuth
struct TrackingScreen: View {
    @ObservedObject var HomeModel: HomeViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var userAddress : CLLocationCoordinate2D?
    @State private var shipperAddress : CLLocationCoordinate2D?
    @State private var routePolyline: MKPolyline?
    @State private var distanceInKilometers: Double?
    @State private var estimatedTravelTime: TimeInterval?
    @State var isShowHome = false
    var body: some View {
        VStack(spacing: 20) {
//header
            if let shipperLocation = HomeModel.shipperLocation, HomeModel.orderStatus == "taken" {
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.green)
                        Text("From: \(shipperLocation.shipper_location)")
                    }
                    HStack {
                        Image(systemName: "house.fill")
                            .foregroundColor(.red)
                        Text("To: \(HomeModel.userAddress)")
                    }
                    HStack(spacing: 5){
                        if let distance = distanceInKilometers {
                            Text(String(format: "Distance: %.2f km", distance))
                                .font(.headline)
                                .foregroundColor(.blue)
                                .padding(.top, 2)
                        }
                        if let travelTime = estimatedTravelTime {
                            Text(", \(formatTravelTime(travelTime))")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .padding(.top, 2)
                        }
                    }
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
                .onAppear{
                    setupLocationsAndRoute()
                }
            }else if let shipperLocation = HomeModel.shipperLocation, HomeModel.orderStatus == "done" {
                Text("Order is delivered!")
                    .font(.title)
                    .foregroundColor(.blue)
                    .padding(.top, 2)
                    .padding()
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                            HomeModel.ordered = false
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
            }else {
                Text("Status:" + HomeModel.orderStatus)
                    .font(.headline)
                    .foregroundColor(.gray)
                Text("Waiting for deliverier...")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
            }
//map
//            Map(position: $cameraPosition){
//                if let location = userAddress {
//                    Annotation("My location", coordinate: location){
//                        ZStack{
//                            Circle()
//                                .frame(width: 32, height: 32)
//                                .foregroundStyle(.blue.opacity(0.25))
//                            Circle()
//                                .frame(width: 20, height: 20)
//                                .foregroundStyle(.white)
//                            Circle()
//                                .frame(width: 12, height: 12)
//                                .foregroundStyle(.blue)
//                        }
//                    }
//                }
//                if shipperAddress != nil{
//                    let shipper = shipperAddress
//                    Annotation("Shipper", coordinate: shipper!){
//                        ZStack{
//                            Circle()
//                                .frame(width: 32, height: 32)
//                                .foregroundStyle(.blue.opacity(0.25))
//                            Circle()
//                                .frame(width: 20, height: 20)
//                                .foregroundStyle(.white)
//                            Circle()
//                                .frame(width: 12, height: 12)
//                                .foregroundStyle(.blue)
//                        }
//                    }
//                }
//                
//            }
//            .onAppear{
//                let userLocation = CLLocationCoordinate2D(latitude: Double(HomeModel.userLatitude)!,
//                                                          longitude: Double(HomeModel.userLongitude)!)
//                self.userAddress = userLocation
//                let userSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
//                let userRegion = MKCoordinateRegion(center: userLocation, span: userSpan)
//                cameraPosition = .region(userRegion)
//                
//                if HomeModel.orderStatus == "taken"{
//                   let shipperLocationData = HomeModel.shipperLocation
//                   let shipperLatitude = Double(shipperLocationData!.shipper_latitude)
//                   let shipperLongitude = Double(shipperLocationData!.shipper_longitude)
//                   let shipperLocation = CLLocationCoordinate2D(latitude: shipperLatitude!, longitude: shipperLongitude!)
//                   self.shipperAddress = shipperLocation
//                }
//                
//                if userAddress != nil , shipperAddress != nil{
//                    calculateRoute(startPoint: shipperAddress!, endPoint: userAddress!){ polyline in
//                        if let polyline = polyline {
//                                print("Đã tính toán xong đường đi.")
//                        } else {
//                                print("Không thể tính toán đường đi.")
//                        }
//                    }
//                }
//            }
//            .mapControls{
//                MapCompass()
//                MapUserLocationButton()
//            }
            MapViewWithPolyline(userLocation: $userAddress,shipperLocation: $shipperAddress,polyline: $routePolyline)
                       .onAppear {
                           setupLocationsAndRoute()
                       }
                      
            
//bottom button
            HStack(spacing: 15) {
                            Button(action: {
                                HomeModel.CancelOrder()
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Cancel")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.red)
                                    .cornerRadius(8)
                            }
                            
                            Button(action: {
                            }) {
                                Text("Notice")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
            }
            .padding(.horizontal)
        }
        .onAppear{
            HomeModel.observeOrder()
        }
    }
}


extension TrackingScreen{
    func calculateRoute(startPoint: CLLocationCoordinate2D,endPoint: CLLocationCoordinate2D,completion: @escaping (MKPolyline?, TimeInterval?) -> Void) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: startPoint))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: endPoint))
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            if let error = error {
                print("k tinh dc duong di: \(error)")
                completion(nil,nil)
                return
            }
            if let route = response?.routes.first {
                completion(route.polyline,route.expectedTravelTime)
            } else {
                completion(nil,nil)
            }
        }
    }
    
  //lay long, lad cua shipper, user
    func setupLocationsAndRoute() {
        let userLocation = CLLocationCoordinate2D(latitude: Double(HomeModel.userLatitude)!,
                                                  longitude: Double(HomeModel.userLongitude)!)
        self.userAddress = userLocation
        if HomeModel.orderStatus == "taken" {
            if let shipperLocationData = HomeModel.shipperLocation {
                let shipperLatitude = Double(shipperLocationData.shipper_latitude)
                let shipperLongitude = Double(shipperLocationData.shipper_longitude)
                let shipperLocation = CLLocationCoordinate2D(latitude: shipperLatitude!, longitude: shipperLongitude!)
                self.shipperAddress = shipperLocation
                
                let shipperCLLocation = CLLocation(latitude: shipperLocation.latitude, longitude: shipperLocation.longitude)
                let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
                let distanceInMeters = shipperCLLocation.distance(from: userCLLocation)
                self.distanceInKilometers = distanceInMeters / 1000
                
                calculateRoute(startPoint: shipperLocation, endPoint: userLocation) { polyline, travelTime in
                    if let polyline = polyline {
                        self.routePolyline = polyline
                    } else {
                        print("k ve dc duong di")
                    }
                    
                    if let travelTime = travelTime {
                        self.estimatedTravelTime = travelTime
                        print("tinh thoi gian thanh cong")
                    }else{
                        print("k tinh dc thoi gian uoc tinh")
                    }
                }
            }
        }
    }
    
  // hien thi ra phut, giay
    func formatTravelTime(_ time: TimeInterval) -> String {
            let minutes = Int(time) / 60
            let seconds = Int(time) % 60
            return "\(minutes) min \(seconds) sec"
    }
}

struct MapViewWithPolyline: UIViewRepresentable {
    @Binding var userLocation: CLLocationCoordinate2D?
    @Binding var shipperLocation: CLLocationCoordinate2D?
    @Binding var polyline: MKPolyline?
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewWithPolyline
        
        init(parent: MapViewWithPolyline) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 4.0
                return renderer
            }
            
            return MKOverlayRenderer(overlay: overlay)
        }
        
//        @objc func refreshMapView(_ mapView: MKMapView) {
//            mapView.removeOverlays(mapView.overlays)
//            mapView.removeAnnotations(mapView.annotations)
//            if let userLocation = parent.userLocation,
//               let shipperLocation = parent.shipperLocation {
//                if userLocation != nil, shipperLocation != nil{
//                    let request = MKDirections.Request()
//                    request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
//                    request.destination = MKMapItem(placemark: MKPlacemark(coordinate: shipperLocation))
//                    request.transportType = .automobile
//                    
//                    let directions = MKDirections(request: request)
//                    directions.calculate { (response, error) in
//                               if let route = response?.routes.first {
//                                   let polyline = route.polyline
//                                   mapView.addOverlay(polyline)
//                                   let mapRect = polyline.boundingMapRect
//                                   mapView.setVisibleMapRect(
//                                       mapRect,
//                                       edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50),
//                                       animated: true
//                                   )
//                                   print("cap nhat duong di")
//                                   return
//                               } else {
//                                   print("k co duong di")
//                                   return
//                               }
//                    }
//                }
//                return
//            } else {
//                print("chua co vi tri shipper")
//            }
//        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
//chuc nang hien tren map
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsTraffic = true
        let locationButton = UIButton(type: .system)
        locationButton.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        locationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        locationButton.addTarget(mapView, action: #selector(mapView.locateUser), for: .touchUpInside)
        mapView.addSubview(locationButton)
        
//        let refreshBtn = UIButton(type: .system)
//        refreshBtn.frame = CGRect(x: 10, y: 80, width: 50, height: 50)
//        refreshBtn.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
//        refreshBtn.addTarget(context.coordinator, action: #selector(Coordinator.refreshMapView), for: .touchUpInside)
//        mapView.addSubview(refreshBtn)

        return mapView
    }
    
  
// ve circle khach hang va icon shipper
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        uiView.removeOverlays(uiView.overlays)

        if let userLocation = userLocation {
            let userCircle = MKCircle(center: userLocation, radius: 100)
            uiView.addOverlay(userCircle)
            let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
            uiView.setRegion(region, animated: true)
        }

        if let shipperLocation = shipperLocation {
                let shipperAnnotation = MKPointAnnotation()
                shipperAnnotation.coordinate = shipperLocation
                shipperAnnotation.title = "Shipper"
                uiView.addAnnotation(shipperAnnotation)
        }

        if let polyline = polyline {
            uiView.addOverlay(polyline)
            let mapRect = polyline.boundingMapRect
            uiView.setVisibleMapRect(mapRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
        }
    }

}

extension MKMapView {
    @objc func locateUser() {
        if let userLocation = self.userLocation.location {
                 let center = userLocation.coordinate
                 let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)  
                 let region = MKCoordinateRegion(center: center, span: span)
                 self.setRegion(region, animated: true)
        }
    }
}
