//
//  ContentView.swift
//  LocatorDemo
//
//  Created by Bohdan Hawrylyshyn on 16.01.23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: DemoViewModel = .init()
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Current city:")
            Text($viewModel.city.wrappedValue)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
