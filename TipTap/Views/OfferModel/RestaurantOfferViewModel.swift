//
//  RestaurantOfferViewModel.swift
//  TipTap
//
//  Created by ToqSoft on 05/08/24.
//

import Foundation

import Foundation
import Combine

class OfferViewModel: ObservableObject {
    @Published var offers = [OfferRecordModel]()
    @Published var errorMessage: String? = nil
    private var cancellables: Set<AnyCancellable> = []
     var restaurants = [RestaurantRecord]()

    func fetchOffers() {
     guard let  restaurantURL = URL(string: RestaurantsURL) else{
                    return
                }
            
                guard let offerURL = URL(string: restaurantOfferURL) else{
                    return
                }

        // Fetch both restaurants and offers
        Publishers.Zip(fetchRestaurants(from: restaurantURL), fetchOffersData(from: offerURL))
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] restaurants, offers in
                self?.restaurants = restaurants
                self?.offers = offers.filter { offer in
                    self?.restaurants.contains(where: { $0.restaurantID == offer.restaurantID }) ?? false
                }
            })
            .store(in: &cancellables)
    }

    private func fetchRestaurants(from url: URL) -> AnyPublisher<[RestaurantRecord], Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: RestaurantResponses.self, decoder: JSONDecoder())
            .map(\.records)
            .eraseToAnyPublisher()
    }

    private func fetchOffersData(from url: URL) -> AnyPublisher<[OfferRecordModel], Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: OfferResponseModel.self, decoder: JSONDecoder())
            .map(\.records)
            .eraseToAnyPublisher()
    }
}

