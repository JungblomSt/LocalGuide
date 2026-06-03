

import SwiftUI
import CoreLocation

struct GuideListView: View {

    @State private var viewModel = GuidesListViewModel()
    @State private var searchText: String = ""
    @State private var selectedCategory: Category? = nil
    @State private var maxDistanceKm: Double? = nil

    private var filteredGuides: [Guide] {
        var result = viewModel.sortedGuides

        if !searchText.isEmpty {
            let q = searchText.lowercased()
            result = result.filter {
                $0.title.lowercased().contains(q) ||
                $0.city.lowercased().contains(q) ||
                $0.description.lowercased().contains(q)
            }
        }

        if let selectedCategory {
            result = result.filter { $0.category == selectedCategory.rawValue }
        }

        if let maxDistanceKm {
            let maxMeters = maxDistanceKm * 1000
            result = result.filter {
                $0.distance(from: viewModel.userLocation ?? CLLocation()) <= maxMeters
            }
        }

        return result
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                filterBar

                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.errorMessage {
                    Text(error)
                } else {
                    List(filteredGuides) { guide in
                        NavigationLink {
                            GuideDetailView(guide: guide)
                        } label: {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(guide.title)
                                    Spacer()
                                    Text(guide.city)
                                }
                                .font(.headline)
                                Text(guide.description)
                                    .font(.subheadline)
                                    .lineLimit(2)
                                if let location = viewModel.userLocation {
                                    Text("\(guide.distance(from: location) / 1000, specifier: "%.2f") km bort")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding()
                        }
                    }
                    .overlay {
                        if filteredGuides.isEmpty && !viewModel.sortedGuides.isEmpty {
                            ContentUnavailableView.search
                        }
                    }
                }
            }
            .navigationTitle("Nära mig")
        }
        .task {
            viewModel.locationManager.requestLocationAccess()
            await viewModel.loadGuides()
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
