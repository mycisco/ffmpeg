//
//  Tutorial01.m
//  ffmpeg-tutorial
//
//  Created by MARBEAN on 2022/09/02.
//

#import "Tutorial01.h"
#import "FFmpeg/ffmpeg.h"

@implementation Tutorial01

- (void)tutorial01 {
    
    av_register_all();
    
    AVFormatContext *pFormatCtx = NULL;
    
    // Open video File
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"h264" ofType:@".mp4"];
    
    if (avformat_open_input(&pFormatCtx, filePath.UTF8String, NULL, 0)) {
        NSLog(@"Clouldn't open file");
        return;
    }
    
    if (avformat_find_stream_info(pFormatCtx, NULL) < 0) {
        NSLog(@"Couldn't find stream infomation");
        return;;
    }
    
    //    av_dump_format(pFormatCtx, 0, filePath.UTF8String, 0);
    AVCodecContext *pCodecCtxOrig = NULL;
    AVCodecContext *pCodecCtx = NULL;
    
    // Find the first video stream
    int videoStream = -1;
    for (int i = 0; i < pFormatCtx->nb_streams; i++) {
        
        if (pFormatCtx->streams[i]->codec->codec_type == AVMEDIA_TYPE_VIDEO) {
            videoStream = i;
            break;
        }
    }
    
    if (videoStream == -1) {
        NSLog(@"Didn't find a video stream");
        return;
    }
    pCodecCtx = pFormatCtx->streams[videoStream]->codec;
    AVCodec *pCodec = NULL;
    
    // FInd the decoder for the video stream
    pCodec = avcodec_find_decoder(pCodecCtx->codec_id);
    if (pCodec == NULL) {
        NSLog(@"Unsupported codec!");
        return;
    }
    // open codec
    if (avcodec_open2(pCodecCtx, pCodec, 0) < 0) {
        NSLog(@"Cloud not open codec");
        return;
    }
    
    AVFrame *pFrame = av_frame_alloc();
    AVFrame *pFrameRGB = av_frame_alloc();
    
    
    int numBytes = avpicture_get_size(AV_PIX_FMT_RGB24, pCodecCtx->width, pCodecCtx->height);
    uint8_t *buffer = av_malloc(numBytes * sizeof(uint8_t));
    
    avpicture_fill((AVPicture *)pFrameRGB,
                   buffer,
                   AV_PIX_FMT_RGB24,
                   pCodecCtx->width,
                   pCodecCtx->height);
    
    // Read the data
    AVPacket packet;
    struct SwsContext *sws_ctx = sws_getContext(pCodecCtx->width,
                                         pCodecCtx->height,
                                         pCodecCtx->pix_fmt,
                                         pCodecCtx->width,
                                         pCodecCtx->height,
                                         AV_PIX_FMT_RGB24,
                                         SWS_BILINEAR,
                                         NULL,
                                         NULL,
                                         NULL);
    
    int i = 0;
    int frameFinished;
    while (av_read_frame(pFormatCtx, &packet) >= 0) {
        
        // Is the a packet frome the video stream?
        if (packet.stream_index == videoStream) {
            // Decode video frame
            avcodec_decode_video2(pCodecCtx, pFrame, &frameFinished, &packet);
            
            if (frameFinished) {
                // Did we get video frame?
                sws_scale(sws_ctx,
                          (const uint8_t *const)pFrame->data,
                          pFrame->linesize,
                          0,
                          pCodecCtx->height,
                          pFrameRGB->data,
                          pFrameRGB->linesize);
                
                if (++i <= 5) {
                    [self saveFrame:pFrameRGB width:pCodecCtx->width height:pCodecCtx->height iFrame:i];
                }
            }
        }
        
    }
    
    av_free(buffer);
    av_free(pFrameRGB);
    av_free(pFrame);
    
    avcodec_close(pCodecCtx);
    avcodec_close(pCodecCtxOrig);
    
    avformat_close_input(&pFormatCtx);
    
}

- (void)saveFrame:(AVFrame *)frame width:(int)width height:(int)height iFrame:(int)iFrame {
    FILE *pFile;
    char szFilename[32];
    sprintf(szFilename, "frame%d.ppm", iFrame);
    pFile = fopen(szFilename, "wb");
    
    if (pFile == NULL) {
        return;;
    }
    
    fprintf(pFile, "P6\n%d %d\n255\n", width, height);
    
    for (int y = 0; y < height; y++) {
        fwrite(frame->data[0]+y*frame->linesize[0], 1, width*3, pFile);
    }
    
    
    fclose(pFile);
}
@end
