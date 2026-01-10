import 'package:busic/consts/network.dart';
import 'package:just_audio/just_audio.dart';

void playTest() async {
  final player = AudioPlayer();
  await player.setUrl(
    'https://cn-hbwh-fx-01-12.bilivideo.com/upgcxcode/15/72/35261777215/35261777215-1-30232.m4s?e=ig8euxZM2rNcNbdlhoNvNC8BqJIzNbfqXBvEqxTEto8BTrNvN0GvT90W5JZMkX_YN0MvXg8gNEV4NC8xNEV4N03eN0B5tZlqNxTEto8BTrNvNeZVuJ10Kj_g2UB02J0mN0B5tZlqNCNEto8BTrNvNC7MTX502C8f2jmMQJ6mqF2fka1mqx6gqj0eN0B599M=&gen=playurlv3&os=bcache&nbs=1&og=cos&oi=1939639862&mid=285379645&deadline=1767932656&platform=pc&trid=0000a786fc6c9a6b4ff5b0b5e7efe7e8046u&uipk=5&upsig=68ead163a37836e0965125114ed328e6&uparams=e,gen,os,nbs,og,oi,mid,deadline,platform,trid,uipk&cdnid=1237&bvc=vod&nettype=0&bw=77115&f=u_0_0&qn_dyeid=9df9f331c746fb7900c02e27696066d0&agrr=0&buvid=0D246273-509D-0DEF-124C-0BA3248035FB23309infoc&build=0&dl=0&np=151388311&orderid=0,3',
    headers: {
      'User-Agent': ua,
      'referer': 'https://www.bilibili.com',
      'Cookie':
          "buvid3=0D246273-509D-0DEF-124C-0BA3248035FB23309infoc; b_nut=1746278823; _uuid=924F10C7C-CADB-5C98-4F7B-3C110A4997EB123670infoc; buvid4=088E958B-4740-068F-245A-719FB2377EC724133-025050321-p4ISvucwps6KFYid8NQ80Q%3D%3D; enable_web_push=DISABLE; enable_feed_channel=ENABLE; rpdid=|(umJmYR|l|R0J'u~RYk~))J~; DedeUserID=285379645; DedeUserID__ckMd5=5d78bf722b27466d; hit-dyn-v2=1; buvid_fp_plain=undefined; header_theme_version=OPEN; theme-tip-show=SHOWED; theme-avatar-tip-show=SHOWED; theme-switch-show=SHOWED; theme_style=dark; CURRENT_BLACKGAP=0; LIVE_BUVID=AUTO1217532768530465; bp_video_offset_285379645=1147968161774043136; home_feed_column=5; browser_resolution=1920-945; bili_ticket=eyJhbGciOiJIUzI1NiIsImtpZCI6InMwMyIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3Njc5MzY3MDIsImlhdCI6MTc2NzY3NzQ0MiwicGx0IjotMX0.nFtflUixpTpJIuX8JAznx_m5Fob0MUZLuljj2M0xlKw; bili_ticket_expires=1767936642; SESSDATA=f92f4c32%2C1783229503%2Cbb256%2A11CjCpx8kPm2pWjA_VdJ0BCDWw9XM-54OGXI05XlIV2D3_SoCS4dmE6peCnbmn0zS9G1sSVlFvdUZFd1J1dk1EMzJUNmlnamlxeGZBTEUxT2d6QVpYbm55MU5IcHB4Nzh6MkpuOEQ0OEFuUW50UFNkVGxQR1RBQ3NxWTczSmhyRDNmQ2lwXzhtXzFnIIEC; bili_jct=a2ef88b0c4734784a1cec639277009de; CURRENT_QUALITY=0; fingerprint=3d2a990e53caa149a29f4ff4e89f1134; buvid_fp=db3964f8b0914b7c594bc3b9b7e15187; bp_t_offset_285379645=1155478281458286592; b_lsid=3B85638C_19BA0914D16; bmg_af_switch=1; bmg_src_def_domain=i0.hdslb.com; CURRENT_FNVAL=4048; sid=qb2d89jh",
    },
  );
  player.positionStream.listen((position) {
    print('当前播放位置: $position');
  });

  player.bufferedPositionStream.listen((bufferedPosition) {
    print('已缓冲到: $bufferedPosition');
  });

  player.durationStream.listen((duration) {
    print('总时长: $duration');
  });

  await player.play();
}
