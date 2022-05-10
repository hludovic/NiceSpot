//
//  ContentView.swift
//  NiceSpot
//
//  Created by Ludovic HENRY on 15/03/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack{
            Text("Hello, world!!")
                .padding()
            AsyncImage(url: URL(string: "https://www.hackingwithswift.com/img/paul-2.png")) { image in
                image.resizable()
            } placeholder: {
                Color.red
            }
            .frame(width: 128, height: 128)
            .clipShape(RoundedRectangle(cornerRadius: 25))

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
