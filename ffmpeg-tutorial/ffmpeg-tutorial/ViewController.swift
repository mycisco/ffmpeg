//
//  ViewController.swift
//  ffmpeg-tutorial
//
//  Created by marbean on 2022/09/01.
//

import UIKit
import FFmpeg

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filePath = Bundle.main.path(forResource: "h264", ofType: ".mp4")
        var pFormatCtx: UnsafeMutablePointer<AVFormatContext>?
        
        // 0. FFMPEG 4 이상 부턴 자동으로 관리 해주기 때문에 초기화 함수 사용 안함
//        av_register_all()
        
        // 1. 파일 스트림 열기
        let ret = avformat_open_input(&pFormatCtx, filePath, nil, nil)
        print("avformat_open_input = \(ret)")
        
        // 2. 스트림 정보 찾기
        let ret1 = avformat_find_stream_info(pFormatCtx, nil)
        print("avformat_find_stream_info = \(ret1)")
        
        // 2.1 디버깅 프린트
//        av_dump_format(pFormatCtx, 0, filePath, 0)
        
        // 3. 오디오, 비디오 스트림의 인덱스 값 가져 오기
        var pCodecCtxOrig: UnsafeMutablePointer<AVCodecContext>?
        var pCodecCtx: UnsafeMutablePointer<AVCodecContext>?
        if let safeFormatCtx = pFormatCtx {
            for i in 0..<safeFormatCtx.pointee.nb_streams {
                // TODO: codec deprecated 되어 다른 방법도 찾아보기
                let stream = safeFormatCtx.pointee.streams[Int(i)]
                if let codecType = stream?.pointee.codec.pointee.codec_type,
                   codecType == AVMEDIA_TYPE_VIDEO {
                    pCodecCtx = stream?.pointee.codec
                    break
                }
            }
        }
        
        /*
         MARK: 요건 왜하는거임??????????
        // Copy context
        pCodecCtx = avcodec_alloc_context3(pCodec);
        if(avcodec_copy_context(pCodecCtx, pCodecCtxOrig) != 0) {
          fprintf(stderr, "Couldn't copy codec context");
          return -1; // Error copying codec context
        }
         */
        
        // 4. 지원 코덱 찾기?
        var pCodec: UnsafeMutablePointer<AVCodec>?
        if let codec_id = pCodecCtx?.pointee.codec_id {
            pCodec = avcodec_find_decoder(codec_id)
            print("codec_id = \(codec_id) ")
        }
        if pCodec == nil {
            print("Unsupported codec")
        }
        
        let ret3 = avcodec_open2(pCodecCtx, pCodec, nil)
        print("avcodec_open2 = \(ret3)")
        
        
        // 5. 프레임 데이터 저장
        var pFrameRGB: UnsafeMutablePointer<AVFrame> = av_frame_alloc()
        var pFrame: UnsafeMutablePointer<AVFrame> = av_frame_alloc()
        let numberByte:Int32 = avpicture_get_size(AV_PIX_FMT_RGB24,
                                                  pCodecCtx?.pointee.width ?? 0,
                                                  pCodecCtx?.pointee.height ?? 0)
        

        var buffer: UnsafeMutablePointer<UInt8>?
        // MemoryLayout == sizeof()
        let bufferSize: Int = Int(numberByte) * MemoryLayout<UInt8>.size
        let aaa = av_malloc(bufferSize)
//        buffer = aaa?.bindMemory(to: UInt8.self, capacity: bufferSize)
//        var pPicture: UnsafeMutablePointer<AVPicture> = UnsafeMutablePointer<AVPicture>()
//        Unmanaged<AVPicture>.fromOpaque()
        
        pFrame?.
//        var pPicture: UnsafeMutablePointer<AVPicture>? = UnsafeMutablePointer<AVPicture>(pFrame)
        
//        avpicture_fill(nil,
//                       buffer,
//                       AV_PIX_FMT_RGB24,
//                       pCodecCtx?.pointee.width ?? 0,
//                       pCodecCtx?.pointee.height ?? 0)
    }
}

