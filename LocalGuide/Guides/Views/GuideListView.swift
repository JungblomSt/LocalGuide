//
//  GuideListView.swift
//  LocalGuide
//
//  Created by neda khalajnejad on 2026-05-19.
//


import SwiftUI
import CoreLocation

struct GuideListView: View {

    private let userLocation = CLLocation(latitude: 59.3293, longitude: 18.0686)

    @State private var guides: [Guide] = []                // ← filled from Firestore
    @State private var searchText: String = ""             // ← filter: free text
    @State private var selectedCategory: Category? = nil   // ← filter: category (nil = all)
    @State private var maxDistanceKm: Double? = nil        // ← filter: max distance (nil = unlimited)

    private var filteredGuides: [Guide] {
        var result = guides

        // 1) free-text search
        if !searchText.isEmpty {
            let q = searchText.lowercased()
            result = result.filter {
                $0.title.lowercased().contains(q) ||
                $0.city.lowercased().contains(q) ||
                $0.description.lowercased().contains(q)
            }
        }

        // 2) category
        if let selectedCategory {
            result = result.filter { $0.category == selectedCategory.rawValue }
        }

        // 3) max distance
        if let maxDistanceKm {
            let maxMeters = maxDistanceKm * 1000
            result = result.filter { $0.distance(from: userLocation) <= maxMeters }
        }

        // 4) sort by distance (nearest first)
        return result.sorted {
            $0.distance(from: userLocation) < $1.distance(from: userLocation)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                filterBar

                List(filteredGuides) { guide in
                    NavigationLink {
                        GuideDetailView(guide: guide)
                    } label: {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(guide.title)
                                Spacer()
                                Text(guide.city)
                                Spacer()
                            }
                            .font(.headline)
                            Text(guide.description)
                                .font(.subheadline)
                                .lineLimit(2)
                            Text("\(guide.distance(from: userLocation) / 1000, specifier: "%.2f") km bort")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .overlay {
                    if filteredGuides.isEmpty && !guides.isEmpty {
                        ContentUnavailableView.search
                    }
                }
            }
            .navigationTitle("Nära mig")
            .onAppear {
                GuideService.shared.fetchGuides { fetched in
                    self.guides = fetched
                }
            }
        }
    }

    // MARK: - Filter bar

    private var filterBar: some View {
        VStack(spacing: 8) {
            TextField("Sök titel, stad eller beskrivning", text: $searchText)
                .textFieldStyle(.roundedBorder)

            HStack {
                Picker("Kategori", selection: $selectedCategory) {
                    Text("Alla kategorier").tag(Category?.none)
                    ForEach(Category.allCases) { category in
                        Text(category.displayName).tag(Category?.some(category))
                    }
                }
                .pickerStyle(.menu)

                Spacer()

                Picker("Avstånd", selection: $maxDistanceKm) {
                    Text("Alla").tag(Double?.none)
                    Text("10 km").tag(Double?.some(10))
                    Text("50 km").tag(Double?.some(50))
                    Text("100 km").tag(Double?.some(100))
                }
                .pickerStyle(.menu)
            }
            .font(.subheadline)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.thinMaterial)
    }
}

#Preview { GuideListView() }
