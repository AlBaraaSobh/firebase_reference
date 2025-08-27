import 'package:elancer_firebase/bloc/events/crud_event.dart';
import 'package:elancer_firebase/bloc/state/crud_state.dart';
import 'package:elancer_firebase/firebase/fb_storage_controller.dart';
import 'package:elancer_firebase/models/fb_response.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImagesBloc extends Bloc<CrudEvent, CrudState> {
  ImagesBloc(super.initialState) {
    on<CreateEvent>(_onCreateEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<ReadEvent>(_onReadEvent);
  }

  FbStorageController _controller = FbStorageController();
  List<Reference> _reference = <Reference>[];

  void _onCreateEvent(CreateEvent event, Emitter<CrudState> emit) {
    UploadTask uploadTask = _controller.upload(event.path);
    uploadTask.snapshotEvents.listen((event) {
      if (event.state == TaskState.success) {
        _reference.add(event.ref);
        emit(ReadState(_reference));
        emit(
          ProcessState('Image Upload Successfully', true, ProcessType.create),
        );
      } else if (event.state == TaskState.success) {
        emit(ProcessState('Image Uploading Failed', false, ProcessType.create));
      }
    });
  }


  void _onReadEvent(ReadEvent event, Emitter<CrudState> emit)async {
    _reference = await  _controller.read();
    emit(ReadState(_reference));
  }

  void _onDeleteEvent(DeleteEvent event, Emitter<CrudState> emit) async{
      FbResponse fbResponse = await _controller.delete(_reference[event.index].fullPath);
      if(fbResponse.success){
        _reference.removeAt(event.index);
        emit(ReadState(_reference));
        emit(ProcessState(fbResponse.message, true, ProcessType.delete));
      }
  }
    
}
