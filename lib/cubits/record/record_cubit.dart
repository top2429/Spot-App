import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:meta/meta.dart';

part 'record_state.dart';

class RecordCubit extends Cubit<RecordState> {
  RecordCubit() : super(RecordInitial());
  late CameraController _controller;

  Future<void> initialize() async {
    try {
      final cameras = await availableCameras();
      _controller = CameraController(cameras.first, ResolutionPreset.high);
      await _controller.initialize();
      await _controller.prepareForVideoRecording();
      emit(RecordReady(controller: _controller));
    } catch (e) {
      emit(RecordError('Camera initialize failed'));
    }
  }

  Future<void> startRecording() async {
    if (state is RecordReady) {
      await _controller.startVideoRecording();
      emit(RecordInProgress(controller: _controller));
    } else if (state is RecordPaused) {
      await _controller.resumeVideoRecording();
      emit(RecordInProgress(controller: _controller));
    }
  }

  Future<void> pauseRecording() async {
    await _controller.pauseVideoRecording();
    emit(RecordPaused(controller: _controller));
  }

  Future<void> doneRecording() async {
    emit(RecordProcessing(controller: _controller));

    // stopVideoRecording takes about a whole second
    final videoFile = await _controller.stopVideoRecording();
    emit(
      RecordCompleted(controller: _controller, videoFile: videoFile),
    );
  }

  @override
  Future<void> close() {
    _controller.dispose();
    return super.close();
  }
}
