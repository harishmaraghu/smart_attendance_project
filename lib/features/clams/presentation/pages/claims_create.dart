import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositrory/claim_repository_impl.dart';
import '../widgets/claim_create_widgets/claim_form.dart';
import '../widgets/claim_create_widgets/top_nav_claim_apply.dart';
import '../bloc/claim_create_bloc.dart'; // import your bloc

class ClaimsCreate extends StatelessWidget {
 final String Userid;
 final String username;
  const ClaimsCreate({required this.Userid,required this.username,super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopDashboardHeaderinClaimApply(userId: Userid,),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: BlocProvider(
                    create: (_) => ClaimCreateBloc(

                      userName: username,
                     userId: Userid,
                // userId: "15",
                // userName: "demo check",
                repository: ClaimRepository(),
              ),
              child: ClaimForm(userId:Userid , userName:username),
            ),

      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
