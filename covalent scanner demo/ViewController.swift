//
//  ViewController.swift
//  covalent scanner demo
//
//  Created by MAC on 21/10/2024.
//

import UIKit
import BlinkID

class ViewController: UIViewController, MBBlinkIdOverlayViewControllerDelegate  {

    var blinkIdMultiSideRecognizer: MBBlinkIdMultiSideRecognizer?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        MBMicroblinkSDK.shared().setLicenseKey(setLicenseKey, errorCallback: { error in
            print("Error occurred: \(String(describing: error))")
        })
    }

    // Action to trigger the scan
    @IBAction func didTapScan(_ sender: AnyObject) {
     
        self.blinkIdMultiSideRecognizer = MBBlinkIdMultiSideRecognizer()
        
        let settings : MBBlinkIdOverlaySettings = MBBlinkIdOverlaySettings()
        
        let recognizerList = [self.blinkIdMultiSideRecognizer!]
        let recognizerCollection : MBRecognizerCollection = MBRecognizerCollection(recognizers: recognizerList)
        
        let blinkIdOverlayViewController : MBBlinkIdOverlayViewController = MBBlinkIdOverlayViewController(settings: settings, recognizerCollection: recognizerCollection, delegate: self)
        
        let recognizerRunneViewController : UIViewController = MBViewControllerFactory.recognizerRunnerViewController(withOverlayViewController: blinkIdOverlayViewController) ?? self
        
        self.present(recognizerRunneViewController, animated: true, completion: nil)
    }

    // MARK: - MBBlinkIdOverlayViewControllerDelegate

    func blinkIdOverlayViewControllerDidFinishScanning(_ blinkIdOverlayViewController: MBBlinkIdOverlayViewController, state: MBRecognizerResultState) {
        if state == .valid {
            blinkIdOverlayViewController.recognizerRunnerViewController?.pauseScanning()
            
            if let result = blinkIdMultiSideRecognizer?.result {
                let resultData = prepareResultData(result: result)
                
                DispatchQueue.main.async { [weak self] in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let resultVC = storyboard.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController {
                        resultVC.resultData = resultData
                        blinkIdOverlayViewController.dismiss(animated: true) {
                            self?.present(resultVC, animated: true, completion: nil)
                        }
                    }
                }
            } else {
                blinkIdOverlayViewController.dismiss(animated: true, completion: {
                    let alert = UIAlertController(title: "Error", message: "No result found.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                })
            }
        }
    }
    private func prepareResultData(result: MBBlinkIdMultiSideRecognizerResult) -> [String: String] {
        var resultDict: [String: String] = [:]
        
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            

        if let fullName = result.fullName?.value {
            resultDict["Full Name"] = fullName
        }
        if let firstName = result.firstName?.value {
            resultDict["First Name"] = firstName
        }
        if let lastName = result.lastName?.value {
            resultDict["Last Name"] = lastName
        }
        if let documentNumber = result.documentNumber?.value {
            resultDict["Document Number"] = documentNumber
        }
        if let dateOfBirth = result.dateOfBirth?.date {
            resultDict["Date of Birth"] = dateFormatter.string(from: dateOfBirth)
        }
        if let sex = result.sex?.value {
            resultDict["Sex"] = sex
        }
        if let nationality = result.nationality?.value {
            resultDict["Nationality"] = nationality
        }
        if let issuingAuthority = result.issuingAuthority?.value {
            resultDict["Issuing Authority"] = issuingAuthority
        }
        if let dateOfIssue = result.dateOfIssue?.date {
            resultDict["Date of Issue"] = dateFormatter.string(from: dateOfIssue)
        }
        if let dateOfExpiry = result.dateOfExpiry?.date {
            resultDict["Date of Expiry"] = dateFormatter.string(from: dateOfExpiry)
        }
        if let address = result.address?.value {
            resultDict["Address"] = address
        }
        if let placeOfBirth = result.placeOfBirth?.value {
            resultDict["Place of Birth"] = placeOfBirth
        }
        if let documentType = result.documentSubtype?.value {
            resultDict["Document Type"] = documentType
        }
        if let maritalStatus = result.maritalStatus?.value {
            resultDict["Marital Status"] = maritalStatus
        }
        if let profession = result.profession?.value {
            resultDict["Profession"] = profession
        }
        if let race = result.race?.value {
            resultDict["Race"] = race
        }
        if let religion = result.religion?.value {
            resultDict["Religion"] = religion
        }
        if let residentialStatus = result.residentialStatus?.value {
            resultDict["Residential Status"] = residentialStatus
        }
        if let employer = result.employer?.value {
            resultDict["Employer"] = employer
        }
        if let issuingState = result.dateOfIssue?.date {
            resultDict["Issuing State"] = dateFormatter.string(from: issuingState)
        }

        return resultDict
    }
    
    

    func blinkIdOverlayViewControllerDidTapClose(_ blinkIdOverlayViewController: MBBlinkIdOverlayViewController) {
        blinkIdOverlayViewController.dismiss(animated: true, completion: nil)
    }

   
}

