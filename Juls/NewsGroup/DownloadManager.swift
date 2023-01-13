//
//  DownloadManager.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import Foundation


// MARK: Основные Новости https://newsapi.org/v2/top-headlines?country=ru&apiKey=2cec4a99ce694b1590c742a166b419da
// MARK: GOOGLE Новости https://newsapi.org/v2/top-headlines?sources=google-news-ru&apiKey=2cec4a99ce694b1590c742a166b419da
// MARK: Технологические Новости https://newsapi.org/v2/top-headlines?country=ru&category=technology&apiKey=2cec4a99ce694b1590c742a166b419da
// MARK: Бизнес Новости https://newsapi.org/v2/top-headlines?country=ru&category=business&apiKey=2cec4a99ce694b1590c742a166b419da
// MARK: Tesla Новости https://newsapi.org/v2/everything?q=tesla&from=2022-09-26&sortBy=publishedAt&apiKey=2cec4a99ce694b1590c742a166b419da
// MARK: Здоровье Новости https://newsapi.org/v2/top-headlines?country=ru&category=health&apiKey=2cec4a99ce694b1590c742a166b419da
// MARK: Entertaimant Новости (ДОМ2, и тд МЕДИА) https://newsapi.org/v2/top-headlines?country=ru&category=entertainment&apiKey=2cec4a99ce694b1590c742a166b419da
// MARK: NEWS http://api.mediastack.com/v1/news?access_key=69367ccc3f3c0d371d2df65238ed2d5f&keywords=tennis&countries=us

struct Answer: Decodable {
    var status: String?
    var articles: [Article]
}

struct Article: Decodable {
    var name: String?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var content: String?
    var publishedAt: String?
}
//MARK: Первый метод
func downloadNews(completion: ((_ item: [Article]?) -> Void)?) {
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: URL(string: "https://newsapi.org/v2/everything?q=tesla&from=2022-09-26&sortBy=publishedAt&apiKey=2cec4a99ce694b1590c742a166b419da")!) { data, responce, error in
        if let error {
            print(error.localizedDescription)
            completion?(nil)
            return
        }
        if (responce as? HTTPURLResponse)?.statusCode != 200 {
            print("statusCode = \((responce as? HTTPURLResponse)?.statusCode)")
            return
        }
        
        guard let data else {
            print("data = nil")
            return
        }
        
        do {
            let answer = try JSONDecoder().decode(Answer.self, from: data)
            completion?(answer.articles)
        } catch {
            print(error)
            completion?(nil)
        }
    }
    task.resume()
}
func downloadNewsList(searchString: String? = nil, completion: ((_ articles: [Article]?) -> Void)?) {
    
    var urlString = "https://newsapi.org/v2/top-headlines?country=ru&category=technology&apiKey=2cec4a99ce694b1590c742a166b419da"
    
    if let searchString = searchString, searchString != "" {
        urlString =
        "https://newsapi.org/v2/top-headlines?country=ru&category=technology&apiKey=2cec4a99ce694b1590c742a166b419da"
    }
    
    downloadData(url: URL(string: urlString)!) {
        data in
        guard let data else { return }
        
        do {
            let answer = try JSONDecoder().decode(Answer.self, from: data)
            completion?(answer.articles)
//            print("ЭТО ANSWER--------------------------------\(answer)")
        } catch {
            print(error)
            print("сюда заходим")
            completion?(nil)
        }
    }
}

func downloadData(url: URL, completion: ((_ data: Data?) -> Void)?) {
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: url) {
        data, responce, error in
        
        if let error {
            print(error.localizedDescription)
            completion?(nil)
            return
        }
        
        if (responce as? HTTPURLResponse)?.statusCode != 200 {
            print("StatusCode = \((responce as? HTTPURLResponse)?.statusCode)")
            return
        }
        
        guard let data else {
            print("Data = nil")
            return
        }
        completion?(data)
    }
    task.resume()
}

func downloadFile(urlFile: URL, completion: ((_ imageData: Data?) -> Void)?) {
    let session = URLSession(configuration: .default)
    let task = session.downloadTask(with: urlFile) { urlSavedImageTMP, responce, error in
        
        guard let urlSavedImageTMP else {
            print("urlSavedImageTMP = nil")
            completion?(nil)
            return
        }
        completion?(try? Data(contentsOf: urlSavedImageTMP))
    }
    task.resume()
}

class DownloadManager: NSObject, URLSessionDownloadDelegate {
    
    var didFinishDownload: ((_ data: Data?) -> Void)?
    var didWriteData: ((_ percentCompleted: Float) -> Void)?
    
    func downloadFile(url: URL, didFinishDownload: ((_ data: Data?) -> Void)?,didWriteData: ((_ percentCompleted: Float) -> Void)? ) {
        
        self.didFinishDownload = didFinishDownload
        self.didWriteData = didWriteData
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let task = session.downloadTask(with: url)
        task.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let data = try? Data(contentsOf: location) {
            didFinishDownload?(data)
        } else {
            print("data = nil")
            didFinishDownload?(nil)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if totalBytesExpectedToWrite != -1 {
            didWriteData?(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))
        }
        
        func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
            if let error {
                print(error.localizedDescription)
                didFinishDownload?(nil)
            }
        }
    }
}

