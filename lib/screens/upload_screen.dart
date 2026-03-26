import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_strings.dart';
import '../models/event.dart';
import '../providers/schedule_provider.dart';
import '../providers/settings_provider.dart';
import '../services/file_import_service.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _importService = FileImportService();

  String? _selectedFileName;
  List<Event>? _previewEvents;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _pickFile() async {
    setState(() {
      _errorMessage = null;
      _previewEvents = null;
    });

    final result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['csv', 'xlsx', 'xls', 'ics'],
      type: FileType.custom,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    if (file.path == null) return;

    setState(() {
      _selectedFileName = file.name;
      _isLoading = true;
    });

    try {
      final events = await _importService.importFile(file.path!);
      setState(() {
        _previewEvents = events;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Could not read file: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _import() async {
    if (_previewEvents == null || _previewEvents!.isEmpty) return;

    final scheduleProvider = context.read<ScheduleProvider>();
    await scheduleProvider.importEvents(
      _previewEvents!,
      scheduleProvider.selectedDate,
    );

    if (!mounted) return;

    final strings = AppStrings(context.read<SettingsProvider>().language);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(strings.importSuccess)),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final strings = AppStrings(settings.language);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.uploadSchedule),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _pickFile,
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                    style: BorderStyle.solid,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _selectedFileName != null
                          ? Icons.insert_drive_file
                          : Icons.folder_open,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _selectedFileName ?? strings.clickToSelect,
                      style: const TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${strings.supported}: .csv, .xlsx, .ics',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            if (_previewEvents != null) ...[
              Text(
                strings.preview,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _previewEvents!.isEmpty
                    ? Center(child: Text(strings.noEvents))
                    : ListView.builder(
                        itemCount: _previewEvents!.length,
                        itemBuilder: (context, index) {
                          final event = _previewEvents![index];
                          final timeStr = settings.formatTime(event.dateTime);
                          return ListTile(
                            leading: Text(timeStr),
                            title: Text(event.title),
                            dense: true,
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(strings.cancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _previewEvents!.isEmpty ? null : _import,
                      child: Text(strings.importBtn),
                    ),
                  ),
                ],
              ),
            ],
            if (_previewEvents == null && !_isLoading) ...[
              const Spacer(),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(strings.cancel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
