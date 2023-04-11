//
//  AddDesignView.swift
//  Capstone_Final
//
//  Created by Madi Davis on 8/4/2023.
//

import SwiftUI

struct AddDesignView: View {
    //MARK: PROPERTIES
    /* View Model */
    @ObservedObject var viewModel = addDesignViewModel()
    
    /* Display Properties */
    @Environment(\.presentationMode) var presentationMode
    
    /* Layout & Sizing Properties */
    @ScaledMetric var overlayPadding = 20.0
    var height: CGFloat
    var width: CGFloat
    
    var body: some View {
        ZStack(){
                //MARK: BACKGROUND
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(.systemGray6))
                
                //MARK: CONTENT
                VStack(alignment: .center){
                    /* Header */
                    HStack {
                        Spacer()
                        Text("Create New Design?")
                            .font(.headline)
                        Spacer()
                        Button("Close") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    
                    /* Image */
                    Spacer()
                    
                    /* Text Field */
                    TextField("Design Name", text: $viewModel.newDesignTitle)
                        .background(Color(.systemGray5))
                        .cornerRadius(10)
                        .frame(height: 46.0)
                    
                    
                    /* Submit Button */
                    Button("OpenEditor") {
                        // Add New Design Model
                        viewModel.addNewDesign()
                        // Dismiss
                        presentationMode.wrappedValue.dismiss()
                    }
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .buttonStyle(.borderedProminent)

                    
                }
                .padding(overlayPadding)
            }//: ZSTACK
        .frame(width:width, height: height)
        
    }
}

struct AddDesignView_Previews: PreviewProvider {
    static var previews: some View {
        AddDesignView(viewModel: addDesignViewModel(dataManager: DataManager.shared), height: 360, width: 350)
    }
}
