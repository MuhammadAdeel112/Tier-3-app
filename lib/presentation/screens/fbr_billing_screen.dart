import 'package:flutter/material.dart';
import '../viewmodels/fbr_billing_viewmodel.dart';
import '../widgets/billing_tab_content.dart';
import '../widgets/products_tab_content.dart';
import '../widgets/tax_reports_tab_content.dart';
import '../widgets/history_tab_content.dart';
import 'auth/login_screen.dart';
import '../widgets/auth/auth_dialogs.dart';

class FBRBillingScreen extends StatefulWidget {
  const FBRBillingScreen({super.key});

  @override
  State<FBRBillingScreen> createState() => _FBRBillingScreenState();
}

class _FBRBillingScreenState extends State<FBRBillingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late FBRBillingViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = FBRBillingViewModel();
    _tabController = TabController(length: 4, vsync: this);
    
    // Bind TabController changes back to presentation state notifier
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _viewModel.changeActiveTab(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: _viewModel.backgroundColor,
          appBar: AppBar(
            backgroundColor: _viewModel.primaryColor,
            elevation: 4,
            shadowColor: _viewModel.primaryColor.withValues(alpha: 0.3),
            title: Row(
              children: [
                Icon(Icons.shield, color: _viewModel.accentColor, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Tier3 FBR INVOICING",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      letterSpacing: 0.8,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            actions: [
              // Theme Toggle Button
              IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, anim) => RotationTransition(
                    turns: child.key == const ValueKey('icon1') ? Tween<double>(begin: 1, end: 0.75).animate(anim) : Tween<double>(begin: 0.75, end: 1).animate(anim),
                    child: FadeTransition(opacity: anim, child: child),
                  ),
                  child: Icon(
                    _viewModel.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    key: ValueKey(_viewModel.isDarkMode ? 'icon1' : 'icon2'),
                    color: Colors.white,
                  ),
                ),
                onPressed: () => _viewModel.toggleTheme(),
                tooltip: "Toggle Theme",
              ),
              // FBR Secure Official Logo badging
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _viewModel.accentColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.verified, color: _viewModel.primaryColor, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      "FBR SECURE",
                      style: TextStyle(
                        color: _viewModel.primaryColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () {
                  AuthDialogs.showPremiumLogout(context, () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  });
                },
                tooltip: "Logout",
              ),
              const SizedBox(width: 8),
            ],
            bottom: TabBar(
              controller: _tabController,
              isScrollable: false,
              indicatorColor: _viewModel.accentColor,
              indicatorWeight: 3.5,
              labelColor: _viewModel.accentColor,
              unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              tabs: const [
                Tab(text: "Billing"),
                Tab(text: "Products"),
                Tab(text: "Tax Reports"),
                Tab(text: "History"),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              BillingTabContent(viewModel: _viewModel, tabController: _tabController),
              ProductsTabContent(viewModel: _viewModel, tabController: _tabController),
              TaxReportsTabContent(viewModel: _viewModel),
              HistoryTabContent(viewModel: _viewModel),
            ],
          ),
        );
      }
    );
  }
}
