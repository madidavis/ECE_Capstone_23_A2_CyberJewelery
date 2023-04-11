//
//  LED_CellEdit.swift
//  Capstone_Final
//
//  Created by Madi Davis on 8/4/2023.
//

import SwiftUI

struct LED_CellEdit: View {
    //MARK: - PROPERTIES
    /* View Model */
    @ObservedObject var viewModel : LED_CellEditViewModel
    
    
    /* Editor Layout Properties */
    
    //MARK: - PROPERTIES
    @ScaledMetric var maxWidth = 30
    @ScaledMetric var maxHeight = 32
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(viewModel.isSelected ? Color(.systemGray5) : .blue)
            .frame(width:maxWidth ,height: maxHeight)
           // .onTapGesture {
                //viewModel.isSelected.toggle()
            //}
    }
}

struct LED_CellEdit_Previews: PreviewProvider {
    static var previews: some View {
        LED_CellEdit(viewModel: LED_CellEditViewModel(dataManager: DataManager.shared, idx: 0))
    }
    
}
