import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  final void Function()? onLogout;

  const DrawerWidget({super.key, this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: ListView(
          children: [
            Row(
              children: const [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blueGrey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 12),
                Text("Abdellahi Memoud",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 30, thickness: 3, color: Colors.greenAccent),
            _drawerItem(
                icon: Icons.insert_chart,
                label: "Recommandations",
                onTap: () {}),
            _drawerItem(
                icon: Icons.cloud_outlined, label: "Météo", onTap: () {}),
            _drawerItem(
                icon: Icons.camera_alt_outlined,
                label: "Détection des maladies",
                onTap: () {}),
            _drawerItem(
                icon: Icons.person_outline, label: "Profil", onTap: () {}),
            _drawerItem(
                icon: Icons.info_outline,
                label: "Contacter nous",
                onTap: () {}),
            _drawerItem(icon: Icons.language, label: "Langage", onTap: () {}),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Déconnexion",
                  style: TextStyle(color: Colors.red)),
              onTap: onLogout,
            ),
          ],
        ),
      ),
    );
  }

  ListTile _drawerItem(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueGrey),
      title: Text(label),
      onTap: onTap,
    );
  }
}
