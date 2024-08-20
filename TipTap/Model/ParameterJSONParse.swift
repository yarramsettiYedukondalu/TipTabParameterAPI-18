//
//  ParameterJSONParse.swift
//  TipTap
//
//  Created by Toqsoft on 08/04/24.
//

import Foundation

func fetchFeedbackJsonData(completion: @escaping () -> Void) {
    JsonDataArrays.feedbackArray.removeAll()
    guard let loginUserID = loginUserID, loginUserID != "" else{return}
    let apiUrlString = CompanyFeedbackURL + "?filter= UserID eq '\(loginUserID)'"
    guard let apiUrl = URL(string: apiUrlString) else {
        print("Invalid API URL")
        return
    }
    fetchJSONData(from: apiUrl)  { (result: Result<fetchCompanyfeedbackApiResponse, APIError>) in
        switch result {
        case .success(let jsondata):
            JsonDataArrays.feedbackArray.removeAll()
            if let record = jsondata.records{
                JsonDataArrays.feedbackArray = record
                completion()
            }
            
        case .failure(let error):
            print("Error: \(error)")
            completion()
        }
    }
}

func fetchUserEnquiry(completion: @escaping () -> Void){
    JsonDataArrays.UserEnquiryArray.removeAll()
    guard let loginUserID = loginUserID, loginUserID != "" else{return}
    let apiUrlString = EnquiryURL + "?filter= UserID eq '\(loginUserID)'"
    guard let apiUrl = URL(string: apiUrlString) else {
        print("Invalid API URL")
        return
    }
    fetchJSONData(from: apiUrl)  { (result: Result<fetchUserEnquiryApiResponse, APIError>) in
        switch result {
        case .success(let jsondata):
            if let records = jsondata.records {
                JsonDataArrays.UserEnquiryArray = records
            } else {
                
                JsonDataArrays.UserEnquiryArray = []
            }
            completion()
        case .failure(let error):
            print("Error: \(error)")
            completion()
        }
        
    }
    
}
func fetchUserLogs(completion: @escaping () -> Void){
    JsonDataArrays.userLogArray.removeAll()
    guard let loginUserID = loginUserID, loginUserID != "" else{return}
    let apiUrlString = userLogURL + "?filter= UserID eq '\(loginUserID)'"
    guard let apiUrl = URL(string: apiUrlString) else {
        print("Invalid API URL")
        return
    }
    
    fetchJSONData(from: apiUrl)  {  (result: Result<fetchUserLogsApiResponse, APIError>) in
        switch result {
        case .success(let jsondata):
            if let records = jsondata.records {
                JsonDataArrays.userLogArray = records 
                
            } else {
                
                JsonDataArrays.userLogArray = []
            }
            completion()
        case .failure(let error):
            print("Error: \(error)")
        }
        completion()
    }
    
}

func fetchUserReport(completion: @escaping () -> Void){
    JsonDataArrays.UserReportArray.removeAll()
    guard let loginUserID = loginUserID, loginUserID != "" else{return}
    let apiUrlString = userReportURL + "?filter= UserID eq '\(loginUserID)'"
    guard let apiUrl = URL(string: apiUrlString) else {
        print("Invalid API URL")
        return
    }
    fetchJSONData(from: apiUrl)  { (result: Result<fetchuserReportsApiResponse, APIError>) in
        switch result {
        case .success(let jsondata):
            if let records = jsondata.records {
                JsonDataArrays.UserReportArray = records
            } else {
                JsonDataArrays.UserReportArray = []
            }
            completion()
        case .failure(let error):
            print("Error: \(error)")
            completion()
        }
    }
    
}
