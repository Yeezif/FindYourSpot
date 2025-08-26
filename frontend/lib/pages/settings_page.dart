import 'package:findyourspot/widgets/exports.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:findyourspot/services/logout_service.dart';
import 'settings_categories/settings_categories.dart';

class SettingsPage extends StatelessWidget {
  
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBarSettings(),
      body: SettingsList(

        platform: DevicePlatform.android,

        lightTheme: SettingsThemeData(
          settingsListBackground: theme.scaffoldBackgroundColor,
          settingsSectionBackground: theme.cardColor,
          titleTextColor: theme.textTheme.bodyLarge?.color,
          settingsTileTextColor: theme.textTheme.bodyMedium?.color,
          leadingIconsColor: theme.iconTheme.color,
        ),

        darkTheme: SettingsThemeData(
          settingsListBackground: theme.scaffoldBackgroundColor,
          settingsSectionBackground: theme.cardColor,
          titleTextColor: theme.textTheme.bodyLarge?.color,
          settingsTileTextColor: theme.textTheme.bodyMedium?.color,
          leadingIconsColor: theme.iconTheme.color,
        ),

        sections: [

          // General Settings
          CustomSettingsSection(
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
              ),

              child: SettingsSection(

                title: const Text('General'),
                tiles: <SettingsTile>[

                  SettingsTile.navigation(
                    leading: const Icon(Icons.notifications_rounded),
                    title: const Text('Notifications'),
                    onPressed: (context) => Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const NotificationSettings()),
                    )
                  ),

                  SettingsTile.navigation(
                    leading: const Icon(Icons.location_pin),
                    title: const Text('Location Services'),
                    onPressed: (context) => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LocationSettings()),
                    ),
                  ),

                  SettingsTile.navigation(
                    leading: const Icon(Icons.delete_forever_rounded),
                    title: const Text('Clear Cache'),
                    onPressed: (context) => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ClearCache()),
                    ),
                  ),

                ],
              ),
            )
          ),
          

          // User Interface Settings
          CustomSettingsSection(
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
              ),

              child: SettingsSection(

                title: const Text('User Interface'),
                tiles: <SettingsTile>[

                  SettingsTile.navigation(
                    leading: const Icon(Icons.language_rounded),
                    title: const Text('Language'),
                    onPressed: (context) => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LanguageSettings()),
                    ),
                  ),

                  SettingsTile.navigation(
                    leading: const Icon(Icons.text_fields_rounded),
                    title: const Text('Text Size'),
                    onPressed: (context) => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AccessibilitySettings()),
                    ),
                  ),

                  SettingsTile.navigation(
                    leading: const Icon(Icons.settings_display),
                    title: const Text('Color Theme'),
                    onPressed: (context) => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ColorThemeSettings()),
                    ),
                  ),

                ],
              ),
            )
          ),
          

          // Account Settings
          CustomSettingsSection(
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
              ),

              child: SettingsSection(

                title: const Text('Account'),
                tiles: <SettingsTile>[

                  SettingsTile.navigation(
                    leading: const Icon(Icons.person_rounded),
                    title: const Text('Edit Profile'),
                    onPressed: (context) => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditProfile()),
                    ),
                  ),

                  SettingsTile.navigation(
                    leading: const Icon(Icons.lock_rounded),
                    title: const Text('Change Password'),
                    onPressed: (context) => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChangePassword()),
                    )
                  ),

                  SettingsTile.navigation(
                    leading: const Icon(Icons.email_rounded),
                    title: const Text('Change Email'),
                    onPressed: (context) => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChangeEmail()),
                    )
                  ),

                  SettingsTile.navigation(
                    leading: const Icon(Icons.logout_rounded),
                    title: const Text('Logout'),
                    onPressed: (context) => logout(context), // TODO: Popup Dialog
                  ),

                  SettingsTile.navigation(
                    leading: const Icon(Icons.delete_rounded),
                    title: const Text('Delete Account'),
                    onPressed: (context) => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DeleteAccount()),
                    ),
                  ),

                ],
              ),
            )
          ),
          

          

          // Privacy Settings
          CustomSettingsSection(
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
              ),

              child: SettingsSection(

                title: const Text('Privacy'),
                tiles: <SettingsTile>[

                  SettingsTile.navigation(
                    leading: const Icon(Icons.privacy_tip_rounded),
                    title: const Text('Privacy Policy'),
                    onPressed: (context) => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PrivacyPolicy()),
                    ),
                  ),

                  SettingsTile.navigation(
                    leading: const Icon(Icons.info_rounded),
                    title: const Text('About'),
                    onPressed: (context) => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutPage()),
                    ),
                  ),

                  SettingsTile.navigation(
                    leading: const Icon(Icons.bug_report_rounded),
                    title: const Text('Report a Bug'),
                    onPressed: (context) => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ReportABug()),
                    ),
                  ),

                  SettingsTile.navigation(
                    leading: const Icon(Icons.contact_support_rounded),
                    title: const Text('Contact Support'),
                    onPressed: (context) => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ContactSupport()),
                    ),
                  ),


                ],
              ),
            )
          ),
          
        ],
      ),
    );
  }
}