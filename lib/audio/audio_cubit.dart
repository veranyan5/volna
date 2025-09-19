import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radio_player_test/audio/audio_handler.dart';
import 'package:radio_player_test/audio/audio_state.dart';

class AudioCubit extends Cubit<AudioState> {
  final MyAudioHandler audioHandler;

  AudioCubit(this.audioHandler) : super(const AudioState(isLoading: true)) {
    audioHandler.listenMetadata.listen((data) {
      final title = data?.info?.title;

      if (title != null) {
        // Разделяем название песни и исполнителя по символу "-"
        final parts = title.split(' - ');
        String songName = title;
        String artistName = '';

        if (parts.length >= 2) {
          artistName = parts[0].trim();
          songName = parts[1].trim();
        } else if (parts.length == 1) {
          // Если нет разделителя, считаем весь текст названием песни
          songName = parts[0].trim();
        }

        emit(state.copyWith(
          fullTitle: title,
          songName: songName,
          artistName: artistName.isNotEmpty ? artistName : null,
        ));
      } else {
        emit(state.copyWith(
          fullTitle: null,
          songName: null,
          artistName: null,
        ));
      }
    });

    audioHandler.playbackState.listen((playbackState) {
      final playing = playbackState.playing;

      emit(state.copyWith(
        isPlaying: playing,
      ));
    });
  }

  Future<void> loadInitialData() async {
    try {
      emit(state.copyWith(isLoading: true));

      emit(state.copyWith(isLoading: false));
    } catch (error) {
      emit(state.copyWith(error: error.toString(), isLoading: false));
    }
  }

  Future<void> playAudio() async {
    try {
      await audioHandler.setMediaItem(
        'https://de1.streamingpulse.com/ssl/radiovolna',
      );
      await audioHandler.play();
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
    }
  }

  Future<void> pauseAudio() async {
    try {
      await audioHandler.pause();
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
    }
  }
}
