import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class MyAudioHandler extends BaseAudioHandler with SeekHandler {
  final _player = AudioPlayer();
  late final Stream<IcyMetadata?> listenMetadata;

  MyAudioHandler() {
    _player.playbackEventStream.listen(_broadcastState);
    listenMetadata = _player.icyMetadataStream;
  }

  @override
  Future<void> play() async => await _player.play();
  Future<void> playFromNetwork(String url) async => await _player.setUrl(url);
  @override
  Future<void> pause() => _player.pause();
  @override
  Future<void> stop() => _player.stop();
  
  @override
  Future<void> seek(Duration position) => _player.seek(position);
  Future<void> setAsset(String asset) => _player.setAsset(asset);
  Future<void> setLink(String asset) => _player.setUrl(asset);
  Future<void> setMediaItem(String uri) => _player.setAudioSource(
        AudioSource.uri(Uri.parse(uri),
            tag: const MediaItem(id: '1', title: 'Volna')),
      );
  @override
  Future<void> skipToQueueItem(int i) => _player.seek(Duration.zero, index: i);

  void _broadcastState(PlaybackEvent event) {
    playbackState.add(playbackState.value.copyWith(
      playing: _player.playing,
      controls: [
        MediaControl.play,
        MediaControl.pause,
        MediaControl.stop,
      ],
      processingState: _player.processingState == ProcessingState.completed
          ? AudioProcessingState.completed
          : AudioProcessingState.ready,
    ));
  }

  Stream<MediaItem> _item() async* {
    MediaItem(
      id: "https://www.radiorecord.ru/station/dub",
      title: "Radio",
      artist: "Volna",
      genre: 'Russian',
    );
  }
}
