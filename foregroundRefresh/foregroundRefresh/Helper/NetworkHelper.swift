//
//  NetworkHelper.swift
//  foregroundRefresh
//
//  Created by Ashfak Ahamed Alauddeen on 09/06/24.
//

import Foundation

protocol TimerDelegate{
    func getTimerModel(from timerModel: TimerModel)
}

struct NetworkHelper{
    
    var path = "https://api.restful-api.dev/objects/"
    var id = "ff8081818feaa6c4018ff8dcafbf14f6"
    var delegate: TimerDelegate?
    var responseModel: TimerModel?
    

    
    func callGetObjects(){
        
        let urlString = "\(path)\(id)"
        if let apiURL = URL(string: urlString){
            
            var request = URLRequest(url: apiURL)
            request.httpMethod = "GET"
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                
                if let error = error{
                    print("There occured an error \(String(describing: error.localizedDescription))")
                    return
                }
                if let data = data{
                    print("Data has been returned ...")
                    if let model = self.parseCoinModel(from: data){
                        delegate?.getTimerModel(from: model)
                    }
                }
            }
            task.resume()
        }
    }
    
    func makePutRequest(_ body: TimerModel) {
            let urlString = "\(path)\(id)"// Replace with your actual URL path
            guard let url = URL(string: urlString) else { return }

            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            // Convert TimerModel to JSON data
            let encoder = JSONEncoder()
            do {
                request.httpBody = try encoder.encode(body)
            } catch {
                print("Failed to encode body: \(error)")
                return
            }

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                if let data = data{
                    print("Data has been returned ...")
                    if let model = self.parseCoinModel(from: data){
                        delegate?.getTimerModel(from: model)
                    }
                }
            }
            task.resume()
        }
    
    func parseCoinModel(from coinData: Data) -> TimerModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(TimerModel.self, from: coinData)
            return decodedData
        }catch{
            print("Error: \(error)")
            return nil
        }
    }
    
    
}
