import 'package:firebase_storage/firebase_storage.dart';
enum ProcessType{create , delete}
class CrudState {}
class LoadingState extends CrudState{

}
class ReadState extends  CrudState{
  List<Reference> reference;
  ReadState(this.reference);
}
class ProcessState extends CrudState{
  final String message;
  final bool success;
  final ProcessType processType;

  ProcessState(this.message, this.success, this.processType);
}