//
//  NYPDViewController.swift
//  Summonses
//
//  Created by Stanislav on 5/26/20.
//  Copyright © 2020 neoviso. All rights reserved.
//

import UIKit
import WebKit
class NYPDDetailViewController: BaseViewController, WKUIDelegate {
    
    var pdfNumber = 1
    var webView: WKWebView!

    override func loadView() {
      let webConfiguration = WKWebViewConfiguration()
      webView = WKWebView(frame: .zero, configuration: webConfiguration)
      webView.uiDelegate = self
      view = webView
    }
    override func viewDidLoad() {
      super.viewDidLoad()
      self.navigationController?.setNavigationBarHidden(false, animated: false)
      // first, load the PDF Viewer
      loadPDFViewer()

      // then, grab the PDF from the server and render in the viewer
      //renderServerPDF()

      // or grab the PDF locally in the bundle and render in the viewer
      renderLocalPDF()
      //renderServerPDF()
        
    }

    func loadPDFViewer() {
      let urlString = "pdf.js-dist/web/viewer"

      let filePath = Bundle.main.resourceURL?.appendingPathComponent("pdf.js-dist/web/viewer.html").path
      print("File \(urlString).html exists: \(FileManager().fileExists(atPath: filePath!))")

      // first, load the PDF viewer
      if let filePath = Bundle.main.path(forResource: urlString, ofType: "html") {
        do {
          let myURL = URL(fileURLWithPath: filePath)

          let myRequest = URLRequest(url: myURL)

          webView.load(myRequest)
        }
      }
      else {
        print("cannot find resource")
      }
    }


    func renderServerPDF() {
      downloadFile()
    }

    func downloadFile() {

      // Create destination URL
      let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
      let destinationFileUrl = documentsUrl.appendingPathComponent("download.pdf")

      //Create URL to the source file you want to download
      let fileURL = URL(string: "https://www1.nyc.gov/assets/nypd/downloads/pdf/public_information/public-pguide1.pdf")

      let sessionConfig = URLSessionConfiguration.default
      let session = URLSession(configuration: sessionConfig)

      let request = URLRequest(url:fileURL!)

      let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
        if let tempLocalUrl = tempLocalUrl, error == nil {
          // Success
          if let statusCode = (response as? HTTPURLResponse)?.statusCode {
            print("Successfully downloaded. Status code: \(statusCode)")
            self.storePDFLocally()
          }

          do {
            try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
          } catch (let writeError) {
            print("Error creating a file \(destinationFileUrl) : \(writeError)")
          }

        } else {
          print("Error took place while downloading a file.");
        }
      }

      task.resume()
    }

    func storePDFLocally() {

      let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
      let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
      let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
      if let dirPath          = paths.first
      {
        let myURL = URL(fileURLWithPath: dirPath).appendingPathComponent("download.pdf")
        openPDFInViewer(myURL: myURL)
      }
    }

    func openPDFInViewer(myURL: URL) {
      let pdf = NSData(contentsOf: myURL)

      //print(pdf?.description ?? "No pdf values here")
      //print("---------------------------------------")
      let length = pdf?.length
      var myArray = [UInt8](repeating: 0, count: length!)
      pdf?.getBytes(&myArray, length: length!)

      //print(myArray.description)

      webView?.evaluateJavaScript("PDFViewerApplication.open(new Uint8Array(\(myArray)))", completionHandler: { result, error in
        print("Completed Javascript evaluation.")
        print("Result: \(String(describing: result))")
        print("Error: \(String(describing: error))")
      })
    }

    func renderLocalPDF() {

      // load the PDF into the viewer after a delay
      let timeDelay = 1.0 // in seconds
      Timer.scheduledTimer(timeInterval: timeDelay, target: self, selector: #selector(self.getLocalPDF), userInfo: nil, repeats: false)
    }

    @objc func getLocalPDF() {
    
      let urlString = "public-pguide" + String(pdfNumber)

      if let filePath = Bundle.main.path(forResource: urlString, ofType: "pdf") {
        print("File \(urlString).pdf exists: \(FileManager().fileExists(atPath: filePath))")

        let myURL = URL(fileURLWithPath: filePath)
        openPDFInViewer(myURL: myURL)
      }
      else {
        print("File \(urlString) doesn't exist")
      }
    }
    
}

