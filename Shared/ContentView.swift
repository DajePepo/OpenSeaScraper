//
//  ContentView.swift
//  Shared
//
//  Created by Pietro on 10/04/22.
//

import SwiftUI

struct BlueButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color.blue : Color.white)
            .background(configuration.isPressed ? Color.white : Color.blue)
            .cornerRadius(6.0)
            .padding()
    }
}

struct ContentView: View {
    
    @ObservedObject var viewModel: ContentViewModel
    
    init() {
        self.viewModel = ContentViewModel()
    }
    
    var body: some View {
        VStack {
            CustomButton(title: "Fetch Sales") {
                Task.detached(priority: .userInitiated) {
                    await self.viewModel.fetchSaleEvents()
                }
            }
//            .disabled(!$viewModel.sales.isEmpty)
            
            CustomButton(title: "Clear Sales") {
                viewModel.clearSalesEvents()
            }
//            .disabled($viewModel.sales.isEmpty)
            
            CustomButton(title: "Write on CSV") {
                viewModel.writeSalesOnCvs()
            }
//            .disabled(!$viewModel.sales.isEmpty)
        }
    }
}

struct CustomButton: View {
    
    @State private var disabled = false
    
    private let title: String
    private let action: ()->()
    
    init(title: String, action: @escaping ()->()) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
               .frame(maxWidth: 100, maxHeight: 24)
        }
        .buttonStyle(BlueButtonStyle())
        .disabled(disabled)
        .opacity(disabled ? 0.4 : 1.0)
    }
}
