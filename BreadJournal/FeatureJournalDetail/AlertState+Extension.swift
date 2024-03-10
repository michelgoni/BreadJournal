//
//  AlertState+Extension.swift
//  BreadJournal
//
//  Created by Michel Goñi on 4/2/24.
//

import ComposableArchitecture
import Foundation

extension AlertState where Action == JournalDetailViewFeature.Destination.Action.Alert {
    
    static let deleteJournalEntry = Self {
      TextState("¿Borrar entrada?")
    } actions: {
        ButtonState(role: .destructive, action: .confirmDelete) {
        TextState("Sí")
      }
      ButtonState(role: .cancel) {
        TextState("No")
      }
    } message: {
      TextState("¿Seguro que quieres borrar esta entrada de tu diario de panes")
    }
}
