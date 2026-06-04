import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import 'admin_dashboard_screen.dart';
import 'auth/login_screen.dart';
import 'fbr_billing_screen.dart';
class UserDashboardScreen extends StatelessWidget {
  const UserDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('My Dashboard', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          )
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final role = state is Authenticated ? state.role : 'user';
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello, ${role == 'admin' ? 'Admin' : 'User'}!",
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
                ),
                const SizedBox(height: 8),
            const Text(
              "Here is your personal data overview.",
              style: TextStyle(fontSize: 16, color: Color(0xFF7F8C8D)),
            ),
            const SizedBox(height: 30),
            _buildActionCard(
              context,
              icon: Icons.receipt_long,
              title: "My Billing",
              subtitle: "View and manage your FBR bills",
              color: const Color(0xFF3498DB),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const FBRBillingScreen()));
              },
            ),
            const SizedBox(height: 16),
            _buildActionCard(
              context,
              icon: Icons.person,
              title: "My Profile",
              subtitle: "Update your personal information",
              color: const Color(0xFF9B59B6),
              onTap: () {},
            ),
            const SizedBox(height: 16),
            _buildActionCard(
              context,
              icon: Icons.history,
              title: "Activity History",
              subtitle: "View your recent transactions",
              color: const Color(0xFF1ABC9C),
              onTap: () {},
            ),
            if (role == 'admin') ...[
              const SizedBox(height: 16),
              _buildActionCard(
                context,
                icon: Icons.admin_panel_settings,
                title: "Admin Dashboard",
                subtitle: "Access administrative tools and settings",
                color: Colors.redAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  },
  ),
);
  }

  Widget _buildActionCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 14, color: Color(0xFF7F8C8D))),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 16),
          ],
        ),
      ),
    );
  }
}
