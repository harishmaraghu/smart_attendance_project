import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_attendance_project/core/constants/app_colors.dart';
import 'package:smart_attendance_project/features/history_claim/constants/network.dart' show ApiClient;
import 'package:smart_attendance_project/features/history_claim/data/datasources/claim_remote_datasource.dart' show ClaimRemoteDataSourceImpl;
import 'package:smart_attendance_project/features/history_claim/data/repositories/claim_repository.dart' show ClaimRepositoryImpl;
import 'package:smart_attendance_project/features/history_claim/presentation/bloc/claim_his_bloc.dart';
import 'package:smart_attendance_project/features/history_claim/presentation/bloc/claim_his_event.dart' show LoadClaimsEvent, RefreshClaimsEvent;
import 'package:smart_attendance_project/features/history_claim/presentation/bloc/claim_his_state.dart' show ClaimHistoryError, ClaimHistoryLoaded, ClaimHistoryLoading, ClaimHistoryState;
import 'package:smart_attendance_project/features/history_claim/presentation/widgets/claim_item_widget.dart' show ClaimItemWidget;

class ClaimHistoryScreen extends StatelessWidget {
  final String userId;

  const ClaimHistoryScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClaimHistoryBloc(
        repository: ClaimRepositoryImpl(
          remoteDataSource: ClaimRemoteDataSourceImpl(
            apiClient: ApiClient(),
          ),
        ),
      )..add(LoadClaimsEvent(userId: userId)),
      child: ClaimHistoryView(userId: userId),
    );
  }
}

class ClaimHistoryView extends StatefulWidget {
  final String userId;

  const ClaimHistoryView({Key? key, required this.userId}) : super(key: key);

  @override
  State<ClaimHistoryView> createState() => _ClaimHistoryViewState();
}

class _ClaimHistoryViewState extends State<ClaimHistoryView>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().backgroundcolor,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.receipt_long,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Claim History',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors().backgroundcolor,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Tab Bar Section
          Container(
            color: AppColors().backgroundcolor,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: TabBar(
              controller: _tabController,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(color: Colors.black, width: 3),
                insets: EdgeInsets.symmetric(horizontal: 40),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white.withOpacity(0.7),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
                fontSize: 16,
              ),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _tabController.index == 0
                              ? const Color(0xFF10B981)
                              : Colors.white.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Processing'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _tabController.index == 1
                              ? const Color(0xFF10B981)
                              : Colors.white.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Completed'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content Section
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF9FAFB),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildClaimsTab(isProcessing: true),
                  _buildClaimsTab(isProcessing: false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClaimsTab({required bool isProcessing}) {
    return BlocBuilder<ClaimHistoryBloc, ClaimHistoryState>(
      builder: (context, state) {
        if (state is ClaimHistoryLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        }

        if (state is ClaimHistoryError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Error loading claims',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<ClaimHistoryBloc>().add(
                      RefreshClaimsEvent(userId: widget.userId),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is ClaimHistoryLoaded) {
          final claims = isProcessing ? state.processingClaims : state.completedClaims;

          if (claims.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isProcessing ? Icons.hourglass_empty : Icons.check_circle_outline,
                    size: 64,
                    color: const Color(0xFFD1D5DB),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isProcessing ? 'No processing claims' : 'No completed claims',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Claims will appear here when available',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ClaimHistoryBloc>().add(
                RefreshClaimsEvent(userId: widget.userId),
              );
            },
            color: const Color(0xFF2563EB),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: claims.length,
              itemBuilder: (context, index) {
                return ClaimItemWidget(claim: claims[index]);
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}