import 'package:equatable/equatable.dart';

class AudioState extends Equatable {
  final bool isLoading;
  final String? error;
  final String? songName;
  final String? artistName;
  final String? fullTitle;
  final bool isPlaying;

  const AudioState({
    this.isLoading = false,
    this.error,
    this.songName,
    this.artistName,
    this.fullTitle,
    this.isPlaying = false,
  });

  AudioState copyWith({
    bool? isLoading,
    String? error,
    String? songName,
    String? artistName,
    String? fullTitle,
    bool? isPlaying,
  }) {
    return AudioState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      songName: songName ?? this.songName,
      artistName: artistName ?? this.artistName,
      fullTitle: fullTitle ?? this.fullTitle,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }

  @override
  List<Object?> get props =>
      [songName, artistName, fullTitle, isLoading, error, isPlaying];
}
