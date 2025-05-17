
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositrory/claim_repository_impl.dart';
import 'claim_create_event.dart';
import 'claim_create_state.dart';

class ClaimCreateBloc extends Bloc<ClaimCreateEvent, ClaimCreateState> {
  final String userId;
  final String userName;
  final ClaimRepository repository;
  ClaimCreateBloc({
    required this.userId,
    required this.userName,
    required this.repository,
  }) : super(ClaimCreateState())

  {
    on<ClaimGroupChanged>((event, emit) {
      emit(state.copyWith(claimGroup: event.claimGroup));
    });

    on<ClaimNameChanged>((event, emit) {
      emit(state.copyWith(claimName: event.claimName));
    });

    on<ReceiptNoChanged>((event, emit) {
      emit(state.copyWith(receiptNo: event.receiptNo));
    });

    on<ReceiptAmountChanged>((event, emit) {
      emit(state.copyWith(receiptAmount: event.amount));
    });

    on<ClaimableAmountChanged>((event, emit) {
      emit(state.copyWith(claimableAmount: event.claimableAmount));
    });

    on<AttachmentAdded>((event, emit) {
      emit(state.copyWith(attachment: event.attachment));
    });

    on<SubmitClaimForm>((event, emit) async {
      emit(state.copyWith(isSubmitting: true, errorMessage: null));
      try {
        await repository.createClaim(
          claimGroup: state.claimGroup!,
          claimName: state.claimName!,
          receiptNo: state.receiptNo!,
          receiptAmount: state.receiptAmount!,
          claimableAmount: state.claimableAmount!,
          attachment: state.attachment!,
          userId: userId,
          userName: userName,
        );
        emit(state.copyWith(isSubmitting: false, isSuccess: true));
      } catch (e) {
        emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
      }
    });

  }
}
