import 'package:flutter/material.dart';

/// Bottom sheet для выбора типа вложения
/// TODO: Реализовать реальный выбор файлов из галереи/файловой системы
class AttachmentBottomSheet extends StatelessWidget {
  final VoidCallback onPhotoSelected;
  final VoidCallback onDocumentSelected;
  final VoidCallback onAudioSelected;

  const AttachmentBottomSheet({
    super.key,
    required this.onPhotoSelected,
    required this.onDocumentSelected,
    required this.onAudioSelected,
  });

  @override
  Widget build(BuildContext context) {
    /// Строит кнопку опции вложения
    Widget _buildAttachmentOption({required IconData icon, required String label, required VoidCallback onTap}) {
      final theme = Theme.of(context);
      return Column(
        children: [
          IconButton(
            icon: Icon(icon),
            onPressed: onTap,
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.primaryContainer,
              foregroundColor: theme.colorScheme.onPrimaryContainer,
              padding: const EdgeInsets.all(16),
            ),
            iconSize: 28,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.bodySmall,
          ),
        ],
      );
    }

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Верхняя ручка bottom sheet
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Добавить вложение',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAttachmentOption(
                icon: Icons.photo,
                label: 'Фото',
                onTap: onPhotoSelected,
              ),
              _buildAttachmentOption(
                icon: Icons.insert_drive_file,
                label: 'Документ',
                onTap: onDocumentSelected,
              ),
              _buildAttachmentOption(
                icon: Icons.mic,
                label: 'Аудио',
                onTap: onAudioSelected,
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}