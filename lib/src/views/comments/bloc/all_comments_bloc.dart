import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'all_comments_event.dart';
part 'all_comments_state.dart';

class AllCommentsBloc extends Bloc<AllCommentsEvent, AllCommentsState> {
  AllCommentsBloc() : super(AllCommentsInitial()) {
    on<AllCommentsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
