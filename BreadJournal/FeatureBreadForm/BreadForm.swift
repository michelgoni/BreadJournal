//
//  BreadForm.swift
//  BreadJournal
//
//  Created by Michel Goñi on 21/1/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct BreadFormFeature {
    @ObservableState
    struct State: Equatable, Sendable {
        var journalEntry: Entry
        
        init(journalEntry: Entry) {
            self.journalEntry = journalEntry
        }
    }

    enum Action: BindableAction, Equatable, Sendable {
        case addIngredientTapped(String)
        case binding(BindingAction<State>)
        case deleteIngredient(atOffset: IndexSet)
    }
    @Dependency(\.uuid) var uuid
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .addIngredientTapped(let ingredient):
                let ingredient = Ingredient(id: Ingredient.ID(self.uuid()),
                                            ingredient: ingredient)
                state.journalEntry.ingredients.append(ingredient)
                return .none
            case .binding:
                return .none
            case .deleteIngredient(let offSet):
                state.journalEntry.ingredients.remove(atOffsets: offSet)
                return .none
            }
            
        }
    }
}

struct BreadFormView: View {
    @Bindable var store: StoreOf<BreadFormFeature>
    
    var body: some View {
        VStack {
            Form {
                Section("Nombre de la receta") {
                    TextField("",
                              text: $store.journalEntry.name)
                }
                Section {
                    DatePicker("Fecha",
                               selection: $store.journalEntry.entryDate,
                               displayedComponents: .date)
                }
                Section(header: Text("Foto")) {
                    ImagePickerView(selectedImage: $store.journalEntry.breadPicture)
                        .frame(maxWidth: .infinity, alignment: .center)
                }

                Section(header: Text("Ingredientes")) {
                    ForEach($store.journalEntry.ingredients) {
                        TextField("Ingredient", text: $0.ingredient)
                    }
                    .onDelete {
                        store.send(.deleteIngredient(atOffset: $0))
                    }
                    
                    Button("Añade ingrediente") {
                        store.send(.addIngredientTapped(""))
                    }
                }
                Group {
                    Section("Tiempo refresco masa madre") {
                        TextField(
                            "",
                            text: $store.journalEntry.sourdoughFeedTime)
                    }
                    Section(header: Text("Temperatura refresco")) {
                        TextField(
                            "",
                            text: $store.journalEntry.sourdoughFeedTemperature)
                    }

                    Section(header: Text("Tiempo autólisis")) {
                        TextField(
                            "",
                            text: $store.journalEntry.autolysisTime)
                    }

                    Section(header: Text("Tiempo fermentación en bloque")) {
                        TextField(
                            "",
                            text: $store.journalEntry.bulkFermentationStartingTime)
                    }

                    Section(header: Text("Pliegues")) {
                        TextField(
                            "",
                            text: $store.journalEntry.folds
                        )
                    }
                    Section(header: Text("Tiempo segunda fermentación")) {
                        TextField(
                            "",
                            text: $store.journalEntry.secondFermentarionTime
                        )
                    }
                }
                Group {
                    Toggle(isOn: $store.journalEntry.isFridgeUsed) {
                        Text("¿Se ha usado frigorífico?")
                    }
                    if store.journalEntry.isFridgeUsed{
                        Section {
                            TextField(
                                "",
                                text: $store.journalEntry.fridgeTotalTime)
                        }
                    }
                    Section(header: Text("Cómo ha sido el horneado")) {
                        TextField(
                            "",
                            text: $store.journalEntry.bakingProcedureAndTime)
                    }
                    Toggle(
                        isOn: $store.journalEntry.isSteelPlateUsed
                    ) {
                        Text(
                            "¿Plancha de acero?"
                        )
                    }
                    Section(header: Text("Corteza")) {
                        StarRatingView(rating: $store.journalEntry.crustRating)
                    }
                    Section(header: Text("Miga")) {
                        StarRatingView(rating: $store.journalEntry.crumbRating)
                    }
                    Section(header: Text("Subida")) {
                        StarRatingView(rating: $store.journalEntry.bloomRating)
                    }
                    Section(header: Text("Greñado")) {
                        StarRatingView(rating: $store.journalEntry.scoreRating)
                    }
                    Section(header: Text("Sabor")) {
                        StarRatingView(rating: $store.journalEntry.tasteRating)
                    }
                    Section(header: Text("Evaluation")) {
                        StarRatingView(rating: $store.journalEntry.rating)
                    }
                }
            }
        }
    }
}

#Preview(body: {
    BreadFormView(
        store: Store(
            initialState: BreadFormFeature.State(
                journalEntry: .mock), reducer: {
                    BreadFormFeature()
                }))
})
