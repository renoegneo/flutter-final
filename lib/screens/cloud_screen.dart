import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_strings.dart';
import '../providers/auth_provider.dart';
import '../providers/schedule_provider.dart';
import '../providers/settings_provider.dart';

class CloudScreen extends StatefulWidget {
  const CloudScreen({super.key});

  @override
  State<CloudScreen> createState() => _CloudScreenState();
}

class _CloudScreenState extends State<CloudScreen> {
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();

    _usernameController = TextEditingController(text: auth.username ?? '');
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final strings = AppStrings(settings.language);
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.cloudAccount),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (auth.errorMessage != null) ...[
            _ErrorCard(message: auth.errorMessage!),
            const SizedBox(height: 12),
          ],
          if (!auth.isAuthenticated)
            _buildAuthForm(strings, auth)
          else
            _buildCloudPanel(strings, auth),
        ],
      ),
    );
  }

  Widget _buildAuthForm(AppStrings strings, AuthProvider auth) {
    final isBusy = auth.isLoading || _isSyncing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(strings.cloudLoginHint),
        const SizedBox(height: 16),
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: strings.username,
            border: const OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: strings.password,
            border: const OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: isBusy ? null : _login,
          child: auth.isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(strings.login),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: isBusy ? null : _register,
          child: Text(strings.register),
        ),
      ],
    );
  }

  Widget _buildCloudPanel(AppStrings strings, AuthProvider auth) {
    final isBusy = auth.isLoading || _isSyncing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(strings.cloudConnectedAs(auth.username ?? '-')),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: isBusy ? null : _uploadToCloud,
          icon: const Icon(Icons.cloud_upload_outlined),
          label: Text(strings.cloudSyncUpload),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: isBusy ? null : _downloadFromCloud,
          icon: const Icon(Icons.cloud_download_outlined),
          label: Text(strings.cloudSyncDownload),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: isBusy
              ? null
              : () async {
                  await auth.logout();
                  if (!mounted) return;
                  setState(() {
                    _passwordController.clear();
                    _usernameController.clear();
                  });
                },
          child: Text(strings.logout),
        ),
      ],
    );
  }

  Future<void> _login() async {
    final auth = context.read<AuthProvider>();
    final strings = AppStrings(context.read<SettingsProvider>().language);

    final ok = await auth.login(
      username: _usernameController.text.trim(),
      password: _passwordController.text,
    );

    if (ok && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(strings.loginSuccess)));
    }
  }

  Future<void> _register() async {
    final auth = context.read<AuthProvider>();
    final strings = AppStrings(context.read<SettingsProvider>().language);

    final ok = await auth.register(
      username: _usernameController.text.trim(),
      password: _passwordController.text,
    );

    if (ok && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(strings.registerSuccess)));
    }
  }

  Future<void> _uploadToCloud() async {
    setState(() => _isSyncing = true);
    final auth = context.read<AuthProvider>();
    final schedule = context.read<ScheduleProvider>();
    final strings = AppStrings(context.read<SettingsProvider>().language);

    try {
      await auth.uploadEvents(schedule.allEvents);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.cloudUploadSuccess(schedule.allEvents.length)),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  Future<void> _downloadFromCloud() async {
    setState(() => _isSyncing = true);
    final auth = context.read<AuthProvider>();
    final schedule = context.read<ScheduleProvider>();
    final strings = AppStrings(context.read<SettingsProvider>().language);

    try {
      final events = await auth.downloadEvents();
      await schedule.replaceAllEvents(events);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.cloudDownloadSuccess(events.length))),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;

  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        message,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
