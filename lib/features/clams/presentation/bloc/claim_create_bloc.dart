import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_attendance_project/features/clams/data/models/claim_history_model.dart';
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
  }) : super(ClaimCreateState()) {
    on<ClaimGroupChanged>((event, emit) {
      emit(state.copyWith(claimGroup: event.claimGroup, errorMessage: null));
    });

    on<ClaimNameChanged>((event, emit) {
      emit(state.copyWith(claimName: event.claimName, errorMessage: null));
    });

    on<ReceiptNoChanged>((event, emit) {
      emit(state.copyWith(receiptNo: event.receiptNo, errorMessage: null));
    });

    on<ReceiptAmountChanged>((event, emit) {
      emit(state.copyWith(receiptAmount: event.amount, errorMessage: null));
    });

    on<ClaimableAmountChanged>((event, emit) {
      emit(state.copyWith(claimableAmount: event.claimableAmount, errorMessage: null));
    });

    on<ClaimAttachmentChanged>((event, emit) {
      emit(state.copyWith(attachment: event.file, errorMessage: null));
    });

    on<SubmitClaimForm>((event, emit) async {
      emit(state.copyWith(isSubmitting: true, errorMessage: null));

      // Comprehensive validation
      if (state.claimGroup?.trim().isEmpty ?? true) {
        emit(state.copyWith(isSubmitting: false, errorMessage: "Please select a claim group"));
        return;
      }

      if (state.claimName?.trim().isEmpty ?? true) {
        emit(state.copyWith(isSubmitting: false, errorMessage: "Please select a claim name"));
        return;
      }

      if (state.receiptNo?.trim().isEmpty ?? true) {
        emit(state.copyWith(isSubmitting: false, errorMessage: "Please enter receipt number"));
        return;
      }

      if (state.receiptAmount?.trim().isEmpty ?? true) {
        emit(state.copyWith(isSubmitting: false, errorMessage: "Please enter receipt amount"));
        return;
      }

      if (state.claimableAmount?.trim().isEmpty ?? true) {
        emit(state.copyWith(isSubmitting: false, errorMessage: "Please enter claimable amount"));
        return;
      }

      // Validate numeric values
      final receiptAmount = double.tryParse(state.receiptAmount!.trim());
      if (receiptAmount == null || receiptAmount <= 0) {
        emit(state.copyWith(isSubmitting: false, errorMessage: "Please enter a valid receipt amount"));
        return;
      }

      final claimableAmount = double.tryParse(state.claimableAmount!.trim());
      if (claimableAmount == null || claimableAmount <= 0) {
        emit(state.copyWith(isSubmitting: false, errorMessage: "Please enter a valid claimable amount"));
        return;
      }

      if (claimableAmount > receiptAmount) {
        emit(state.copyWith(isSubmitting: false, errorMessage: "Claimable amount cannot exceed receipt amount"));
        return;
      }

      // Check if attachment is provided (required by backend)
      if (state.attachment == null) {
        emit(state.copyWith(isSubmitting: false, errorMessage: "Please attach a receipt image"));
        return;
      }

      // Validate user info
      if (userId.trim().isEmpty) {
        emit(state.copyWith(isSubmitting: false, errorMessage: "User ID is missing"));
        return;
      }

      if (userName.trim().isEmpty) {
        emit(state.copyWith(isSubmitting: false, errorMessage: "User name is missing"));
        return;
      }

      try {
        print("🚀 Submitting claim with:");
        print("- UserId: $userId");
        print("- UserName: $userName");
        print("- ClaimGroup: ${state.claimGroup}");
        print("- ClaimName: ${state.claimName}");
        print("- ReceiptNo: ${state.receiptNo}");
        print("- ReceiptAmount: ${state.receiptAmount}");
        print("- ClaimableAmount: ${state.claimableAmount}");
        print("- Attachment: ${state.attachment?.path ?? 'None'}");

        // Use JSON method instead of multipart to match backend expectations
        final result = await repository.createClaimAsJson(
          claimGroup: state.claimGroup!.trim(),
          claimName: state.claimName!.trim(),
          receiptNo: state.receiptNo!.trim(),
          receiptAmount: state.receiptAmount!.trim(),
          claimableAmount: state.claimableAmount!.trim(),
          userId: userId.trim(),
          userName: userName.trim(),
          attachment: state.attachment, // This will be base64 encoded in the repository
        );

        print("✅ Claim submitted successfully: $result");
        emit(state.copyWith(isSubmitting: false, isSuccess: true));

      } catch (e) {
        print("❌ Claim submission failed: $e");
        String errorMessage = e.toString();

        // Clean up error message
        errorMessage = errorMessage.replaceAll('Exception: ', '');
        errorMessage = errorMessage.replaceAll('ClaimSubmissionException: ', '');
        errorMessage = errorMessage.replaceAll('ClaimValidationException: ', '');

        // Handle specific error cases
        if (errorMessage.contains('Employee with matching Userid and name not found')) {
          errorMessage = "Your user credentials don't match our records. Please contact HR.";
        } else if (errorMessage.contains('ClaimableAmount must be an integer')) {
          errorMessage = "Please enter a valid whole number for claimable amount.";
        } else if (errorMessage.contains('Attachment is required')) {
          errorMessage = "Please attach a receipt image.";
        } else if (errorMessage.contains('base64')) {
          errorMessage = "There was an issue with the attached file. Please try a different image.";
        } else if (errorMessage.contains('Connection timeout') || errorMessage.contains('Network error')) {
          errorMessage = "Network connection issue. Please check your internet and try again.";
        }

        emit(state.copyWith(
          isSubmitting: false,
          errorMessage: errorMessage,
        ));
      }
    });
  }
}


// class ClaimHistoryLoaded extends ClaimHistoryState {
//   final List<ClaimHistoryModel> claims;
//
//   ClaimHistoryLoaded(this.claims);
// }
