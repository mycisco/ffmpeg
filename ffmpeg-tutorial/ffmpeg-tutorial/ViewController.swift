//
//  ViewController.swift
//  ffmpeg-tutorial
//
//  Created by marbean on 2022/09/01.
//

import UIKit
//import FFmpeg

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
  
        
        Tutorial01().tutorial01()
        
//        av_register_all()
//        let filePath = Bundle.main.path(forResource: "h264", ofType: ".mp4")
//        var pFormatCtx: UnsafeMutablePointer<AVFormatContext>?
//
//        // 1. 파일 스트림 열기
//        if avformat_open_input(&pFormatCtx, filePath, nil, nil) != 0 {
//            print("avformat_open_input")
//            return
//        }
//
//        // 2. 스트림 정보 찾기
//        if avformat_find_stream_info(pFormatCtx, nil) != 0 {
//            print("avformat_find_stream_info")
//            return
//        }
//
//
//        // 2.1 디버깅 프린트
////        av_dump_format(pFormatCtx, 0, filePath, 0)
//
//        // 3. 오디오, 비디오 스트림의 인덱스 값 가져 오기
//        var videoStream: Int = -1
//        var pCodecCtxOrig: UnsafeMutablePointer<AVCodecContext>?
//        var pCodecCtx: UnsafeMutablePointer<AVCodecContext>?
//        if let safeFormatCtx = pFormatCtx {
//            for i in 0..<safeFormatCtx.pointee.nb_streams {
//                // TODO: codec deprecated 되어 다른 방법도 찾아보기
//                let stream = safeFormatCtx.pointee.streams[Int(i)]
//                if let codecType = stream?.pointee.codec.pointee.codec_type,
//                   codecType == AVMEDIA_TYPE_VIDEO {
//                    pCodecCtx = stream?.pointee.codec
//                    videoStream = Int(i)
//                    break
//                }
//            }
//        }
//
//        /*
//         MARK: 요건 왜하는거임??????????
//        // Copy context
//        pCodecCtx = avcodec_alloc_context3(pCodec);
//        if(avcodec_copy_context(pCodecCtx, pCodecCtxOrig) != 0) {
//          fprintf(stderr, "Couldn't copy codec context");
//          return -1; // Error copying codec context
//        }
//         */
//
//        // 4. 지원 코덱 찾기?
//        var pCodec: UnsafeMutablePointer<AVCodec>?
//        if let codec_id = pCodecCtx?.pointee.codec_id {
//            pCodec = avcodec_find_decoder(codec_id)
//            print("codec_id = \(codec_id) ")
//        }
//        if pCodec == nil {
//            print("Unsupported codec")
//            return
//        }
//
//        if avcodec_open2(pCodecCtx, pCodec, nil) != 0 {
//            print("avcodec_open2")
//            return
//        }
//
//        // 5. 프레임 데이터 저장
////        var pFrameRGB: UnsafeMutablePointer<AVFrame> = av_frame_alloc()
//        var pFrame: UnsafeMutablePointer<AVFrame> = av_frame_alloc()
//        let numberByte:Int32 = avpicture_get_size(AV_PIX_FMT_RGB24,
//                                                  pCodecCtx?.pointee.width ?? 0,
//                                                  pCodecCtx?.pointee.height ?? 0)
//
//
//        /*
//         TODO: down casting, type casting 사용법 찾아보기
//         */
//        let bufferSize: Int = Int(numberByte) * MemoryLayout<UInt8>.size
//        var buffer: UnsafeMutableRawPointer = av_malloc(bufferSize)
////        var avPicture: AVPicture = AVPicture(data: pFrame.pointee.data, linesize: pFrame.pointee.linesize)
//
//        var avPicture: AVPicture = AVPicture()
//        avpicture_fill(&avPicture,
//                       buffer,
//                       AV_PIX_FMT_RGB24,
//                       pCodecCtx?.pointee.width ?? 0,
//                       pCodecCtx?.pointee.height ?? 0)
//
//        //. 6
//
//        /*
//         struct SwsContext *sws_ctx = NULL;
//         int frameFinished;
//         AVPacket packet;
//         // initialize SWS context for software scaling
//         sws_ctx = sws_getContext(pCodecCtx->width,
//             pCodecCtx->height,
//             pCodecCtx->pix_fmt,
//             pCodecCtx->width,
//             pCodecCtx->height,
//             PIX_FMT_RGB24,
//             SWS_BILINEAR,
//             NULL,
//             NULL,
//             NULL
//             );
//        */
//
//        sws_getContext(pCodecCtx?.pointee.width ?? 0,
//                       pCodecCtx?.pointee.height ?? 0,
//                       pCodecCtx?.pointee.pix_fmt ?? AV_PIX_FMT_NONE,
//                       pCodecCtx?.pointee.width ?? 0,
//                       pCodecCtx?.pointee.height ?? 0,
//                       AV_PIX_FMT_RGB24,
//                       SWS_BILINEAR,
//                       nil,
//                       nil,
//                       nil)
//
//        var packet: UnsafeMutablePointer<AVPacket>?
//        var frameFinished: UnsafeMutablePointer<Int32>?
////        var sws_ctx: UnsafeMutablePointer<sws>?
//        swscon
//        while av_read_frame(pFormatCtx, packet) >= 0 {
//            if packet?.pointee.stream_index == Int32(videoStream) {
//                // decode video frame
//                avcodec_decode_video2(pCodecCtx, pFrame, frameFinished, packet)
//
//                sws_scale(sws_ctx, pFrame.pointee.data, pFrame.pointee.linesize, 0, pCodecCtx?.pointee.height ?? 0, avPicture.data , avPicture.linesize)
//
//            }
//
//        }
//
//
//
//        /*
//         i=0;
//         while(av_read_frame(pFormatCtx, &packet)>=0) {
//           // Is this a packet from the video stream?
//           if(packet.stream_index==videoStream) {
//             // Decode video frame
//             avcodec_decode_video2(pCodecCtx, pFrame, &frameFinished, &packet);
//
//             // Did we get a video frame?
//             if(frameFinished) {
//             // Convert the image from its native format to RGB
//                 sws_scale(sws_ctx, (uint8_t const * const *)pFrame->data,
//                   pFrame->linesize, 0, pCodecCtx->height,
//                   pFrameRGB->data, pFrameRGB->linesize);
//
//                 // Save the frame to disk
//                 if(++i<=5)
//                   SaveFrame(pFrameRGB, pCodecCtx->width,
//                             pCodecCtx->height, i);
//             }
//           }
//
//           // Free the packet that was allocated by av_read_frame
//           av_free_packet(&packet);
//         }
//         */
        
        
    }
}

