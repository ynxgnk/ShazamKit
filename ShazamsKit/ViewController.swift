//
//  ViewController.swift
//  ShazamsKit
//
//  Created by Nazar Kopeika on 15.05.2023.
//

import ShazamKit /* 1 */
import UIKit

class ViewController: UIViewController,SHSessionDelegate { /* 6 1 protocol */

    override func viewDidLoad() {
        super.viewDidLoad()
        recognizeSong() /* 3 */
    }

    private func recognizeSong() { /* 2 */
        // Session
        let session = SHSession() /* 4 */
        //Delegate
        session.delegate = self /* 5 */
        
        do { /* 11 */
            //Get track
            guard let url = Bundle.main.url(forResource: "song", withExtension: "mp4") else { /* 14 */
                print("Failed to get song url") /* 15 */
                return /* 16 */
            }
            //Create AudioFile
            let file = try AVAudioFile(forReading: url) /* 17 */
            //Audio -> Buffer
            guard let buffer = AVAudioPCMBuffer(pcmFormat: file.processingFormat,
                                                frameCapacity: AVAudioFrameCount(file.length / 17)
            ) else { /* 18 */ /* 19 else */
                print("Failed to create buffer") /* 22 */
                return /* 20 */
            }
            try file.read(into: buffer) /* 21 */
            //SignatureGenerator
            let generator = SHSignatureGenerator() /* 23 */
            try generator.append(buffer, at: nil) /* 24 */
            //Create signature
            let signature = generator.signature() /* 25 */
            //try to match
            session.match(signature) /* 26 */
        }
        catch { /* 12 */
            print(error) /* 13 */
        }
        
    }
    
    func session(_ session: SHSession, didFind match: SHMatch) { /* 7 */
        //Get results
        let items = match.mediaItems /* 27 */
        items.forEach { item in /* 28 */
            print(item.title ?? "Title") /* 29 */
            print(item.artist ?? "Artist") /* 30 */
            print(item.artworkURL?.absoluteURL ?? "Artwork url") /* 31 */
        }
        
    }

    func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) { /* 8 */
        if let error = error { /* 9 */
            print(error) /* 10 */
        }
    }
}

