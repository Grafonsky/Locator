//
//  DemoViewModel.swift
//  LocatorDemo
//
//  Created by Bohdan Hawrylyshyn on 16.01.23.
//

import Foundation
import Locator
import Combine

final class DemoViewModel: ObservableObject {
    
    private var currentCityStore: AnyCancellable?
    
    private let locator: Locator
    
    @Published var city: String = ""
    
    init() {
        locator = .init()
        
        city = Locator._currentCity.value
        let placeholderString = "🌐 Change location in XCode Simulator 🌐"
        
        currentCityStore = Locator._currentCity
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] city in
                self?.city = city == "-" ? placeholderString : city
            })
    }
}
