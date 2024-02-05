//
//  JournalDetailView.swift
//  BreadJournal
//
//  Created by Michel Goñi on 27/1/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer

struct JournalDetailViewFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        var journalEntry: Entry
        var ingredients: IdentifiedArrayOf<Ingredient> = []
        
    }
    enum Action: Sendable {
        case cancelEditTapped
        case delegate(Delegate)
        case deleteButtonTapped
        case destination(PresentationAction<Destination.Action>)
        case doneEditingButtonTapped
        case editButtonTapped
     
        
        @CasePathable
        enum Delegate {
            case entryUpdated(Entry)
            case deleteJournalEntry
        }
    }
    @Dependency(\.dismiss) var dismiss
    @Reducer
    struct Destination {
        @ObservableState
        enum State: Equatable {
            case alert(AlertState<Action.Alert>)
            case edit(BreadFormFeature.State)
        }
        enum Action: Equatable {
            case alert(Alert)
            case edit(BreadFormFeature.Action)
            
            enum Alert {
                case confirmDelete
            }
        }
        
      
        var body: some ReducerOf<Self> {
            Scope(state: \.edit, action: \.edit) {
                BreadFormFeature()
            }
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .cancelEditTapped:
                state.destination = nil
                return .none
                
            case .delegate:
                return .none
                
            case .deleteButtonTapped:
                state.destination = .alert(.deleteJournalEntry)
                return .none
         
                
            case let .destination(.presented(.alert(alertAction))):
                switch alertAction {
                case .confirmDelete:
                    return .run { send in
                        await send(.delegate(.deleteJournalEntry))
                        await self.dismiss()
                    }
                }
                
            case .doneEditingButtonTapped:
                switch state.destination {
                case .edit(let value):
                    state.journalEntry = value.journalEntry
                    state.destination = nil
                default: break
                }
                return .none
                
            case .editButtonTapped:
                state.destination = .edit(BreadFormFeature.State(journalEntry: state.journalEntry))
                return .none
                
            case .destination:
              return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
          Destination()
        }
        .onChange(of: \.journalEntry) { oldValue, newValue in
            Reduce { state, action in
                    .send(.delegate(.entryUpdated(newValue)))
            }
        }
    }
}

struct JournalDetailView: View {
    
    @Bindable var store: StoreOf<JournalDetailViewFeature>
    
    var body: some View {
        
        VStack {
            Form {
                Section(header: Text("Fecha")) {
                    Text(store.journalEntry.entryDate.convertToMonthYearFormat())
                }
                Section(header: Text("Ingredientes")) {
                    ForEach(store.ingredients) {
                        Text($0.ingredient)
                    }
                    
                }
                
                Section(header: Text("Foto")) {
                    Image(uiImage: store.journalEntry.breadPicture ?? UIImage())
                }
                
                Group {
                    Section(header: Text("Hora último refresco mada madre")) {
                        Text(store.journalEntry.lastSourdoughFeedTime.toHourMinuteString())
                    }
                    Section(header: Text("Hora comiezo prefermento")) {
                        Text(store.journalEntry.prefermentStartingTime.toHourMinuteString())
                    }
                    Section(header: Text("Hora comiezo autólisis")) {
                        Text(store.journalEntry.autolysisStartingTime.toHourMinuteString())
                    }
                    Section(header: Text("Hora comiezo fermentación en bloque")) {
                        Text(store.journalEntry.bulkFermentationStartingTime.toHourMinuteString())
                    }
                    
                    Section(header: Text("Pliegues")) {
                        Text(store.journalEntry.folds)
                    }
                    Section(header: Text("Hora formado del pan")) {
                        Text(store.journalEntry.breadFormingTime.toHourMinuteString())
                    }
                    Section(header: Text("Hora segunda fermentación")) {
                        Text(store.journalEntry.secondFermentarionStartingTime.toHourMinuteString())
                    }
                    Group {
                        Section(header: Text("¿Se ha usado frigorífico?")) {
                            Text(store.journalEntry.isFridgeUsed.elementUsedTitle)
                        }
                        
                        if store.journalEntry.isFridgeUsed {
                            Section(header: Text("Tiempo total en el frigo")) {
                                Text(store.journalEntry.fridgeTotalTime)
                            }
                        }
                        Section(header: Text("Tiempo de horneado")) {
                            Text(store.journalEntry.bakingTime)
                        }
                        Section(header: Text("¿Plancha de acero?")) {
                            Text(store.journalEntry.isSteelPlateUsed.elementUsedTitle)
                        }
                    }
                    Section(header: Text("Corteza")) {
                        StarRatingView(staticRating: store.journalEntry.crustRating)
                    }
                    Section(header: Text("Miga")) {
                        StarRatingView(staticRating: store.journalEntry.crumbRating)
                    }
                    Section(header: Text("Subida")) {
                        StarRatingView(staticRating: store.journalEntry.bloomRating)
                    }
                    Section(header: Text("Greñado")) {
                        StarRatingView(staticRating: store.journalEntry.scoreRating)
                    }
                    Section(header: Text("Sabor")) {
                        StarRatingView(staticRating: store.journalEntry.tasteRating)
                    }
                    Section(header: Text("Evaluation")) {
                        StarRatingView(staticRating: store.journalEntry.evaluation)
                    }
                }
                
                Section {
                    Button("Delete") {
                        store.send(.deleteButtonTapped)
                    }
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                }
                
            }
            .toolbar {
                Button("Edit") {
                    store.send(.editButtonTapped)
                }
            }
            .navigationTitle(store.journalEntry.name)
            .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
            .sheet(item: $store.scope(state: \.destination?.edit, action: \.destination.edit)) { store in
                NavigationStack {
                    BreadFormView(store: store)
                        .navigationTitle(store.journalEntry.name)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    self.store.send(.cancelEditTapped)
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Done") {
                                    self.store.send(.doneEditingButtonTapped)
                                }
                            }
                        }
                }
            }
        }
        
    }
}

#Preview {
    NavigationStack {
        JournalDetailView(
            store:
                Store(
                    initialState: JournalDetailViewFeature.State(
                        journalEntry: .mock
                    ),
                    reducer: {
                        JournalDetailViewFeature()
                    }
                )
        )
    }
    
}
