//
//  ContentView.swift
//  FoodOderring_FinalProject
//
//  Created by Trung Thành  on 13/10/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            WelcomeView()
//            Login()
                .navigationBarBackButtonHidden()
                .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
