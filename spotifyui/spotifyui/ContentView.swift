//
//  ContentView.swift
//  spotifyui
//
//  Created by Jorge on 11/4/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {

        ZStack {
            VStack(spacing: 5.0){
                Text("Hola")
                Text("Hola")
                    .foregroundColor(Color.red)
                    .padding(.leading)
            }
        }
    }
}
asdasd
struct HomeView: View {
    var body: some View {
        Text("Courses")
            .navigationTitle("Courses")
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
