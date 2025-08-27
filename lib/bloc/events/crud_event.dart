class CrudEvent {}
class CreateEvent extends CrudEvent {
  final String path;

  CreateEvent(this.path);
}
class ReadEvent extends CrudEvent {

}
class DeleteEvent extends CrudEvent {
  final int index;
  DeleteEvent(this.index);
}