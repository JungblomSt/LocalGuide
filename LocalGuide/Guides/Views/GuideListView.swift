
import SwiftUI
import CoreLocation


struct GuideListView: View {
    
    @State private var viewModel = GuidesListViewModel()

    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.errorMessage {
                Text(error)
            } else {
                List(viewModel.sortedGuides) { guide in
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
                            if let location = viewModel.userLocation {
                                Text("\(guide.distance(from: location) / 1000, specifier: "%.2f") km bort")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            } else {
                                EmptyView()
                            }
                            
                        }
                        .padding()
                    }
                }
                .navigationTitle(Text("Nära mig"))
            }
        }
        .task {
            viewModel.locationManager.requestLocationAccess()
            await viewModel.loadGuides()
        }
    }
}
#Preview { GuideListView() }
