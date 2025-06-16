import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_attendance_project/core/constants/app_colors.dart';
import 'package:smart_attendance_project/features/home_dashboard/presentation/pages/home_screen.dart';
import 'package:smart_attendance_project/features/loan/data/repositories/loan_history_repository_impl.dart';
import 'package:smart_attendance_project/features/loan/presentation/bloc/loan_bloc.dart';
import 'package:smart_attendance_project/features/loan/presentation/bloc/loan_event.dart';
import 'package:smart_attendance_project/features/loan/presentation/bloc/loan_state.dart';
import 'package:smart_attendance_project/features/loan/presentation/screens/history/history_view.dart';

import 'package:smart_attendance_project/features/loan/presentation/widgets/apply/topbarloanapply.dart';


class LoanForm extends StatefulWidget {
  final String Userid;
  final String username;

  const LoanForm({required this.Userid, required this.username, Key? key}) : super(key: key);

  @override
  State<LoanForm> createState() => _LoanFormState();
}

class _LoanFormState extends State<LoanForm> {
  final _formKey = GlobalKey<FormState>();
  String _paymentType = '';
  String _duration = '';
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _emiController = TextEditingController();

  void _resetForm() {
    _amountController.clear();
    _emiController.clear();
    setState(() {
      _paymentType = '';
      _duration = '';
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final loanBloc = BlocProvider.of<LoanBloc>(context);
      loanBloc.add(
        SubmitLoanForm(
          userId: widget.Userid,
          userName: widget.username,
          paymentClaimType: _paymentType,
          amount: int.parse(_amountController.text),
          duration: _duration,
          emiAmount: int.parse(_emiController.text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoanBloc, LoanState>(
      listener: (context, state) {
        if (state is LoanSuccess) {
          _resetForm();
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(username: widget.username, userId: widget.Userid)));
        } else if (state is LoanFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: SafeArea(
          child: Column(
            children: [
              TopDashboardinLoanApply(),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LoanFormCard(
                      formKey: _formKey,
                      paymentType: _paymentType,
                      duration: _duration,
                      amountController: _amountController,
                      emiController: _emiController,
                      onPaymentTypeChanged: (value) => setState(() => _paymentType = value),
                      onDurationChanged: (value) => setState(() => _duration = value),
                      onSubmit: _submit,
                      onHistoryPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => LoanHistoryBloc(
                                repository: LoanHistoryRepositoryImpl(),
                              ),
                              child: HistoryView(
                                Userid: widget.Userid,
                                username: widget.username,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// loan_form_card.dart
class LoanFormCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String paymentType;
  final String duration;
  final TextEditingController amountController;
  final TextEditingController emiController;
  final Function(String) onPaymentTypeChanged;
  final Function(String) onDurationChanged;
  final VoidCallback onSubmit;
  final VoidCallback onHistoryPressed;

  const LoanFormCard({
    Key? key,
    required this.formKey,
    required this.paymentType,
    required this.duration,
    required this.amountController,
    required this.emiController,
    required this.onPaymentTypeChanged,
    required this.onDurationChanged,
    required this.onSubmit,
    required this.onHistoryPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LoanFormTitle(),
              const SizedBox(height: 24),

              PaymentTypeDropdown(
                value: paymentType,
                onChanged: onPaymentTypeChanged,
              ),
              const SizedBox(height: 20),

              AmountInputField(
                controller: amountController,
              ),
              const SizedBox(height: 20),

              DurationSection(
                value: duration,
                onChanged: onDurationChanged,
              ),
              const SizedBox(height: 20),

              EMIAmountField(
                controller: emiController,
              ),
              const SizedBox(height: 38),

              LoanFormButtons(
                onSubmit: onSubmit,
                onHistoryPressed: onHistoryPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// loan_form_title.dart
class LoanFormTitle extends StatelessWidget {
  const LoanFormTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Apply for a Loan',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF093F67),
      ),
    );
  }
}

// payment_type_dropdown.dart
class PaymentTypeDropdown extends StatelessWidget {
  final String value;
  final Function(String) onChanged;

  const PaymentTypeDropdown({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormSectionLabel(
          title: 'Select Payment Claim Type',
          subtitle: '(Loan / Advance)',
        ),
        const SizedBox(height: 8),
        CustomDropdownContainer(
          child: DropdownButtonFormField<String>(
            value: value.isEmpty ? null : value,
            hint: const Text(
              "Select payment",
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 14,
              ),
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: ['Loan', 'Advance'].map((type) {
              return DropdownMenuItem(value: type, child: Text(type));
            }).toList(),
            onChanged: (value) => onChanged(value!),
            validator: (value) => value == null ? 'Select a type' : null,
          ),
        ),
      ],
    );
  }
}

// amount_input_field.dart
class AmountInputField extends StatelessWidget {
  final TextEditingController controller;

  const AmountInputField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormSectionLabel(title: 'Amount'),
        const SizedBox(height: 8),
        CustomInputContainer(
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: '\$ Enter',
              hintStyle: TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 14,
              ),
              suffixText: 'SGD',
              suffixStyle: TextStyle(
                color: Color(0xFF4A5568),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            validator: (value) =>
            value == null || value.isEmpty ? 'Enter amount' : null,
          ),
        ),
      ],
    );
  }
}

// duration_section.dart
class DurationSection extends StatelessWidget {
  final String value;
  final Function(String) onChanged;

  const DurationSection({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormSectionLabel(
          title: 'Loan Repayment Details',
          subtitle: 'Duration',
        ),
        const SizedBox(height: 8),
        CustomDropdownContainer(
          child: DropdownButtonFormField<String>(
            value: value.isEmpty ? null : value,
            hint: const Text(
              "Duration",
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 14,
              ),
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: ['6 months', '12 months', '24 months'].map((d) {
              return DropdownMenuItem(value: d, child: Text(d));
            }).toList(),
            onChanged: (value) => onChanged(value!),
            validator: (value) => value == null ? 'Select duration' : null,
          ),
        ),
      ],
    );
  }
}

// emi_amount_field.dart
class EMIAmountField extends StatelessWidget {
  final TextEditingController controller;

  const EMIAmountField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormSectionLabel(title: 'EMI Amount'),
        const SizedBox(height: 8),
        CustomInputContainer(
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: '\$ Enter',
              hintStyle: TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 14,
              ),
              suffixText: 'SGD',
              suffixStyle: TextStyle(
                color: Color(0xFF4A5568),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            validator: (value) =>
            value == null || value.isEmpty ? 'Enter EMI' : null,
          ),
        ),
      ],
    );
  }
}

// loan_form_buttons.dart
class LoanFormButtons extends StatelessWidget {
  final VoidCallback onSubmit;
  final VoidCallback onHistoryPressed;

  const LoanFormButtons({
    Key? key,
    required this.onSubmit,
    required this.onHistoryPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryButton(
          text: 'Claim',
          onPressed: onSubmit,
        ),
        const SizedBox(height: 12),
        SecondaryButton(
          text: 'History',
          onPressed: onHistoryPressed,
        ),
      ],
    );
  }
}

// Common Widgets

// form_section_label.dart
class FormSectionLabel extends StatelessWidget {
  final String title;
  final String? subtitle;

  const FormSectionLabel({
    Key? key,
    required this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF4A5568),
          ),
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF718096),
            ),
          ),
      ],
    );
  }
}

// custom_input_container.dart
class CustomInputContainer extends StatelessWidget {
  final Widget child;

  const CustomInputContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors().loan_apply_form_texfiled_bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xffD2EDFF),
          width: 1.5,
        ),
      ),
      child: child,
    );
  }
}

// custom_dropdown_container.dart
class CustomDropdownContainer extends StatelessWidget {
  final Widget child;

  const CustomDropdownContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors().loan_apply_form_texfiled_bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xffD2EDFF),
          width: 1.5,
        ),
      ),
      child: child,
    );
  }
}

// primary_button.dart
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
       width: double.infinity,
      height: 45,
      // width:150,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors().loan_apply_form_texfiled_bg,
          foregroundColor: AppColors().loan_apply_form_texfiled,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// secondary_button.dart
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SecondaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: TextButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white70,
          foregroundColor: AppColors().loan_apply_form_texfiled,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
